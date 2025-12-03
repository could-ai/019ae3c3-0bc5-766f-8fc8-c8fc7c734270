import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'sky_jump_game.dart';

// --- Player ---
class PlayerComponent extends PositionComponent with HasGameRef<SkyJumpGame>, CollisionCallbacks {
  final String character;
  Vector2 velocity = Vector2.zero();
  final double gravity = 800;
  final double jumpForce = -550;
  final double moveSpeed = 300;
  int horizontalDirection = 0; // -1 left, 1 right, 0 none

  PlayerComponent({required this.character}) : super(size: Vector2(40, 40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Visual
    String emoji = '🦊';
    if (character == 'panda') emoji = '🐼';
    if (character == 'rabbit') emoji = '🐰';
    
    add(TextComponent(
      text: emoji,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 32)),
      anchor: Anchor.center,
      position: size / 2,
    ));

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Gravity
    velocity.y += gravity * dt;
    
    // Movement
    velocity.x = horizontalDirection * moveSpeed;
    
    position += velocity * dt;

    // Screen wrapping
    if (position.x < 0) position.x = gameRef.size.x;
    if (position.x > gameRef.size.x) position.x = 0;
  }

  void jump() {
    if (velocity.y > 0) { // Only jump if falling
      velocity.y = jumpForce;
      gameRef.gameState.incrementJump();
      // Play sound here if audio was fully set up
    }
  }

  void moveLeft() => horizontalDirection = -1;
  void moveRight() => horizontalDirection = 1;
  void stopMoving() => horizontalDirection = 0;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlatformComponent) {
      // Check if falling onto platform (simple check)
      if (velocity.y > 0 && position.y < other.position.y) {
        jump();
      }
    } else if (other is CoinComponent) {
      other.collect();
      gameRef.gameState.addCoins(1);
    } else if (other is EnemyComponent) {
      gameRef.gameOver();
    }
  }
}

// --- Platform ---
class PlatformComponent extends PositionComponent with CollisionCallbacks {
  PlatformComponent({required Vector2 position}) 
      : super(position: position, size: Vector2(80, 20), anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.green,
    ));
    add(RectangleHitbox());
  }
}

// --- Coin ---
class CoinComponent extends PositionComponent with HasGameRef<SkyJumpGame>, CollisionCallbacks {
  CoinComponent({required Vector2 position}) 
      : super(position: position, size: Vector2(20, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleComponent(
      radius: 10,
      paint: Paint()..color = Colors.amber,
    ));
    add(CircleHitbox());
  }

  void collect() {
    removeFromParent();
  }
}

// --- Enemy ---
class EnemyComponent extends PositionComponent with CollisionCallbacks {
  double speed = 100;
  int direction = 1;

  EnemyComponent({required Vector2 position}) 
      : super(position: position, size: Vector2(30, 30), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(TextComponent(
      text: '🦇',
      textRenderer: TextPaint(style: const TextStyle(fontSize: 24)),
      anchor: Anchor.center,
      position: size / 2,
    ));
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speed * direction * dt;
    
    // Patrol logic (simple)
    if (position.x > 300) direction = -1; // Assuming screen width approx
    if (position.x < 0) direction = 1;
  }
}
