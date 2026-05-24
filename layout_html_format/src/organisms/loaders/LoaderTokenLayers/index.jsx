/**
 * @file organisms/loaders/LoaderTokenLayers — L15: transformer stack viz.
 */
function LoaderTokenLayers() {
  const t = useTick(80);
  const LAYERS = 12;
  const TOKENS = 8;
  return (
    <div style={{ flex: 1, background: '#020608', padding: '14px 12px', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Scanlines opacity={0.08}/>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 10 }}>
        <span style={{ width: 8, height: 8, background: COL.magenta, animation: 'blink 0.6s steps(2) infinite' }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.magenta, letterSpacing: 1 }}>TRANSFORMER STACK</span>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkDim }}>{LAYERS}×{TOKENS}</span>
      </div>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 2, overflow: 'hidden' }}>
        {Array.from({ length: LAYERS }, (_, layerIdx) => {
          const layerActive = ((t - layerIdx) % 16) < 8;
          return (
            <div key={layerIdx} style={{
              display: 'flex', alignItems: 'center', gap: 3, padding: '2px 4px',
              background: layerActive ? '#0a0e0a' : 'transparent',
              border: layerActive ? `1px solid ${COL.acid}55` : `1px solid ${COL.line}`,
              flex: 1, minHeight: 0,
            }}>
              <span style={{ fontFamily: FONT.pixel, fontSize: 7, color: layerActive ? COL.acid : COL.inkMute, width: 22, flexShrink: 0 }}>
                L{String(layerIdx + 1).padStart(2,'0')}
              </span>
              {Array.from({ length: TOKENS }, (_, tokIdx) => {
                const cellActive = ((t * 2 - layerIdx + tokIdx) % 16) < 6;
                const value = (Math.sin(t * 0.1 + layerIdx * 0.4 + tokIdx * 0.5) + 1) / 2;
                return (
                  <div key={tokIdx} style={{
                    flex: 1, height: '100%',
                    background: cellActive ? `rgba(183,255,42,${0.3 + value * 0.7})` : '#0a0a0a',
                    border: cellActive ? `1px solid ${COL.acid}` : `1px solid ${COL.line}`,
                    boxShadow: cellActive && value > 0.7 ? `0 0 4px ${COL.acid}` : 'none',
                  }}/>
                );
              })}
            </div>
          );
        })}
      </div>
      <div style={{ marginTop: 8, fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <span>self-attn → ffn → norm</span><span>·</span><span>residual</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderTokenLayers });
