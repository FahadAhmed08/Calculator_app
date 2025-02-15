import 'package:calculator_3/provider/calculator_provider.dart';
import 'package:calculator_3/provider/history_provider.dart';
import 'package:calculator_3/screens/history_screen.dart';
import 'package:calculator_3/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool isCalculatorHidden = false;

  void _toggleCalculator(bool hide) {
    setState(() {
      isCalculatorHidden = hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(
                Icons.history_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // Ensure all areas detect touch
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            _toggleCalculator(true);
          } else if (details.primaryDelta! < -10) {
            _toggleCalculator(false);
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        children: calculatorProvider.history.reversed
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(
                                    right: 15, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item['expression']!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 18 : 22),
                                    ),
                                    Text(
                                      '=${item['result']!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 18 : 22),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (calculatorProvider.expression.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                calculatorProvider.expression,
                                style: TextStyle(
                                  fontSize:
                                      calculatorProvider.expression.length <= 12
                                          ? (isSmallScreen ? 20.0 : 55.0)
                                          : (isSmallScreen
                                              ? (20 -
                                                      ((calculatorProvider
                                                                  .expression
                                                                  .length -
                                                              13) *
                                                          2))
                                                  .clamp(10, 20)
                                                  .toDouble()
                                              : (50 -
                                                      ((calculatorProvider
                                                                  .expression
                                                                  .length -
                                                              13) *
                                                          2))
                                                  .clamp(10, 50)
                                                  .toDouble()),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Text(
                            calculatorProvider.expression.isEmpty
                                ? '0'
                                : "=${calculatorProvider.result}",
                            style: TextStyle(
                              fontSize: calculatorProvider.expression.isEmpty
                                  ? (isSmallScreen ? 50 : 60)
                                  : calculatorProvider.isResultFinalized
                                      ? (isSmallScreen ? 40 : 50)
                                      : (isSmallScreen ? 30 : 35),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0, endIndent: 15, indent: 20),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isCalculatorHidden ? 0 : 456,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var row in _buildButtonRows(
                      calculatorProvider, historyProvider, isSmallScreen))
                    SizedBox(
                      height: 86,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: row,
                      ),
                    ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _HistoryItem extends StatelessWidget {
  final String expression;
  final String result;
  final bool isSmallScreen;

  const _HistoryItem({
    required this.expression,
    required this.result,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            expression,
            style: TextStyle(
                color: Colors.white, fontSize: isSmallScreen ? 18 : 22),
          ),
          Text(
            '=$result',
            style: TextStyle(
                color: Colors.white, fontSize: isSmallScreen ? 18 : 22),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _ExpressionDisplay extends StatelessWidget {
  final String expression;
  final String result;
  final bool isResultFinalized;

  const _ExpressionDisplay({
    required this.expression,
    required this.result,
    required this.isResultFinalized,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double calculateFontSize() {
      int length = expression.length;
      bool isSmallScreen =
          screenWidth < 400; // 400px se chhoti screen small mani jayegi

      return length <= 11
          ? (isSmallScreen ? 40 : 60)
          : (isSmallScreen ? 20 : 40);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (expression.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                expression,
                style: TextStyle(
                  fontSize: calculateFontSize(),
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          Text(
            expression.isEmpty ? '0' : "=$result",
            style: TextStyle(
              fontSize: isResultFinalized
                  ? (screenWidth < 400 ? 40 : 50)
                  : (screenWidth < 400 ? 30 : 35),
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

List<List<Widget>> _buildButtonRows(CalculatorProvider calculatorProvider,
    HistoryProvider historyProvider, bool isSmallScreen) {
  return [
    [
      CalculatorButton(
          label: 'C',
          onPressed: () {
            if (calculatorProvider.expression.isEmpty) {
              calculatorProvider.clearAll();
            } else {
              calculatorProvider.clearExpression();
            }
          },
          textColor: Colors.deepOrangeAccent,
          textSize: 30),
      CalculatorButton(
          label: '⌫',
          onPressed: calculatorProvider.removeLast,
          textColor: Colors.deepOrangeAccent,
          textSize: 22),
      CalculatorButton(
          label: '%',
          onPressed: () => calculatorProvider.addCharacter('%'),
          textColor: Colors.deepOrangeAccent,
          textSize: 30),
      CalculatorButton(
          label: '÷',
          onPressed: () => calculatorProvider.addCharacter('÷'),
          textColor: Colors.deepOrangeAccent,
          textSize: 35),
    ],
    [
      CalculatorButton(
          label: '7',
          onPressed: () => calculatorProvider.addCharacter('7'),
          textSize: 35),
      CalculatorButton(
          label: '8',
          onPressed: () => calculatorProvider.addCharacter('8'),
          textSize: 35),
      CalculatorButton(
          label: '9',
          onPressed: () => calculatorProvider.addCharacter('9'),
          textSize: 35),
      CalculatorButton(
          label: '×',
          onPressed: () => calculatorProvider.addCharacter('×'),
          textColor: Colors.deepOrangeAccent,
          textSize: 35),
    ],
    [
      CalculatorButton(
          label: '4',
          onPressed: () => calculatorProvider.addCharacter('4'),
          textSize: 35),
      CalculatorButton(
          label: '5',
          onPressed: () => calculatorProvider.addCharacter('5'),
          textSize: 35),
      CalculatorButton(
          label: '6',
          onPressed: () => calculatorProvider.addCharacter('6'),
          textSize: 35),
      CalculatorButton(
          label: '-',
          onPressed: () => calculatorProvider.addCharacter('-'),
          textColor: Colors.deepOrangeAccent,
          textSize: 35),
    ],
    [
      CalculatorButton(
          label: '1',
          onPressed: () => calculatorProvider.addCharacter('1'),
          textSize: 35),
      CalculatorButton(
          label: '2',
          onPressed: () => calculatorProvider.addCharacter('2'),
          textSize: 35),
      CalculatorButton(
          label: '3',
          onPressed: () => calculatorProvider.addCharacter('3'),
          textSize: 35),
      CalculatorButton(
          label: '+',
          onPressed: () => calculatorProvider.addCharacter('+'),
          textColor: Colors.deepOrangeAccent,
          textSize: 35),
    ],
    [
      CalculatorButton(
          label: 'AC',
          onPressed: calculatorProvider.clearAll,
          textColor: Colors.deepOrangeAccent,
          textSize: 30),
      CalculatorButton(
          label: '0',
          onPressed: () => calculatorProvider.addCharacter('0'),
          textSize: 35),
      CalculatorButton(
          label: '.',
          onPressed: () => calculatorProvider.addCharacter('.'),
          textSize: 35),
      CalculatorButton(
          label: '=',
          isCircle: true,
          onPressed: () {
            String result = calculatorProvider.calculateResult();
            historyProvider.addToHistory(calculatorProvider.expression, result);
          },
          textSize: 35),
    ],
  ];
}
