/**
 * @file fonts.jsx
 * Font stacks. Loaded by index.html via Google Fonts.
 */

/**
 * @typedef {Object} DedsecFonts
 * @property {string} pixel    Press Start 2P — pixel/stencil headings
 * @property {string} stencil  Anton — chunky display headings
 * @property {string} mono     JetBrains Mono — code, terminal, meta
 * @property {string} body     Space Grotesk — body copy
 */

/** @type {DedsecFonts} */
const FONT = {
  pixel:   '"Press Start 2P", monospace',
  stencil: '"Anton", "Bebas Neue", Impact, sans-serif',
  mono:    '"JetBrains Mono", "VT323", monospace',
  body:    '"Space Grotesk", system-ui, sans-serif',
};

Object.assign(window, { FONT });
