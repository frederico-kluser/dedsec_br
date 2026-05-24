import 'package:flutter/material.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../molecules/badge_carousel.dart';
import '../molecules/badge_mosaic.dart';
import '../organisms/badge_share_modal.dart';
import '../state/achievements.dart';
import '../state/app_state.dart';
import '../state/user.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/back_header.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class AchievementsPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  final DedsecUser user;
  const AchievementsPage({super.key, required this.onGo, required this.user});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  DedsecBadge? _active;

  @override
  Widget build(BuildContext context) {
    final state = DedsecScope.of(context);
    final owned = state.ownedBadges;
    final unopened = state.unopenedBadges;

    void pick(DedsecBadge b) {
      if (owned.contains(b.id) && unopened.contains(b.id)) state.openBadge(b.id);
      setState(() => _active = b);
    }

    return ScreenRoot(
      child: Stack(children: [
        Column(children: [
          BackHeader(
            onBack: () => widget.onGo(DedsecScreen.help),
            trailing: PixelChip('${owned.length}/${badges.length} SELOS',
                color: DedsecColors.acid, size: 8),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 80),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const PixelChip('// COLEÇÃO', color: DedsecColors.magenta),
                const SizedBox(height: 10),
                StencilRich(size: 36, spans: const [
                  TextSpan(text: 'SELOS\n'),
                  TextSpan(text: 'CONQUISTADOS',
                      style: TextStyle(
                        color: DedsecColors.magenta,
                        shadows: [Shadow(color: DedsecColors.acid, offset: Offset(3, 3))],
                      )),
                ]),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: DedsecFonts.body(size: 13, color: DedsecColors.inkDim, height: 1.5),
                    children: [
                      const TextSpan(text: 'Você desbloqueou '),
                      TextSpan(text: '${owned.length}', style: const TextStyle(color: DedsecColors.acid, fontWeight: FontWeight.bold)),
                      TextSpan(text: ' de ${badges.length}. '),
                      if (unopened.isNotEmpty)
                        TextSpan(text: '${unopened.length} novos pra abrir.', style: const TextStyle(color: DedsecColors.magenta)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('// SEUS SELOS',
                    style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                const SizedBox(height: 4),
                DedsecBadgeCarousel(owned: owned, unopened: unopened, onPick: pick),
                const SizedBox(height: 14),
                Text('// MOSAICO DA COLEÇÃO · pinch / scroll p/ zoom',
                    style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                DedsecBadgeMosaic(owned: owned, unopened: unopened, onDedsecBadgeClick: pick),
                const SizedBox(height: 14),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final e in badgeCategories.entries)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: e.value.color),
                      ),
                      child: Text(
                        '${e.value.label} ${badges.where((b) => b.category == e.key && owned.contains(b.id)).length}/${badges.where((b) => b.category == e.key).length}',
                        style: DedsecFonts.pixel(size: 8, color: e.value.color, letterSpacing: 0.8),
                      ),
                    ),
                ]),
              ]),
            ),
          ),
        ]),
        if (_active != null)
          DedsecBadgeShareModal(
            badge: _active!,
            user: widget.user,
            isLocked: !owned.contains(_active!.id),
            onClose: () => setState(() => _active = null),
          ),
      ]),
    );
  }
}
