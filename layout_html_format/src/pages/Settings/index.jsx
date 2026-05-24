/**
 * @file pages/Settings — anonymous profile, LLM, data, about.
 */
function ScreenSettings({ go, tab, setTab, user, setUser, regenerateUser }) {
  const Group = ({ title, children }) => (
    <div style={{ marginBottom: 22 }}>
      <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5, marginBottom: 8 }}>
        // {title}
      </div>
      <div style={{ background: COL.panel, border: `1px solid ${COL.line}` }}>{children}</div>
    </div>
  );
  const Row = ({ label, value, danger, onClick }) => (
    <div onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 8,
      padding: '13px 14px', borderBottom: `1px solid ${COL.line}`,
      cursor: onClick ? 'pointer' : 'default',
    }}>
      <span style={{ flex: 1, fontFamily: FONT.body, fontSize: 13, color: danger ? COL.danger : COL.ink }}>{label}</span>
      <span style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim }}>{value}</span>
      <span style={{ color: COL.inkMute }}>›</span>
    </div>
  );
  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <TopBar/>
      <div style={{ padding: '16px 16px 8px' }}>
        <Stencil size={28}>CONFIG</Stencil>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 4 }}>
          // uuid local · {user.seed}
        </div>
      </div>
      <div style={{ flex: 1, padding: '14px 16px 90px', overflow: 'auto', minHeight: 0 }}>
        <Group title="PERFIL ANÔNIMO">
          <div style={{ padding: 16, display: 'flex', gap: 14, alignItems: 'center', borderBottom: `1px solid ${COL.line}` }}>
            <Avatar seed={user.seed} style="identicon" size={84}/>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontFamily: FONT.body, fontSize: 15, fontWeight: 700, color: COL.ink }}>{user.pseudonym}</div>
              <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 4, wordBreak: 'break-all' }}>
                seed: <span style={{ color: COL.acid }}>{user.seed}</span>
              </div>
              <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute, marginTop: 2 }}>via dicebear · identicon</div>
            </div>
          </div>
          <div style={{ padding: 12 }}>
            <button onClick={regenerateUser} style={{
              width: '100%', fontFamily: FONT.pixel, fontSize: 10, padding: '12px 14px',
              letterSpacing: 1.5, background: COL.magenta, color: '#fff',
              border: 'none', cursor: 'pointer', boxShadow: '4px 4px 0 #000',
            }}>↻ REGERAR AVATAR</button>
            <div style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute, marginTop: 8, lineHeight: 1.5 }}>
              // gera uma nova imagem aleatória.<br/>
              // seu pseudônimo <span style={{ color: COL.acid }}>{user.pseudonym}</span> não muda.
            </div>
          </div>
        </Group>
        <Group title="LLM LOCAL">
          <Row label="Modelo" value="gemma-3-1b · q4"/>
          <Row label="Baixar de novo" value="530 MB"/>
          <Row label="Atualizar p/ 4B" value="aparelho ok"/>
        </Group>
        <Group title="QUANDO AJUDAR">
          <Row label="Bateria mínima" value="50%"/>
          <Row label="Só plugado" value="ON"/>
          <Row label="Só wifi" value="ON"/>
        </Group>
        <Group title="DADOS">
          <Row label="Notificações" value="ON"/>
          <Row label="Limpar dados locais" value=""/>
        </Group>
        <Group title="SOBRE">
          <Row label="Código aberto (AGPLv3)" value="github"/>
          <Row label="Política de privacidade" value=""/>
          <Row label="Manifesto" value=""/>
          <Row label="Versão" value="0.1.0-beta"/>
        </Group>
      </div>
      <TabBar active={tab} onTab={setTab}/>
    </div>
  );
}
Object.assign(window, { ScreenSettings });
