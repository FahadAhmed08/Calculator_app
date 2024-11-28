import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/calculator_provider.dart';
import '../provider/history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Confirmation dialog for clearing history
  void _confirmClearHistory(BuildContext context,
      HistoryProvider historyProvider, CalculatorProvider calculatorProvider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Clear history and expressions
              historyProvider.clearHistory();
              calculatorProvider.clearAll();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Move back to CalculatorScreen
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final calculatorProvider = Provider.of<CalculatorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmClearHistory(
                context, historyProvider, calculatorProvider),
          ),
        ],
      ),
      body: historyProvider.history.isEmpty
          ? const Center(
              child: Text(
                'No history found.',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: historyProvider.history.length,
              itemBuilder: (context, index) {
                final item = historyProvider.history[index];
                return ListTile(
                  title: Text(
                    item['expression']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '= ${item['result']}',
                    style: const TextStyle(color: Colors.orange),
                  ),
                );
              },
            ),
    );
  }
}
