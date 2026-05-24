/**
 * @file atoms/PixelBar — chunky progress bar.
 * @param {{value?: number, color?: string, bg?: string, height?: number}} props
 */
function PixelBar({ value = 0, color, bg = '#1a1a1a', height = 14 }) {
  return (
    <div style={{ background: bg, height, border: '1.5px solid #000', position: 'relative', overflow: 'hidden' }}>
      <div style={{
        height: '100%', width: `${value}%`, background: color || COL.acid,
        backgroundImage: `repeating-linear-gradient(90deg, rgba(0,0,0,0.25) 0 2px, transparent 2px 6px)`,
        transition: 'width 0.4s',
      }} />
    </div>
  );
}
Object.assign(window, { PixelBar });
