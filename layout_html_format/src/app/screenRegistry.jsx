/**
 * @file app/screenRegistry — single source of truth for every screen.
 * The sidebar uses this to render its menu; the router uses it to pick
 * which component to mount.
 *
 * @typedef {Object} ScreenEntry
 * @property {string} id      Route id
 * @property {string} label   Sidebar label
 * @property {string} phase   Sidebar section
 * @property {boolean} [loader]
 */

/** @type {ScreenEntry[]} */
const SCREENS = [
  { id: 'splash',     label: '01 · Splash',           phase: 'BOOT' },
  { id: 'onb1',       label: '02 · Onboarding',       phase: 'BOOT' },
  { id: 'interests',  label: '03 · Interesses',       phase: 'SETUP' },
  { id: 'city',       label: '04 · Cidade',           phase: 'SETUP' },
  { id: 'perms',      label: '05 · Permissões',       phase: 'SETUP' },
  { id: 'home',       label: '06 · Home / Feed',      phase: 'CORE' },
  { id: 'detail',     label: '07 · Detalhe Pauta',    phase: 'CORE' },
  { id: 'generate',   label: '08 · Gerar Mensagem',   phase: 'CORE' },
  { id: 'channels',   label: '09 · Canais',           phase: 'CORE' },
  { id: 'help',       label: '10 · Ajudar Dedsec',    phase: 'COMM' },
  { id: 'achievements', label: '11 · Conquistas',      phase: 'COMM' },
  { id: 'forum',      label: '12 · Fórum · escopo',   phase: 'COMM' },
  { id: 'forum-list', label: '13 · Fórum · pautas',   phase: 'COMM' },
  { id: 'topic',      label: '14 · Post',             phase: 'COMM' },
  { id: 'newpost',    label: '15 · Nova Pauta + IA',  phase: 'COMM' },
  { id: 'settings',   label: '16 · Config',           phase: 'SYS' },

  { id: 'ld-terminal',    label: 'L1 · Terminal de Boot',  phase: 'LOADERS', loader: true },
  { id: 'ld-halftone',    label: 'L2 · Pulso Halftone',    phase: 'LOADERS', loader: true },
  { id: 'ld-radar',       label: 'L3 · Varredura Radar',   phase: 'LOADERS', loader: true },
  { id: 'ld-tape',        label: 'L4 · Fita de Dados',     phase: 'LOADERS', loader: true },
  { id: 'ld-counter',     label: 'L5 · Contador Células',  phase: 'LOADERS', loader: true },
  { id: 'ld-glitch',      label: 'L6 · Glitch Embaralhado',phase: 'LOADERS', loader: true },
  { id: 'ld-tokens',      label: 'L7 · Stream de Tokens',  phase: 'LOADERS', loader: true },
  { id: 'ld-rain',        label: 'L8 · Chuva Binária',     phase: 'LOADERS', loader: true },
  { id: 'ld-spectrum',    label: 'L9 · Espectro de Sinal', phase: 'LOADERS', loader: true },
  { id: 'ld-glyph',       label: 'L11 · Decifrador',       phase: 'LOADERS', loader: true },
  { id: 'ld-tk-attn',     label: 'L12 · Tokens · Atenção', phase: 'LOADERS', loader: true },
  { id: 'ld-tk-beam',     label: 'L13 · Tokens · Top-K',   phase: 'LOADERS', loader: true },
  { id: 'ld-tk-rag',      label: 'L14 · Tokens · RAG',     phase: 'LOADERS', loader: true },
  { id: 'ld-tk-layers',   label: 'L15 · Tokens · Camadas', phase: 'LOADERS', loader: true },
];

const PHASES = ['BOOT', 'SETUP', 'CORE', 'COMM', 'SYS', 'LOADERS'];
const PHASE_COLORS = {
  BOOT: COL.magenta, SETUP: COL.alert, CORE: COL.acid, COMM: '#7fc8ff', SYS: COL.inkDim, LOADERS: COL.magenta,
};

/** Loader showcase metadata. */
const LOADER_META = {
  'ld-terminal':    { title: 'Terminal de Boot',  sub: 'rolagem CRT · verde-ácido' },
  'ld-halftone':    { title: 'Pulso Halftone',    sub: 'pop-art pulsante · embaralhamento' },
  'ld-radar':       { title: 'Varredura Radar',   sub: 'descoberta de pares · p2p' },
  'ld-tape':        { title: 'Fita de Dados',     sub: 'fluxo vertical · binário/vazamento' },
  'ld-counter':     { title: 'Contador de Células', sub: 'mutirão · explosões de caveira' },
  'ld-glitch':      { title: 'Glitch Embaralhado', sub: 'split RGB · burst pop-art' },
  'ld-tokens':      { title: 'Stream de Tokens',  sub: 'usado pra processar pauta no LLM' },
  'ld-rain':        { title: 'Chuva Binária',     sub: 'matrix-style · DEDSEC infiltrado' },
  'ld-spectrum':    { title: 'Espectro de Sinal', sub: 'equalizer · escutando a rede' },
  'ld-glyph':       { title: 'Decifrador',        sub: 'scramble · arquivo interceptado' },
  'ld-tk-attn':     { title: 'Tokens · Atenção',  sub: 'matriz de attention weights' },
  'ld-tk-beam':     { title: 'Tokens · Top-K',    sub: 'top-K sampling · candidatos com prob' },
  'ld-tk-rag':      { title: 'Tokens · RAG',      sub: 'busca + chunks + geração' },
  'ld-tk-layers':   { title: 'Tokens · Camadas',  sub: 'transformer stack · 12×8' },
};

/** id → React component factory */
const LOADER_COMP = {
  'ld-terminal':    () => <LoaderTerminal/>,
  'ld-halftone':    () => <LoaderHalftone/>,
  'ld-radar':       () => <LoaderRadar/>,
  'ld-tape':        () => <LoaderDataTape/>,
  'ld-counter':     () => <LoaderCounter/>,
  'ld-glitch':      () => <LoaderGlitch/>,
  'ld-tokens':      () => <LoaderTokenStream/>,
  'ld-rain':        () => <LoaderBinaryRain/>,
  'ld-spectrum':    () => <LoaderSpectrum/>,
  'ld-glyph':       () => <LoaderGlyphDecode/>,
  'ld-tk-attn':     () => <LoaderTokenAttention/>,
  'ld-tk-beam':     () => <LoaderTokenBeam/>,
  'ld-tk-rag':      () => <LoaderTokenRAG/>,
  'ld-tk-layers':   () => <LoaderTokenLayers/>,
};

Object.assign(window, { SCREENS, PHASES, PHASE_COLORS, LOADER_META, LOADER_COMP });
