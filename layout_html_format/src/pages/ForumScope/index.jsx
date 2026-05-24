/**
 * @file pages/ForumScope — pick municipal / estadual / federal.
 */

/** Scope card metadata. */
const FORUM_SCOPES = [
  { id: 'mun', label: 'MUNICIPAL', color: COL.magenta, sub: 'São Paulo / SP',      glyph: '◉' },
  { id: 'est', label: 'ESTADUAL',  color: COL.acid,    sub: 'Estado de São Paulo', glyph: '◐' },
  { id: 'fed', label: 'FEDERAL',   color: COL.alert,   sub: 'Brasil inteiro',      glyph: '◯' },
];

function ScreenForumScope({ go, tab, setTab, user, topics, setForumScope }) {
  /** @param {string} sid */
  const statsFor = (sid) => {
    const list = topics.filter(t => t.scope === sid);
    return {
      total: list.length,
      newReplies: list.reduce((s, t) => s + (t.newReplies || 0), 0),
      hot: list.some(t => t.hot),
    };
  };
  const pick = (sid) => { setForumScope(sid); go('forum-list'); };

  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <TopBar/>
      <div style={{ padding: '22px 18px 14px' }}>
        <PixelChip color={COL.acid} bg="#000">FÓRUM CÍVICO</PixelChip>
        <Stencil size={42} style={{ marginTop: 12, lineHeight: 0.92 }}>
          ESCOLHA O<br/><span style={{ color: COL.magenta, textShadow: `3px 3px 0 ${COL.acid}` }}>NÍVEL</span>
        </Stencil>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 8, lineHeight: 1.5 }}>
          // pautas separadas por escopo geográfico.<br/>
          // novos posts no seu escopo aparecem com badge.
        </div>
      </div>
      <div style={{ flex: 1, padding: '0 18px 90px', overflow: 'auto', minHeight: 0 }}>
        {FORUM_SCOPES.map(s => {
          const { total, newReplies, hot } = statsFor(s.id);
          return (
            <button key={s.id} onClick={() => pick(s.id)} style={{
              display: 'flex', alignItems: 'stretch', gap: 12, width: '100%',
              background: COL.panel, border: `1.5px solid ${COL.line}`,
              padding: 14, marginBottom: 12, cursor: 'pointer', textAlign: 'left',
              position: 'relative', boxShadow: '4px 4px 0 #000',
            }}>
              <div style={{
                width: 52, height: 52, background: s.color, flexShrink: 0,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: FONT.pixel, fontSize: 22, color: '#000', border: '2px solid #000',
                alignSelf: 'center',
              }}>{s.glyph}</div>
              <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 4 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
                  <span style={{ fontFamily: FONT.pixel, fontSize: 12, color: s.color, letterSpacing: 1.5 }}>{s.label}</span>
                  {hot && (
                    <span style={{
                      fontFamily: FONT.pixel, fontSize: 7, padding: '3px 5px',
                      background: '#000', color: COL.danger, border: `1px solid ${COL.danger}`,
                      letterSpacing: 0.5,
                    }}>🔥 QUENTE</span>
                  )}
                </div>
                <div style={{ fontFamily: FONT.body, fontSize: 13, color: COL.ink, fontWeight: 600 }}>{s.sub}</div>
                <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim }}>
                  {total} pauta{total !== 1 ? 's' : ''} ativa{total !== 1 ? 's' : ''}
                </div>
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', justifyContent: 'center', gap: 4, flexShrink: 0 }}>
                {newReplies > 0 && (
                  <div style={{
                    background: COL.magenta, color: '#fff',
                    fontFamily: FONT.pixel, fontSize: 10, letterSpacing: 0.5,
                    padding: '5px 8px', minWidth: 28, textAlign: 'center',
                    border: '2px solid #000',
                  }}>+{newReplies}</div>
                )}
                <span style={{ color: COL.inkMute, fontSize: 18, lineHeight: 1 }}>›</span>
              </div>
            </button>
          );
        })}
        <div style={{
          marginTop: 18, padding: 12, background: COL.panel, border: `1.5px dashed ${COL.line}`,
          fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, lineHeight: 1.55,
        }}>
          <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 9 }}>// REGRA</span><br/>
          Você só posta no escopo da sua cidade (municipal).<br/>
          Estadual e federal você lê + reage + vota.
        </div>
      </div>
      <TabBar active={tab} onTab={setTab}/>
    </div>
  );
}

Object.assign(window, { ScreenForumScope, FORUM_SCOPES });
