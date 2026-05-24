/**
 * @file organisms/loaders/LoaderTokenBeam — L13: top-K sampling viz.
 */
function LoaderTokenBeam() {
  const t = useTick(450);
  const baseCandidateSets = [
    [['-Ouro', 0.62], ['-Diamante', 0.15], ['-Prata', 0.10], [' está', 0.08], [' tem', 0.05]],
    [[' atrasou', 0.55], [' tem', 0.18], [' foi', 0.13], [' está', 0.09], [' chegou', 0.05]],
    [[' 14', 0.41], [' anos', 0.22], [' a', 0.18], [' dois', 0.12], [' três', 0.07]],
    [[' e', 0.48], [' com', 0.21], [' mas', 0.15], [' enquanto', 0.10], [' por', 0.06]],
  ];
  const ctxOptions = [
    ['A',' Linha',' 17'],
    ['A',' Linha',' 17','-Ouro'],
    ['A',' Linha',' 17','-Ouro',' atrasou'],
    ['A',' Linha',' 17','-Ouro',' atrasou',' 14'],
  ];
  const idx = t % baseCandidateSets.length;
  const candidates = baseCandidateSets[idx];
  const committed = ctxOptions[idx];
  return (
    <div style={{ flex: 1, background: '#020608', padding: 14, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Scanlines opacity={0.08}/>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 10 }}>
        <span style={{ width: 8, height: 8, background: COL.alert, animation: 'blink 0.7s steps(2) infinite' }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.alert, letterSpacing: 1 }}>TOP-K SAMPLING</span>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkDim }}>k=5 · τ=0.7</span>
      </div>
      <div style={{ background: '#0a0e0a', border: `1.5px solid ${COL.acid}`, padding: 10, marginBottom: 10 }}>
        <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1.2, marginBottom: 5 }}>
          CONTEXTO ({committed.length} tok)
        </div>
        <div style={{ fontFamily: FONT.mono, fontSize: 13, color: COL.ink }}>
          {committed.join('')}<span style={{ color: COL.acid, animation: 'blink 0.6s steps(2) infinite' }}>▮</span>
        </div>
      </div>
      <div style={{ flex: 1, background: '#0a0a0e', border: `1.5px solid ${COL.line}`, padding: 10, overflow: 'hidden' }}>
        <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1.2, marginBottom: 8 }}>
          PRÓXIMO TOKEN — 5 CANDIDATOS
        </div>
        {candidates.map(([tok, prob], i) => {
          const isWinner = i === 0;
          return (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 5 }}>
              <span style={{ width: 16, fontFamily: FONT.pixel, fontSize: 8, color: isWinner ? COL.acid : COL.inkMute, textAlign: 'right' }}>#{i+1}</span>
              <span style={{
                fontFamily: FONT.mono, fontSize: 11, padding: '3px 6px',
                background: isWinner ? COL.acid : '#000',
                color: isWinner ? '#000' : COL.ink,
                border: `1px solid ${isWinner ? COL.acid : COL.line}`,
                minWidth: 60, textAlign: 'center',
              }}>{tok.trim() || '·'}</span>
              <div style={{ flex: 1, height: 8, background: COL.line, position: 'relative' }}>
                <div style={{
                  height: '100%', width: (prob * 100) + '%',
                  background: isWinner ? COL.acid : COL.magenta,
                  boxShadow: isWinner ? `0 0 4px ${COL.acid}` : 'none',
                  transition: 'width 0.3s',
                }}/>
              </div>
              <span style={{ fontFamily: FONT.mono, fontSize: 10, color: isWinner ? COL.acid : COL.inkDim, width: 36, textAlign: 'right' }}>
                {(prob * 100).toFixed(0)}%
              </span>
            </div>
          );
        })}
      </div>
      <div style={{ marginTop: 8, fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <span>argmax</span><span>·</span><span>softmax</span><span>·</span><span>rep_penalty=1.1</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderTokenBeam });
