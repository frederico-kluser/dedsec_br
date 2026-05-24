import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../data/achievements_data.dart';
import '../models/badge.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/molecules/badge_widgets.dart';
import '../widgets/organisms/badge_share_modal.dart';
import '../widgets/utils/layout.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});
  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  static const _initialOwned = {'b01', 'b02', 'b03', 'b04', 'b05', 'b06', 'b10', 'b13', 'b15', 'b18', 'b22'};
  static const _initialUnopened = {'b06', 'b13', 'b18'};

  late Set<String> _owned;
  late Set<String> _unopened;
  DedsecBadge? _active;

  @override
  void initState() {
    super.initState();
    _owned = Set.of(_initialOwned);
    _unopened = Set.of(_initialUnopened);
  }

  void _pick(DedsecBadge b) {
    if (_owned.contains(b.id) && _unopened.contains(b.id)) {
      setState(() => _unopened.remove(b.id));
    }
    setState(() => _active = b);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          Column(
            children: [
              BackHeader(
                onBack: () => state.go(AppRoute.help),
                trailing: PixelChip('${_owned.length}/${kBadges.length} SELOS',
                    color: COL.acid, size: 8),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PixelChip('// COLEÇÃO', color: COL.magenta),
                      const SizedBox(height: 10),
                      const StencilSpans(
                        spans: [
                          TextSpan(text: 'SELOS\n'),
                          TextSpan(
                            text: 'CONQUISTADOS',
                            style: TextStyle(
                              color: COL.magenta,
                              shadows: [Shadow(offset: Offset(3, 3), color: COL.acid)],
                            ),
                          ),
                        ],
                        size: 36,
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(children: [
                          const TextSpan(text: 'Você desbloqueou '),
                          TextSpan(
                            text: '${_owned.length}',
                            style: const TextStyle(color: COL.acid, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: ' de ${kBadges.length}. '),
                          if (_unopened.isNotEmpty)
                            TextSpan(
                              text: '${_unopened.length} novos pra abrir.',
                              style: const TextStyle(color: COL.magenta),
                            ),
                        ], style: FONT.body(size: 13, color: COL.inkDim, height: 1.5)),
                      ),
                      const SizedBox(height: 18),
                      Text('// SEUS SELOS',
                          style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5)),
                      const SizedBox(height: 4),
                      BadgeCarousel(
                        badges: kBadges,
                        owned: _owned,
                        unopened: _unopened,
                        onPick: _pick,
                      ),
                      const SizedBox(height: 14),
                      Text('// MOSAICO DA COLEÇÃO · pinch / scroll p/ zoom',
                          style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5)),
                      const SizedBox(height: 8),
                      BadgeMosaic(
                        badges: kBadges,
                        owned: _owned,
                        unopened: _unopened,
                        onBadgeClick: _pick,
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final entry in kBadgeCategories.entries)
                            _categoryChip(entry.key, entry.value),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_active != null)
            BadgeShareModal(
              badge: _active,
              user: state.user,
              isLocked: !_owned.contains(_active!.id),
              onClose: () => setState(() => _active = null),
            ),
        ],
      ),
    );
  }

  Widget _categoryChip(BadgeCategory cat, BadgeCategoryMeta meta) {
    final catBadges = kBadges.where((b) => b.category == cat).length;
    final catOwned = kBadges.where((b) => b.category == cat && _owned.contains(b.id)).length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: meta.color),
      ),
      child: Text(
        '${meta.label} $catOwned/$catBadges',
        style: FONT.pixel(size: 8, color: meta.color, letterSpacing: 0.8),
      ),
    );
  }
}
