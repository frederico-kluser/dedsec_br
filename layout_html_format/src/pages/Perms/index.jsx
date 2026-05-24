/**
 * @file pages/Perms — minimal permissions screen + privacy manifesto.
 */
function ScreenPerms({ go }) {
  const [p, setP] = React.useState({ push: true, store: true, share: true });
  const Row = ({ k, title, sub }) => (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 12,
      padding: '14px 0', borderBottom: `1px solid ${COL.line}`,
    }}>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: FONT.body, fontSize: 14, fontWeight: 600 }}>{title}</div>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 3 }}>{sub}</div>
      </div>
      <Toggle value={p[k]} onChange={() => setP({...p, [k]: !p[k]})}/>
    </div>
  );
  return (
    <ScreenRoot relative={false}>
      <div style={{ padding: '18px 20px 14px' }}>
        <PixelChip color={COL.alert} bg="#000">OP_04 / PERMISSÕES</PixelChip>
        <Stencil size={36} style={{ marginTop: 10, lineHeight: 0.95 }}>O MÍNIMO<br/>POSSÍVEL.</Stencil>
      </div>
      <div style={{ flex: 1, padding: '0 20px', overflow: 'auto', minHeight: 0 }}>
        <Row k="push"  title="Notificações"     sub="Avisar quando tiver pauta urgente." />
        <Row k="store" title="Armazenamento"    sub="Modelo LLM local · 530 MB · gemma-3-1b" />
        <Row k="share" title="Compartilhamento" sub="Abrir Instagram / X / WhatsApp via deep link." />
        <div style={{
          marginTop: 22, padding: 14, border: `1.5px dashed ${COL.acid}`,
          fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, lineHeight: 1.55,
        }}>
          <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 9 }}>// MANIFESTO</span><br/><br/>
          NÃO exigimos login.<br/>
          NÃO coletamos nome, e-mail, telefone.<br/>
          NÃO usamos localização exata.<br/>
          NÃO rastreamos suas redes sociais.<br/>
          NÃO postamos por você. Você revisa, você publica.
        </div>
        <div style={{ marginTop: 12, fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute, textDecoration: 'underline' }}>
          ler política completa →
        </div>
      </div>
      <div style={{ padding: '14px 20px 24px', display: 'flex', gap: 10 }}>
        <GhostBtn onClick={() => go('city')} color={COL.inkDim}>VOLTAR</GhostBtn>
        <div style={{ flex: 1 }}/>
        <Btn color={COL.alert} onClick={() => go('home')}>ENTRAR →</Btn>
      </div>
    </ScreenRoot>
  );
}
Object.assign(window, { ScreenPerms });
