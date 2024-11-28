import 'package:calculator_3/provider/calculator_provider.dart';
import 'package:calculator_3/provider/history_provider.dart';
import 'package:calculator_3/screens/history_screen.dart';
import 'package:calculator_3/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
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
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HistoryScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                          position: offsetAnimation, child: child);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (calculatorProvider.history.isNotEmpty)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ListView.builder(
                  reverse: true,
                  itemCount: calculatorProvider.history.length,
                  itemBuilder: (context, index) {
                    final item = calculatorProvider.history[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item['expression']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 18 : 22,
                              ),
                            ),
                            Text(
                              '=${item['result']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 18 : 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (calculatorProvider.expression.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 20,
                            ),
                            child: Text(
                              calculatorProvider.expression,
                              style: TextStyle(
                                fontSize: calculatorProvider.isResultFinalized
                                    ? 30
                                    : calculatorProvider.expression.length <= 40
                                        ? (isSmallScreen ? 35 : 50)
                                        : (isSmallScreen ? 25 : 30),
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 20.0,
                          ),
                          child: Text(
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
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                  child:
                      Divider(height: 2, thickness: 0, color: Colors.white54),
                ),
                for (var row in _buildButtonRows(calculatorProvider,
                    Provider.of<HistoryProvider>(context), isSmallScreen))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row,
                    ),
                  ),
              ],
            ),
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
          textColor: Colors.orange,
          textSize: 35),
      CalculatorButton(
          label: '⌫',
          onPressed: calculatorProvider.removeLast,
          textColor: Colors.orange,
          textSize: 25),
      CalculatorButton(
          label: '%',
          onPressed: () => calculatorProvider.addCharacter('%'),
          textColor: Colors.orange,
          textSize: 35),
      CalculatorButton(
          label: '÷',
          onPressed: () => calculatorProvider.addCharacter('÷'),
          textColor: Colors.orange,
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
          textColor: Colors.orange,
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
          textColor: Colors.orange,
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
          textColor: Colors.orange,
          textSize: 35),
    ],
    [
      CalculatorButton(
          label: 'AC',
          onPressed: calculatorProvider.clearAll,
          textColor: Colors.orange,
          textSize: 35),
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
