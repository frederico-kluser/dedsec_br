/**
 * @file organisms/loaders/LoaderRadar — L3: P2P peer discovery sweep.
 */
function LoaderRadar() {
  const t = useTick(120);
  const blips = React.useMemo(() => Array.from({ length: 14 }, (_, i) => ({
    angle: (i * 67) % 360,
    radius: 30 + (i * 23) % 100,
    delay: i * 200,
  })), []);
  return (
    <div style={{
      flex: 1, background: '#040805', position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
    }}>
      <Scanlines opacity={0.12}/>
      <div style={{
        position: 'absolute', top: 22, left: 20, right: 20,
        display: 'flex', justifyContent: 'space-between',
        fontFamily: FONT.pixel, fontSize: 9, color: COL.acid, letterSpacing: 2,
      }}>
        <span>// RASTREIO_REDE</span>
        <span style={{ color: COL.acid }}>● 312</span>
      </div>
      <div style={{
        position: 'relative', width: 280, height: 280,
        borderRadius: '50%', border: `1.5px solid ${COL.acid}66`,
        boxShadow: `inset 0 0 60px ${COL.acid}22, 0 0 30px ${COL.acid}33`,
      }}>
        {[1, 2, 3].map(r => (
          <div key={r} style={{
            position: 'absolute', top: '50%', left: '50%',
            width: r * 70, height: r * 70, marginLeft: -r*35, marginTop: -r*35,
            borderRadius: '50%', border: `1px dashed ${COL.acid}33`,
          }}/>
        ))}
        <div style={{ position: 'absolute', top: 0, bottom: 0, left: '50%', width: 1, background: `${COL.acid}33` }}/>
        <div style={{ position: 'absolute', left: 0, right: 0, top: '50%', height: 1, background: `${COL.acid}33` }}/>
        <div style={{
          position: 'absolute', top: 0, left: 0, width: '100%', height: '100%',
          animation: 'sweep 2.4s linear infinite', borderRadius: '50%',
        }}>
          <div style={{
            position: 'absolute', top: '50%', left: '50%', width: '50%', height: 2,
            background: `linear-gradient(90deg, ${COL.acid}, ${COL.acid}66 30%, transparent)`,
            transformOrigin: '0 50%',
            boxShadow: `0 0 8px ${COL.acid}`,
          }}/>
        </div>
        {blips.map((b, i) => {
          const ageMs = t * 120 - b.delay;
          const visible = ageMs > 0 && (ageMs % 2400) < 1200;
          const opacity = visible ? Math.max(0, 1 - (ageMs % 2400) / 1200) : 0;
          const x = Math.cos(b.angle * Math.PI / 180) * b.radius;
          const y = Math.sin(b.angle * Math.PI / 180) * b.radius;
          return (
            <div key={i} style={{
              position: 'absolute', top: '50%', left: '50%',
              transform: `translate(${x - 4}px, ${y - 4}px)`,
              width: 8, height: 8, background: COL.acid, opacity,
              boxShadow: `0 0 8px ${COL.acid}`, transition: 'opacity 0.4s',
            }}/>
          );
        })}
        <div style={{
          position: 'absolute', top: '50%', left: '50%',
          width: 10, height: 10, marginLeft: -5, marginTop: -5,
          background: COL.magenta, boxShadow: `0 0 16px ${COL.magenta}`,
        }}/>
      </div>
      <div style={{ marginTop: 30, textAlign: 'center' }}>
        <div style={{ fontFamily: FONT.stencil, fontSize: 30, color: COL.ink, letterSpacing: 2 }}>
          BUSCANDO <span style={{ color: COL.acid }}>CÉLULAS</span>
        </div>
        <div style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, marginTop: 6, letterSpacing: 2 }}>
          { (312 + (t % 20)) } peers ativos · são paulo
        </div>
      </div>
      <div style={{
        position: 'absolute', bottom: 22, left: 22, right: 22,
        fontFamily: FONT.pixel, fontSize: 8, color: COL.acid, letterSpacing: 1.5,
        display: 'flex', justifyContent: 'space-between',
      }}>
        <span>P2P · libp2p</span>
        <span>RSSI -42 dB</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderRadar });
