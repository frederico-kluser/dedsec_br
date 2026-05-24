/**
 * @file pages/Help — Ajude a Célula (crowdsource LLM cycles).
 * Uses Toggle, StatBox, RankingPanel, ScreenRoot, ScrollArea utilities.
 */
function ScreenHelp({ go, tab, setTab, user }) {
  const { auto, setAuto, processState, score, startProcessing, cancel } = useHelpFlow();

  return (
    <ScreenRoot>
      <TopBar/>

      {/* PROCESSING OVERLAY */}
      {processState === 'processing' && (
        <div style={{
          position: 'absolute', inset: 0, zIndex: 100,
          background: 'rgba(2,6,8,0.98)', display: 'flex', flexDirection: 'column', overflow: 'hidden',
        }}>
          <div style={{ padding: '14px 16px', borderBottom: `1px solid ${COL.line}`, background: '#050a08' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
              <span style={{ width: 8, height: 8, background: COL.acid, animation: 'blink 0.6s steps(2) infinite' }}/>
              <PixelChip color={COL.acid} bg="#000" size={8}>MUTIRÃO · 1/1</PixelChip>
              <div style={{ flex: 1 }}/>
              <button onClick={cancel} style={{
                background: 'transparent', border: `1px solid ${COL.line}`, color: COL.inkDim,
                fontFamily: FONT.pixel, fontSize: 8, padding: '4px 8px', cursor: 'pointer', letterSpacing: 1,
              }}>CANCELAR</button>
            </div>
            <Stencil size={20} style={{ lineHeight: 1 }}>
              PROCESSANDO<br/><span style={{ color: COL.acid }}>PAUTA DA FILA</span>
            </Stencil>
          </div>
          <TokenStreamPanel/>
          <div style={{
            padding: '10px 14px', borderTop: `1px solid ${COL.line}`,
            fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, lineHeight: 1.55,
          }}>
            // gemma-3-1b roda 100% local. seu celular contribui pra rede.
          </div>
        </div>
      )}

      {/* DONE OVERLAY */}
      {processState === 'done' && (
        <div style={{
          position: 'absolute', inset: 0, zIndex: 100, background: COL.bg,
          display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: 22, overflow: 'hidden',
        }}>
          <Halftone color={COL.acid} size={6} opacity={0.1} style={{ position: 'absolute', inset: 0 }}/>
          {[0,1].map(i => (
            <div key={i} style={{
              position: 'absolute', top: '50%', left: '50%', width: 280, height: 280,
              marginLeft: -140, marginTop: -140, borderRadius: '50%',
              background: `radial-gradient(circle, ${COL.acid}66 0%, transparent 60%)`,
              animation: `pulse-out 1.6s ease-out ${i*0.5}s infinite`,
            }}/>
          ))}
          <div style={{
            width: 120, height: 120, background: COL.acid, border: '4px solid #000',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: FONT.pixel, fontSize: 60, color: '#000', boxShadow: '6px 6px 0 #000',
            position: 'relative', zIndex: 1,
          }}>✓</div>
          <Stencil size={38} style={{ marginTop: 26, lineHeight: 0.95, textAlign: 'center', position: 'relative', zIndex: 1 }}>
            +1 PAUTA<br/><span style={{ color: COL.acid }}>PROCESSADA</span>
          </Stencil>
          <div style={{
            fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, marginTop: 12, letterSpacing: 1,
            position: 'relative', zIndex: 1,
          }}>obrigado por ajudar a célula.</div>
        </div>
      )}

      <ScrollArea padding="22px 18px 90px">
        <PixelChip color={COL.magenta} bg="#000">MUTIRÃO_LLM</PixelChip>
        <Stencil size={42} style={{ marginTop: 12, lineHeight: 0.9 }}>
          AJUDE A<br/><span style={{ color: COL.magenta, textShadow: `3px 3px 0 ${COL.acid}` }}>CÉLULA</span>
        </Stencil>
        <div style={{ fontFamily: FONT.body, fontSize: 13, color: COL.inkDim, marginTop: 12, lineHeight: 1.55 }}>
          Seu celular processa <b style={{ color: COL.ink }}>1 pauta em ~60s</b>. O resultado aparece no feed de outros usuários da sua cidade.
        </div>

        {/* PRIMARY ACTION */}
        <div style={{
          marginTop: 22, padding: 18, background: COL.panel,
          border: `2px solid ${COL.acid}`, boxShadow: `4px 4px 0 ${COL.line}`,
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
            <span style={{ width: 12, height: 12, background: COL.acid, animation: 'blink 1.2s steps(2) infinite' }}/>
            <span style={{ fontFamily: FONT.pixel, fontSize: 10, color: COL.acid, letterSpacing: 1.5 }}>DISPOSITIVO PRONTO</span>
          </div>
          <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginBottom: 16, letterSpacing: 0.5 }}>
            wifi · 4.8GB livre · 34°C · 87% bateria
          </div>
          <Btn full color={COL.magenta} fg="#fff" onClick={startProcessing} disabled={processState !== 'idle'}>
            ▶ PROCESSAR 1 PAUTA
          </Btn>
        </div>

        {/* STATS LINE */}
        <div style={{
          marginTop: 14, background: COL.panel, border: `1.5px solid ${COL.line}`,
          display: 'flex', alignItems: 'stretch',
        }}>
          <div style={{ flex: 1 }}>
            <StatBox label="VOCÊ HOJE" value={score}/>
          </div>
          <div style={{ width: 1, background: COL.line }}/>
          <div style={{ flex: 1 }}>
            <StatBox label="COMUNIDADE" value={formatNum(SCOPE_TOTALS.cidade)} color={COL.acid}/>
          </div>
        </div>

        {/* AUTO MODE */}
        <div style={{
          marginTop: 14, display: 'flex', alignItems: 'center', gap: 12,
          background: COL.panel, border: `1.5px solid ${COL.line}`, padding: '12px 14px',
        }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: FONT.body, fontSize: 13, fontWeight: 600 }}>Modo automático</div>
            <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 3 }}>
              roda só plugado + wifi + tela apagada
            </div>
          </div>
          <Toggle value={auto} onChange={() => setAuto(!auto)} size="sm"/>
        </div>

        {/* RANKING — new */}
        <div style={{ marginTop: 22 }}>
          <RankingPanel user={user} score={score}/>
        </div>

        {/* ACHIEVEMENTS CTA */}
        <button onClick={() => go('achievements')} style={{
          marginTop: 22, width: '100%', display: 'flex', alignItems: 'center', gap: 12,
          background: COL.panel, border: `1.5px solid ${COL.magenta}`,
          padding: '14px 14px', cursor: 'pointer', textAlign: 'left',
          boxShadow: '4px 4px 0 #000',
        }}>
          <div style={{
            width: 48, height: 48, background: COL.magenta,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 26, border: '2px solid #000', flexShrink: 0,
          }}>🏅</div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.magenta, letterSpacing: 1.2 }}>SUA COLEÇÃO</div>
            <div style={{ fontFamily: FONT.body, fontSize: 13, fontWeight: 700, color: COL.ink, marginTop: 4 }}>
              Selos conquistados
            </div>
            <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 2 }}>
              11/24 desbloqueados · <span style={{ color: COL.magenta }}>3 novos pra abrir</span>
            </div>
          </div>
          <span style={{ color: COL.inkMute, fontSize: 18 }}>›</span>
        </button>
      </ScrollArea>

      <TabBar active={tab} onTab={setTab}/>
    </ScreenRoot>
  );
}
Object.assign(window, { ScreenHelp });
