/**
 * @file pages/Onboarding — 3-card paged intro.
 */
function ScreenOnboarding({ go }) {
  const [step, setStep] = React.useState(0);
  const cards = [
    { color: COL.magenta, title: 'VOCÊ É O\nVIGIA', body: 'Pautas da sua cidade chegam direto. Você decide quando, como e onde se manifestar.', panel: '👁' },
    { color: COL.acid,    title: 'NADA DE\nLOGIN', body: 'Sem CPF, sem e-mail, sem celular. Sem rastrear suas redes. Sua identidade nunca sai do seu aparelho.', panel: '🛡' },
    { color: COL.alert,   title: 'CÉLULA\nDISTRIBUÍDA', body: 'O cérebro do app é o seu próprio celular. Quando você quiser, ajuda outros usuários processando pautas.', panel: '⚡' },
  ];
  const c = cards[step];
  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <div style={{ display: 'flex', gap: 6, padding: '16px 18px 0' }}>
        {cards.map((_, i) => (
          <div key={i} style={{ flex: 1, height: 4, background: i <= step ? c.color : COL.line }}/>
        ))}
      </div>
      <div style={{ flex: 1, padding: 20, display: 'flex', flexDirection: 'column', gap: 18, overflow: 'auto', minHeight: 0 }}>
        <ComicPanel color={c.color} halftone="#000" height={220}>
          <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <span style={{ fontSize: 110, filter: 'grayscale(1) contrast(1.5)', opacity: 0.85 }}>{c.panel}</span>
          </div>
          <div style={{
            position: 'absolute', top: 12, left: 12,
            fontFamily: FONT.pixel, fontSize: 9, background: '#000', color: c.color, padding: '4px 7px', letterSpacing: 1,
          }}>OP_{String(step+1).padStart(2,'0')}</div>
          <div style={{
            position: 'absolute', bottom: 12, right: 12, fontFamily: FONT.pixel, fontSize: 9, color: '#000',
            background: '#fff', padding: '4px 6px',
          }}>{step+1}/3</div>
        </ComicPanel>
        <Stencil size={48} style={{ whiteSpace: 'pre-line', textShadow: `3px 3px 0 ${c.color}` }}>{c.title}</Stencil>
        <div style={{ fontFamily: FONT.body, fontSize: 15, lineHeight: 1.5, color: COL.inkDim }}>{c.body}</div>
      </div>
      <div style={{ padding: '0 20px 24px', display: 'flex', gap: 10 }}>
        <GhostBtn color={COL.inkDim} onClick={() => go('interests')}>PULAR</GhostBtn>
        <div style={{ flex: 1 }}/>
        <Btn color={c.color} fg="#000" onClick={() => step < 2 ? setStep(step+1) : go('interests')}>
          {step < 2 ? 'PRÓXIMO →' : 'COMEÇAR →'}
        </Btn>
      </div>
    </div>
  );
}
Object.assign(window, { ScreenOnboarding });
