/**
 * @file organisms/loaders/LoaderGlitch — L6: heavy RGB-split + comic burst.
 */
function LoaderGlitch() {
  const t = useTick(50);
  const phases = ['ACESSANDO', 'DECIFRANDO', 'COMPILANDO', 'LIBERADO'];
  const phase = phases[Math.floor(t / 30) % phases.length];
  const lock = Math.min(phase.length, Math.floor((t % 30) / 3));
  const offsetX = (t % 4) - 2;
  const offsetY = ((t * 3) % 4) - 2;
  return (
    <div style={{
      flex: 1, background: '#000', position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
    }}>
      <div style={{
        position: 'absolute', inset: 0, display: 'grid',
        gridTemplateColumns: '1fr 1fr', gridTemplateRows: '1fr 1fr', gap: 2,
      }}>
        <div style={{ background: COL.magenta, position: 'relative', overflow: 'hidden' }}>
          <Halftone color="#000" size={5} opacity={0.6} style={{ position: 'absolute', inset: 0 }}/>
        </div>
        <div style={{ background: '#000', position: 'relative', overflow: 'hidden' }}>
          <Halftone color={COL.acid} size={4} opacity={0.3} style={{ position: 'absolute', inset: 0 }}/>
        </div>
        <div style={{ background: '#000', position: 'relative', overflow: 'hidden' }}>
          <Halftone color={COL.magenta} size={4} opacity={0.3} style={{ position: 'absolute', inset: 0 }}/>
        </div>
        <div style={{ background: COL.acid, position: 'relative', overflow: 'hidden' }}>
          <Halftone color="#000" size={5} opacity={0.6} style={{ position: 'absolute', inset: 0 }}/>
        </div>
      </div>
      <div style={{ position: 'relative', zIndex: 2 }}>
        <div style={{
          position: 'relative',
          fontFamily: FONT.pixel, fontSize: 26, color: '#fff', letterSpacing: 2,
          padding: '12px 14px', background: '#000', border: `3px solid #fff`,
          boxShadow: `${offsetX * 3}px ${offsetY * 3}px 0 ${COL.magenta}, ${-offsetX * 3}px ${-offsetY * 3}px 0 ${COL.acid}`,
          transform: `translate(${offsetX}px, ${offsetY}px)`,
        }}>DEDSEC_BR</div>
      </div>
      <div style={{
        position: 'absolute', top: '12%', right: '6%', zIndex: 3,
        width: 84, height: 84,
        background: '#fff',
        clipPath: 'polygon(50% 0%, 60% 35%, 100% 35%, 65% 55%, 80% 100%, 50% 70%, 20% 100%, 35% 55%, 0% 35%, 40% 35%)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontFamily: FONT.pixel, fontSize: 8, color: '#000', textAlign: 'center', lineHeight: 1.3,
        transform: `rotate(${-12 + (t % 6)}deg)`,
        boxShadow: `4px 4px 0 #000`,
      }}>NOS<br/>AGUARDE!</div>
      <div style={{
        marginTop: 22, padding: '12px 18px', background: '#000', border: `2.5px solid #fff`,
        boxShadow: `4px 4px 0 #000`, position: 'relative', zIndex: 2,
        minWidth: 240, textAlign: 'center',
      }}>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, letterSpacing: 2, marginBottom: 6 }}>// STATUS</div>
        <div style={{ fontFamily: FONT.pixel, fontSize: 16, color: COL.acid, letterSpacing: 2 }}>
          {scramble(phase, t, lock)}<span style={{ color: '#fff' }}>...</span>
        </div>
      </div>
      <div style={{ display: 'flex', gap: 4, marginTop: 16, position: 'relative', zIndex: 2 }}>
        {[...Array(8)].map((_, i) => (
          <div key={i} style={{ width: 22, height: 6, background: i <= (t % 8) ? '#fff' : '#333' }}/>
        ))}
      </div>
      <Grain opacity={0.15}/>
    </div>
  );
}
Object.assign(window, { LoaderGlitch });
