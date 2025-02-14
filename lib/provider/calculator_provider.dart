// import 'package:flutter/material.dart';
// import 'package:math_expressions/math_expressions.dart';

// class CalculatorProvider extends ChangeNotifier {
//   String _expression = ''; // Stores user input expression
//   String _result = '0'; // Stores calculated result
//   bool _isResultFinalized = false; // Flag to check if result is final
//   bool shouldAddToHistory = false; // Flag to manage history
//   List<Map<String, String>> _history = []; // Stores calculation history

//   static const int maxExpressionLength =
//       20; // Maximum allowed expression length

//   // Getters for private variables
//   String get expression => _expression;
//   String get result => _result;
//   bool get isResultFinalized => _isResultFinalized;
//   List<Map<String, String>> get history => _history;

//   // Clears all data including expression, result, and history
//   void clearAll() {
//     _expression = '';
//     _result = '0';
//     _isResultFinalized = false;
//     shouldAddToHistory = false;
//     _history.clear();
//     notifyListeners();
//   }

//   // Clears only the current expression
//   void clearExpression() {
//     _expression = '';
//     _result = '0';
//     _isResultFinalized = false;
//     shouldAddToHistory = false;
//     notifyListeners();
//   }

//   // Removes the last character from the expression
//   void removeLast() {
//     if (_expression.isNotEmpty) {
//       _expression = _expression.substring(0, _expression.length - 1);
//       if (_expression.isEmpty) {
//         _result = '0';
//       } else {
//         _calculateIntermediateResult();
//       }
//       notifyListeners();
//     }
//   }

//   // Adds a character (number or operator) to the expression
//   void addCharacter(String character) {
//     if (_isResultFinalized) {
//       if (shouldAddToHistory) {
//         _history.add({'expression': _expression, 'result': _result});
//         shouldAddToHistory = false;
//       }
//       _expression = '';
//       _result = '0';
//       _isResultFinalized = false;
//     }

//     // Prevent leading zero issues
//     if (_expression.isEmpty && character == '0') {
//       return;
//     }

//     // Handle operators after zero
//     if (_expression == '0' && !RegExp(r'[+\-×÷]').hasMatch(character)) {
//       return;
//     }

//     // Handle percentage separately
//     if (character == '%') {
//       _handlePercentage();
//     } else {
//       if (_expression.isEmpty && RegExp(r'[+\-×÷]').hasMatch(character)) {
//         _expression = '0$character';
//       } else if (_expression.isNotEmpty &&
//           RegExp(r'[+\-×÷]').hasMatch(character) &&
//           RegExp(r'[+\-×÷]').hasMatch(_expression[_expression.length - 1])) {
//         _expression =
//             _expression.substring(0, _expression.length - 1) + character;
//       } else if (_expression.length < maxExpressionLength) {
//         _expression += character;
//       }
//     }
//     _calculateIntermediateResult();
//     notifyListeners();
//   }

//   // Handles percentage calculation
//   void _handlePercentage() {
//     RegExp regex = RegExp(r'(\d+(\.\d+)?)$');
//     Match? match = regex.firstMatch(_expression);

//     if (match != null) {
//       String lastNumber = match.group(0)!;
//       double percentageValue = double.parse(lastNumber) / 100;

//       _expression =
//           _expression.substring(0, match.start) + percentageValue.toString();
//       _calculateIntermediateResult();
//     }
//   }

//   // Evaluates the expression for intermediate result display
//   void _calculateIntermediateResult() {
//     try {
//       String modifiedExpression =
//           _expression.replaceAll('×', '*').replaceAll('÷', '/');

//       // Agar expression operator pe end ho raha hai, to last valid part calculate karein
//       modifiedExpression =
//           modifiedExpression.replaceAll(RegExp(r'[+\-*/]+$'), '');
//       if (modifiedExpression.isEmpty) return;

//       final parser = Parser();
//       final exp = parser.parse(modifiedExpression);
//       final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
//       _result =
//           (eval == eval.toInt()) ? eval.toInt().toString() : eval.toString();
//     } catch (e) {
//       _result = '0';
//     }
//   }

//   // Evaluates the final result of the expression
//   String calculateResult() {
//     try {
//       String modifiedExpression =
//           _expression.replaceAll('×', '*').replaceAll('÷', '/');

