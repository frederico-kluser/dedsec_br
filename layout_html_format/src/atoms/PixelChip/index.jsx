/**
 * @file atoms/PixelChip — small pixel-font label.
 * @param {{children?: any, color?: string, bg?: string, size?: number, style?: object}} props
 */
function PixelChip({ children, color, bg = '#000', size = 9, style = {} }) {
  const c = color || COL.acid;
  return (
    <span style={{
      display: 'inline-block', fontFamily: FONT.pixel, fontSize: size,
      color: c, background: bg, padding: '5px 7px', letterSpacing: 1,
      border: `1px solid ${c}`,
      ...style,
    }}>{children}</span>
  );
}
Object.assign(window, { PixelChip });
