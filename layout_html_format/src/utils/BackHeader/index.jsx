/**
 * @file utils/BackHeader — top header with back button + right-side slot.
 *
 * @param {{ label?: string, onBack?: () => void, children?: any }} props
 */
function BackHeader({ label = 'VOLTAR', onBack, children }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px',
      background: COL.bg, borderBottom: `1px solid ${COL.line}`,
    }}>
      <button onClick={onBack} style={{
        background: 'transparent', border: 'none', color: COL.ink,
        fontFamily: FONT.pixel, fontSize: 11, cursor: 'pointer', letterSpacing: 1,
      }}>← {label}</button>
      <div style={{ flex: 1 }}/>
      {children}
    </div>
  );
}
Object.assign(window, { BackHeader });
