/**
 * @file molecules/ComicPanel — solid color card with halftone + corner label.
 * Used for hero illustrations in feed and onboarding.
 * @param {{
 *   color?: string,
 *   halftone?: string,
 *   children?: any,
 *   style?: object,
 *   height?: number,
 *   label?: string,
 * }} props
 */
function ComicPanel({ color, halftone = '#000', children, style = {}, height = 120, label }) {
  return (
    <div style={{
      position: 'relative', overflow: 'hidden', height,
      background: color || COL.magenta, border: `2px solid #000`,
      ...style,
    }}>
      <Halftone color={halftone} size={5} opacity={0.55} style={{ position: 'absolute', inset: 0 }} />
      <div style={{
        position: 'absolute', inset: 0,
        backgroundImage: 'linear-gradient(135deg, rgba(0,0,0,0) 60%, rgba(0,0,0,0.55))',
      }} />
      {children}
      {label && (
        <div style={{
          position: 'absolute', left: 8, bottom: 8,
          fontFamily: FONT.pixel, fontSize: 9, color: '#fff', letterSpacing: 1,
          background: '#000', padding: '4px 6px',
        }}>{label}</div>
      )}
      <Grain opacity={0.12} />
    </div>
  );
}
Object.assign(window, { ComicPanel });
