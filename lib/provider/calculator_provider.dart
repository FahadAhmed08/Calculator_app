import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  bool _isResultFinalized = false;
  bool shouldAddToHistory = false; // Flag added
  List<Map<String, String>> _history = []; // History List

  static const int maxExpressionLength = 10;

  // Getters
  String get expression => _expression;
  String get result => _result;
  bool get isResultFinalized => _isResultFinalized;
  List<Map<String, String>> get history => _history;

  // Clear all
  void clearAll() {
    _expression = '';
    _result = '0';
    _isResultFinalized = false;
    shouldAddToHistory = false; // Reset flag
    _history.clear();
    notifyListeners();
  }

  // Clear expression
  void clearExpression() {
    _expression = '';
    _result = '0';
    _isResultFinalized = false;
    shouldAddToHistory = false; // Reset flag
    notifyListeners();
  }

  // Remove last character
  void removeLast() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression.isEmpty) {
        _result = '0';
      } else {
        _calculateIntermediateResult();
      }
      notifyListeners();
    }
  }

  void addCharacter(String character) {
    if (_isResultFinalized) {
      if (shouldAddToHistory) {
        _history.add({'expression': _expression, 'result': _result});
        shouldAddToHistory = false; // Reset flag after adding to history
      }
      _expression = '';
      _result = '0';
      _isResultFinalized = false;
    }

    // Ignore '0' if it's clicked alone
    if (_expression.isEmpty && character == '0') {
      return;
    }

    if (_expression == '0' &&
        character != '+' &&
        character != '-' &&
        character != '×' &&
        character != '÷') {
      return;
    }

    if (character == '%') {
      if (_expression.isNotEmpty && !_expression.endsWith('%')) {
        RegExp regex = RegExp(r'(\d+(\.\d+)?)$');
        Match? match = regex.firstMatch(_expression);

        if (match != null) {
          String lastNumber = match.group(0)!;
          double percentageValue = double.parse(lastNumber) / 100;

          _expression = _expression.substring(0, match.start) +
              percentageValue.toString();

          _result = _expression;
        }
        notifyListeners();
      }
    } else {
      if (_expression == '0' && RegExp(r'[1-9]').hasMatch(character)) {
        _expression = character;
      } else if (_expression.isEmpty &&
          RegExp(r'[+\-×÷]').hasMatch(character)) {
        _expression = '0$character';
      } else if (_expression.isNotEmpty &&
          RegExp(r'[+\-×÷]').hasMatch(character) &&
          RegExp(r'[+\-×÷]').hasMatch(_expression[_expression.length - 1])) {
        _expression =
            _expression.substring(0, _expression.length - 1) + character;
      } else if (_expression.length < maxExpressionLength) {
        _expression += character;
      }

      _calculateIntermediateResult();
      notifyListeners();
    }
  }

  // Calculate intermediate result
  void _calculateIntermediateResult() {
    try {
      String expressionWithPercentage = _expression.replaceAll('%', '/100');

      // Agar last character operator hai, result update na karo
      if (RegExp(r'[+\-×÷]$').hasMatch(expressionWithPercentage)) {
        return;
      }

      final parser = Parser();
      final exp = parser.parse(
          expressionWithPercentage.replaceAll('×', '*').replaceAll('÷', '/'));
      final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
      _result =
          (eval == eval.toInt()) ? eval.toInt().toString() : eval.toString();
    } catch (e) {
      _result = '0';
    }
  }

  // Calculate final result
  String calculateResult() {
    try {
      String expressionWithPercentage = _expression.replaceAll('%', '/100');

      // Agar last character operator hai, to hatao
      while (RegExp(r'[+\-×÷]$').hasMatch(expressionWithPercentage)) {
        expressionWithPercentage = expressionWithPercentage.substring(
            0, expressionWithPercentage.length - 1);
      }

      if (expressionWithPercentage.isEmpty) {
        _result = '0';
      } else {
        final parser = Parser();
        final exp = parser.parse(
            expressionWithPercentage.replaceAll('×', '*').replaceAll('÷', '/'));
        final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
        _result =
            (eval == eval.toInt()) ? eval.toInt().toString() : eval.toString();
        _isResultFinalized = true;
        shouldAddToHistory = true;
      }
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
    return _result;
  }

  // Clear history
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
