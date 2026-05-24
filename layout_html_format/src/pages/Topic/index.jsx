/**
 * @file pages/Topic — the single-thread "post" view (formerly "Tópico").
 */
function ScreenTopic({ go, user, replies, addReply, deleteReply, currentTopic }) {
  const { input, setInput, mod, confirmId, setConfirmId, scrollRef, send, dismissMod, discardInput }
    = useTopicComposer({ replies, addReply, deleteReply });

  const t = currentTopic || {
    id: 't1', tag: 'TRANSPORTE', scope: 'mun', hot: true, live: true,
    title: 'Linha 17-Ouro: como cobrar o TCE-SP?',
    author: 'Cidadão_SP_4a7b', age: '12 min',
    body: 'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?',
  };
  const isUserPost = t.author === user.pseudonym;

  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0, position: 'relative' }}>
      <ModerationOverlay phase={mod.phase} text={mod.text} word={mod.word} onEdit={dismissMod} onDiscard={discardInput}/>

      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px', borderBottom: `1px solid ${COL.line}` }}>
        <button onClick={() => go('forum-list')} style={{
          background: 'transparent', border: 'none', color: COL.ink, fontFamily: FONT.pixel, fontSize: 11, cursor: 'pointer',
        }}>← PAUTAS</button>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid }}>● AO VIVO · 312</span>
      </div>

      <div ref={scrollRef} style={{ flex: 1, overflow: 'auto', minHeight: 0 }}>
        <div style={{ padding: '16px 16px', background: COL.panelHi, borderBottom: `2px solid ${COL.magenta}` }}>
          <div style={{ display: 'flex', gap: 12 }}>
            <Avatar seed={t.author} size={44}/>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', gap: 6, marginBottom: 8, flexWrap: 'wrap' }}>
                <PixelChip color={COL.acid} bg="#000" size={7}>{t.tag}</PixelChip>
                {t.hot  && <PixelChip color={COL.danger} bg="#000" size={7}>🔥 QUENTE</PixelChip>}
                {t.live && <span style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.acid }}>● AO VIVO</span>}
              </div>
              <Stencil size={22} style={{ lineHeight: 1.1 }}>{t.title}</Stencil>
              <div style={{ fontFamily: FONT.body, fontSize: 13, color: COL.inkDim, marginTop: 10, lineHeight: 1.55 }}>
                {t.body}
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 12, fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim }}>
                <span style={{ color: isUserPost ? COL.magenta : COL.acid }}>{t.author}</span>
                {isUserPost && <PixelChip color={COL.magenta} bg="#000" size={6}>VOCÊ</PixelChip>}
                <span>·</span><span>{t.age}</span>
              </div>
              <div style={{ display: 'flex', gap: 6, marginTop: 10, flexWrap: 'wrap' }}>
                {['⚡ 87', '🔥 42', '🤔 11', '👍 56'].map(r => (
                  <span key={r} style={{
                    fontFamily: FONT.pixel, fontSize: 9, padding: '6px 8px',
                    background: COL.panel, border: `1px solid ${COL.line}`, color: COL.ink,
                  }}>{r}</span>
                ))}
              </div>
            </div>
          </div>
        </div>

        <div style={{ padding: 14 }}>
          {replies.map((r) => {
            const isMine = r.mine || r.who === user.pseudonym;
            const confirming = isMine && confirmId === r.id;
            return (
              <div key={r.id} style={{
                padding: '12px 12px', background: isMine ? '#161616' : COL.panel,
                border: `1px solid ${isMine ? COL.acid + '55' : COL.line}`,
                marginBottom: 8, marginLeft: 12,
                borderLeft: `3px solid ${isMine ? COL.magenta : COL.acid}`,
                display: 'flex', gap: 10,
              }}>
                <Avatar seed={r.seed || r.who} size={32}/>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{
                    display: 'flex', alignItems: 'center', gap: 6, marginBottom: 6,
                    fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim,
                  }}>
                    <span style={{
                      color: isMine ? COL.magenta : COL.acid,
                      overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', minWidth: 0,
                    }}>{r.who}</span>
                    {isMine && <PixelChip color={COL.magenta} bg="#000" size={6}>VOCÊ</PixelChip>}
                    <span>·</span>
                    <span>{r.age}</span>
                    <div style={{ flex: 1 }}/>
                    {isMine && !confirming && (
                      <button onClick={() => setConfirmId(r.id)} title="apagar" style={{
                        background: 'transparent', color: COL.inkMute, border: `1px solid ${COL.line}`,
                        fontFamily: FONT.pixel, fontSize: 9, padding: '3px 6px', cursor: 'pointer',
                        flexShrink: 0,
                      }}>×</button>
                    )}
                  </div>
                  <div style={{ fontFamily: FONT.body, fontSize: 12.5, color: COL.ink, lineHeight: 1.5 }}>{r.body}</div>
                  {Object.keys(r.reacts || {}).length > 0 && !confirming && (
                    <div style={{ display: 'flex', gap: 6, marginTop: 8, flexWrap: 'wrap' }}>
                      {Object.entries(r.reacts).map(([k, v]) => (
                        <span key={k} style={{ fontFamily: FONT.pixel, fontSize: 8, padding: '4px 6px', background: COL.panelHi, color: COL.ink, border: `1px solid ${COL.line}` }}>{k} {v}</span>
                      ))}
                    </div>
                  )}
                  {confirming && (
                    <div style={{
                      display: 'flex', alignItems: 'center', gap: 6, marginTop: 10,
                      padding: '8px 10px', background: '#000',
                      border: `1.5px dashed ${COL.danger}`, flexWrap: 'wrap',
                    }}>
                      <span style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.danger, letterSpacing: 1, flex: 1, minWidth: 0 }}>
                        APAGAR ESTA RESPOSTA?
                      </span>
                      <button onClick={() => setConfirmId(null)} style={{
                        background: 'transparent', color: COL.inkDim, border: `1px solid ${COL.line}`,
                        fontFamily: FONT.pixel, fontSize: 9, padding: '5px 10px', cursor: 'pointer', flexShrink: 0,
                      }}>NÃO</button>
                      <button onClick={() => { deleteReply(r.id); setConfirmId(null); }} style={{
                        background: COL.danger, color: '#000', border: 'none',
                        fontFamily: FONT.pixel, fontSize: 9, padding: '5px 10px', cursor: 'pointer', letterSpacing: 1, flexShrink: 0,
                      }}>SIM, APAGAR</button>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
          {replies.length === 0 && (
            <div style={{
              padding: 24, textAlign: 'center', fontFamily: FONT.mono, fontSize: 11, color: COL.inkMute,
              border: `1.5px dashed ${COL.line}`,
            }}>// ninguém respondeu ainda. seja o primeiro.</div>
          )}
        </div>
      </div>

      <div style={{
        padding: '12px 14px', background: COL.bg2,
        borderTop: `1.5px solid ${COL.line}`, display: 'flex', gap: 8, alignItems: 'center',
      }}>
        <Avatar seed={user.seed} size={32}/>
        <input
          value={input}
          onChange={e => setInput(e.target.value)}
          onKeyDown={e => { if (e.key === 'Enter') send(); }}
          placeholder={`responder como ${user.pseudonym}`}
          style={{
            flex: 1, background: COL.panel, border: `1px solid ${COL.line}`,
            padding: '10px 12px', color: COL.ink, fontFamily: FONT.body, fontSize: 13, outline: 'none',
            minWidth: 0,
          }}
        />
        <button onClick={send} disabled={!input.trim() || mod.phase !== 'idle'} style={{
          fontFamily: FONT.pixel, fontSize: 10, padding: '10px 12px',
          background: input.trim() && mod.phase === 'idle' ? COL.acid : COL.panelHi,
          color: input.trim() && mod.phase === 'idle' ? '#000' : COL.inkMute,
          border: 'none', cursor: input.trim() && mod.phase === 'idle' ? 'pointer' : 'not-allowed', letterSpacing: 1,
        }}>↳</button>
      </div>
    </div>
  );
}
Object.assign(window, { ScreenTopic });
