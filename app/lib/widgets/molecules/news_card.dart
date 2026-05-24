import 'package:flutter/material.dart';

import '../../models/news.dart';
import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import 'comic_panel.dart';

/// `molecules/NewsCard` — feed card with hero panel + body.
class NewsCard extends StatelessWidget {
  final NewsItem item;
  final VoidCallback? onOpen;
  const NewsCard({super.key, required this.item, this.onOpen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: COL.panel,
          border: Border.all(color: COL.line, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ComicPanel(
              color: item.color,
              halftoneColor: Colors.black,
              height: 96,
              label: 'PAUTA · ${item.tag}',
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.85,
                      child: Text(item.panel, style: const TextStyle(fontSize: 56)),
                    ),
                  ),
                  if (item.urgent)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: COL.danger),
                        ),
                        child: Text(
                          '🔥 URGENTE',
                          style: FONT.pixel(size: 8, color: COL.danger, letterSpacing: 1),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: FONT.body(size: 14, color: COL.ink, weight: FontWeight.w700, height: 1.3)),
                  const SizedBox(height: 6),
                  Text(item.desc,
                      style: FONT.body(size: 12, color: COL.inkDim, height: 1.45)),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(item.sources.join(' · '),
                            style: FONT.mono(size: 9, color: COL.inkMute, letterSpacing: 0.5)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        color: COL.acid,
                        child: Text('PROTESTAR →',
                            style: FONT.pixel(size: 9, color: Colors.black, letterSpacing: 1)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
