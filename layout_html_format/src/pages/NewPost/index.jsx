/**
 * @file pages/NewPost — register a new pauta. The IA analyzes the text
 * and produces a ready-to-publish post.
 */
function ScreenNewPost({ go, user, addTopic, setForumScope }) {
  const flow = useNewPostFlow();
  const { scope, setScope, text, setText, url, setUrl, phase, currentPhase, result, startAnalysis, regenerate } = flow;

  const publish = () => {
    addTopic({
      id: 't' + Date.now(),
      tag: result.theme,
      title: result.title,
      body: result.desc,
      author: user.pseudonym,
      seed: user.seed,
      replies: 0,
      age: 'agora',
      live: true,
      hot: false,
      scope,
    });
    if (setForumScope) setForumScope(scope);
    go('forum-list');
  };

  // PREVIEW
  if (phase === 'preview' && result) {
    return (
      <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px', borderBottom: `1px solid ${COL.line}` }}>
          <button onClick={regenerate} style={{
            background: 'transparent', border: 'none', color: COL.ink, fontFamily: FONT.pixel, fontSize: 11, cursor: 'pointer',
          }}>← REFAZER</button>
          <div style={{ flex: 1 }}/>
          <PixelChip color={COL.acid} bg="#000" size={8}>IA · {result.confidence}% CONFIANÇA</PixelChip>
        </div>
        <div style={{ flex: 1, padding: '16px 18px', overflow: 'auto', minHeight: 0 }}>
          <PixelChip color={result.color} bg="#000">PRÉVIA DA PAUTA</PixelChip>
          <Stencil size={30} style={{ lineHeight: 1.05, marginTop: 12 }}>
            ASSIM VAI<br/><span style={{ color: result.color }}>APARECER</span>
          </Stencil>
          <div style={{
            marginTop: 18, background: COL.panel, border: `1.5px solid ${COL.line}`, padding: 14,
          }}>
            <div style={{ display: 'flex', gap: 6, marginBottom: 10, flexWrap: 'wrap' }}>
              <PixelChip color={result.color} bg="#000" size={7}>{result.theme}</PixelChip>
              <PixelChip color={COL.acid} bg="#000" size={7}>{NEWPOST_SCOPES.find(s => s.id === scope).label}</PixelChip>
              <PixelChip color={COL.inkMute} bg="#000" size={7}>● AO VIVO · agora</PixelChip>
            </div>
            <div style={{ fontFamily: FONT.body, fontSize: 14, fontWeight: 700, color: COL.ink, lineHeight: 1.3 }}>{result.title}</div>
            <div style={{ fontFamily: FONT.body, fontSize: 12.5, color: COL.inkDim, lineHeight: 1.55, marginTop: 8 }}>{result.desc}</div>
            {url && (
              <div style={{ marginTop: 10, fontFamily: FONT.mono, fontSize: 10, color: COL.acid }}>↗ {url}</div>
            )}
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 12 }}>
              <Avatar seed={user.seed} size={22}/>
              <span style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim }}>{user.pseudonym} · agora</span>
            </div>
          </div>
          <div style={{ marginTop: 18, fontFamily: FONT.pixel, fontSize: 9, color: COL.magenta, letterSpacing: 1.2 }}>
            // AUTORIDADES IDENTIFICADAS PELA IA
          </div>
          {result.authorities.map(a => (
            <div key={a.handle} style={{ padding: '10px 0', borderBottom: `1px solid ${COL.line}` }}>
              <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1 }}>{a.role}</div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
                <span style={{ fontFamily: FONT.body, fontSize: 13, color: COL.ink, fontWeight: 600 }}>{a.name}</span>
                <span style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.acid }}>{a.handle}</span>
              </div>
            </div>
          ))}
          <div style={{
            marginTop: 18, padding: 12, background: COL.panel, border: `1.5px dashed ${COL.acid}`,
            fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, lineHeight: 1.55,
          }}>
            <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 9 }}>// NOTA</span><br/>
            A IA classificou esta pauta automaticamente. Revise antes de publicar — você é responsável pelo conteúdo.
          </div>
        </div>
        <div style={{ padding: '12px 14px', background: COL.bg, borderTop: `1.5px solid ${COL.line}`, display: 'flex', gap: 10 }}>
          <GhostBtn onClick={regenerate} color={COL.inkDim}>↻ REFAZER</GhostBtn>
          <div style={{ flex: 1 }}/>
          <Btn color={result.color} onClick={publish}>PUBLICAR ✓</Btn>
        </div>
      </div>
    );
  }

  // FORM
  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0, position: 'relative' }}>
      <AnalysisOverlay phase={phase} currentPhase={currentPhase} inputText={text} scope={scope}/>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px', borderBottom: `1px solid ${COL.line}` }}>
        <button onClick={() => go('forum-list')} style={{
          background: 'transparent', border: 'none', color: COL.ink, fontFamily: FONT.pixel, fontSize: 11, cursor: 'pointer',
        }}>← PAUTAS</button>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid }}>NOVA PAUTA</span>
      </div>
      <div style={{ flex: 1, padding: '16px 18px 12px', overflow: 'auto', minHeight: 0 }}>
        <Stencil size={32} style={{ lineHeight: 0.95 }}>
          LEVANTE UMA<br/><span style={{ color: COL.magenta }}>PAUTA</span>
        </Stencil>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, marginTop: 6, lineHeight: 1.5 }}>
          // a IA local lê o conteúdo, classifica o tema,<br/>
          // identifica autoridades e monta o post pra você.
        </div>
        <div style={{ marginTop: 22 }}>
          <div style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.inkMute, letterSpacing: 1.5, marginBottom: 8 }}>
            // ESCOPO DA PAUTA
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {NEWPOST_SCOPES.map(s => {
              const on = scope === s.id;
              return (
                <button key={s.id} onClick={() => setScope(s.id)} style={{
                  display: 'flex', alignItems: 'center', gap: 12, padding: '12px 14px', textAlign: 'left',
                  background: on ? COL.panelHi : 'transparent',
                  border: `1.5px solid ${on ? s.color : COL.line}`,
                  cursor: 'pointer',
                }}>
                  <div style={{
                    width: 36, height: 36, background: on ? s.color : COL.panel,
                    border: `1.5px solid ${on ? s.color : COL.line}`,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    fontFamily: FONT.pixel, fontSize: 14, color: on ? '#000' : COL.inkDim,
                  }}>{s.id === 'mun' ? '◉' : s.id === 'est' ? '◐' : '◯'}</div>
                  <div style={{ flex: 1 }}>
                    <div style={{ fontFamily: FONT.pixel, fontSize: 10, color: on ? s.color : COL.ink, letterSpacing: 1.5 }}>{s.label}</div>
                    <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute, marginTop: 2 }}>
                      {s.sub} {s.id === 'mun' && `· ${user.city === 'SP' ? 'São Paulo / SP' : user.city}`}
                    </div>
                  </div>
                  {on && <span style={{ color: s.color, fontFamily: FONT.pixel, fontSize: 12 }}>●</span>}
                </button>
              );
            })}
          </div>
        </div>
        <div style={{ marginTop: 22 }}>
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 8 }}>
            <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.inkMute, letterSpacing: 1.5 }}>
              // CONTEÚDO DA NOTÍCIA
            </span>
            <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute }}>{text.length}/2000</span>
          </div>
          <textarea
            value={text}
            onChange={e => setText(e.target.value.slice(0, 2000))}
            placeholder="cole o texto da notícia, descreva o problema, ou conte o que tá acontecendo na sua quebrada..."
            style={{
              width: '100%', minHeight: 140, resize: 'vertical',
              background: '#000', border: `1.5px solid ${COL.line}`,
              padding: '12px 14px', color: COL.ink, fontFamily: FONT.body, fontSize: 13, outline: 'none',
              lineHeight: 1.55, boxSizing: 'border-box',
            }}
          />
        </div>
        <div style={{ marginTop: 18 }}>
          <div style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.inkMute, letterSpacing: 1.5, marginBottom: 8 }}>
            // FONTE (URL, opcional)
          </div>
          <input
            value={url} onChange={e => setUrl(e.target.value)}
            placeholder="https://g1.globo.com/..."
            style={{
              width: '100%', background: '#000', border: `1.5px solid ${COL.line}`,
              padding: '10px 12px', color: COL.acid, fontFamily: FONT.mono, fontSize: 12, outline: 'none',
              boxSizing: 'border-box',
            }}
          />
        </div>
        <div style={{
          marginTop: 16, padding: 12, background: COL.panel, border: `1.5px dashed ${COL.line}`,
          fontFamily: FONT.mono, fontSize: 10, color: COL.inkDim, lineHeight: 1.55,
        }}>
          <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 8 }}>// LEMBRE</span><br/>
          Você é responsável pelo que publica. A IA classifica e formata, mas não checa veracidade — anexe fontes confiáveis.
        </div>
      </div>
      <div style={{ padding: '12px 14px', background: COL.bg, borderTop: `1.5px solid ${COL.line}`, display: 'flex', alignItems: 'center', gap: 10 }}>
        <span style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1 }}>
          {text.trim() ? 'PRONTO PRA ANALISAR' : '↓ COLE O CONTEÚDO ↑'}
        </span>
        <div style={{ flex: 1 }}/>
        <Btn color={text.trim() ? COL.magenta : COL.line} fg={text.trim() ? '#fff' : COL.inkMute} onClick={startAnalysis} disabled={!text.trim()}>
          ANALISAR COM IA →
        </Btn>
      </div>
    </div>
  );
}
Object.assign(window, { ScreenNewPost });
