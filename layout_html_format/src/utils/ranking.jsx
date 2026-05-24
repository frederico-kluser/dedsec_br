/**
 * @file utils/ranking — leaderboard data + rank computation.
 * In production these numbers would come from the P2P mesh.
 */

/**
 * @typedef {Object} RankRow
 * @property {number} rank
 * @property {string} who
 * @property {string} seed
 * @property {number} score
 */

/** @type {RankRow[]} Top of the user's city. */
const LEADERBOARD_CITY = [
  { rank: 1, who: 'Cidadão_SP_91cd', seed: 'Cidadão_SP_91cd', score: 247 },
  { rank: 2, who: 'Cidadão_SP_bb22', seed: 'Cidadão_SP_bb22', score: 198 },
  { rank: 3, who: 'Cidadão_SP_d013', seed: 'Cidadão_SP_d013', score: 156 },
  { rank: 4, who: 'Cidadão_SP_aabb', seed: 'Cidadão_SP_aabb', score: 134 },
  { rank: 5, who: 'Cidadão_SP_71fa', seed: 'Cidadão_SP_71fa', score: 118 },
  { rank: 6, who: 'Cidadão_SP_ccdd', seed: 'Cidadão_SP_ccdd', score: 102 },
];

/** Total participants per scope. */
const SCOPE_TOTALS = { cidade: 4328, estado: 15918, pais: 89432 };

/**
 * Compute the user's rank in each scope from their score. Mock-y formula:
 * higher score → better (lower) rank. Numbers shift slightly each call so
 * processing a pauta visibly improves the position.
 *
 * @param {number} score
 * @returns {{ cidade: {rank:number,total:number}, estado: {...}, pais: {...} }}
 */
function computeRanks(score) {
  const baseScore = 12;
  const delta = Math.max(0, score - baseScore);
  return {
    cidade: { rank: Math.max(1, 47   - delta * 2), total: SCOPE_TOTALS.cidade },
    estado: { rank: Math.max(1, 312  - delta * 4), total: SCOPE_TOTALS.estado },
    pais:   { rank: Math.max(1, 2847 - delta * 9), total: SCOPE_TOTALS.pais   },
  };
}

Object.assign(window, { LEADERBOARD_CITY, SCOPE_TOTALS, computeRanks });
