/**
 * @file molecules/TokenStreamPanel — visualization of LLM input + output
 * tokens streaming. Reusable both as loader L7 and as the working visual
 * inside the "Process pauta" and "Analyze pauta" overlays.
 *
 * @param {{
 *   inputTokens?: string[],
 *   outputTokens?: string[],
 *   modelLabel?: string,
 * }} props
 */
function TokenStreamPanel({
  inputTokens = ['[BOS]','pauta:','linha','17-','ouro','sp','atraso','14','anos','custo','3x','[EOS]'],
  outputTokens = ['A',' Linha',' 17-Ouro',' do',' metrô',' atrasou',' 14',' anos',' e',' o',' custo',' triplicou','.',' Quem',' paga','?'],
  modelLabel = 'GEMMA-3-1B',
}) {
  const t = useTick(180);
  const cycleLength = outputTokens.length + 6;
  const cycle = t % cycleLength;
  const visible = Math.min(outputTokens.length, cycle);
  const layer = (Math.floor(t / 2) % 16) + 1;
  const tokPerSec = (12 + Math.sin(t * 0.3) * 2).toFixed(1);
  const attnPct = Math.round(visible / outputTokens.length * 100);
  const kvKb = visible * 8 + inputTokens.length * 4;

  return (
    <div style={{
      flex: 1, position: 'relative', overflow: 'hidden',
      padding: '14px 12px', display: 'flex', flexDirection: 'column', minHeight: 0,
    }}>
      <Scanlines opacity={0.08}/>

      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 10, zIndex: 1 }}>
        <span style={{ width: 8, height: 8, background: COL.acid, animation: 'blink 0.6s steps(2) infinite' }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid, letterSpacing: 1 }}>{modelLabel}</span>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkDim }}>
          layer <span style={{ color: COL.magenta }}>{layer}</span>/16
        </span>
      </div>

      <div style={{ background: '#0a0d0a', border: `1.5px solid ${COL.line}`, padding: 8, marginBottom: 8, zIndex: 1 }}>
        <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1.5, marginBottom: 5 }}>
          INPUT · {inputTokens.length} TOK
        </div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 3 }}>
          {inputTokens.map((tk, i) => (
            <span key={i} style={{
              fontFamily: FONT.mono, fontSize: 10, padding: '2px 5px',
              background: '#000', color: COL.inkDim, border: `1px solid ${COL.line}`,
            }}>{tk.trim() || '·'}</span>
          ))}
        </div>
      </div>

      <div style={{
        background: '#0a0e0a', border: `1.5px solid ${COL.acid}`, padding: 8,
        flex: 1, minHeight: 0, zIndex: 1, display: 'flex', flexDirection: 'column',
        boxShadow: `0 0 16px ${COL.acid}33`, overflow: 'hidden',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 6 }}>
          <span style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.acid, letterSpacing: 1.5 }}>GERANDO</span>
          <div style={{ flex: 1 }}/>
          <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.acid }}>{visible}/{outputTokens.length} · {tokPerSec} tok/s</span>
        </div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 3, flex: 1, alignContent: 'flex-start', overflow: 'hidden' }}>
          {outputTokens.slice(0, visible).map((tk, i) => {
            const fresh = i === visible - 1;
            return (
              <span key={i} style={{
                fontFamily: FONT.mono, fontSize: 11, padding: '2px 6px',
                background: COL.acid, color: '#000', border: `1.5px solid #000`,
                fontWeight: fresh ? 700 : 400,
                boxShadow: fresh ? '2px 2px 0 #000' : 'none',
                transform: fresh ? 'scale(1.05)' : 'scale(1)',
                transition: 'transform 0.15s',
              }}>{tk.trim() || '·'}</span>
            );
          })}
          {visible < outputTokens.length && (
            <span style={{
              fontFamily: FONT.mono, fontSize: 11, padding: '2px 6px',
              background: '#000', color: COL.acid, border: `1.5px solid ${COL.acid}`,
              animation: 'blink 0.5s steps(2) infinite',
            }}>▮</span>
          )}
        </div>
      </div>

      <div style={{
        marginTop: 8, fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute,
        display: 'flex', gap: 10, zIndex: 1, flexWrap: 'wrap',
      }}>
        <span>attn: <span style={{ color: COL.acid }}>{attnPct}%</span></span>
        <span>·</span>
        <span>kv: <span style={{ color: COL.magenta }}>{kvKb}KB</span>/256KB</span>
        <span>·</span>
        <span>vocab: 32k</span>
      </div>
    </div>
  );
}
Object.assign(window, { TokenStreamPanel });
