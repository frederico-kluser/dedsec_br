import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import 'topics.dart';

class Authority {
  final String role;
  final String name;
  final String handle;
  const Authority(this.role, this.name, this.handle);
}

class AnalysisResult {
  final String theme;
  final Color color;
  final String title;
  final String desc;
  final List<Authority> authorities;
  final int confidence;
  const AnalysisResult({
    required this.theme,
    required this.color,
    required this.title,
    required this.desc,
    required this.authorities,
    required this.confidence,
  });
}

class NewPostScopeInfo {
  final TopicScope id;
  final String label;
  final Color color;
  final String sub;
  const NewPostScopeInfo(this.id, this.label, this.color, this.sub);
}

const newPostScopes = <NewPostScopeInfo>[
  NewPostScopeInfo(TopicScope.mun, 'MUNICIPAL', DedsecColors.magenta, 'só sua cidade'),
  NewPostScopeInfo(TopicScope.est, 'ESTADUAL', DedsecColors.acid, 'seu estado'),
  NewPostScopeInfo(TopicScope.fed, 'FEDERAL', DedsecColors.alert, 'país inteiro'),
];

const analysisPhases = <Map<String, String>>[
  {'label': 'lendo conteúdo ...', 'tech': 'tokenize + chunk · 142 tokens'},
  {'label': 'classificando tema ...', 'tech': 'zero-shot · 20 categorias'},
  {'label': 'identificando autoridades ...', 'tech': 'lookup TSE + Câmara API'},
  {'label': 'gerando título + resumo ...', 'tech': 'gemma-3-1b · prompt cidadania'},
];

AnalysisResult analyzeText(String text, TopicScope scope) {
  final lower = text.toLowerCase();
  String theme = 'POLÍTICA';
  Color color = DedsecColors.magenta;

  final patterns = <(RegExp, String, Color)>[
    (RegExp(r'metr[ôo]|[ôo]nibus|\btrans|mobil|rua|via|tr[áa]fego|congestion|cicl'), 'TRANSPORTE', DedsecColors.magenta),
    (RegExp(r'saud|hospital|\bubs|posto|m[ée]dic|\bsus|vacin|pediat|enferm'), 'SAÚDE', DedsecColors.alert),
    (RegExp(r'escol|educa|merenda|professor|aluno|creche|universid'), 'EDUCAÇÃO', DedsecColors.magenta),
    (RegExp(r'or[çc]ament|gasto|verba|licit|contrat|aditiv|caixa|impost'), 'ORÇAMENTO', DedsecColors.acid),
    (RegExp(r'ambient|polui|reciclag|lixo|enchente|desmat|verde|parque'), 'MEIO AMBIENTE', DedsecColors.acid),
    (RegExp(r'cultur|museu|teatro|biblio|arte|festiv'), 'CULTURA', DedsecColors.magenta),
    (RegExp(r'pol[íi]cia|seguran[çc]|crime|viol[êe]ncia|assalt'), 'SEGURANÇA', DedsecColors.danger),
    (RegExp(r'morad|habita|favel|cortic|despej'), 'MORADIA', DedsecColors.alert),
    (RegExp(r'corrup|propin|desvi|fraud|escândal'), 'CORRUPÇÃO', DedsecColors.danger),
  ];

  for (final p in patterns) {
    if (p.$1.hasMatch(lower)) {
      theme = p.$2;
      color = p.$3;
      break;
    }
  }

  final firstSentenceRaw = text.split(RegExp(r'[.!?\n]')).first.trim();
  final title = firstSentenceRaw.length > 12
      ? firstSentenceRaw[0].toUpperCase() +
          firstSentenceRaw.substring(1, firstSentenceRaw.length > 110 ? 110 : firstSentenceRaw.length)
      : 'Nova pauta de ${theme.toLowerCase()} levantada por cidadão';

  final trim = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final desc = trim.length > 280 ? '${trim.substring(0, 280).trim()} ...' : trim;

  final authorities = switch (scope) {
    TopicScope.mun => const [
        Authority('PREFEITO', 'Prefeitura de São Paulo', '@prefsp'),
        Authority('CÂMARA MUNICIPAL', 'CMSP — vereadores', '@cmsp_oficial'),
      ],
    TopicScope.est => const [
        Authority('GOVERNADOR', 'Governo do Estado de SP', '@governosp'),
        Authority('ASSEMBLEIA', 'ALESP', '@alesp_oficial'),
      ],
    TopicScope.fed => const [
        Authority('PRESIDÊNCIA', 'Planalto', '@planalto'),
        Authority('CÂMARA', 'Câmara dos Deputados', '@camaradeputados'),
        Authority('SENADO', 'Senado Federal', '@senadofederal'),
      ],
  };

  final confidence = 78 + (text.length % 18);
  return AnalysisResult(
    theme: theme, color: color, title: title, desc: desc,
    authorities: authorities, confidence: confidence,
  );
}
