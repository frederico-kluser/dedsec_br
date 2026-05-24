/**
 * @file molecules/NewsCard — single feed card with hero panel + body.
 * @param {{n: object, onOpen?: () => void}} props
 */
function NewsCard({ n, onOpen }) {
  return (
    <div onClick={onOpen} style={{
      background: COL.panel, border: `1.5px solid ${COL.line}`,
      marginBottom: 14, cursor: 'pointer',
    }}>
      <ComicPanel color={n.color} halftone="#000" height={96} label={`PAUTA · ${n.tag}`}>
        <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', opacity: 0.85 }}>
          <span style={{ fontSize: 56, filter: 'grayscale(0.6) contrast(1.4)' }}>{n.panel}</span>
        </div>
        {n.urgent && (
          <div style={{
            position: 'absolute', top: 8, right: 8, background: '#000', color: COL.danger,
            fontFamily: FONT.pixel, fontSize: 8, padding: '4px 6px', letterSpacing: 1,
            border: `1px solid ${COL.danger}`,
          }}>🔥 URGENTE</div>
        )}
      </ComicPanel>
      <div style={{ padding: 12 }}>
        <div style={{ fontFamily: FONT.body, fontSize: 14, fontWeight: 700, lineHeight: 1.3, color: COL.ink, marginBottom: 6 }}>
          {n.title}
        </div>
        <div style={{ fontFamily: FONT.body, fontSize: 12, color: COL.inkDim, lineHeight: 1.45, marginBottom: 10 }}>
          {n.desc}
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ flex: 1, fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute, letterSpacing: 0.5 }}>
            {n.sources.join(' · ')}
          </div>
          <div style={{
            fontFamily: FONT.pixel, fontSize: 9, color: '#000', background: COL.acid,
            padding: '6px 8px', letterSpacing: 1,
          }}>PROTESTAR →</div>
        </div>
      </div>
    </div>
  );
}
Object.assign(window, { NewsCard });
