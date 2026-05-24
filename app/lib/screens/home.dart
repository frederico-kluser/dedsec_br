import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../data/home_data.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/molecules/bars.dart';
import '../widgets/molecules/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _scope = 'mun';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                color: COL.bg,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ScopeChip('MUNICIPAL',
                            active: _scope == 'mun',
                            color: COL.magenta,
                            onTap: () => setState(() => _scope = 'mun')),
                        const SizedBox(width: 6),
                        ScopeChip('ESTADUAL',
                            active: _scope == 'est',
                            color: COL.acid,
                            onTap: () => setState(() => _scope = 'est')),
                        const SizedBox(width: 6),
                        ScopeChip('FEDERAL',
                            active: _scope == 'fed',
                            color: COL.alert,
                            onTap: () => setState(() => _scope = 'fed')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: COL.panel,
                        border: Border.all(color: COL.line),
                      ),
                      child: Row(
                        children: [
                          Text('◉ SÃO PAULO / SP',
                              style: FONT.pixel(size: 9, color: COL.acid)),
                          const Spacer(),
                          Text('4 pautas novas',
                              style: FONT.mono(size: 10, color: COL.inkDim)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
                  children: [
                    for (final n in kNews)
                      NewsCard(item: n, onOpen: () => state.go(AppRoute.detail)),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 78,
            child: GestureDetector(
              onTap: () => state.go(AppRoute.help),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: COL.magenta,
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                child: Text('✦ AJUDAR',
                    style: FONT.pixel(size: 10, color: Colors.white, letterSpacing: 1)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DedsecTabBar(active: state.tab.name, onTab: _onTab),
          ),
        ],
      ),
    );
  }

  void _onTab(String id) {
    final s = AppScope.read(context);
    switch (id) {
      case 'home':
        s.goTab(AppTab.home);
        break;
      case 'help':
        s.goTab(AppTab.help);
        break;
      case 'forum':
        s.goTab(AppTab.forum);
        break;
      case 'settings':
        s.goTab(AppTab.settings);
        break;
    }
  }
}
