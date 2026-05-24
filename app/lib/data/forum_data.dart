import '../models/forum.dart';

const List<ForumTopic> kInitialTopics = [
  ForumTopic(
    id: 't1',
    live: true,
    tag: 'TRANSPORTE',
    scope: TopicScope.mun,
    title: 'Linha 17-Ouro: como cobrar o TCE-SP?',
    author: 'Cidadão_SP_4a7b',
    replies: 87,
    age: '12 min',
    hot: true,
    newReplies: 5,
    body:
        'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?',
  ),
  ForumTopic(
    id: 't2',
    tag: 'ORÇAMENTO',
    scope: TopicScope.mun,
    title: 'Audiência pública pulada — vamos ao MP?',
    author: 'Cidadão_SP_91cd',
    replies: 34,
    age: '1h',
    newReplies: 2,
    body:
        'Vereadores aprovaram o orçamento 2026 em sessão extraordinária sem audiências públicas. Quem topa redigir representação pro Ministério Público?',
  ),
  ForumTopic(
    id: 't3',
    live: true,
    tag: 'SAÚDE',
    scope: TopicScope.mun,
    title: 'Mutirão para denunciar falta de pediatra em Capão Redondo',
    author: 'Cidadão_SP_bb22',
    replies: 56,
    age: '2h',
    newReplies: 7,
    body:
        'UBS sem pediatra há 3 meses. Vamos coordenar denúncia simultânea na Ouvidoria-SUS, no MP e na imprensa local.',
  ),
  ForumTopic(
    id: 't4',
    tag: 'MEIO AMBIENTE',
    scope: TopicScope.est,
    title: 'Corte na fiscalização ambiental: alguém viu o edital?',
    author: 'Cidadão_SP_d013',
    replies: 12,
    age: '4h',
    newReplies: 1,
    body:
        'Boato circulando que vão cortar 40% dos fiscais ambientais do estado. Tem confirmação? Vamos achar o edital ou D.O.',
  ),
  ForumTopic(
    id: 't5',
    live: true,
    tag: 'CORRUPÇÃO',
    scope: TopicScope.est,
    title: 'CPI dos pedágios — sumiço de documentos?',
    author: 'Cidadão_SP_aabb',
    replies: 28,
    age: '7h',
    newReplies: 3,
    hot: true,
    body:
        'Documentos requisitados pela CPI dos pedágios não chegaram à ALESP. Alguém sabe quem é o relator?',
  ),
  ForumTopic(
    id: 't6',
    tag: 'CULTURA',
    scope: TopicScope.fed,
    title: 'Repasse pra museus suspenso há 4 meses — fontes?',
    author: 'Cidadão_SP_71fa',
    replies: 9,
    age: '6h',
    body:
        'MINC anunciou retomada do repasse, mas museus dizem que nada chegou. Vamos cruzar dados do SIAFI.',
  ),
  ForumTopic(
    id: 't7',
    live: true,
    tag: 'EDUCAÇÃO',
    scope: TopicScope.fed,
    title: 'PEC do FUNDEB: como pressionar pelos R\$ 7 bi',
    author: 'Cidadão_SP_ccdd',
    replies: 41,
    age: '1d',
    newReplies: 4,
    body:
        'Senado adiou votação da PEC do FUNDEB pela 3ª vez. Lista de senadores indecisos: 22 nomes. Quem topa redigir e-mail conjunto?',
  ),
];

const List<ForumReply> kInitialReplies = [
  ForumReply(
    id: 'r1',
    who: 'Cidadão_SP_91cd',
    seed: 'Cidadão_SP_91cd',
    age: '8 min',
    body:
        'Já mandei pra ouvidoria do TCE-SP. Protocolo é OUVI-2026-001234. Quem quiser comentar lá, link no perfil oficial.',
    reacts: {'⚡': 23, '🔥': 12},
  ),
  ForumReply(
    id: 'r2',
    who: 'Cidadão_SP_bb22',
    seed: 'Cidadão_SP_bb22',
    age: '6 min',
    body:
        'Boa! Importante lembrar que o prazo de resposta da Ouvidoria do TCE é 20 dias úteis pela Lei 12.527. Vale acompanhar.',
    reacts: {'👍': 18},
  ),
  ForumReply(
    id: 'r3',
    who: 'Cidadão_SP_d013',
    seed: 'Cidadão_SP_d013',
    age: '3 min',
    body:
        'Tem alguém que entende de licitação e pode olhar os aditivos do contrato? Tá tudo público no D.O. mas é denso.',
    reacts: {'🤔': 9},
  ),
];
