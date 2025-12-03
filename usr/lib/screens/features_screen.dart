import 'package:flutter/material.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('100 Features')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.primaries[index % Colors.primaries.length]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIcon(index),
                  color: Colors.primaries[index % Colors.primaries.length],
                ),
                const SizedBox(height: 5),
                Text(
                  'Feat #${index + 1}',
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(int index) {
    // Just returning some random icons for visual variety
    final icons = [
      Icons.ac_unit, Icons.access_alarm, Icons.accessibility, Icons.account_balance,
      Icons.adb, Icons.add_a_photo, Icons.adjust, Icons.agriculture, Icons.air,
      Icons.airline_seat_flat, Icons.airport_shuttle, Icons.all_inclusive,
      Icons.analytics, Icons.anchor, Icons.android, Icons.announcement,
      Icons.api, Icons.app_blocking, Icons.apps, Icons.architecture,
    ];
    return icons[index % icons.length];
  }
}
