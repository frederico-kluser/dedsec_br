import 'package:flutter/material.dart';

class NewsItem {
  final String id;
  final bool urgent;
  final String tag;
  final Color color;
  final String title;
  final String desc;
  final List<String> sources;
  final String panel;

  const NewsItem({
    required this.id,
    required this.tag,
    required this.color,
    required this.title,
    required this.desc,
    required this.sources,
    required this.panel,
    this.urgent = false,
  });
}
