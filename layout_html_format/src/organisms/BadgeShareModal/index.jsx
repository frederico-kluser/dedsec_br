/**
 * @file organisms/BadgeShareModal — share dialog for a single badge.
 * Toggle to include identity (avatar + pseudonym) or stay anonymous.
 *
 * @param {{
 *   badge: Badge|null,
 *   user: DedsecUser,
 *   isLocked?: boolean,
 *   onClose: () => void,
 * }} props
 */
function BadgeShareModal({ badge, user, isLocked, onClose }) {
  const [includeId, setIncludeId] = React.useState(true);
  const [shared, setShared]       = React.useState(null);

  if (!badge) return null;
  const cat = BADGE_CATEGORIES[badge.category];

  const shareTo = (where) => { setShared(where); setTimeout(() => setShared(null), 1500); };

  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 200,
      background: 'rgba(0,0,0,0.88)', display: 'flex', flexDirection: 'column',
      overflow: 'hidden',
    }}>
      <Scanlines opacity={0.08}/>
      <div style={{
        display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px',
        borderBottom: `1px solid ${COL.line}`, background: COL.bg,
      }}>
        <span style={{ fontFamily: FONT.pixel, fontSize: 10, color: COL.acid, letterSpacing: 1 }}>
          {isLocked ? 'SELO BLOQUEADO' : 'COMPARTILHAR SELO'}
        </span>
        <div style={{ flex: 1 }}/>
        <button onClick={onClose} style={{
          background: 'transparent', border: `1px solid ${COL.line}`,
          color: COL.inkDim, fontFamily: FONT.pixel, fontSize: 10,
          padding: '4px 8px', cursor: 'pointer',
        }}>× FECHAR</button>
      </div>

      <ScrollArea padding="18px 18px 100px">
        {/* badge hero */}
        <div style={{
          padding: 20, background: COL.panel,
          border: `2px solid ${cat.color}`, textAlign: 'center',
          boxShadow: `4px 4px 0 #000`,
          position: 'relative', overflow: 'hidden',
          filter: isLocked ? 'grayscale(0.85) opacity(0.7)' : 'none',
        }}>
          <Halftone color={cat.color} size={4} opacity={0.12} style={{ position: 'absolute', inset: 0 }}/>
          <div style={{ fontSize: 80, lineHeight: 1, marginBottom: 10, position: 'relative' }}>
            {isLocked ? '🔒' : badge.emoji}
          </div>
          <PixelChip color={cat.color} bg="#000" size={8}>{cat.label} · TIER {badge.tier}</PixelChip>
          <Stencil size={26} style={{ marginTop: 10, position: 'relative' }}>{badge.title.toUpperCase()}</Stencil>
          <div style={{
            fontFamily: FONT.body, fontSize: 13, color: COL.inkDim, marginTop: 8, lineHeight: 1.5,
            position: 'relative',
          }}>{badge.desc}</div>
        </div>

        {!isLocked && (
          <>
            <div style={{
              marginTop: 14, fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim,
              padding: '8px 10px', background: COL.panel, border: `1px dashed ${COL.line}`,
            }}>
              conquistado em <span style={{ color: COL.acid }}>23 mai 2026</span>
            </div>

            {/* identity toggle */}
            <div style={{
              marginTop: 18, padding: 12, background: COL.panel, border: `1.5px solid ${COL.line}`,
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontFamily: FONT.body, fontSize: 13, fontWeight: 600 }}>Incluir minha identidade?</div>
                <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 3 }}>
                  avatar + pseudônimo aparecem no selo compartilhado.
                </div>
              </div>
              <Toggle value={includeId} onChange={() => setIncludeId(!includeId)} size="sm"/>
            </div>

            {/* preview */}
            <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5, margin: '18px 0 8px' }}>
              // PRÉVIA DO COMPARTILHAMENTO
            </div>
            <div style={{
              padding: 14, background: '#0a0a0a', border: `1.5px solid ${cat.color}`,
              display: 'flex', alignItems: 'center', gap: 12, position: 'relative', overflow: 'hidden',
            }}>
              <Halftone color={cat.color} size={3} opacity={0.1} style={{ position: 'absolute', inset: 0 }}/>
              <div style={{
                width: 64, height: 64, background: cat.color, border: '2px solid #000',
                display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 36,
                flexShrink: 0, position: 'relative',
              }}>{badge.emoji}</div>
              <div style={{ flex: 1, minWidth: 0, position: 'relative' }}>
                <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: cat.color, letterSpacing: 1 }}>
                  CONQUISTA · DEDSEC_BR
                </div>
                <div style={{ fontFamily: FONT.body, fontSize: 14, color: COL.ink, fontWeight: 700, marginTop: 4 }}>
                  {badge.title}
                </div>
                {includeId ? (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 6 }}>
                    <Avatar seed={user.seed} size={20} border={false}/>
                    <span style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.acid }}>{user.pseudonym}</span>
                  </div>
                ) : (
                  <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute, marginTop: 6 }}>
                    cidadão anônimo · sp
                  </div>
                )}
              </div>
            </div>

            {/* share channels */}
            <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5, margin: '18px 0 8px' }}>
              // COMPARTILHAR EM
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
              {[
                { id: 'ig', label: 'INSTAGRAM',  color: '#E1306C', glyph: '📷' },
                { id: 'x',  label: 'X / TWITTER', color: '#1DA1F2', glyph: '🐦' },
                { id: 'wa', label: 'WHATSAPP',    color: '#25D366', glyph: '💬' },
                { id: 'cp', label: 'COPIAR IMG',  color: COL.acid,  glyph: '📋' },
              ].map(ch => (
                <button key={ch.id} onClick={() => shareTo(ch.id)} style={{
                  display: 'flex', alignItems: 'center', gap: 8,
                  background: shared === ch.id ? ch.color : COL.panel,
                  border: `1.5px solid ${ch.color}`,
                  padding: '10px 12px', cursor: 'pointer',
                  color: shared === ch.id ? '#000' : COL.ink,
                  fontFamily: FONT.pixel, fontSize: 9, letterSpacing: 1,
                }}>
                  <span style={{ fontSize: 18 }}>{ch.glyph}</span>
                  <span>{shared === ch.id ? 'ABRINDO...' : ch.label}</span>
                </button>
              ))}
            </div>
          </>
        )}

        {isLocked && (
          <div style={{
            marginTop: 18, padding: 14, background: COL.panel, border: `1.5px dashed ${COL.line}`,
            fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, lineHeight: 1.55,
          }}>
            <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 9 }}>// COMO DESBLOQUEAR</span><br/><br/>
            {badge.desc}
          </div>
        )}
      </ScrollArea>
    </div>
  );
}
Object.assign(window, { BadgeShareModal });
