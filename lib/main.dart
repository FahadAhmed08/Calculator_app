import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_3/provider/calculator_provider.dart';
import 'package:calculator_3/provider/history_provider.dart';
import 'package:calculator_3/screens/calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock the screen orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CalculatorProvider()),
          ChangeNotifierProvider(
              create: (_) => HistoryProvider()..loadHistory()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: _buildTheme(), // Customized dark theme applied here
      home: const CalculatorScreen(),
    );
  }
}
