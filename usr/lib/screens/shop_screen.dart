import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  final List<Map<String, dynamic>> items = const [
    {'id': 'fox', 'name': 'Fox', 'price': 0, 'icon': '🦊', 'desc': 'Agile and cunning.'},
    {'id': 'panda', 'name': 'Panda', 'price': 200, 'icon': '🐼', 'desc': 'Shield ability.'},
    {'id': 'rabbit', 'name': 'Rabbit', 'price': 500, 'icon': '🐰', 'desc': 'Super jump.'},
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Shop'),
        actions: [
          Center(child: Text('${state.coins} 🪙  ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isUnlocked = state.unlockedCharacters.contains(item['id']);
          final isSelected = state.selectedCharacter == item['id'];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Text(item['icon'], style: const TextStyle(fontSize: 40)),
              title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['desc']),
              trailing: isUnlocked
                  ? (isSelected
                      ? const Chip(label: Text('Selected'), backgroundColor: Colors.greenAccent)
                      : ElevatedButton(
                          onPressed: () => state.selectCharacter(item['id']),
                          child: const Text('Select'),
                        ))
                  : ElevatedButton(
                      onPressed: () {
                        if (state.spendCoins(item['price'])) {
                          state.unlockCharacter(item['id']);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Not enough coins!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      child: Text('${item['price']} 🪙'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
