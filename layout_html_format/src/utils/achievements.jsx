/**
 * @file utils/achievements — badge catalog + ownership hook.
 */

/**
 * @typedef {Object} Badge
 * @property {string} id
 * @property {string} emoji      Cover glyph
 * @property {string} title
 * @property {string} desc
 * @property {'init'|'cell'|'voice'|'sources'|'comm'|'time'} category
 * @property {1|2|3|4} tier       1 = comum, 4 = lendário
 */

/** Stable badge catalog (24 entries — fills a 6×4 hex grid). */
const BADGES = [
  // INIT
  { id: 'b01', emoji: '👁', title: 'Primeiro Vigia',     desc: 'Completou o onboarding.',                       category: 'init',    tier: 1 },
  { id: 'b02', emoji: '⚡', title: 'Trincheira',          desc: 'Escolheu sua cidade.',                          category: 'init',    tier: 1 },
  { id: 'b03', emoji: '🛡', title: 'Sem Login',           desc: 'Aceitou usar o app sem ceder dados pessoais.',  category: 'init',    tier: 1 },
  { id: 'b04', emoji: '🧠', title: 'Cérebro Local',       desc: 'Baixou o modelo gemma-3-1b.',                   category: 'init',    tier: 1 },
  // CELL
  { id: 'b05', emoji: '🌱', title: 'Célula Nascendo',     desc: 'Processou sua primeira pauta.',                 category: 'cell',    tier: 1 },
  { id: 'b06', emoji: '🔋', title: 'Célula Ativa',        desc: '10 pautas processadas pelo seu aparelho.',      category: 'cell',    tier: 2 },
  { id: 'b07', emoji: '⚙',  title: 'Núcleo',              desc: '100 pautas processadas.',                       category: 'cell',    tier: 3 },
  { id: 'b08', emoji: '👑', title: 'Célula-Mãe',          desc: '500 pautas processadas.',                       category: 'cell',    tier: 4 },
  { id: 'b09', emoji: '🌐', title: 'Filho da Rede',       desc: 'Ajudou peers em 5 cidades diferentes.',         category: 'cell',    tier: 3 },
  // VOICE
  { id: 'b10', emoji: '🚩', title: 'Primeira Pauta',      desc: 'Publicou sua primeira pauta no fórum.',         category: 'voice',   tier: 1 },
  { id: 'b11', emoji: '🔥', title: 'Viralizou',           desc: 'Uma pauta sua passou de 100 reactions.',        category: 'voice',   tier: 3 },
  { id: 'b12', emoji: '📣', title: 'Mobilizador',         desc: 'Tópico seu passou de 50 replies.',              category: 'voice',   tier: 2 },
  { id: 'b13', emoji: '🎯', title: 'Fiscal',              desc: 'Cobrou 10 autoridades distintas.',              category: 'voice',   tier: 2 },
  { id: 'b14', emoji: '⚖',  title: 'Processo Aberto',     desc: 'Sua pauta virou processo no MP ou TCE.',        category: 'voice',   tier: 4 },
  // SOURCES
  { id: 'b15', emoji: '📰', title: 'Repórter',            desc: 'Anexou fontes em 20 pautas.',                   category: 'sources', tier: 2 },
  { id: 'b16', emoji: '🔍', title: 'Investigador',        desc: 'Cruzou dados de 3 fontes oficiais.',            category: 'sources', tier: 2 },
  { id: 'b17', emoji: '📡', title: 'Antena',              desc: 'Foi o primeiro a postar 5 pautas locais.',      category: 'sources', tier: 3 },
  // COMM
  { id: 'b18', emoji: '🤝', title: 'República',           desc: 'Respondeu em 20 tópicos diferentes.',           category: 'comm',    tier: 2 },
  { id: 'b19', emoji: '💬', title: 'Debatedor',           desc: 'Recebeu 100 reactions em respostas.',           category: 'comm',    tier: 2 },
  { id: 'b20', emoji: '🧑‍🏫', title: 'Mentor',            desc: 'Resposta sua com mais de 50 reactions.',        category: 'comm',    tier: 3 },
  { id: 'b21', emoji: '🌎', title: 'Voz Nacional',        desc: 'Pauta federal sua virou trending.',             category: 'comm',    tier: 4 },
  // TIME
  { id: 'b22', emoji: '🎖', title: 'Batismo',             desc: '7 dias usando o app.',                          category: 'time',    tier: 1 },
  { id: 'b23', emoji: '⏳', title: 'Maratona',            desc: '30 dias seguidos.',                             category: 'time',    tier: 3 },
  { id: 'b24', emoji: '🏛', title: 'Fundador',            desc: 'Entrou entre os primeiros 1.000 da rede.',      category: 'time',    tier: 4 },
];

/** Category metadata for chips + legends. */
const BADGE_CATEGORIES = {
  init:    { label: 'INÍCIO',     color: COL.alert   },
  cell:    { label: 'CÉLULA',     color: COL.acid    },
  voice:   { label: 'VOZ',        color: COL.magenta },
  sources: { label: 'FONTES',     color: '#7fc8ff'   },
  comm:    { label: 'COMUNIDADE', color: COL.acidD   },
  time:    { label: 'TEMPO',      color: '#ff9933'   },
};

/**
 * Returns the user's badge collection state + actions.
 * In production this would persist to local storage.
 *
 * @returns {{
 *   owned: Set<string>,
 *   unopened: Set<string>,
 *   open: (id: string) => void,
 *   total: number,
 *   ownedCount: number,
 * }}
 */
function useAchievements() {
  // Mock initial state: user owns 11 of 24, 3 of which are unopened ("new")
  const [owned] = React.useState(() => new Set([
    'b01','b02','b03','b04',           // all init
    'b05','b06',                       // 2 cell
    'b10','b13',                       // 2 voice
    'b15',                             // 1 sources
    'b18',                             // 1 comm
    'b22',                             // 1 time
  ]));
  const [unopened, setUnopened] = React.useState(() => new Set(['b06','b13','b18']));

  const open = React.useCallback((id) => {
    setUnopened(prev => {
      if (!prev.has(id)) return prev;
      const next = new Set(prev);
      next.delete(id);
      return next;
    });
  }, []);

  return { owned, unopened, open, total: BADGES.length, ownedCount: owned.size };
}

Object.assign(window, { BADGES, BADGE_CATEGORIES, useAchievements });
