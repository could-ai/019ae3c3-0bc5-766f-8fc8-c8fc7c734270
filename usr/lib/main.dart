import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'state/game_state.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/features_screen.dart';
import 'screens/coin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState(prefs)),
      ],
      child: const SkyJumpApp(),
    ),
  );
}

class SkyJumpApp extends StatelessWidget {
  const SkyJumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Jump Legends',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        fontFamily: 'Roboto', // Fallback
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
        '/shop': (context) => const ShopScreen(),
        '/features': (context) => const FeaturesScreen(),
        '/coins': (context) => const CoinScreen(),
      },
    );
  }
}
