/**
 * @file organisms/loaders/LoaderCounter — L5: big counter with skull bursts.
 */
function LoaderCounter() {
  const t = useTick(140);
  const base = 4328 + t;
  const burstShown = (t % 4) === 0;
  return (
    <div style={{
      flex: 1, background: COL.bg, position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: 22,
    }}>
      <Halftone color={COL.acid} size={6} opacity={0.08} style={{ position: 'absolute', inset: 0 }}/>
      <Scanlines opacity={0.1}/>
      <div style={{ position: 'absolute', top: 22, left: 20, right: 20, display: 'flex', justifyContent: 'space-between' }}>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid }}>// MUTIRÃO</span>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.inkDim }}>SÃO PAULO</span>
      </div>
      <div style={{ fontFamily: FONT.pixel, fontSize: 10, color: COL.inkDim, letterSpacing: 2 }}>
        PAUTAS PROCESSADAS HOJE
      </div>
      <div style={{
        position: 'relative', margin: '20px 0',
        fontFamily: FONT.stencil, fontSize: 96, lineHeight: 0.9, color: COL.ink,
        letterSpacing: 4, textShadow: `4px 4px 0 ${COL.magenta}, -4px -4px 0 ${COL.acid}`,
      }}>
        {base.toLocaleString('pt-BR')}
        {burstShown && (
          <>
            <div style={{ position: 'absolute', top: -10, right: -36, animation: 'burst 0.6s ease-out forwards' }}>
              <Skull size={28} color={COL.acid}/>
            </div>
            <div style={{ position: 'absolute', bottom: -10, left: -36, animation: 'burst 0.6s ease-out forwards' }}>
              <Skull size={24} color={COL.magenta}/>
            </div>
          </>
        )}
      </div>
      <div style={{ display: 'flex', gap: 6, marginTop: 6 }}>
        {[...Array(20)].map((_, i) => (
          <div key={i} style={{
            width: 6, height: 18,
            background: i <= (t % 20) ? COL.acid : COL.line,
            boxShadow: i === (t % 20) ? `0 0 10px ${COL.acid}` : 'none',
          }}/>
        ))}
      </div>
      <div style={{
        marginTop: 28, padding: '10px 14px', background: '#000',
        border: `1.5px solid ${COL.acid}`, fontFamily: FONT.mono, fontSize: 11, color: COL.acid,
      }}>
        +1 célula entrou agora · cidadão_<span style={{ color: COL.magenta }}>sp_{(t * 7).toString(16).slice(-4)}</span>
      </div>
      <div style={{
        position: 'absolute', bottom: 22, left: 22, right: 22, textAlign: 'center',
        fontFamily: FONT.pixel, fontSize: 9, color: COL.inkMute, letterSpacing: 1.5,
      }}>SINCRONIZANDO FEED LOCAL ...</div>
    </div>
  );
}
Object.assign(window, { LoaderCounter });
