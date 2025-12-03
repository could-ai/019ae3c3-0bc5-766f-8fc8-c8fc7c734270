import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameState extends ChangeNotifier {
  final SharedPreferences prefs;

  int _coins = 0;
  int _highScore = 0;
  String _selectedCharacter = 'fox'; // fox, panda, rabbit
  List<String> _unlockedCharacters = ['fox'];
  
  // Daily Quests Progress
  int _jumpsToday = 0;
  bool _questJumpClaimed = false;
  
  GameState(this.prefs) {
    _loadData();
  }

  int get coins => _coins;
  int get highScore => _highScore;
  String get selectedCharacter => _selectedCharacter;
  List<String> get unlockedCharacters => _unlockedCharacters;
  int get jumpsToday => _jumpsToday;
  bool get questJumpClaimed => _questJumpClaimed;

  void _loadData() {
    _coins = prefs.getInt('coins') ?? 100; // Start with 100 coins
    _highScore = prefs.getInt('highScore') ?? 0;
    _selectedCharacter = prefs.getString('selectedCharacter') ?? 'fox';
    _unlockedCharacters = prefs.getStringList('unlockedCharacters') ?? ['fox'];
    notifyListeners();
  }

  void addCoins(int amount) {
    _coins += amount;
    prefs.setInt('coins', _coins);
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      prefs.setInt('coins', _coins);
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateHighScore(int score) {
    if (score > _highScore) {
      _highScore = score;
      prefs.setInt('highScore', _highScore);
      notifyListeners();
    }
  }

  void unlockCharacter(String id) {
    if (!_unlockedCharacters.contains(id)) {
      _unlockedCharacters.add(id);
      prefs.setStringList('unlockedCharacters', _unlockedCharacters);
      notifyListeners();
    }
  }

  void selectCharacter(String id) {
    if (_unlockedCharacters.contains(id)) {
      _selectedCharacter = id;
      prefs.setString('selectedCharacter', _selectedCharacter);
      notifyListeners();
    }
  }

  void incrementJump() {
    _jumpsToday++;
    notifyListeners();
  }

  void claimQuestReward() {
    if (_jumpsToday >= 100 && !_questJumpClaimed) {
      addCoins(50);
      _questJumpClaimed = true;
      notifyListeners();
    }
  }
}
