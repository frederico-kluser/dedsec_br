/**
 * @file templates/AppShell — desktop shell: sidebar menu + phone stage.
 * Pure view; receives state via props.
 */

const PHONE_W = 380;
const PHONE_H = 740;

function AppShell({ screen, go, renderScreen }) {
  const current = SCREENS.find(s => s.id === screen);
  return (
    <div style={{
      minHeight: '100vh', background: '#000', color: COL.ink,
      display: 'flex', fontFamily: FONT.body,
    }}>
      <div style={{ position: 'fixed', inset: 0, zIndex: 0, pointerEvents: 'none' }}>
        <Halftone color={COL.magenta} size={8} opacity={0.06} style={{ position: 'absolute', inset: 0 }}/>
        <div style={{
          position: 'absolute', top: '-10%', right: '-5%', width: 600, height: 600,
          background: `radial-gradient(circle, ${COL.magenta}40, transparent 60%)`, filter: 'blur(80px)',
        }}/>
        <div style={{
          position: 'absolute', bottom: '-10%', left: '-5%', width: 500, height: 500,
          background: `radial-gradient(circle, ${COL.acid}30, transparent 60%)`, filter: 'blur(80px)',
        }}/>
      </div>

      <aside style={{
        width: 280, padding: '28px 22px', borderRight: `1px solid ${COL.line}`,
        position: 'relative', zIndex: 1, overflowY: 'auto', maxHeight: '100vh',
        boxSizing: 'border-box',
      }}>
        <Wordmark size={18}/>
        <div style={{
          fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, marginTop: 8, letterSpacing: 1, lineHeight: 1.5,
        }}>
          // protótipo de interface<br/>
          // 15 telas + 15 loaders
        </div>
        <div style={{
          marginTop: 22, padding: 12, border: `1px dashed ${COL.lineHi}`,
          fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute, lineHeight: 1.55,
        }}>
          App cívico brasileiro · LLM local (Gemma 3 1B) · sem login · sem coleta de dados pessoais · código aberto AGPLv3.
        </div>
        <div style={{ marginTop: 26 }}>
          {PHASES.map(p => (
            <div key={p} style={{ marginBottom: 18 }}>
              <div style={{
                fontFamily: FONT.pixel, fontSize: 9, letterSpacing: 1.5, color: PHASE_COLORS[p],
                marginBottom: 8, display: 'flex', alignItems: 'center', gap: 8,
              }}>
                <span style={{ width: 8, height: 8, background: PHASE_COLORS[p] }}/> {p}
              </div>
              {SCREENS.filter(s => s.phase === p).map(s => {
                const active = screen === s.id;
                return (
                  <button key={s.id} onClick={() => go(s.id)} style={{
                    display: 'block', width: '100%', textAlign: 'left',
                    background: active ? PHASE_COLORS[p] : 'transparent',
                    color: active ? '#000' : COL.inkDim,
                    fontFamily: FONT.mono, fontSize: 12,
                    border: 'none', padding: '7px 10px', cursor: 'pointer',
                    borderLeft: active ? `3px solid #000` : `3px solid transparent`,
                    marginBottom: 2, letterSpacing: 0.3,
                  }}
                  onMouseEnter={e => { if (!active) e.currentTarget.style.color = COL.ink; }}
                  onMouseLeave={e => { if (!active) e.currentTarget.style.color = COL.inkDim; }}
                  >{s.label}</button>
                );
              })}
            </div>
          ))}
        </div>
        <div style={{
          marginTop: 30, padding: 12, fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute,
          lineHeight: 1.55, borderTop: `1px solid ${COL.line}`,
        }}>
          ⓘ Visual original inspirado em estética pop-art/glitch/cyberpunk. Não usa logo, imagens ou UI de Watch Dogs (Ubisoft®).
        </div>
      </aside>

      <main style={{
        flex: 1, position: 'relative', zIndex: 1,
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        padding: 24, gap: 18,
      }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 14,
          fontFamily: FONT.pixel, fontSize: 10, color: COL.inkDim, letterSpacing: 1.5,
        }}>
          <span>TELA</span>
          <span style={{ color: COL.acid }}>{current && current.label}</span>
          <span style={{ color: COL.inkMute }}>·</span>
          <span>android · {PHONE_W}×{PHONE_H}</span>
        </div>
        <AndroidDevice width={PHONE_W} height={PHONE_H} dark>
          {renderScreen()}
        </AndroidDevice>
        <div style={{
          fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute, letterSpacing: 1, marginTop: 4,
        }}>Use a sidebar ← ou os botões dentro do app para navegar.</div>
      </main>
    </div>
  );
}

Object.assign(window, { AppShell });
