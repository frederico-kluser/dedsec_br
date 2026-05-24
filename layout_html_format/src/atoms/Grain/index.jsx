/**
 * @file atoms/Grain — film-grain overlay (SVG fractalNoise).
 * @param {{opacity?: number}} props
 */
function Grain({ opacity = 0.08 }) {
  return (
    <div style={{
      position: 'absolute', inset: 0, pointerEvents: 'none', mixBlendMode: 'overlay', opacity,
      backgroundImage: `url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='160' height='160'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/><feColorMatrix values='0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 1 0'/></filter><rect width='100%' height='100%' filter='url(%23n)' opacity='0.6'/></svg>")`,
    }} />
  );
}
Object.assign(window, { Grain });
