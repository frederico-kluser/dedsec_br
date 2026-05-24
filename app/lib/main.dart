import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/data/app_state.dart';
import 'src/design/colors.dart';
import 'src/design/fonts.dart';
import 'src/screens/achievements.dart';
import 'src/screens/channels.dart';
import 'src/screens/city.dart';
import 'src/screens/detail.dart';
import 'src/screens/forum_list.dart';
import 'src/screens/forum_scope.dart';
import 'src/screens/generate.dart';
import 'src/screens/help.dart';
import 'src/screens/home.dart';
import 'src/screens/interests.dart';
import 'src/screens/new_post.dart';
import 'src/screens/onboarding.dart';
import 'src/screens/perms.dart';
import 'src/screens/settings.dart';
import 'src/screens/splash.dart';
import 'src/screens/topic.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DedsecApp());
}

class DedsecApp extends StatefulWidget {
  const DedsecApp({super.key});

  @override
  State<DedsecApp> createState() => _DedsecAppState();
}

class _DedsecAppState extends State<DedsecApp> {
  final _state = AppState();

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
        scaffoldBackgroundColor: DCol.bg,
        useMaterial3: true,
        primaryColor: DCol.magenta,
        textTheme: TextTheme(bodyMedium: DFont.body()),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: DCol.acid,
          selectionColor: Color(0x55B7FF2A),
          selectionHandleColor: DCol.acid,
        ),
      ),
      home: AppScope(
        state: _state,
        child: const _Router(),
      ),
    );
  }
}

class _Router extends StatelessWidget {
  const _Router();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
      backgroundColor: DCol.bg,
      body: SafeArea(child: _screenFor(app.screen)),
    );
  }

  Widget _screenFor(Screen s) {
    switch (s) {
      case Screen.splash:
        return const SplashScreen();
      case Screen.onboarding:
        return const OnboardingScreen();
      case Screen.interests:
        return const InterestsScreen();
      case Screen.city:
        return const CityScreen();
      case Screen.perms:
        return const PermsScreen();
      case Screen.home:
        return const HomeScreen();
      case Screen.detail:
        return const DetailScreen();
      case Screen.generate:
        return const GenerateScreen();
      case Screen.channels:
        return const ChannelsScreen();
      case Screen.help:
        return const HelpScreen();
      case Screen.achievements:
        return const AchievementsScreen();
      case Screen.forumScope:
        return const ForumScopeScreen();
      case Screen.forumList:
        return const ForumListScreen();
      case Screen.topic:
        return const TopicScreen();
      case Screen.newPost:
        return const NewPostScreen();
      case Screen.settings:
        return const SettingsScreen();
    }
  }
}
