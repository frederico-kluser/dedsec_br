/**
 * @file atoms/Btn — chunky push-button with offset shadow.
 * @param {{children?: any, color?: string, fg?: string, onClick?: () => void, full?: boolean, style?: object, disabled?: boolean}} props
 */
function Btn({ children, color, fg = '#000', onClick, full, style = {}, disabled }) {
  return (
    <button onClick={onClick} disabled={disabled} style={{
      display: 'inline-block', width: full ? '100%' : 'auto',
      fontFamily: FONT.pixel, fontSize: 11, letterSpacing: 1.5,
      padding: '14px 18px', textTransform: 'uppercase',
      color: fg, background: color || COL.acid, border: 'none', cursor: 'pointer',
      boxShadow: `4px 4px 0 #000`, transition: 'transform 0.08s',
      opacity: disabled ? 0.4 : 1,
      ...style,
    }}
    onMouseDown={e => e.currentTarget.style.transform = 'translate(2px,2px)'}
    onMouseUp={e => e.currentTarget.style.transform = 'translate(0,0)'}
    onMouseLeave={e => e.currentTarget.style.transform = 'translate(0,0)'}
    >{children}</button>
  );
}
Object.assign(window, { Btn });
