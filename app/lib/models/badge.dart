import 'package:flutter/material.dart';

enum BadgeCategory { init, cell, voice, sources, comm, time }

class DedsecBadge {
  final String id;
  final String emoji;
  final String title;
  final String desc;
  final BadgeCategory category;
  final int tier; // 1..4

  const DedsecBadge({
    required this.id,
    required this.emoji,
    required this.title,
    required this.desc,
    required this.category,
    required this.tier,
  });
}

class BadgeCategoryMeta {
  final String label;
  final Color color;
  const BadgeCategoryMeta(this.label, this.color);
}
