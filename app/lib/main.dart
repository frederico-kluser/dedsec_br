import 'package:flutter/material.dart';

void main() {
  runApp(const DedsecApp());
}

class DedsecApp extends StatelessWidget {
  const DedsecApp({super.key});

  static const _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dedsec',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00FF95),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(env: _env),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({required this.env, super.key});

  final String env;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dedsec'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, Dedsec',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'env: $env',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
