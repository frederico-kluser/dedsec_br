/**
 * @file useTopics/index.jsx
 * Forum topic store + thread replies. In a real app this would sync with
 * a P2P mesh. Here it's local React state.
 */

/**
 * @typedef {'mun'|'est'|'fed'} TopicScope
 * @typedef {Object} ForumTopic
 * @property {string}     id
 * @property {string}     tag           e.g. 'TRANSPORTE'
 * @property {TopicScope} scope
 * @property {string}     title
 * @property {string}     body
 * @property {string}     author        pseudonym
 * @property {string}     [seed]
 * @property {number}     replies
 * @property {string}     age           human-friendly age string
 * @property {boolean}    [live]
 * @property {boolean}    [hot]
 * @property {number}     [newReplies]  unseen reply counter
 * @property {boolean}    [mine]
 */

/**
 * @typedef {Object} ForumReply
 * @property {string}        id
 * @property {string}        who    author pseudonym
 * @property {string}        [seed] DiceBear seed
 * @property {string}        age
 * @property {string}        body
 * @property {Object<string, number>} reacts
 * @property {boolean}       [mine]
 */

/** @type {ForumTopic[]} */
const INITIAL_TOPICS = [
  { id: 't1', live: true,  tag: 'TRANSPORTE',     scope: 'mun', title: 'Linha 17-Ouro: como cobrar o TCE-SP?',                                  author: 'Cidadão_SP_4a7b', replies: 87, age: '12 min', hot: true,  newReplies: 5,
    body: 'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?' },
  { id: 't2', live: false, tag: 'ORÇAMENTO',      scope: 'mun', title: 'Audiência pública pulada — vamos ao MP?',                                author: 'Cidadão_SP_91cd', replies: 34, age: '1h',     newReplies: 2,
    body: 'Vereadores aprovaram o orçamento 2026 em sessão extraordinária sem audiências públicas. Quem topa redigir representação pro Ministério Público?' },
  { id: 't3', live: true,  tag: 'SAÚDE',          scope: 'mun', title: 'Mutirão para denunciar falta de pediatra em Capão Redondo',              author: 'Cidadão_SP_bb22', replies: 56, age: '2h',     newReplies: 7,
    body: 'UBS sem pediatra há 3 meses. Vamos coordenar denúncia simultânea na Ouvidoria-SUS, no MP e na imprensa local.' },
  { id: 't4', live: false, tag: 'MEIO AMBIENTE',  scope: 'est', title: 'Corte na fiscalização ambiental: alguém viu o edital?',                 author: 'Cidadão_SP_d013', replies: 12, age: '4h',     newReplies: 1,
    body: 'Boato circulando que vão cortar 40% dos fiscais ambientais do estado. Tem confirmação? Vamos achar o edital ou D.O.' },
  { id: 't5', live: true,  tag: 'CORRUPÇÃO',      scope: 'est', title: 'CPI dos pedágios — sumiço de documentos?',                              author: 'Cidadão_SP_aabb', replies: 28, age: '7h',     newReplies: 3, hot: true,
    body: 'Documentos requisitados pela CPI dos pedágios não chegaram à ALESP. Alguém sabe quem é o relator?' },
  { id: 't6', live: false, tag: 'CULTURA',        scope: 'fed', title: 'Repasse pra museus suspenso há 4 meses — fontes?',                      author: 'Cidadão_SP_71fa', replies: 9,  age: '6h',     newReplies: 0,
    body: 'MINC anunciou retomada do repasse, mas museus dizem que nada chegou. Vamos cruzar dados do SIAFI.' },
  { id: 't7', live: true,  tag: 'EDUCAÇÃO',       scope: 'fed', title: 'PEC do FUNDEB: como pressionar pelos R$ 7 bi',                          author: 'Cidadão_SP_ccdd', replies: 41, age: '1d',     newReplies: 4,
    body: 'Senado adiou votação da PEC do FUNDEB pela 3ª vez. Lista de senadores indecisos: 22 nomes. Quem topa redigir e-mail conjunto?' },
];

/**
 * Forum + replies store.
 * @param {DedsecUser} user
 */
function useTopics(user) {
  const [topics, setTopics] = React.useState(INITIAL_TOPICS);
  const [topicReplies, setTopicReplies] = React.useState([
    { id: 'r1', who: 'Cidadão_SP_91cd', seed: 'Cidadão_SP_91cd', age: '8 min', body: 'Já mandei pra ouvidoria do TCE-SP. Protocolo é OUVI-2026-001234. Quem quiser comentar lá, link no perfil oficial.', reacts: { '⚡': 23, '🔥': 12 } },
    { id: 'r2', who: 'Cidadão_SP_bb22', seed: 'Cidadão_SP_bb22', age: '6 min', body: 'Boa! Importante lembrar que o prazo de resposta da Ouvidoria do TCE é 20 dias úteis pela Lei 12.527. Vale acompanhar.', reacts: { '👍': 18 } },
    { id: 'r3', who: 'Cidadão_SP_d013', seed: 'Cidadão_SP_d013', age: '3 min', body: 'Tem alguém que entende de licitação e pode olhar os aditivos do contrato? Tá tudo público no D.O. mas é denso.', reacts: { '🤔': 9 } },
  ]);

  /** Adds a topic to the top of the list. @param {ForumTopic} topic */
  const addTopic = React.useCallback((topic) => {
    setTopics(ts => [{ ...topic, mine: true, newReplies: 0 }, ...ts]);
  }, []);

  /** Clear the unseen-counter for a topic. @param {string} id */
  const markTopicSeen = React.useCallback((id) => {
    setTopics(ts => ts.map(t => t.id === id ? { ...t, newReplies: 0 } : t));
  }, []);

  /** Append a reply authored by the current user. @param {string} text */
  const addReply = React.useCallback((text) => {
    if (!text || !text.trim()) return;
    setTopicReplies(rs => [...rs, {
      id: 'r' + Date.now(),
      who: user.pseudonym,
      seed: user.seed,
      age: 'agora',
      body: text.trim(),
      reacts: {},
      mine: true,
    }]);
  }, [user]);

  /** Remove a reply (only the user's own). @param {string} id */
  const deleteReply = React.useCallback((id) => {
    setTopicReplies(rs => rs.filter(r => r.id !== id));
  }, []);

  return { topics, addTopic, markTopicSeen, topicReplies, addReply, deleteReply };
}

Object.assign(window, { useTopics, INITIAL_TOPICS });
