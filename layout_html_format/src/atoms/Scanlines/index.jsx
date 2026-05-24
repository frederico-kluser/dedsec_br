/**
 * @file atoms/Scanlines — CRT scanline overlay.
 * @param {{opacity?: number}} props
 */
function Scanlines({ opacity = 0.18 }) {
  return (
    <div style={{
      position: 'absolute', inset: 0, pointerEvents: 'none', opacity,
      backgroundImage: 'repeating-linear-gradient(0deg, rgba(0,0,0,0.5) 0 1px, transparent 1px 3px)',
    }} />
  );
}
Object.assign(window, { Scanlines });
