import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import 'comic_panel.dart';

class NewsItem {
  final String id;
  final bool urgent;
  final String tag;
  final Color color;
  final String title;
  final String desc;
  final List<String> sources;
  final String panel; // emoji
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

const dedsecNews = <NewsItem>[
  NewsItem(
    id: 'n1', urgent: true, tag: 'TRANSPORTE', color: DedsecColors.magenta,
    title: 'Linha 17-Ouro do metrô de SP atrasa mais 4 anos e custo triplica',
    desc:
        'Obra licitada em 2011 com previsão para a Copa de 2014 agora tem entrega prevista para 2028. Custo passou de R\$ 1,6 bi para R\$ 4,8 bi.',
    sources: ['G1 SP', 'Folha · Cotidiano', 'D.O. Municipal'], panel: '🚇',
  ),
  NewsItem(
    id: 'n2', tag: 'ORÇAMENTO', color: DedsecColors.acid,
    title: 'Câmara aprova orçamento 2026 sem ouvir audiências públicas',
    desc:
        'Votação relâmpago em sessão extraordinária. Vereadores da oposição denunciam falta de tempo de análise.',
    sources: ['G1 SP', 'D.O. Câmara'], panel: '📑',
  ),
  NewsItem(
    id: 'n3', tag: 'SAÚDE', color: DedsecColors.alert,
    title: 'UBS do Capão Redondo sem pediatra há 3 meses, denuncia conselho',
    desc:
        'Concurso de 2024 não foi homologado. Mais de 1.200 crianças cadastradas sem atendimento regular.',
    sources: ['Agência Pública', 'G1 SP'], panel: '🏥',
  ),
  NewsItem(
    id: 'n4', tag: 'EDUCAÇÃO', color: DedsecColors.magenta,
    title: 'Merenda escolar tem corte de 18% no orçamento da prefeitura',
    desc:
        'Secretaria justifica com queda de matrículas. Sindicato aponta números inconsistentes.',
    sources: ['Folha', 'D.O. Municipal'], panel: '🍎',
  ),
];

class NewsCard extends StatelessWidget {
  final NewsItem item;
  final VoidCallback? onOpen;
  const NewsCard({super.key, required this.item, this.onOpen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: DedsecColors.panel,
          border: Border.all(color: DedsecColors.line, width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ComicPanel(
            color: item.color,
            height: 96,
            label: 'PAUTA · ${item.tag}',
            child: Stack(children: [
              Positioned.fill(
                child: Center(
                  child: Opacity(opacity: 0.85, child: Text(item.panel, style: const TextStyle(fontSize: 56))),
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
                      border: Border.all(color: DedsecColors.danger),
                    ),
                    child: Text('🔥 URGENTE',
                        style: DedsecFonts.pixel(size: 8, color: DedsecColors.danger, letterSpacing: 1)),
                  ),
                ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title,
                  style: DedsecFonts.body(size: 14, weight: FontWeight.w700, color: DedsecColors.ink, height: 1.3)),
              const SizedBox(height: 6),
              Text(item.desc,
                  style: DedsecFonts.body(size: 12, color: DedsecColors.inkDim, height: 1.45)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Text(item.sources.join(' · '),
                      style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute, letterSpacing: 0.5)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  color: DedsecColors.acid,
                  child: Text('PROTESTAR →',
                      style: DedsecFonts.pixel(size: 9, color: Colors.black, letterSpacing: 1)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
