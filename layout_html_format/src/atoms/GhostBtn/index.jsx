/**
 * @file atoms/GhostBtn — dashed-outline secondary button.
 * @param {{children?: any, onClick?: () => void, full?: boolean, style?: object, color?: string}} props
 */
function GhostBtn({ children, onClick, full, style = {}, color }) {
  const c = color || COL.ink;
  return (
    <button onClick={onClick} style={{
      width: full ? '100%' : 'auto',
      fontFamily: FONT.pixel, fontSize: 10, letterSpacing: 1.5,
      padding: '12px 16px', textTransform: 'uppercase',
      color: c, background: 'transparent', border: `1.5px dashed ${c}`,
      cursor: 'pointer',
      ...style,
    }}>{children}</button>
  );
}
Object.assign(window, { GhostBtn });
