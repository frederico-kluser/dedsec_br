/**
 * @file organisms/loaders/LoaderHalftone — L2: pop-art breathing pulse.
 */
function LoaderHalftone() {
  const t = useTick(60);
  const target = 'NOS AGUARDE';
  const lock = Math.min(target.length, Math.floor((t % 60) / 4));
  return (
    <div style={{
      flex: 1, background: COL.bg, position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      padding: 24,
    }}>
      {[0,1,2].map(i => (
        <div key={i} style={{
          position: 'absolute', top: '50%', left: '50%', width: 320, height: 320,
          marginLeft: -160, marginTop: -160,
          borderRadius: '50%',
          background: `radial-gradient(circle, ${COL.magenta}66 0%, transparent 60%)`,
          opacity: 0.7,
          animation: `pulse-out 2.4s ease-out ${i*0.8}s infinite`,
        }}/>
      ))}
      <div style={{
        width: 220, height: 220, borderRadius: '50%',
        background: COL.magenta, border: '4px solid #000', position: 'relative', overflow: 'hidden',
        boxShadow: '8px 8px 0 #000',
      }}>
        <Halftone color="#000" size={6} opacity={0.7} style={{ position: 'absolute', inset: 0 }}/>
        <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Skull size={90} color="#fff"/>
        </div>
        <Grain opacity={0.18}/>
      </div>
      <div style={{ marginTop: 36, textAlign: 'center', position: 'relative', zIndex: 2 }}>
        <Glitch size={28} family={FONT.pixel}>{scramble(target, t, lock)}</Glitch>
        <div style={{ marginTop: 14, fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, letterSpacing: 2 }}>
          // DECIFRANDO PAUTA ...
        </div>
      </div>
      <div style={{
        position: 'absolute', bottom: 22, left: 22, right: 22,
        display: 'flex', justifyContent: 'space-between',
        fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5,
      }}>
        <span>0xDED5EC</span>
        <span style={{ color: COL.magenta }}>● AO VIVO</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderHalftone });
