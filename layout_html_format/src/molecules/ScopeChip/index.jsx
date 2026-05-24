/**
 * @file molecules/ScopeChip — toggle chip for Municipal/Estadual/Federal.
 * @param {{children?: any, active?: boolean, color?: string, onClick?: () => void}} props
 */
function ScopeChip({ children, active, color, onClick }) {
  return (
    <button onClick={onClick} style={{
      fontFamily: FONT.pixel, fontSize: 9, letterSpacing: 1.5,
      padding: '10px 12px', background: active ? color : 'transparent',
      color: active ? '#000' : COL.inkDim,
      border: `1.5px solid ${active ? color : COL.line}`,
      cursor: 'pointer', flex: 1,
    }}>{children}</button>
  );
}
Object.assign(window, { ScopeChip });
