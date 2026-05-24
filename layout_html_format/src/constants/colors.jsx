/**
 * @file colors.jsx
 * Brand palette and decorative helpers used across Dedsec_BR.
 * Exposed globally because we run Babel in the browser without bundling.
 */

/**
 * @typedef {Object} DedsecPalette
 * @property {string} bg        Page background (near-black)
 * @property {string} bg2       Slightly raised surface
 * @property {string} panel     Card / panel background
 * @property {string} panelHi   Hovered / active panel
 * @property {string} ink       Default text color
 * @property {string} inkDim    Secondary text
 * @property {string} inkMute   Tertiary text
 * @property {string} magenta   Primary accent (pop-art magenta)
 * @property {string} magentaD  Darker magenta
 * @property {string} acid      Secondary accent (acid green)
 * @property {string} acidD     Darker acid
 * @property {string} alert     Warning yellow
 * @property {string} danger    Destructive red
 * @property {string} line      Default border
 * @property {string} lineHi    Brighter border
 */

/** @type {DedsecPalette} */
const COL = {
  bg:       '#050505',
  bg2:      '#0d0d0d',
  panel:    '#141414',
  panelHi:  '#1c1c1c',
  ink:      '#f2f2ec',
  inkDim:   '#9a9a92',
  inkMute:  '#5a5a52',
  magenta:  '#ff1466',
  magentaD: '#c2104f',
  acid:     '#b7ff2a',
  acidD:    '#7fb800',
  alert:    '#ffd60a',
  danger:   '#ff4936',
  line:     '#2a2a26',
  lineHi:   '#3a3a32',
};

Object.assign(window, { COL });
