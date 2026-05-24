/**
 * @file utils/format — pure formatting helpers.
 */

/**
 * Format a number as `#1.234` in pt-BR locale.
 * @param {number} n
 * @returns {string}
 */
function formatRank(n) {
  return '#' + (n || 0).toLocaleString('pt-BR');
}

/**
 * Format a number as `12.345` in pt-BR locale.
 * @param {number} n
 * @returns {string}
 */
function formatNum(n) {
  return (n || 0).toLocaleString('pt-BR');
}

/**
 * Compute the top percentile of a rank inside a total.
 * @param {number} rank
 * @param {number} total
 * @returns {string} e.g. "1,1%"
 */
function topPercent(rank, total) {
  if (!total) return '—';
  const pct = (rank / total) * 100;
  if (pct < 0.1) return '<0,1%';
  return pct.toFixed(1).replace('.', ',') + '%';
}

Object.assign(window, { formatRank, formatNum, topPercent });
