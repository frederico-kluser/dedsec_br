/**
 * @file organisms/ModerationOverlay — full-bleed pre-publish moderation UI.
 * Renders three phases driven by the parent: 'idle' (nothing), 'checking'
 * (LLM running), 'blocked' (rejected with reason).
 *
 * @param {{
 *   phase: 'idle'|'checking'|'blocked',
 *   text: string,
 *   word: string,
 *   onEdit: () => void,
 *   onDiscard: () => void,
 * }} props
 */
function ModerationOverlay({ phase, text, word, onEdit, onDiscard }) {
  if (phase === 'idle') return null;
  const isCheck = phase === 'checking';
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 100,
      background: 'rgba(5,5,5,0.97)',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      padding: 22, overflow: 'hidden',
    }}>
      <Scanlines opacity={0.1}/>
      {isCheck && (
        <>
          {[0,1,2].map(i => (
            <div key={i} style={{
              position: 'absolute', top: '50%', left: '50%', width: 300, height: 300,
              marginLeft: -150, marginTop: -150, borderRadius: '50%',
              background: `radial-gradient(circle, ${COL.acid}55 0%, transparent 60%)`,
              animation: `pulse-out 2.4s ease-out ${i*0.8}s infinite`,
            }}/>
          ))}
          <div style={{
            width: 140, height: 140, borderRadius: '50%',
            background: COL.acid, border: '4px solid #000', overflow: 'hidden', position: 'relative',
            boxShadow: '6px 6px 0 #000',
          }}>
            <Halftone color="#000" size={6} opacity={0.55} style={{ position: 'absolute', inset: 0 }}/>
            <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <Eye size={56} color="#000"/>
            </div>
          </div>
          <Stencil size={26} style={{ marginTop: 22, lineHeight: 1.05, textAlign: 'center', position: 'relative', zIndex: 2 }}>
            MODERANDO COM<br/><span style={{ color: COL.acid }}>IA LOCAL</span>
          </Stencil>
          <div style={{
            fontFamily: FONT.mono, fontSize: 10, color: COL.acid, marginTop: 10, letterSpacing: 1.5,
            position: 'relative', zIndex: 2,
            display: 'flex', alignItems: 'center', gap: 6,
          }}>
            <span style={{ width: 6, height: 6, background: COL.acid, animation: 'blink 0.7s steps(2) infinite' }}/>
            gemma-3-1b · classificando ódio/spam ...
          </div>
          <div style={{
            marginTop: 18, padding: '10px 14px', background: COL.panel,
            border: `1px dashed ${COL.line}`, fontFamily: FONT.mono, fontSize: 11,
            color: COL.inkDim, maxWidth: '88%', textAlign: 'center', lineHeight: 1.5,
            position: 'relative', zIndex: 2,
          }}>"{text}"</div>
        </>
      )}
      {phase === 'blocked' && (
        <>
          <Halftone color={COL.danger} size={5} opacity={0.18} style={{ position: 'absolute', inset: 0 }}/>
          <div style={{
            padding: '10px 18px', background: COL.danger, color: '#000',
            fontFamily: FONT.pixel, fontSize: 11, letterSpacing: 2, marginBottom: 18,
            boxShadow: '4px 4px 0 #000', transform: 'rotate(-2deg)',
            position: 'relative', zIndex: 2,
          }}>BLOQUEADO</div>
          <Stencil size={34} style={{ textAlign: 'center', lineHeight: 1, color: COL.ink, position: 'relative', zIndex: 2 }}>
            DISCURSO<br/><span style={{ color: COL.danger, textShadow: `3px 3px 0 ${COL.magenta}` }}>OFENSIVO</span>
          </Stencil>
          <div style={{
            fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, marginTop: 14,
            textAlign: 'center', lineHeight: 1.55, maxWidth: 320, position: 'relative', zIndex: 2,
          }}>
            // a ia local detectou conteúdo que pode<br/>
            // violar as regras da comunidade.
          </div>
          <div style={{
            marginTop: 16, padding: 12, background: COL.panel, border: `1.5px dashed ${COL.danger}`,
            fontFamily: FONT.mono, fontSize: 11, color: COL.ink, maxWidth: '88%', textAlign: 'center',
            lineHeight: 1.5, position: 'relative', zIndex: 2,
          }}>
            sinal: <span style={{ color: COL.danger, fontWeight: 700 }}>"{word}"</span>
            <div style={{ fontSize: 9, color: COL.inkMute, marginTop: 4 }}>categoria: discurso de ódio</div>
          </div>
          <div style={{ display: 'flex', gap: 10, marginTop: 22, position: 'relative', zIndex: 2 }}>
            <GhostBtn onClick={onDiscard} color={COL.inkDim}>DESCARTAR</GhostBtn>
            <Btn color={COL.acid} onClick={onEdit}>EDITAR ✎</Btn>
          </div>
        </>
      )}
    </div>
  );
}
Object.assign(window, { ModerationOverlay });
