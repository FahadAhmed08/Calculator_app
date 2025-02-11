import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  List<Map<String, String>> _history = [];

  List<Map<String, String>> get history => _history;

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getString('history');
    if (historyData != null) {
      final List<dynamic> decodedHistory = json.decode(historyData);
      _history =
          decodedHistory.map((item) => Map<String, String>.from(item)).toList();
    } else {
      _history = [];
    }
    notifyListeners();
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedHistory = json.encode(_history);
    await prefs.setString('history', encodedHistory);
  }

  void addToHistory(String expression, String result) {
    if (expression.isNotEmpty && result != 'Error') {
      // Check if the last history entry is the same
      if (_history.isEmpty ||
          _history.last['expression'] != expression ||
          _history.last['result'] != result) {
        _history.add({'expression': expression, 'result': result});
        saveHistory();
        notifyListeners();
      }
    }
  }

  void clearHistory() {
    _history.clear();
    saveHistory();
    notifyListeners();
  }
}
