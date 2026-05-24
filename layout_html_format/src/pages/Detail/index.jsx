/**
 * @file pages/Detail — single news item detail.
 */
function ScreenDetail({ go }) {
  const n = NEWS[0];
  const targets = [
    { role: 'PREFEITO',                       name: 'Ricardo Nunes (MDB)',     handles: ['@ricardo_nunes', 'X: @ricardonunes'] },
    { role: 'SEC. TRANSPORTES',               name: 'Marcelo Branco',          handles: ['@marcelo.branco'] },
    { role: 'VEREADOR · Eleito p/ Mobilidade', name: 'Eduardo Tuma (PSDB)',     handles: ['@eduardo_tuma'] },
  ];
  return (
    <ScreenRoot relative={false}>
      <BackHeader label="VOLTAR" onBack={() => go('home')}>
        <PixelChip color={COL.danger} bg="#000" size={8}>🔥 URGENTE</PixelChip>
      </BackHeader>
      <ScrollArea>
        <ComicPanel color={n.color} halftone="#000" height={140} label={`PAUTA · ${n.tag}`}>
          <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <span style={{ fontSize: 90 }}>{n.panel}</span>
          </div>
        </ComicPanel>
        <div style={{ padding: '16px 18px' }}>
          <Stencil size={28} style={{ lineHeight: 1.05 }}>{n.title}</Stencil>
          <div style={{ fontFamily: FONT.body, fontSize: 13, color: COL.inkDim, lineHeight: 1.55, marginTop: 12 }}>
            {n.desc} A licitação inicial previa entrega para a Copa do Mundo de 2014. Sucessivos aditivos contratuais elevaram o custo total para R$ 4,8 bilhões. Tribunal de Contas do Estado abriu processo de fiscalização em 2024.
          </div>
          <div style={{ marginTop: 18, fontFamily: FONT.pixel, fontSize: 9, color: COL.acid, letterSpacing: 1.2 }}>
            // FONTES ORIGINAIS
          </div>
          {n.sources.map(s => (
            <div key={s} style={{
              display: 'flex', alignItems: 'center', gap: 8,
              padding: '10px 0', borderBottom: `1px solid ${COL.line}`,
              fontFamily: FONT.mono, fontSize: 12, color: COL.ink,
            }}>
              <span style={{ color: COL.acid }}>↗</span> {s}
              <span style={{ flex: 1 }}/>
              <span style={{ color: COL.inkMute, fontSize: 10 }}>abrir</span>
            </div>
          ))}
          <div style={{ marginTop: 18, fontFamily: FONT.pixel, fontSize: 9, color: COL.magenta, letterSpacing: 1.2 }}>
            // QUEM DEVERIA SABER DISSO?
          </div>
          {targets.map(t => (
            <div key={t.name} style={{ padding: '12px 0', borderBottom: `1px solid ${COL.line}` }}>
              <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1 }}>{t.role}</div>
              <div style={{ fontFamily: FONT.body, fontSize: 14, color: COL.ink, marginTop: 2, fontWeight: 600 }}>{t.name}</div>
              <div style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.acid, marginTop: 4 }}>{t.handles.join(' · ')}</div>
            </div>
          ))}
        </div>
        <div style={{ padding: '0 18px 100px' }}>
          <div style={{ marginTop: 14, fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute, textDecoration: 'underline' }}>
            reportar pauta enviesada
          </div>
        </div>
      </ScrollArea>
      <StickyFooter>
        <Btn full color={COL.acid} onClick={() => go('generate')}>GERAR MENSAGEM →</Btn>
      </StickyFooter>
    </ScreenRoot>
  );
}
Object.assign(window, { ScreenDetail });
