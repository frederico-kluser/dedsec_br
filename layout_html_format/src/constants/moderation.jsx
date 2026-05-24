/**
 * @file moderation.jsx
 * Mock local moderation. In production this would call the on-device LLM.
 */

/**
 * Test list of blocked words. Replace with classifier output.
 * @type {string[]}
 */
const BLOCKED_WORDS = ['shit'];

/**
 * @typedef {Object} ModerationResult
 * @property {boolean} blocked
 * @property {string}  [word]    Triggering word, when blocked
 */

/**
 * Run the (mock) moderation classifier over a piece of text.
 * @param {string} text
 * @returns {ModerationResult}
 */
function moderateText(text) {
  const lower = (text || '').toLowerCase();
  for (const w of BLOCKED_WORDS) {
    if (lower.includes(w)) return { blocked: true, word: w };
  }
  return { blocked: false };
}

Object.assign(window, { BLOCKED_WORDS, moderateText });
