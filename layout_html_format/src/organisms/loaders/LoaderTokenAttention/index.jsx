/**
 * @file organisms/loaders/LoaderTokenAttention — L12: attention weights.
 */
function LoaderTokenAttention() {
  const t = useTick(220);
  const input = ['notícia','sobre','metrô','linha','17-ouro','SP','atraso','custo'];
  const output = ['transporte','urgência','fiscalização','cobrança'];
  const cycle = t % (output.length + 4);
  const visible = Math.min(output.length, cycle);
  const currentIdx = Math.max(0, visible - 1);
  const weights = input.map((_, i) =>
    Math.abs(Math.sin(currentIdx * 1.3 + i * 0.7)) * 0.7 + 0.2
  );
  return (
    <div style={{ flex: 1, background: '#020608', padding: '14px 12px', display: 'flex', flexDirection: 'column', position: 'relative', overflow: 'hidden' }}>
      <Scanlines opacity={0.08}/>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 10 }}>
        <span style={{ width: 8, height: 8, background: COL.magenta, animation: 'blink 0.6s steps(2) infinite' }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.magenta, letterSpacing: 1 }}>MATRIZ DE ATENÇÃO</span>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkDim }}>head 4/8</span>
      </div>
      <div style={{ background: '#0a0a0e', border: `1.5px solid ${COL.line}`, padding: 10, marginBottom: 10 }}>
        <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1.2, marginBottom: 8 }}>
          INPUT — pesos de atenção
        </div>
        <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap' }}>
          {input.map((tk, i) => {
            const w = weights[i];
            return (
              <div key={i} style={{ display: 'flex', flexDirection: 'column', gap: 3, minWidth: 0 }}>
                <span style={{
                  fontFamily: FONT.mono, fontSize: 10, padding: '3px 6px',
                  background: `rgba(255,20,102,${w * 0.6})`,
                  color: w > 0.55 ? '#fff' : COL.ink,
                  border: `1px solid ${w > 0.55 ? COL.magenta : COL.line}`,
                  textAlign: 'center', whiteSpace: 'nowrap',
                }}>{tk}</span>
                <div style={{ height: 4, background: COL.line, position: 'relative' }}>
                  <div style={{ height: '100%', width: (w * 100) + '%', background: COL.magenta, boxShadow: w > 0.6 ? `0 0 4px ${COL.magenta}` : 'none' }}/>
                </div>
                <div style={{ fontFamily: FONT.mono, fontSize: 8, color: COL.inkMute, textAlign: 'center' }}>{w.toFixed(2)}</div>
              </div>
            );
          })}
        </div>
      </div>
      <div style={{ flex: 1, background: '#0a0e0a', border: `1.5px solid ${COL.acid}`, padding: 10, boxShadow: `0 0 12px ${COL.acid}22` }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 6 }}>
          <span style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.acid, letterSpacing: 1.2 }}>GERANDO</span>
          <div style={{ flex: 1 }}/>
          <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.acid }}>{visible}/{output.length}</span>
        </div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
          {output.slice(0, visible).map((tk, i) => {
            const fresh = i === currentIdx;
            return (
              <span key={i} style={{
                fontFamily: FONT.mono, fontSize: 12, padding: '4px 8px',
                background: fresh ? COL.acid : '#000',
                color: fresh ? '#000' : COL.acid,
                border: `1.5px solid ${COL.acid}`,
                fontWeight: fresh ? 700 : 400,
                transform: fresh ? 'scale(1.08)' : 'scale(1)',
                transition: 'all 0.2s',
              }}>{tk}</span>
            );
          })}
          {visible < output.length && (
            <span style={{
              fontFamily: FONT.mono, fontSize: 12, padding: '4px 8px',
              background: '#000', color: COL.acid, border: `1.5px solid ${COL.acid}`,
              animation: 'blink 0.5s steps(2) infinite',
            }}>▮</span>
          )}
        </div>
      </div>
      <div style={{ marginTop: 8, fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <span>self-attn</span><span>·</span><span>head 4/8</span><span>·</span><span>softmax</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderTokenAttention });
