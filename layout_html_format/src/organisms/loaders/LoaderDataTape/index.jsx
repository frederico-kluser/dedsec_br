/**
 * @file organisms/loaders/LoaderDataTape — L4: vertical streaming tape.
 */
function LoaderDataTape() {
  const t = useTick(80);
  const stream = React.useMemo(() => [
    '01001000 01100001 01100011 01101011',
    'pauta_atualizada :: linha-17-ouro',
    'rede_cidadã ▓▓▓▓ 67%',
    '████████ █████████ ███ ██████',
    'classify(pt-BR) → transporte · urgente',
    'sha256: 9f4a3c12bb98ef...7c12',
    'embedding · 384d · cos=0.81',
    '[CENSURADO] [CENSURADO] [CENSURADO]',
    '0xCAFEBABE :: peer/sp-cidadão-bb22',
    'gemma · token 142/512',
    'queridodiario.api ............ 200',
    'tse.dadosabertos.api ......... 200',
    'fcm.push.batch ............... fila',
    'consenso(2/3) :: confirmado',
    '01000101 01011000 01010000 01000101',
    '> estamos chegando · 4328 hoje',
  ], []);
  const idx = t % stream.length;
  return (
    <div style={{ flex: 1, background: '#000', position: 'relative', overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
      <Scanlines opacity={0.15}/>
      <div style={{
        position: 'absolute', inset: 0, pointerEvents: 'none',
        background: `linear-gradient(180deg, #000 0%, transparent 25%, transparent 75%, #000 100%)`,
        zIndex: 2,
      }}/>
      <div style={{ padding: '20px 18px 10px', display: 'flex', alignItems: 'center', gap: 10, zIndex: 3, position: 'relative' }}>
        <div style={{ width: 10, height: 10, background: COL.magenta, animation: 'blink 0.8s steps(2) infinite' }}/>
        <div style={{ fontFamily: FONT.pixel, fontSize: 10, color: COL.magenta, letterSpacing: 2, flex: 1 }}>TRANSMITINDO</div>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim }}>{(t * 0.42).toFixed(1)} KB/s</div>
      </div>
      <div style={{
        flex: 1, position: 'relative', overflow: 'hidden', margin: '0 14px',
        border: `1px solid ${COL.line}`, background: '#040404',
      }}>
        <div style={{ position: 'absolute', top: -idx * 22, left: 0, right: 0, transition: 'top 0.2s linear' }}>
          {[...stream, ...stream, ...stream].map((line, i) => (
            <div key={i} style={{
              height: 22, padding: '0 12px', display: 'flex', alignItems: 'center',
              fontFamily: FONT.mono, fontSize: 11,
              color: line.includes('[CENSURADO]') ? COL.inkMute :
                     line.includes('████') ? '#444' :
                     line.includes('chegando') ? COL.magenta :
                     line.match(/^[01 ]+$/) ? COL.acid + 'aa' :
                     line.includes('200') ? COL.acid :
                     COL.ink,
              borderBottom: `1px dashed #111`,
              opacity: i === idx || i === idx + stream.length ? 1 : 0.5,
            }}>{line}</div>
          ))}
        </div>
      </div>
      <div style={{ padding: '14px 18px 22px', display: 'flex', alignItems: 'center', gap: 10, zIndex: 3 }}>
        <Glitch size={16}>SINCRONIZANDO</Glitch>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid }}>{Math.min(99, 12 + t).toString().padStart(2, '0')}%</span>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderDataTape });
