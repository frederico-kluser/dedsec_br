/**
 * @file organisms/loaders/LoaderTerminal — L1: CRT boot log scroll.
 */
function LoaderTerminal() {
  const lines = [
    { d: 100,  t: '> dedsec_br célula · v0.1.0-beta' },
    { d: 200,  t: '> kernel: montando /local/cérebro/' },
    { d: 300,  t: '  ↳ gemma-3-1b-it.q4.task  [530MB]' },
    { d: 600,  t: '  ↳ verificando integridade ..... OK' },
    { d: 900,  t: '> aquecendo tokenizador ........ OK' },
    { d: 1200, t: '> descobrindo peers ............ 312 nós' },
    { d: 1500, t: '> handshake da malha (libp2p) .. OK' },
    { d: 1800, t: '> baixando pautas/sp/2026-05-23.' },
    { d: 2100, t: '  ↳ 4 itens · 12 fontes' },
    { d: 2400, t: '> uuid_hash = 9f4a-...-7c12' },
    { d: 2700, t: '> identidade selada (sem login)' },
    { d: 3000, t: '> NOS AGUARDE' },
    { d: 3300, t: '> pronto.' },
  ];
  const [visible, setVisible] = React.useState(0);
  React.useEffect(() => {
    const ids = lines.map((l, i) => setTimeout(() => setVisible(v => Math.max(v, i + 1)), l.d));
    const loop = setTimeout(() => setVisible(0), 5000);
    return () => { ids.forEach(clearTimeout); clearTimeout(loop); };
  }, [visible === 0]);
  return (
    <div style={{
      flex: 1, background: '#020602', position: 'relative', overflow: 'hidden',
      padding: '22px 18px', display: 'flex', flexDirection: 'column',
      color: COL.acid, fontFamily: FONT.mono,
    }}>
      <Scanlines opacity={0.22}/>
      <div style={{
        position: 'absolute', inset: 0, pointerEvents: 'none',
        background: 'radial-gradient(circle at 50% 30%, rgba(183,255,42,0.06), transparent 70%)',
      }}/>
      <div style={{
        fontFamily: FONT.pixel, fontSize: 9, color: COL.acid, letterSpacing: 2,
        borderBottom: `1px dashed ${COL.acid}55`, paddingBottom: 8, marginBottom: 12,
      }}>DEDSEC_BR :: INICIANDO  ░░░░░  TTY1</div>
      <div style={{ flex: 1, fontSize: 12, lineHeight: 1.7, position: 'relative', zIndex: 1 }}>
        {lines.slice(0, visible).map((l, i) => (
          <div key={i} style={{
            opacity: 0.5 + Math.min(1, (visible - i) * 0.5) * 0.5,
            color: l.t.includes('AGUARDE') ? COL.magenta :
                   l.t.includes('OK') ? COL.acid :
                   l.t.startsWith('  ↳') ? '#7fb800' : COL.acid,
            textShadow: '0 0 6px rgba(183,255,42,0.4)',
          }}>{l.t}</div>
        ))}
        <span style={{ display: 'inline-block', width: 8, height: 14, background: COL.acid, animation: 'blink 1s steps(2) infinite' }}/>
      </div>
      <div style={{
        marginTop: 10, fontFamily: FONT.pixel, fontSize: 8, color: COL.acid, letterSpacing: 1.5,
        display: 'flex', alignItems: 'center', gap: 8,
      }}>
        <span style={{ width: 6, height: 6, background: COL.acid, animation: 'blink 0.8s steps(2) infinite' }}/>
        REDE_AO_VIVO · 312 PEERS · TX/RX 4.2KB/s
      </div>
    </div>
  );
}
Object.assign(window, { LoaderTerminal });
