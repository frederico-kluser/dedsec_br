/**
 * @file pages/Home/Home.data — feed mock data.
 * @type {Array<{id:string, urgent?:boolean, tag:string, color:string, title:string, desc:string, sources:string[], panel:string}>}
 */
const NEWS = [
  { id: 'n1', urgent: true,  tag: 'TRANSPORTE', color: COL.magenta,
    title: 'Linha 17-Ouro do metrô de SP atrasa mais 4 anos e custo triplica',
    desc: 'Obra licitada em 2011 com previsão para a Copa de 2014 agora tem entrega prevista para 2028. Custo passou de R$ 1,6 bi para R$ 4,8 bi.',
    sources: ['G1 SP', 'Folha · Cotidiano', 'D.O. Municipal'], panel: '🚇' },
  { id: 'n2', urgent: false, tag: 'ORÇAMENTO', color: COL.acid,
    title: 'Câmara aprova orçamento 2026 sem ouvir audiências públicas',
    desc: 'Votação relâmpago em sessão extraordinária. Vereadores da oposição denunciam falta de tempo de análise.',
    sources: ['G1 SP', 'D.O. Câmara'], panel: '📑' },
  { id: 'n3', urgent: false, tag: 'SAÚDE', color: COL.alert,
    title: 'UBS do Capão Redondo sem pediatra há 3 meses, denuncia conselho',
    desc: 'Concurso de 2024 não foi homologado. Mais de 1.200 crianças cadastradas sem atendimento regular.',
    sources: ['Agência Pública', 'G1 SP'], panel: '🏥' },
  { id: 'n4', urgent: false, tag: 'EDUCAÇÃO', color: COL.magenta,
    title: 'Merenda escolar tem corte de 18% no orçamento da prefeitura',
    desc: 'Secretaria justifica com queda de matrículas. Sindicato aponta números inconsistentes.',
    sources: ['Folha', 'D.O. Municipal'], panel: '🍎' },
];

Object.assign(window, { NEWS });
