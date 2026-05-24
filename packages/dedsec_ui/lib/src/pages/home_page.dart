import 'package:flutter/material.dart';
import '../molecules/news_card.dart';
import '../molecules/scope_chip.dart';
import '../molecules/tab_bar.dart';
import '../molecules/top_bar.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  final String activeTab;
  final ValueChanged<String> onTab;
  const HomePage({super.key, required this.onGo, required this.activeTab, required this.onTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _scope = 'mun';

  @override
  Widget build(BuildContext context) {
    return ScreenRoot(
      child: Stack(children: [
        Column(children: [
          const DedsecTopBar(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(children: [
              Row(children: [
                ScopeChip(label: 'MUNICIPAL', active: _scope == 'mun', color: DedsecColors.magenta,
                    onPressed: () => setState(() => _scope = 'mun')),
                const SizedBox(width: 6),
                ScopeChip(label: 'ESTADUAL', active: _scope == 'est', color: DedsecColors.acid,
                    onPressed: () => setState(() => _scope = 'est')),
                const SizedBox(width: 6),
                ScopeChip(label: 'FEDERAL', active: _scope == 'fed', color: DedsecColors.alert,
                    onPressed: () => setState(() => _scope = 'fed')),
              ]),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: DedsecColors.panel,
                  border: Border.all(color: DedsecColors.line),
                ),
                child: Row(children: [
                  Text('◉ SÃO PAULO / SP',
                      style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
                  const Spacer(),
                  Text('4 pautas novas',
                      style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                ]),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
              itemCount: dedsecNews.length,
              itemBuilder: (_, i) => NewsCard(
                item: dedsecNews[i],
                onOpen: () => widget.onGo(DedsecScreen.detail),
              ),
            ),
          ),
          DedsecTabBar(active: widget.activeTab, onTab: widget.onTab),
        ]),
        Positioned(
          right: 16,
          bottom: 78,
          child: GestureDetector(
            onTap: () => widget.onGo(DedsecScreen.help),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: DedsecColors.magenta,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
              ),
              child: Text('✦ AJUDAR',
                  style: DedsecFonts.pixel(size: 10, color: Colors.white, letterSpacing: 1)),
            ),
          ),
        ),
      ]),
    );
  }
}
