/**
 * @file pages/Channels — pick destination (Instagram/X/WhatsApp).
 */
function ScreenChannels({ go }) {
  const channels = [
    { plat: 'INSTAGRAM',   who: 'Prefeito Ricardo Nunes', handle: '@ricardo_nunes', color: '#E1306C', glyph: '📷' },
    { plat: 'X / TWITTER', who: 'Sec. de Transportes',    handle: '@sptransporte',  color: '#1DA1F2', glyph: '🐦' },
    { plat: 'INSTAGRAM',   who: 'Câmara Municipal SP',    handle: '@cmsp_oficial',  color: '#E1306C', glyph: '📷' },
    { plat: 'X / TWITTER', who: 'Ver. Eduardo Tuma',      handle: '@eduardo_tuma',  color: '#1DA1F2', glyph: '🐦' },
    { plat: 'WHATSAPP',    who: 'Compartilhar p/ grupos', handle: 'enviar via WA',  color: '#25D366', glyph: '💬' },
  ];
  const [posted, setPosted] = React.useState(new Set());
  return (
    <ScreenRoot relative={false}>
      <BackHeader label="VOLTAR" onBack={() => go('generate')}>
        <PixelChip color={COL.magenta} bg="#000" size={8}>POSTAGEM MANUAL</PixelChip>
      </BackHeader>
      <div style={{ padding: '16px 18px' }}>
        <Stencil size={26}>ABRIR ONDE?</Stencil>
        <div style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, marginTop: 6 }}>
          // o app copia o texto, abre o destino e você cola no comentário.
        </div>
      </div>
      <div style={{ flex: 1, padding: '0 18px 100px', overflow: 'auto', minHeight: 0 }}>
        {channels.map(c => {
          const sent = posted.has(c.handle);
          return (
            <button key={c.handle} onClick={() => { const n = new Set(posted); n.add(c.handle); setPosted(n); }} style={{
              display: 'flex', alignItems: 'center', gap: 12, width: '100%',
              background: sent ? COL.panelHi : COL.panel,
              border: `1.5px solid ${sent ? COL.acid : COL.line}`,
              padding: '12px 14px', marginBottom: 10, cursor: 'pointer', textAlign: 'left',
            }}>
              <div style={{
                width: 44, height: 44, background: c.color, color: '#fff',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 22, border: '2px solid #000',
              }}>{c.glyph}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1 }}>{c.plat}</div>
                <div style={{ fontFamily: FONT.body, fontSize: 14, color: COL.ink, fontWeight: 600, marginTop: 2 }}>{c.who}</div>
                <div style={{ fontFamily: FONT.mono, fontSize: 11, color: c.color, marginTop: 2 }}>{c.handle}</div>
              </div>
              <div style={{
                fontFamily: FONT.pixel, fontSize: 9, color: sent ? '#000' : COL.ink,
                background: sent ? COL.acid : 'transparent', border: `1.5px solid ${sent ? COL.acid : COL.line}`,
                padding: '8px 10px',
              }}>{sent ? '✓ COPIADO' : 'ABRIR →'}</div>
            </button>
          );
        })}
        <div style={{
          marginTop: 14, padding: 12, background: COL.panel, border: `1.5px dashed ${COL.acid}`,
          fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, lineHeight: 1.5,
        }}>
          <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 9 }}>// TOAST</span><br/>
          mensagem copiada. cole no comentário do post mais recente do destinatário.
        </div>
      </div>
      <StickyFooter>
        <div style={{ flex: 1, fontFamily: FONT.pixel, fontSize: 10, color: COL.acid }}>
          POSTOU EM {posted.size}/{channels.length}
        </div>
        <Btn color={COL.acid} onClick={() => go('home')}>CONCLUÍDO</Btn>
      </StickyFooter>
    </ScreenRoot>
  );
}
Object.assign(window, { ScreenChannels });
