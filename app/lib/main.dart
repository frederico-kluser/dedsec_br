// main.dart — Dedsec_BR Flutter app entry.
// Mirrors src/app/index.jsx (React) without the desktop sidebar + Android frame.
// Each screen is full-bleed and uses internal navigation via AppState.go(...).

import 'package:flutter/material.dart';
import 'design.dart';
import 'loaders.dart';
import 'molecules.dart';
import 'state.dart';
import 'pages/core.dart';
import 'pages/comm.dart';
import 'pages/settings.dart';
import 'pages/setup.dart';

void main() => runApp(const DedsecApp());

class DedsecApp extends StatefulWidget {
  const DedsecApp({super.key});
  @override
  State<DedsecApp> createState() => _DedsecAppState();
}

class _DedsecAppState extends State<DedsecApp> {
  final _state = AppState();

  @override
  Widget build(BuildContext c) => MaterialApp(
        title: 'Dedsec_BR',
        debugShowCheckedModeBanner: false,
        theme: buildDedsecTheme(),
        home: AppStateScope(
          state: _state,
          child: AnimatedBuilder(
            animation: _state,
            builder: (ctx, _) => Scaffold(
              backgroundColor: Col.bg,
              body: SafeArea(child: _pickScreen(_state.screen)),
            ),
          ),
        ),
      );

  Widget _pickScreen(String s) {
    switch (s) {
      case 'splash':       return const ScreenSplash();
      case 'onb1':         return const ScreenOnboarding();
      case 'interests':    return const ScreenInterests();
      case 'city':         return const ScreenCity();
      case 'perms':        return const ScreenPerms();
      case 'home':         return const ScreenHome();
      case 'detail':       return const ScreenDetail();
      case 'generate':     return const ScreenGenerate();
      case 'channels':     return const ScreenChannels();
      case 'help':         return const ScreenHelp();
      case 'achievements': return const ScreenAchievements();
      case 'forum':        return const ScreenForumScope();
      case 'forum-list':   return const ScreenForumList();
      case 'topic':        return const ScreenTopic();
      case 'newpost':      return const ScreenNewPost();
      case 'settings':     return const ScreenSettings();
      // Loader gallery (optional — not part of the user-visible app)
      case 'ld-terminal':  return const LoaderShowcase(id: 'L1', title: 'Terminal de Boot', subtitle: 'rolagem CRT', loader: LoaderTerminal());
      case 'ld-halftone':  return const LoaderShowcase(id: 'L2', title: 'Pulso Halftone',  subtitle: 'pop-art breathing', loader: LoaderHalftone());
      case 'ld-radar':     return const LoaderShowcase(id: 'L3', title: 'Varredura Radar', subtitle: 'P2P sweep', loader: LoaderRadar());
      case 'ld-tape':      return const LoaderShowcase(id: 'L4', title: 'Fita de Dados',   subtitle: 'streaming vertical', loader: LoaderDataTape());
      case 'ld-counter':   return const LoaderShowcase(id: 'L5', title: 'Contador Células', subtitle: 'mutirão', loader: LoaderCounter());
      case 'ld-glitch':    return const LoaderShowcase(id: 'L6', title: 'Glitch Embaralhado', subtitle: 'RGB split', loader: LoaderGlitch());
      case 'ld-tokens':    return const LoaderShowcase(id: 'L7', title: 'Stream de Tokens', subtitle: 'usado para processar pauta', loader: LoaderTokenStream());
      case 'ld-rain':      return const LoaderShowcase(id: 'L8', title: 'Chuva Binária', subtitle: 'matrix-style', loader: LoaderBinaryRain());
      case 'ld-spectrum':  return const LoaderShowcase(id: 'L9', title: 'Espectro de Sinal', subtitle: 'equalizer', loader: LoaderSpectrum());
      case 'ld-glyph':     return const LoaderShowcase(id: 'L11', title: 'Decifrador', subtitle: 'scramble', loader: LoaderGlyphDecode());
      case 'ld-tk-attn':   return const LoaderShowcase(id: 'L12', title: 'Tokens · Atenção', subtitle: 'attention weights', loader: LoaderTokenAttention());
      case 'ld-tk-beam':   return const LoaderShowcase(id: 'L13', title: 'Tokens · Top-K', subtitle: 'sampling', loader: LoaderTokenBeam());
      case 'ld-tk-rag':    return const LoaderShowcase(id: 'L14', title: 'Tokens · RAG', subtitle: 'retrieval + gen', loader: LoaderTokenRAG());
      case 'ld-tk-layers': return const LoaderShowcase(id: 'L15', title: 'Tokens · Camadas', subtitle: 'transformer stack', loader: LoaderTokenLayers());
      default: return const ScreenSplash();
    }
  }
}
