/**
 * @file atoms/Glitch — RGB-split text effect using pure CSS shadows.
 * @param {{children?: any, size?: number, color?: string, family?: string, style?: object}} props
 */
function Glitch({ children, size = 24, color, family, style = {} }) {
  return (
    <span style={{
      position: 'relative', display: 'inline-block',
      fontFamily: family || FONT.pixel,
      fontSize: size, color: color || COL.ink, letterSpacing: 1,
      textShadow: `2px 0 ${COL.magenta}, -2px 0 ${COL.acid}`,
      ...style,
    }}>{children}</span>
  );
}
Object.assign(window, { Glitch });
