/**
 * @file organisms/loaders/LoaderSpectrum — L9: audio-equalizer style bars.
 */
function LoaderSpectrum() {
  const t = useTick(60);
  const BARS = 26;
  return (
    <div style={{
      flex: 1, background: COL.bg, position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      padding: '20px 16px',
    }}>
      <Halftone color={COL.magenta} size={6} opacity={0.05} style={{ position: 'absolute', inset: 0 }}/>
      <Scanlines opacity={0.08}/>
      <PixelChip color={COL.magenta} bg="#000">// SINAL CAPTADO</PixelChip>
      <Stencil size={28} style={{ marginTop: 12, marginBottom: 22, textAlign: 'center', lineHeight: 1 }}>
        ESCUTANDO<br/>A <span style={{ color: COL.magenta }}>REDE</span>
      </Stencil>
      <div style={{
        display: 'flex', alignItems: 'flex-end', gap: 3, height: 130,
        padding: '10px 12px', border: `1.5px solid ${COL.line}`, background: COL.panel,
      }}>
        {Array.from({ length: BARS }, (_, i) => {
          const phase = t * 0.4 + i * 0.5;
          const h = 18 + Math.abs(Math.sin(phase)) * 65 + Math.abs(Math.sin(phase * 2.3)) * 28;
          const accent = i % 4 === 0;
          return (
            <div key={i} style={{
              width: 6, height: h,
              background: accent ? COL.magenta : COL.acid,
              boxShadow: `0 0 5px ${accent ? COL.magenta : COL.acid}`,
              transition: 'height 0.08s linear',
            }}/>
          );
        })}
      </div>
      <div style={{
        marginTop: 16, fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, letterSpacing: 1.5,
        display: 'flex', gap: 12,
      }}>
        <span>2.4 GHz</span><span>·</span>
        <span>-{42 + (t % 8)} dBm</span><span>·</span>
        <span>{312 + (t % 7)} nós</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderSpectrum });
