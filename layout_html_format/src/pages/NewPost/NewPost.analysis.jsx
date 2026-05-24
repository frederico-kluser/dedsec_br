/**
 * @file pages/NewPost/NewPost.analysis — keyword-routed mock LLM analysis.
 */

/**
 * @typedef {Object} AnalysisResult
 * @property {string}   theme
 * @property {string}   color
 * @property {string}   title
 * @property {string}   desc
 * @property {Array<{role:string, name:string, handle:string}>} authorities
 * @property {number}   confidence
 */

const NEWPOST_SCOPES = [
  { id: 'mun', label: 'MUNICIPAL', color: COL.magenta, sub: 'só sua cidade' },
  { id: 'est', label: 'ESTADUAL',  color: COL.acid,    sub: 'seu estado'    },
  { id: 'fed', label: 'FEDERAL',   color: COL.alert,   sub: 'país inteiro'  },
];

/**
 * Pretend to run a classifier. Keyword-routed mock for demo.
 * @param {string} text
 * @param {'mun'|'est'|'fed'} scope
 * @returns {AnalysisResult}
 */
function analyzeText(text, scope) {
  const lower = text.toLowerCase();
  let theme = 'POLÍTICA';
  let color = COL.magenta;
  if      (lower.match(/metr[ôo]|[ôo]nibus|\btrans|mobil|rua|via|tr[áa]fego|congestion|cicl/)) { theme = 'TRANSPORTE';    color = COL.magenta; }
  else if (lower.match(/saud|hospital|\bubs|posto|m[ée]dic|\bsus|vacin|pediat|enferm/))        { theme = 'SAÚDE';         color = COL.alert;   }
  else if (lower.match(/escol|educa|merenda|professor|aluno|creche|universid/))                  { theme = 'EDUCAÇÃO';      color = COL.magenta; }
  else if (lower.match(/or[çc]ament|gasto|verba|licit|contrat|aditiv|caixa|impost/))             { theme = 'ORÇAMENTO';     color = COL.acid;    }
  else if (lower.match(/ambient|polui|reciclag|lixo|enchente|desmat|verde|parque/))              { theme = 'MEIO AMBIENTE'; color = COL.acid;    }
  else if (lower.match(/cultur|museu|teatro|biblio|arte|festiv/))                                { theme = 'CULTURA';       color = COL.magenta; }
  else if (lower.match(/pol[íi]cia|seguran[çc]|crime|viol[êe]ncia|assalt/))                      { theme = 'SEGURANÇA';     color = COL.danger;  }
  else if (lower.match(/morad|habita|favel|cortic|despej/))                                      { theme = 'MORADIA';       color = COL.alert;   }
  else if (lower.match(/corrup|propin|desvi|fraud|escândal/))                                    { theme = 'CORRUPÇÃO';     color = COL.danger;  }

  const firstSentence = text.split(/[.!?\n]/)[0].trim();
  const title = firstSentence.length > 12
    ? firstSentence.charAt(0).toUpperCase() + firstSentence.slice(1, 110)
    : `Nova pauta de ${theme.toLowerCase()} levantada por cidadão`;

  const trim = text.replace(/\s+/g, ' ').trim();
  const desc = trim.length > 280 ? trim.slice(0, 280).trim() + ' ...' : trim;

  const authorities = {
    mun: [
      { role: 'PREFEITO',         name: 'Prefeitura de São Paulo', handle: '@prefsp' },
      { role: 'CÂMARA MUNICIPAL', name: 'CMSP — vereadores',       handle: '@cmsp_oficial' },
    ],
    est: [
      { role: 'GOVERNADOR', name: 'Governo do Estado de SP', handle: '@governosp' },
      { role: 'ASSEMBLEIA', name: 'ALESP',                   handle: '@alesp_oficial' },
    ],
    fed: [
      { role: 'PRESIDÊNCIA', name: 'Planalto',             handle: '@planalto' },
      { role: 'CÂMARA',      name: 'Câmara dos Deputados', handle: '@camaradeputados' },
      { role: 'SENADO',      name: 'Senado Federal',       handle: '@senadofederal' },
    ],
  }[scope];

  const confidence = 78 + (text.length % 18);

  return { theme, color, title, desc, authorities, confidence };
}

Object.assign(window, { NEWPOST_SCOPES, analyzeText });
