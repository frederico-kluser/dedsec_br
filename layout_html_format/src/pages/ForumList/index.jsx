/**
 * @file pages/ForumList — pautas filtered by selected scope.
 */
function ScreenForumList({ go, tab, setTab, user, topics, forumScope, markTopicSeen, setCurrentTopic }) {
  const scopeInfo = FORUM_SCOPES.find(s => s.id === forumScope) || FORUM_SCOPES[0];
  const filtered = topics.filter(t => t.scope === forumScope);
  const totalNew = filtered.reduce((s, t) => s + (t.newReplies || 0), 0);

  const openTopic = (topic) => {
    setCurrentTopic(topic);
    markTopicSeen(topic.id);
    go('topic');
  };

  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0, position: 'relative' }}>
      <TopBar/>
      <div style={{ padding: '12px 16px', borderBottom: `1px solid ${COL.line}` }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <button onClick={() => go('forum')} style={{
            background: 'transparent', border: 'none', color: COL.ink,
            fontFamily: FONT.pixel, fontSize: 10, cursor: 'pointer', letterSpacing: 1,
          }}>← ESCOPO</button>
          <div style={{ flex: 1 }}/>
          <PixelChip color={scopeInfo.color} bg="#000" size={9}>{scopeInfo.label}</PixelChip>
          <PixelChip color={COL.acid} bg="#000" size={7}>● 312</PixelChip>
        </div>
        <Stencil size={22} style={{ marginTop: 8, lineHeight: 1, color: COL.ink }}>{scopeInfo.sub}</Stencil>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 8 }}>
          <Avatar seed={user.seed} size={26}/>
          <span style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.acid }}>{user.pseudonym}</span>
          {totalNew > 0 && (
            <span style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.magenta, letterSpacing: 1 }}>· {totalNew} NOVOS</span>
          )}
        </div>
      </div>
      <div style={{ flex: 1, padding: '14px 16px 90px', overflow: 'auto', minHeight: 0 }}>
        {filtered.map(t => {
          const newN = t.newReplies || 0;
          return (
            <button key={t.id} onClick={() => openTopic(t)} style={{
              display: 'flex', textAlign: 'left', width: '100%', gap: 10,
              background: COL.panel,
              border: `1.5px solid ${newN > 0 ? COL.acid : COL.line}`,
              padding: 12, paddingRight: newN > 0 ? 44 : 12,
              marginBottom: 10, cursor: 'pointer', position: 'relative',
              boxShadow: newN > 0 ? `2px 2px 0 ${COL.acid}33` : 'none',
            }}>
              <Avatar seed={t.author} size={36}/>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 6, flexWrap: 'wrap' }}>
                  <PixelChip color={COL.acid} bg="#000" size={7}>{t.tag}</PixelChip>
                  {t.hot && <PixelChip color={COL.danger} bg="#000" size={7}>🔥 QUENTE</PixelChip>}
                  {t.live && <span style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.acid }}>● AO VIVO</span>}
                </div>
                <div style={{ fontFamily: FONT.body, fontSize: 13, fontWeight: 600, color: COL.ink, lineHeight: 1.4 }}>{t.title}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 8, fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, flexWrap: 'wrap' }}>
                  <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', minWidth: 0 }}>{t.author}</span>
                  <span>·</span>
                  <span style={{ color: COL.magenta }}>↩ {t.replies}</span>
                  <span>·</span>
                  <span>{t.age}</span>
                </div>
              </div>
              {newN > 0 && (
                <div style={{
                  position: 'absolute', top: 8, right: 8,
                  background: COL.magenta, color: '#fff',
                  fontFamily: FONT.pixel, fontSize: 9, letterSpacing: 0.5,
                  padding: '4px 7px', minWidth: 22, textAlign: 'center',
                  border: '1.5px solid #000',
                }}>+{newN}</div>
              )}
            </button>
          );
        })}
        {filtered.length === 0 && (
          <div style={{
            padding: 24, textAlign: 'center', fontFamily: FONT.mono, fontSize: 11, color: COL.inkMute,
            border: `1.5px dashed ${COL.line}`, lineHeight: 1.55,
          }}>
            // nenhuma pauta nesse escopo ainda.<br/>
            // toque em "+ NOVA PAUTA" pra criar a primeira.
          </div>
        )}
      </div>
      {forumScope === 'mun' && (
        <button onClick={() => go('newpost')} style={{
          position: 'absolute', right: 16, bottom: 78,
          background: COL.acid, color: '#000', border: '3px solid #000',
          padding: '12px 14px', cursor: 'pointer', fontFamily: FONT.pixel, fontSize: 11,
          letterSpacing: 1, boxShadow: '4px 4px 0 #000',
        }}>+ NOVA PAUTA</button>
      )}
      <TabBar active={tab} onTab={setTab}/>
    </div>
  );
}
Object.assign(window, { ScreenForumList });
