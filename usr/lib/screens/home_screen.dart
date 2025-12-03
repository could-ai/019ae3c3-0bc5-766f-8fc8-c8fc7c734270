import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SKY JUMP\nLEGENDS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))],
                ),
              ),
              const SizedBox(height: 20),
              _buildStatBadge('High Score', '${gameState.highScore}'),
              const SizedBox(height: 10),
              _buildStatBadge('Coins', '${gameState.coins} 🪙'),
              
              const SizedBox(height: 50),
              
              _buildMenuButton(context, 'PLAY NOW', Icons.play_arrow_rounded, () {
                Navigator.pushNamed(context, '/game');
              }, primary: true),
              
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSmallButton(context, 'Shop', Icons.shopping_cart, '/shop'),
                  const SizedBox(width: 20),
                  _buildSmallButton(context, 'Coins', Icons.monetization_on, '/coins'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSmallButton(context, 'Features', Icons.list, '/features'),
                  const SizedBox(width: 20),
                  _buildSmallButton(context, 'Quests', Icons.task_alt, null, onTap: () {
                    _showQuestsDialog(context, gameState);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, IconData icon, VoidCallback onPressed, {bool primary = false}) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? Colors.amber : Colors.white,
          foregroundColor: primary ? Colors.black : Colors.purple,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallButton(BuildContext context, String label, IconData icon, String? route, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pushNamed(context, route!),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showQuestsDialog(BuildContext context, GameState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Daily Quests'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.directions_run),
              title: const Text('Jump 100 times'),
              subtitle: Text('${state.jumpsToday} / 100'),
              trailing: state.questJumpClaimed 
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : ElevatedButton(
                      onPressed: state.jumpsToday >= 100 
                          ? () { state.claimQuestReward(); Navigator.pop(ctx); } 
                          : null,
                      child: const Text('Claim'),
                    ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }
}
