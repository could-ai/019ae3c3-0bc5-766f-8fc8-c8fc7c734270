import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/game_state.dart';
import 'objects.dart';

class SkyJumpGame extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  final GameState gameState;
  late PlayerComponent player;
  late TextComponent scoreText;
  
  int score = 0;
  double _highestY = 0;
  
  // Level generation
  double _lastPlatformY = 0;
  final Random _rnd = Random();
  
  SkyJumpGame(this.gameState);

  @override
  Future<void> onLoad() async {
    // Background
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF87CEEB), // Sky blue
    ));

    // Player
    player = PlayerComponent(character: gameState.selectedCharacter);
    player.position = Vector2(size.x / 2, size.y - 200);
    add(player);

    // Initial Platform
    add(PlatformComponent(position: Vector2(size.x / 2, size.y - 50)));
    _lastPlatformY = size.y - 50;

    // Score
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 40),
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
    add(scoreText);

    // Camera
    camera.viewfinder.anchor = Anchor.center;
    // We will manually update camera in update() to follow player only upwards
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update Score based on height
    double currentHeight = (size.y - player.position.y);
    if (currentHeight > score) {
      score = currentHeight.toInt();
      scoreText.text = 'Score: $score';
    }

    // Camera follow (only up)
    if (player.position.y < camera.viewfinder.position.y + size.y / 2 - 300) {
       // Move camera up logic would go here if using CameraComponent fully, 
       // but for simple infinite jumper, we often move the world down or camera up.
       // For this demo, we'll keep it simple: Player moves up, we generate platforms.
       // Actually, standard Flame camera follow:
       camera.viewfinder.position = Vector2(size.x/2, min(camera.viewfinder.position.y, player.position.y));
    }

    // Generate Platforms
    // If the highest platform is too far below the top of the screen (relative to camera), add more
    double generationThreshold = camera.viewfinder.position.y - size.y; 
    
    if (_lastPlatformY > generationThreshold) {
      _generatePlatform();
    }

    // Check Game Over
    if (player.position.y > camera.viewfinder.position.y + size.y / 2 + 100) {
      gameOver();
    }
  }

  void _generatePlatform() {
    double y = _lastPlatformY - (80 + _rnd.nextInt(60)); // Gap between 80 and 140
    double x = 50 + _rnd.nextDouble() * (size.x - 100);
    
    add(PlatformComponent(position: Vector2(x, y)));
    
    // Chance for Enemy
    if (_rnd.nextDouble() < 0.1) {
       add(EnemyComponent(position: Vector2(x, y - 50)));
    }
    
    // Chance for Coin
    if (_rnd.nextDouble() < 0.3) {
      add(CoinComponent(position: Vector2(x, y - 40)));
    }

    _lastPlatformY = y;
  }

  void gameOver() {
    pauseEngine();
    gameState.updateHighScore(score);
    overlays.add('GameOver');
  }

  // Input Handling
  @override
  void onTapDown(TapDownInfo info) {
    if (info.eventPosition.global.x < size.x / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
  }
  
  @override
  void onTapUp(TapUpInfo info) {
    player.stopMoving();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player.moveLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player.moveRight();
    } else {
      player.stopMoving();
    }
    return KeyEventResult.handled;
  }
}
