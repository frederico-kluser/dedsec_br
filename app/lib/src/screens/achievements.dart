import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/molecules.dart';
import '../widgets/overlays.dart';
import '../widgets/utils.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});
  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final _owned = <String>{
    'b01', 'b02', 'b03', 'b04', 'b05', 'b06', 'b10', 'b13', 'b15', 'b18', 'b22',
  };
  final _unopened = <String>{'b06', 'b13', 'b18'};

  DBadge? _active;

  void _pick(DBadge b) {
    if (_owned.contains(b.id) && _unopened.contains(b.id)) {
      setState(() => _unopened.remove(b.id));
    }
    setState(() => _active = b);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Stack(
        children: [
          Column(
            children: [
              BackHeader(
                onBack: () => app.go(Screen.help),
                right: PixelChip('${_owned.length}/${BADGES.length} SELOS',
                    color: DCol.acid, size: 8),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 80),
                  children: [
                    const PixelChip('// COLEÇÃO', color: DCol.magenta),
                    const SizedBox(height: 10),
                    StencilTwoLine(
                      first: 'SELOS',
                      second: 'CONQUISTADOS',
                      size: 36,
                      height: 0.95,
                      secondShadows: const [Shadow(color: DCol.acid, offset: Offset(3, 3))],
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(children: [
                        const TextSpan(text: 'Você desbloqueou '),
                        TextSpan(
                            text: '${_owned.length}',
                            style: DFont.body(
                                size: 13,
                                color: DCol.acid,
                                weight: FontWeight.w700,
                                height: 1.5)),
                        TextSpan(text: ' de ${BADGES.length}. '),
                        if (_unopened.isNotEmpty)
                          TextSpan(
                              text: '${_unopened.length} novos pra abrir.',
                              style: DFont.body(size: 13, color: DCol.magenta, height: 1.5)),
                      ], style: DFont.body(size: 13, color: DCol.inkDim, height: 1.5)),
                    ),
                    const SizedBox(height: 18),
                    Text('// SEUS SELOS',
                        style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.5)),
                    const SizedBox(height: 4),
                    BadgeCarousel(
                      badges: BADGES,
                      owned: _owned,
                      unopened: _unopened,
                      onPick: _pick,
                    ),
                    const SizedBox(height: 14),
                    Text('// MOSAICO DA COLEÇÃO · pinch / scroll p/ zoom',
                        style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    BadgeMosaic(
                      badges: BADGES,
                      owned: _owned,
                      unopened: _unopened,
                      onBadgeClick: _pick,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: BADGE_CATEGORIES.entries.map((e) {
                        final cat = e.value;
                        final catBadges = BADGES.where((b) => b.category == e.key);
                        final catOwned = catBadges.where((b) => _owned.contains(b.id)).length;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: cat.color),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text(
                            '${cat.label} $catOwned/${catBadges.length}',
                            style: DFont.pixel(
                                size: 8, color: cat.color, letterSpacing: 0.8),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_active != null)
            BadgeShareModal(
              badge: _active,
              user: app.user,
              isLocked: !_owned.contains(_active!.id),
              onClose: () => setState(() => _active = null),
            ),
        ],
      ),
    );
  }
}
