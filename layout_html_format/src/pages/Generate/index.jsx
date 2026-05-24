/**
 * @file pages/Generate — message composer with tone + tag picker.
 * Replaces the old "auto-generates 3 variations" flow.
 */
function ScreenGenerate({ go }) {
  const { tags, toggleTag, tone, setTone, phase, streamLen, generatedText, start, regenerate, canGenerate } = useGenerateFlow();
  const streamingText = generatedText.slice(0, streamLen);
  const selectedTone = TONES.find(t => t.id === tone) || TONES[0];

  return (
    <ScreenRoot relative={false}>
      <BackHeader label="VOLTAR" onBack={() => phase === 'compose' ? go('detail') : regenerate()}>
        <PixelChip color={COL.acid} bg="#000" size={8}>
          {phase === 'compose' ? 'COMPOR' :
           phase === 'working' ? 'LLM_LOCAL · 12 tok/s' :
           'LLM_LOCAL · OK'}
        </PixelChip>
      </BackHeader>

      {/* ═══════════ COMPOSE ═══════════ */}
      {phase === 'compose' && (
        <>
          <ScrollArea padding="16px 18px 16px">
            <PixelChip color={COL.magenta} bg="#000">// COMPOR MENSAGEM</PixelChip>
            <Stencil size={32} style={{ marginTop: 10, lineHeight: 0.95 }}>
              COBRAR<br/><span style={{ color: COL.magenta }}>O PREFEITO</span>
            </Stencil>

            {/* pauta context */}
            <div style={{
              marginTop: 14, padding: '10px 12px', background: COL.panel,
              border: `1.5px solid ${COL.line}`, display: 'flex', alignItems: 'center', gap: 8,
            }}>
              <span style={{ fontSize: 22 }}>🚇</span>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1 }}>SOBRE A PAUTA</div>
                <div style={{ fontFamily: FONT.body, fontSize: 12, color: COL.ink, marginTop: 2, lineHeight: 1.3 }}>
                  Linha 17-Ouro: 14 anos de atraso, custo triplicado
                </div>
              </div>
            </div>

            {/* TONE */}
            <div style={{ marginTop: 22 }}>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 8 }}>
                <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.inkMute, letterSpacing: 1.5 }}>
                  // TOM · escolha 1
                </span>
                <span style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.acid }}>{selectedTone.id}</span>
              </div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
                {TONES.map(t => {
                  const on = tone === t.id;
                  return (
                    <button key={t.id} onClick={() => setTone(t.id)} style={{
                      fontFamily: FONT.pixel, fontSize: 9, letterSpacing: 1,
                      padding: '10px 12px',
                      background: on ? t.color : 'transparent',
                      color: on ? '#000' : COL.ink,
                      border: `1.5px solid ${on ? t.color : COL.line}`,
                      cursor: 'pointer',
                    }}>{t.id}</button>
                  );
                })}
              </div>
              <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 6 }}>
                // {selectedTone.desc}
              </div>
            </div>

            {/* TAGS */}
            <div style={{ marginTop: 22 }}>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 8 }}>
                <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.inkMute, letterSpacing: 1.5 }}>
                  // ARGUMENTOS · escolha quantos quiser
                </span>
                <span style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.acid }}>{tags.size} marcados</span>
              </div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                {TAGS.map(t => {
                  const on = tags.has(t.id);
                  return (
                    <button key={t.id} onClick={() => toggleTag(t.id)} style={{
                      display: 'flex', alignItems: 'center', gap: 5,
                      fontFamily: FONT.pixel, fontSize: 9, letterSpacing: 0.8,
                      padding: '8px 10px',
                      background: on ? COL.acid : 'transparent',
                      color: on ? '#000' : COL.ink,
                      border: `1.5px solid ${on ? COL.acid : COL.line}`,
                      cursor: 'pointer',
                    }}>
                      <span style={{ fontSize: 12 }}>{t.glyph}</span>
                      <span>{t.id}</span>
                    </button>
                  );
                })}
              </div>
              {tags.size === 0 && (
                <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.danger, marginTop: 8 }}>
                  // selecione pelo menos 1 argumento.
                </div>
              )}
            </div>

            {/* hint */}
            <div style={{
              marginTop: 22, padding: 12, background: COL.panel, border: `1.5px dashed ${COL.line}`,
              fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, lineHeight: 1.55,
            }}>
              <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 9 }}>// COMO FUNCIONA</span><br/>
              A IA local junta o tom + os argumentos selecionados e escreve UMA mensagem só pra você revisar.
            </div>
          </ScrollArea>
          <StickyFooter>
            <span style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1 }}>
              {canGenerate ? 'PRONTO PRA GERAR' : '↑ ESCOLHA OS ARGUMENTOS'}
            </span>
            <div style={{ flex: 1 }}/>
            <Btn color={canGenerate ? selectedTone.color : COL.line}
                 fg={canGenerate ? '#000' : COL.inkMute}
                 onClick={start} disabled={!canGenerate}>
              GERAR →
            </Btn>
          </StickyFooter>
        </>
      )}

      {/* ═══════════ WORKING ═══════════ */}
      {phase === 'working' && (
        <ScrollArea padding="22px">
          <div style={{
            height: 160, background: COL.panel, border: `1.5px solid ${COL.line}`,
            position: 'relative', overflow: 'hidden',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <div className="dedsec-radar" style={{
              width: 90, height: 90, borderRadius: '50%', border: `2px solid ${COL.acid}`,
              boxShadow: `0 0 30px ${COL.acid}`,
            }}/>
            <div style={{ position: 'absolute', top: 10, left: 10, fontFamily: FONT.pixel, fontSize: 9, color: COL.acid }}>
              // GERANDO_MENSAGEM.exe
            </div>
            <div style={{ position: 'absolute', bottom: 10, right: 10, fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim }}>
              gemma-3-1b-it · q4
            </div>
            <Scanlines opacity={0.15}/>
          </div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 14 }}>
            <PixelChip color={selectedTone.color} bg="#000" size={8}>TOM · {tone}</PixelChip>
            {[...tags].map(t => (
              <span key={t} style={{
                fontFamily: FONT.pixel, fontSize: 8, padding: '4px 6px',
                background: COL.acid, color: '#000', letterSpacing: 0.5,
              }}>{t}</span>
            ))}
          </div>
          <div style={{
            fontFamily: FONT.mono, fontSize: 12, color: COL.ink, lineHeight: 1.55,
            marginTop: 16, minHeight: 120,
          }}>
            {streamingText}<span style={{ color: COL.acid }}>▮</span>
          </div>
        </ScrollArea>
      )}

      {/* ═══════════ DONE ═══════════ */}
      {phase === 'done' && (
        <>
          <ScrollArea padding="16px 18px">
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginBottom: 12 }}>
              <PixelChip color={selectedTone.color} bg="#000" size={8}>TOM · {tone}</PixelChip>
              {[...tags].map(t => (
                <span key={t} style={{
                  fontFamily: FONT.pixel, fontSize: 8, padding: '4px 6px',
                  background: COL.acid, color: '#000', letterSpacing: 0.5,
                }}>{t}</span>
              ))}
            </div>
            <Stencil size={22} style={{ lineHeight: 1 }}>
              MENSAGEM<br/><span style={{ color: selectedTone.color }}>PRONTA</span>
            </Stencil>
            <div style={{
              marginTop: 14, padding: 16, background: COL.panel,
              border: `2px solid ${selectedTone.color}`, boxShadow: `4px 4px 0 #000`,
              fontFamily: FONT.body, fontSize: 13.5, color: COL.ink, lineHeight: 1.55,
            }}>{generatedText}</div>

            <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
              <GhostBtn full color={COL.inkDim} onClick={regenerate}>↻ REFAZER</GhostBtn>
              <GhostBtn full color={COL.inkDim}>✎ EDITAR</GhostBtn>
            </div>

            <div style={{
              marginTop: 14, padding: 10, background: COL.panel, border: `1px dashed ${COL.line}`,
              fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, lineHeight: 1.5,
            }}>
              // sua revisão importa. você sempre pode reescrever antes de postar.
            </div>
          </ScrollArea>
          <StickyFooter>
            <Btn full color={selectedTone.color} onClick={() => go('channels')}>USAR ESTA → CANAIS</Btn>
          </StickyFooter>
        </>
      )}
    </ScreenRoot>
  );
}
Object.assign(window, { ScreenGenerate });
