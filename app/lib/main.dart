import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app_scope.dart';
import 'app/app_state.dart';
import 'app/router.dart';
import 'theme/colors.dart';
import 'theme/fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const DedsecApp());
}

class DedsecApp extends StatefulWidget {
  const DedsecApp({super.key});
  @override
  State<DedsecApp> createState() => _DedsecAppState();
}

class _DedsecAppState extends State<DedsecApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dedsec_BR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: COL.bg,
        textTheme: TextTheme(
          bodyMedium: FONT.body(),
        ),
        colorScheme: ColorScheme.dark(
          surface: COL.bg,
          onSurface: COL.ink,
          primary: COL.magenta,
          secondary: COL.acid,
          error: COL.danger,
        ),
      ),
      home: AppScope(
        state: _state,
        child: const Scaffold(
          backgroundColor: COL.bg,
          body: SafeArea(top: false, child: AppRouter()),
        ),
      ),
    );
  }
}
