/**
 * @file organisms/loaders/LoaderBinaryRain — L8: matrix-style rain w/ DEDSEC.
 */
function LoaderBinaryRain() {
  const COLS = 14;
  const columns = React.useMemo(() => (
    Array.from({ length: COLS }, () => {
      const chars = [];
      for (let i = 0; i < 30; i++) {
        const r = Math.random();
        if (r < 0.18)      chars.push('DEDSEC'[Math.floor(Math.random() * 6)]);
        else if (r < 0.35) chars.push(String(Math.floor(Math.random() * 10)));
        else               chars.push('#@%$&*?!+='[Math.floor(Math.random() * 10)]);
      }
      return {
        chars,
        duration: 4 + Math.random() * 6,
        delay: -Math.random() * 8,
        accent: Math.random() < 0.18,
      };
    })
  ), []);
  return (
    <div style={{ flex: 1, background: '#020602', position: 'relative', overflow: 'hidden', display: 'flex' }}>
      <Scanlines opacity={0.08}/>
      {columns.map((col, ci) => (
        <div key={ci} style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
          <div style={{
            position: 'absolute', top: 0, left: 0, right: 0,
            fontFamily: FONT.mono, fontSize: 13, lineHeight: 1.4,
            color: col.accent ? COL.magenta : COL.acid,
            textAlign: 'center',
            animation: `rain-fall ${col.duration}s linear infinite`,
            animationDelay: `${col.delay}s`,
            textShadow: `0 0 5px ${col.accent ? COL.magenta : COL.acid}`,
            WebkitMaskImage: 'linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.5) 25%, black 60%, transparent 100%)',
            maskImage: 'linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.5) 25%, black 60%, transparent 100%)',
          }}>
            {col.chars.map((c, i) => <div key={i}>{c}</div>)}
          </div>
        </div>
      ))}
      <div style={{
        position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -50%)',
        background: '#000', border: `2px solid ${COL.acid}`, padding: '14px 20px',
        boxShadow: `5px 5px 0 ${COL.magenta}`, textAlign: 'center', zIndex: 3,
      }}>
        <div style={{ fontFamily: FONT.pixel, fontSize: 14, color: COL.acid, letterSpacing: 2 }}>DECIFRANDO</div>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 6, letterSpacing: 1.5 }}>
          // canal seguro · libp2p
        </div>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderBinaryRain });
