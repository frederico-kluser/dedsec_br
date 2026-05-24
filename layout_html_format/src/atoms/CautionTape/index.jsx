/**
 * @file atoms/CautionTape — scrolling diagonal caution band.
 * @param {{text?: string, color?: string}} props
 */
function CautionTape({ text = 'DEDSEC_BR / DEDSEC_BR / DEDSEC_BR / ', color }) {
  return (
    <div style={{
      overflow: 'hidden', background: color || COL.alert,
      transform: 'rotate(-1.5deg)', margin: '0 -8px',
      borderTop: '2px solid #000', borderBottom: '2px solid #000',
    }}>
      <div style={{
        fontFamily: FONT.pixel, fontSize: 10, color: '#000', letterSpacing: 2,
        padding: '6px 0', whiteSpace: 'nowrap', animation: 'tape-scroll 20s linear infinite',
      }}>{text.repeat(8)}</div>
    </div>
  );
}
Object.assign(window, { CautionTape });
