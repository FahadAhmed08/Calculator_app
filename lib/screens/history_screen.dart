import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/calculator_provider.dart';
import '../provider/history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _handleDelete(BuildContext context, HistoryProvider historyProvider,
      CalculatorProvider calculatorProvider) {
    if (historyProvider.history.isEmpty) {
      // Agar history empty ho
      if (calculatorProvider.expression.isNotEmpty) {
        calculatorProvider.clearAll(); // Expression delete
      }
      Navigator.pop(context); // Direct navigate kare
    } else {
      // Agar history available ho, confirm kare
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Clear History'),
          content: const Text('Are you sure you want to clear all history?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                historyProvider.clearHistory(); // History delete
                calculatorProvider.clearAll(); // Expression delete
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                _handleDelete(context, historyProvider, calculatorProvider),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            // History List
            Expanded(
              child: historyProvider.history.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      itemCount: historyProvider.history.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final reversedIndex =
                            historyProvider.history.length - 1 - index;
                        final item = historyProvider.history[reversedIndex];

                        return Align(
                          alignment: Alignment.centerRight,
                          child: ListTile(
                            title: Text(
                              item['expression']!,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            subtitle: Text(
                              '=${item['result']}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Divider Between History and Current Expression
            const Divider(
              color: Colors.white54,
              thickness: 0,
              height: 10,
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 25,
            ),

            // Current Expression Display
            if (calculatorProvider.expression.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    calculatorProvider.expression,
                    textAlign: TextAlign.right,
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
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  calculatorProvider.expression.isEmpty
                      ? '0'
                      : "=${calculatorProvider.result}",
                  textAlign: TextAlign.right,
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
            ),
          ],
        ),
      ),
    );
  }
}
