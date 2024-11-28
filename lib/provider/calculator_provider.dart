import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  bool _isResultFinalized = false;
  List<Map<String, String>> _history = []; // Added history

  static const int maxExpressionLength = 11;

  // Getters
  String get expression => _expression;
  String get result => _result;
  bool get isResultFinalized => _isResultFinalized;
  List<Map<String, String>> get history => _history; // History getter

  // Clear all data
  void clearAll() {
    _expression = '';
    _result = '0';
    _isResultFinalized = false;

    // Local history clear karein
    _history.clear();

    notifyListeners();
  }

  // Clear current expression only
  void clearExpression() {
    _expression = '';
    _result = '0';
    _isResultFinalized = false;
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

  // Add character to expression
  void addCharacter(String character) {
    if (_isResultFinalized) {
      _expression = '';
      _result = '0';
      _isResultFinalized = false;
    }

    if (character == '%') {
      // If '%' is pressed, handle it as a percentage operation
      if (_expression.isNotEmpty && !_expression.endsWith('%')) {
        _expression += character;
        _calculateIntermediateResult();
        notifyListeners();
      }
    } else {
      if (_expression.length < maxExpressionLength) {
        _expression += character;
        _calculateIntermediateResult();
        notifyListeners();
      }
    }
  }

  // Calculate intermediate result
  void _calculateIntermediateResult() {
    try {
      // Handle the case where there's a percentage sign
      String expressionWithPercentage = _expression.replaceAll('%', '/100');

      // Avoid displaying the operator if it's at the end of the expression
      if (expressionWithPercentage.endsWith('+') ||
          expressionWithPercentage.endsWith('-') ||
          expressionWithPercentage.endsWith('×') ||
          expressionWithPercentage.endsWith('÷')) {
        _result = expressionWithPercentage.substring(
            0, expressionWithPercentage.length - 1); // Remove last operator
      } else {
        final parser = Parser();
        final exp = parser.parse(
            expressionWithPercentage.replaceAll('×', '*').replaceAll('÷', '/'));
        final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
        _result =
            (eval == eval.toInt()) ? eval.toInt().toString() : eval.toString();
      }
    } catch (e) {
      _result = '0';
    }
  }

  // Calculate final result
  String calculateResult() {
    try {
      // Handle the case where there's a percentage sign
      String expressionWithPercentage = _expression.replaceAll('%', '/100');

      // Avoid displaying the operator if it's at the end of the expression
      if (expressionWithPercentage.endsWith('+') ||
          expressionWithPercentage.endsWith('-') ||
          expressionWithPercentage.endsWith('×') ||
          expressionWithPercentage.endsWith('÷')) {
        _expression = _expression.substring(
            0, _expression.length - 1); // Remove last operator
      }

      final parser = Parser();
      final exp = parser.parse(
          expressionWithPercentage.replaceAll('×', '*').replaceAll('÷', '/'));
      final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
      _result =
          (eval == eval.toInt()) ? eval.toInt().toString() : eval.toString();
      _isResultFinalized = true;

      // Add to history
      _history.add({'expression': _expression, 'result': _result});
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
