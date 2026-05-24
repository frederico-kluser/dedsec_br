/**
 * @file atoms/Wordmark — "DEDSEC_BR" lockup.
 * @param {{size?: number, color?: string}} props
 */
function Wordmark({ size = 16, color }) {
  return (
    <span style={{
      fontFamily: FONT.pixel, fontSize: size, color: color || COL.ink, letterSpacing: 2,
      display: 'inline-flex', alignItems: 'baseline', gap: size * 0.25,
    }}>
      <span>DEDSEC</span>
      <span style={{
        fontSize: size * 0.6, padding: `${size*0.12}px ${size*0.3}px`,
        background: COL.magenta, color: '#000',
      }}>_BR</span>
    </span>
  );
}
Object.assign(window, { Wordmark });
