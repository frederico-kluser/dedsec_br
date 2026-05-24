/**
 * @file pages/Splash — boot + LLM download progress.
 * State and view are tiny and tightly coupled, kept inline.
 */
function ScreenSplash({ go }) {
  const [pct, setPct] = React.useState(34);
  React.useEffect(() => {
    const t = setInterval(() => setPct(p => p >= 100 ? 34 : p + 1), 160);
    return () => clearInterval(t);
  }, []);
  return (
    <div style={{
      position: 'relative', flex: 1, background: COL.bg, color: COL.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      <Halftone color={COL.magenta} size={6} opacity={0.18} style={{ position: 'absolute', inset: 0 }}/>
      <Scanlines opacity={0.12}/>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: 24, position: 'relative', zIndex: 1 }}>
        <div style={{ marginBottom: 22 }}><Skull size={64} color={COL.ink}/></div>
        <Glitch size={24}>DEDSEC_BR</Glitch>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 12, letterSpacing: 2 }}>
          // CÉLULA CÍVICA LOCAL · v0.1.0
        </div>
        <div style={{ width: '100%', marginTop: 40 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6 }}>
            <span style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.acid }}>BAIXANDO_CÉREBRO_LOCAL</span>
            <span style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.acid }}>{pct}%</span>
          </div>
          <PixelBar value={pct} color={COL.acid}/>
          <div style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute, marginTop: 8, letterSpacing: 1 }}>
            gemma-3-1b-it-q4.task · 530 MB · wifi recomendado
          </div>
        </div>
      </div>
      <CautionTape text="NOS AGUARDE · NOS AGUARDE · NOS AGUARDE · " color={COL.acid}/>
      <div style={{ padding: '18px 20px 22px', display: 'flex', gap: 10, position: 'relative', zIndex: 1 }}>
        <GhostBtn full color={COL.inkDim}>CANCELAR</GhostBtn>
        <Btn full color={COL.magenta} fg="#fff" onClick={() => go('onb1')}>PULAR →</Btn>
      </div>
    </div>
  );
}
Object.assign(window, { ScreenSplash });
