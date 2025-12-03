import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';

class CoinScreen extends StatelessWidget {
  const CoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Coin Store')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            color: Colors.purple.shade50,
            width: double.infinity,
            child: Column(
              children: [
                const Text('Your Balance', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('${state.coins} 🪙', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.amber)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCoinPack(context, state, 'Tiny Pack', 100, '\$0.99'),
                _buildCoinPack(context, state, 'Small Pack', 500, '\$4.99'),
                _buildCoinPack(context, state, 'Mega Pack', 1200, '\$9.99'),
                _buildCoinPack(context, state, 'Ultra Pack', 5000, '\$29.99'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPack(BuildContext context, GameState state, String name, int amount, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.amber,
          child: Icon(Icons.monetization_on, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text('$amount Coins'),
        trailing: ElevatedButton(
          onPressed: () {
            // Mock purchase
            state.addCoins(amount);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Purchased $amount coins!')),
            );
          },
          child: Text(price),
        ),
      ),
    );
  }
}
