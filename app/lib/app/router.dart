import 'package:flutter/material.dart';

import '../screens/achievements.dart';
import '../screens/channels.dart';
import '../screens/city.dart';
import '../screens/detail.dart';
import '../screens/forum_list.dart';
import '../screens/forum_scope.dart';
import '../screens/generate.dart';
import '../screens/help.dart';
import '../screens/home.dart';
import '../screens/interests.dart';
import '../screens/new_post.dart';
import '../screens/onboarding.dart';
import '../screens/perms.dart';
import '../screens/settings.dart';
import '../screens/splash.dart';
import '../screens/topic.dart';
import '../widgets/loaders/loaders.dart';
import '../widgets/molecules/loader_showcase.dart';
import 'app_scope.dart';
import 'app_state.dart';

/// Picks the screen widget that matches [AppState.route].
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return _routeWidget(state.route);
  }

  Widget _routeWidget(AppRoute r) {
    switch (r) {
      case AppRoute.splash:
        return const SplashScreen();
      case AppRoute.onb1:
        return const OnboardingScreen();
      case AppRoute.interests:
        return const InterestsScreen();
      case AppRoute.city:
        return const CityScreen();
      case AppRoute.perms:
        return const PermsScreen();
      case AppRoute.home:
        return const HomeScreen();
      case AppRoute.detail:
        return const DetailScreen();
      case AppRoute.generate:
        return const GenerateScreen();
      case AppRoute.channels:
        return const ChannelsScreen();
      case AppRoute.help:
        return const HelpScreen();
      case AppRoute.achievements:
        return const AchievementsScreen();
      case AppRoute.forum:
        return const ForumScopeScreen();
      case AppRoute.forumList:
        return const ForumListScreen();
      case AppRoute.topic:
        return const TopicScreen();
      case AppRoute.newpost:
        return const NewPostScreen();
      case AppRoute.settings:
        return const SettingsScreen();
      // ─── loaders ─────────────────────────────────────────────
      case AppRoute.ldTerminal:
        return const LoaderShowcase(
          id: 'LD-TERMINAL',
          title: 'Terminal de Boot',
          subtitle: 'rolagem CRT · verde-ácido',
          child: LoaderTerminal(),
        );
      case AppRoute.ldHalftone:
        return const LoaderShowcase(
          id: 'LD-HALFTONE',
          title: 'Pulso Halftone',
          subtitle: 'pop-art pulsante · embaralhamento',
          child: LoaderHalftone(),
        );
      case AppRoute.ldRadar:
        return const LoaderShowcase(
          id: 'LD-RADAR',
          title: 'Varredura Radar',
          subtitle: 'descoberta de pares · p2p',
          child: LoaderRadar(),
        );
      case AppRoute.ldTape:
        return const LoaderShowcase(
          id: 'LD-TAPE',
          title: 'Fita de Dados',
          subtitle: 'fluxo vertical · binário/vazamento',
          child: LoaderDataTape(),
        );
      case AppRoute.ldCounter:
        return const LoaderShowcase(
          id: 'LD-COUNTER',
          title: 'Contador de Células',
          subtitle: 'mutirão · explosões de caveira',
          child: LoaderCounter(),
        );
      case AppRoute.ldGlitch:
        return const LoaderShowcase(
          id: 'LD-GLITCH',
          title: 'Glitch Embaralhado',
          subtitle: 'split RGB · burst pop-art',
          child: LoaderGlitch(),
        );
      case AppRoute.ldTokens:
        return const LoaderShowcase(
          id: 'LD-TOKENS',
          title: 'Stream de Tokens',
          subtitle: 'usado pra processar pauta no LLM',
          child: LoaderTokenStream(),
        );
      case AppRoute.ldRain:
        return const LoaderShowcase(
          id: 'LD-RAIN',
          title: 'Chuva Binária',
          subtitle: 'matrix-style · DEDSEC infiltrado',
          child: LoaderBinaryRain(),
        );
      case AppRoute.ldSpectrum:
        return const LoaderShowcase(
          id: 'LD-SPECTRUM',
          title: 'Espectro de Sinal',
          subtitle: 'equalizer · escutando a rede',
          child: LoaderSpectrum(),
        );
      case AppRoute.ldGlyph:
        return const LoaderShowcase(
          id: 'LD-GLYPH',
          title: 'Decifrador',
          subtitle: 'scramble · arquivo interceptado',
          child: LoaderGlyphDecode(),
        );
      case AppRoute.ldTkAttn:
        return const LoaderShowcase(
          id: 'LD-TK-ATTN',
          title: 'Tokens · Atenção',
          subtitle: 'matriz de attention weights',
          child: LoaderTokenAttention(),
        );
      case AppRoute.ldTkBeam:
        return const LoaderShowcase(
          id: 'LD-TK-BEAM',
          title: 'Tokens · Top-K',
          subtitle: 'top-K sampling · candidatos com prob',
          child: LoaderTokenBeam(),
        );
      case AppRoute.ldTkRag:
        return const LoaderShowcase(
          id: 'LD-TK-RAG',
          title: 'Tokens · RAG',
          subtitle: 'busca + chunks + geração',
          child: LoaderTokenRAG(),
        );
      case AppRoute.ldTkLayers:
        return const LoaderShowcase(
          id: 'LD-TK-LAYERS',
          title: 'Tokens · Camadas',
          subtitle: 'transformer stack · 12×8',
          child: LoaderTokenLayers(),
        );
    }
  }
}
