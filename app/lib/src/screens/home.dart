import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/news.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/molecules.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _scope = 'mun';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Container(
                color: DCol.bg,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ScopeChip(
                          label: 'MUNICIPAL',
                          active: _scope == 'mun',
                          color: DCol.magenta,
                          onTap: () => setState(() => _scope = 'mun'),
                        ),
                        const SizedBox(width: 6),
                        ScopeChip(
                          label: 'ESTADUAL',
                          active: _scope == 'est',
                          color: DCol.acid,
                          onTap: () => setState(() => _scope = 'est'),
                        ),
                        const SizedBox(width: 6),
                        ScopeChip(
                          label: 'FEDERAL',
                          active: _scope == 'fed',
                          color: DCol.alert,
                          onTap: () => setState(() => _scope = 'fed'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: DCol.panel,
                        border: Border.all(color: DCol.line),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Text('◉ SÃO PAULO / SP',
                              style: DFont.pixel(size: 9, color: DCol.acid)),
                          const Spacer(),
                          Text('4 pautas novas',
                              style: DFont.mono(size: 10, color: DCol.inkDim)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
                  itemCount: NEWS.length,
                  itemBuilder: (_, i) => NewsCard(
                    item: NEWS[i],
                    onOpen: () => app.go(Screen.detail),
                  ),
                ),
              ),
              DTabBar(active: app.tab, onTab: app.goTab),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 78 + 48, // above tab bar
            child: GestureDetector(
              onTap: () => app.go(Screen.help),
              child: Container(
                decoration: BoxDecoration(
                  color: DCol.magenta,
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Text('✦ AJUDAR',
                    style:
                        DFont.pixel(size: 10, color: Colors.white, letterSpacing: 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
