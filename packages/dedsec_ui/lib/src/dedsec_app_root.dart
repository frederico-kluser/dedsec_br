import 'package:flutter/material.dart';

import 'pages/achievements_page.dart';
import 'pages/channels_page.dart';
import 'pages/city_page.dart';
import 'pages/detail_page.dart';
import 'pages/forum_list_page.dart';
import 'pages/forum_scope_page.dart';
import 'pages/generate_page.dart';
import 'pages/help_page.dart';
import 'pages/home_page.dart';
import 'pages/interests_page.dart';
import 'pages/new_post_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/perms_page.dart';
import 'pages/route.dart';
import 'pages/settings_page.dart';
import 'pages/splash_page.dart';
import 'pages/topic_page.dart';
import 'state/app_state.dart';
import 'tokens/colors.dart';
import 'tokens/theme.dart';

/// Top-level widget. Mirrors the React `<App/>` switch on `s.screen` but as
/// a Flutter widget — every screen is rendered full-bleed (no desktop
/// chrome). The in-app "go" navigation stays exactly like the prototype.
class DedsecApp extends StatefulWidget {
  const DedsecApp({super.key});

  @override
  State<DedsecApp> createState() => _DedsecAppState();
}

class _DedsecAppState extends State<DedsecApp> {
  final _state = DedsecAppState();
  DedsecScreen _current = DedsecScreen.splash;

  void _go(DedsecScreen s) {
    setState(() {
      _current = s;
      // mirror the React `go` mapping → tab sync
      final newTab = switch (s) {
        DedsecScreen.home => 'home',
        DedsecScreen.help => 'help',
        DedsecScreen.forumScope ||
        DedsecScreen.forumList ||
        DedsecScreen.topic ||
        DedsecScreen.newPost =>
          'forum',
        DedsecScreen.settings => 'settings',
        _ => _state.tab,
      };
      if (newTab != _state.tab) _state.setTab(newTab);
    });
  }

  void _goTab(String t) {
    _state.setTab(t);
    setState(() {
      _current = switch (t) {
        'home' => DedsecScreen.home,
        'help' => DedsecScreen.help,
        'forum' => DedsecScreen.forumScope,
        'settings' => DedsecScreen.settings,
        _ => _current,
      };
    });
  }

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
      theme: buildDedsecTheme(),
      builder: (context, child) => DefaultTextStyle.merge(
        style: const TextStyle(color: DedsecColors.ink),
        child: child!,
      ),
      home: DedsecScope(
        notifier: _state,
        child: AnimatedBuilder(
          animation: _state,
          builder: (_, __) => _renderScreen(),
        ),
      ),
    );
  }

  Widget _renderScreen() {
    return switch (_current) {
      DedsecScreen.splash => SplashPage(onGo: _go),
      DedsecScreen.onboarding => OnboardingPage(onGo: _go),
      DedsecScreen.interests => InterestsPage(onGo: _go),
      DedsecScreen.city => CityPage(onGo: _go),
      DedsecScreen.perms => PermsPage(onGo: _go),
      DedsecScreen.home => HomePage(onGo: _go, activeTab: _state.tab, onTab: _goTab),
      DedsecScreen.detail => DetailPage(onGo: _go),
      DedsecScreen.generate => GeneratePage(onGo: _go),
      DedsecScreen.channels => ChannelsPage(onGo: _go),
      DedsecScreen.help => HelpPage(onGo: _go, activeTab: _state.tab, onTab: _goTab, user: _state.user),
      DedsecScreen.achievements => AchievementsPage(onGo: _go, user: _state.user),
      DedsecScreen.forumScope => ForumScopePage(onGo: _go, activeTab: _state.tab, onTab: _goTab),
      DedsecScreen.forumList => ForumListPage(onGo: _go, activeTab: _state.tab, onTab: _goTab),
      DedsecScreen.topic => TopicPage(onGo: _go),
      DedsecScreen.newPost => NewPostPage(onGo: _go),
      DedsecScreen.settings => SettingsPage(onGo: _go, activeTab: _state.tab, onTab: _goTab),
    };
  }
}
