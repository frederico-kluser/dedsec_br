/**
 * @file pages/Generate/Generate.state — composer state for "gerar mensagem".
 * User picks a tone + tags, hits generate, gets ONE result back.
 */

/** All available tones for the message. */
const TONES = [
  { id: 'FORMAL',       color: COL.acid,    desc: 'institucional, respeitoso' },
  { id: 'MOBILIZADORA', color: COL.magenta, desc: 'engajada, chama à ação' },
  { id: 'IRÔNICA',      color: COL.alert,   desc: 'sarcasmo cívico' },
  { id: 'TÉCNICA',      color: '#7fc8ff',   desc: 'fria, com números' },
  { id: 'POÉTICA',      color: COL.acidD,   desc: 'literária, evocativa' },
];

/** Argumentation tags — multiple allowed. */
const TAGS = [
  { id: 'URGÊNCIA',       glyph: '⚡' },
  { id: 'DADOS',          glyph: '📊' },
  { id: 'TRANSPARÊNCIA',  glyph: '🔍' },
  { id: 'PRESSÃO',        glyph: '🎯' },
  { id: 'HISTÓRICO',      glyph: '📜' },
  { id: 'PESSOAL',        glyph: '🙋' },
  { id: 'CITAÇÃO LEI',    glyph: '⚖' },
  { id: 'COMPARAÇÃO',     glyph: '↔' },
];

/**
 * Compose the generated message text. Keyword-routed.
 * @param {string} tone
 * @param {string[]} tagList
 * @returns {string}
 */
function buildMessage(tone, tagList) {
  const intro = {
    FORMAL:       'Prezado Prefeito Ricardo Nunes,',
    MOBILIZADORA: 'Prefeito Ricardo Nunes,',
    'IRÔNICA':    'Curiosidade pública:',
    'TÉCNICA':    'Sr. Prefeito,',
    'POÉTICA':    'Senhor Prefeito,',
  }[tone] || 'Prezado Prefeito,';

  const parts = [intro];
  const has = (k) => tagList.includes(k);

  if (has('URGÊNCIA'))       parts.push('a Linha 17-Ouro do metrô está atrasada há 14 anos e sem prazo realista.');
  if (has('HISTÓRICO'))      parts.push('A obra foi licitada em 2011 com previsão para a Copa de 2014.');
  if (has('DADOS'))          parts.push('O custo passou de R$ 1,6 bi para R$ 4,8 bi — alta de 200%.');
  if (has('TRANSPARÊNCIA'))  parts.push('Exigimos publicação integral dos aditivos contratuais já assinados.');
  if (has('COMPARAÇÃO'))     parts.push('Cidades como Curitiba e Belo Horizonte entregaram corredores no mesmo período.');
  if (has('CITAÇÃO LEI'))    parts.push('A Lei 12.527/2011 (LAI) garante acesso público a esses documentos.');
  if (has('PRESSÃO'))        parts.push('Caso a Prefeitura não se manifeste, levaremos a denúncia ao TCE-SP.');
  if (has('PESSOAL'))        parts.push('Como cidadão de São Paulo, sou diretamente impactado pelo atraso.');

  // Tone-specific closer
  const closer = {
    FORMAL:       'Aguardo manifestação oficial. Atenciosamente,',
    MOBILIZADORA: 'Não dá mais pra empurrar pra próxima gestão. Vamos cobrar.',
    'IRÔNICA':    'A esse ritmo, o metrô fica pronto antes do próximo eclipse. 🚇⏳',
    'TÉCNICA':    'Solicito resposta formal em até 20 dias úteis.',
    'POÉTICA':    'A cidade que não anda é a cidade que esquece de seus.',
  }[tone] || 'Atenciosamente.';

  parts.push(closer);
  return parts.join(' ');
}

/**
 * @returns {{
 *   tags: Set<string>, toggleTag: (t: string) => void,
 *   tone: string, setTone: (t: string) => void,
 *   phase: 'compose'|'working'|'done',
 *   streamLen: number,
 *   generatedText: string,
 *   start: () => void,
 *   regenerate: () => void,
 *   canGenerate: boolean,
 * }}
 */
function useGenerateFlow() {
  const [tags, setTags]           = React.useState(() => new Set(['URGÊNCIA', 'DADOS']));
  const [tone, setTone]           = React.useState('MOBILIZADORA');
  const [phase, setPhase]         = React.useState('compose');
  const [streamLen, setStreamLen] = React.useState(0);

  const toggleTag = React.useCallback((t) => {
    setTags(prev => {
      const n = new Set(prev);
      n.has(t) ? n.delete(t) : n.add(t);
      return n;
    });
  }, []);

  const generatedText = React.useMemo(() => buildMessage(tone, [...tags]), [tone, tags]);

  React.useEffect(() => {
    if (phase !== 'working') return;
    let timer;
    const stream = () => {
      setStreamLen(l => {
        const next = l + 6;
        if (next >= generatedText.length) {
          setPhase('done');
          return generatedText.length;
        }
        timer = setTimeout(stream, 35);
        return next;
      });
    };
    timer = setTimeout(stream, 500);
    return () => clearTimeout(timer);
  }, [phase, generatedText]);

  const start = React.useCallback(() => {
    if (tags.size === 0) return;
    setStreamLen(0);
    setPhase('working');
  }, [tags.size]);

  const regenerate = React.useCallback(() => {
    setPhase('compose');
    setStreamLen(0);
  }, []);

  return { tags, toggleTag, tone, setTone, phase, streamLen, generatedText, start, regenerate, canGenerate: tags.size > 0 };
}

Object.assign(window, { useGenerateFlow, TONES, TAGS, buildMessage });
