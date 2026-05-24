/**
 * @file atoms/Stencil — heavy stencil display headline.
 * @param {{children?: any, size?: number, color?: string, style?: object}} props
 */
function Stencil({ children, size = 40, color, style = {} }) {
  return (
    <div style={{
      fontFamily: FONT.stencil, fontSize: size, lineHeight: 0.9,
      letterSpacing: 1, color: color || COL.ink, textTransform: 'uppercase',
      ...style,
    }}>{children}</div>
  );
}
Object.assign(window, { Stencil });
