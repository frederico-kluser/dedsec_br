/**
 * @file organisms/loaders/LoaderGlyphDecode — L11: scramble cycler with framing.
 */
function LoaderGlyphDecode() {
  const t = useTick(45);
  const lines = [
    'ARQUIVO_VAZADO.txt',
    'PROTOCOLO_OUVI_2026',
    'DIARIO_OFICIAL_MUN',
    'DEDSEC_BR DECRIPTANDO',
  ];
  const cycleLen = lines.length * 36;
  const cycle = t % cycleLen;
  const lineIdx = Math.floor(cycle / 36);
  const subStep = cycle % 36;
  const target = lines[lineIdx];
  const lock = Math.min(target.length, Math.floor(subStep / 1.5));
  return (
    <div style={{
      flex: 1, background: '#000', position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: 22,
    }}>
      <Scanlines opacity={0.16}/>
      <div style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid, letterSpacing: 2, marginBottom: 24 }}>
        // ARQUIVO INTERCEPTADO
      </div>
      <div style={{
        padding: '18px 22px', background: '#0a0a0a', border: `2px solid ${COL.acid}`,
        boxShadow: `4px 4px 0 ${COL.magenta}, 0 0 20px ${COL.acid}44`,
        fontFamily: FONT.mono, fontSize: 16, color: COL.acid, letterSpacing: 1.5,
        textShadow: `0 0 6px ${COL.acid}`, textAlign: 'center', maxWidth: '90%',
      }}>{scramble(target, t * 7, lock)}</div>
      <div style={{ display: 'flex', gap: 6, marginTop: 26 }}>
        {lines.map((_, i) => (
          <div key={i} style={{
            width: 30, height: 4,
            background: i < lineIdx ? COL.acid : i === lineIdx ? COL.magenta : COL.line,
            boxShadow: i === lineIdx ? `0 0 6px ${COL.magenta}` : 'none',
          }}/>
        ))}
      </div>
      <div style={{ marginTop: 14, fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute }}>
        decifrando · <span style={{ color: COL.acid }}>{Math.floor(lock / target.length * 100)}%</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderGlyphDecode });
