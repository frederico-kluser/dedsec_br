/**
 * @file useScramble/index.jsx
 * Character-scramble helper for "decoding text" effects.
 */

/** Alphabet used to fill un-locked positions. */
const GLYPHS = '!@#$%&*+=<>/\\|0123456789ABCDEFXYZ';

/**
 * Returns `target` with the first `lock` characters revealed and the
 * remaining characters replaced by deterministic random-looking glyphs.
 * @param {string} target
 * @param {number} t      Tick counter (varies the output over time)
 * @param {number} [lock] Number of leading characters already decoded
 * @returns {string}
 */
function scramble(target, t, lock = 0) {
  return target.split('').map((c, i) => {
    if (i < lock || c === ' ') return c;
    return GLYPHS[(t * 7 + i * 13) % GLYPHS.length];
  }).join('');
}

Object.assign(window, { scramble });
