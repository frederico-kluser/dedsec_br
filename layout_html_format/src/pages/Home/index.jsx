/**
 * @file pages/Home — main news feed with scope filter chips.
 */
function ScreenHome({ go, tab, setTab }) {
  const [scope, setScope] = React.useState('mun');
  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', position: 'relative', minHeight: 0 }}>
      <TopBar/>
      <div style={{ padding: '12px 14px', background: COL.bg }}>
        <div style={{ display: 'flex', gap: 6 }}>
          <ScopeChip active={scope==='mun'} color={COL.magenta} onClick={() => setScope('mun')}>MUNICIPAL</ScopeChip>
          <ScopeChip active={scope==='est'} color={COL.acid} onClick={() => setScope('est')}>ESTADUAL</ScopeChip>
          <ScopeChip active={scope==='fed'} color={COL.alert} onClick={() => setScope('fed')}>FEDERAL</ScopeChip>
        </div>
        <div style={{
          marginTop: 10, padding: '8px 10px', background: COL.panel,
          border: `1px solid ${COL.line}`, display: 'flex', alignItems: 'center', gap: 8,
        }}>
          <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid }}>◉ SÃO PAULO / SP</span>
          <span style={{ flex: 1 }}/>
          <span style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim }}>4 pautas novas</span>
        </div>
      </div>
      <div style={{ flex: 1, padding: '14px 14px 90px', overflow: 'auto', minHeight: 0 }}>
        {NEWS.map(n => <NewsCard key={n.id} n={n} onOpen={() => go('detail')}/>)}
      </div>
      <button onClick={() => go('help')} style={{
        position: 'absolute', right: 16, bottom: 78,
        background: COL.magenta, color: '#fff', border: '3px solid #000',
        padding: '12px 14px', cursor: 'pointer', fontFamily: FONT.pixel, fontSize: 10,
        letterSpacing: 1, boxShadow: '4px 4px 0 #000',
      }}>✦ AJUDAR</button>
      <TabBar active={tab} onTab={setTab}/>
    </div>
  );
}
Object.assign(window, { ScreenHome });