//       // Agar expression operator pe end ho raha hai, to last valid part calculate karein
//       modifiedExpression =
//           modifiedExpression.replaceAll(RegExp(r'[+\-*/]+$'), '');
//       if (modifiedExpression.isEmpty) {
//         _result = '0';
//       } else {
//         final parser = Parser();
//         final exp = parser.parse(modifiedExpression);
//         final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
//         _result =
//             (eval == eval.toInt()) ? eval.toInt().toString() : eval.toString();
//         _isResultFinalized = true;
//         shouldAddToHistory = true;
//       }
//     } catch (e) {
//       _result = 'Error';
//     }
//     notifyListeners();
//     return _result;
//   }

//   // Clears calculation history
//   void clearHistory() {
//     _history.clear();
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = ''; // Stores user input expression
  String _result = '0'; // Stores calculated result
  bool _isResultFinalized = false; // Flag to check if result is final
  bool shouldAddToHistory = false; // Flag to manage history
  List<Map<String, String>> _history = []; // Stores calculation history

  static const int maxExpressionLength = 20; // Maximum allowed expression length

  // Getters for private variables
  String get expression => _expression;
  String get result => _result;
  bool get isResultFinalized => _isResultFinalized;
  List<Map<String, String>> get history => _history;

  // Clears all data including expression, result, and history
  void clearAll() {
    _expression = '';
    _result = '0';
    _isResultFinalized = false;
    shouldAddToHistory = false;
    _history.clear();
    notifyListeners();
  }

  // Clears only the current expression
  void clearExpression() {
    _expression = '';
    _result = '0';
    _isResultFinalized = false;
    shouldAddToHistory = false;
    notifyListeners();
  }

  // Removes the last character from the expression
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

  // Adds a character (number or operator) to the expression
  void addCharacter(String character) {
    if (_isResultFinalized) {
      if (shouldAddToHistory) {
        _history.add({'expression': _expression, 'result': _result});
        shouldAddToHistory = false;
      }
      _expression = '';
      _result = '0';
      _isResultFinalized = false;
    }

    // Prevent leading zero issues
    if (_expression.isEmpty && character == '0') {
      return;
    }

    // Handle operators after zero
    if (_expression == '0' && !RegExp(r'[+\-×÷]').hasMatch(character)) {
      return;
    }

    // Handle percentage separately
    if (character == '%') {
      _handlePercentage();
    } else {
      if (_expression.isEmpty && RegExp(r'[+\-×÷]').hasMatch(character)) {
        _expression = '0$character';
      } else if (_expression.isNotEmpty &&
          RegExp(r'[+\-×÷]').hasMatch(character) &&
          RegExp(r'[+\-×÷]').hasMatch(_expression[_expression.length - 1])) {
        _expression =
            _expression.substring(0, _expression.length - 1) + character;
      } else if (_expression.length < maxExpressionLength) {
        _expression += character;
      }
    }
    _calculateIntermediateResult();
    notifyListeners();
  }

  // Handles percentage calculation
  void _handlePercentage() {
    RegExp regex = RegExp(r'(\d+(\.\d+)?)$');
    Match? match = regex.firstMatch(_expression);

    if (match != null) {
      String lastNumber = match.group(0)!;
      double percentageValue = double.parse(lastNumber) / 100;

      _expression =
          _expression.substring(0, match.start) + percentageValue.toString();
      _calculateIntermediateResult();
    }
  }

  // Evaluates the expression for intermediate result display
  void _calculateIntermediateResult() {
    try {
      String modifiedExpression =
          _expression.replaceAll('×', '*').replaceAll('÷', '/');

      modifiedExpression =
          modifiedExpression.replaceAll(RegExp(r'[+\-*/]+$'), '');
      if (modifiedExpression.isEmpty) return;

      final parser = Parser();
      final exp = parser.parse(modifiedExpression);
      final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
      
      if (eval.abs() >= 1e9 || eval.abs() < 1e-6 && eval != 0) {
        _result = eval.toStringAsExponential(6);
      } else {
        _result = eval.toString();
      }
    } catch (e) {
      _result = '0';
    }
  }

  // Evaluates the final result of the expression
  String calculateResult() {
    try {
      String modifiedExpression =
          _expression.replaceAll('×', '*').replaceAll('÷', '/');

      modifiedExpression =
          modifiedExpression.replaceAll(RegExp(r'[+\-*/]+$'), '');
      if (modifiedExpression.isEmpty) {
        _result = '0';
      } else {
        final parser = Parser();
        final exp = parser.parse(modifiedExpression);
        final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
        
        if (eval.abs() >= 1e9 || eval.abs() < 1e-6 && eval != 0) {
          _result = eval.toStringAsExponential(6);
        } else {
          _result = eval.toString();
        }
        
        _isResultFinalized = true;
        shouldAddToHistory = true;
      }
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
    return _result;
  }

  // Clears calculation history
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}