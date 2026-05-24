/**
 * @file organisms/loaders/LoaderTokenRAG — L14: retrieval-augmented generation.
 */
function LoaderTokenRAG() {
  const t = useTick(180);
  const query = 'transporte público sp · atraso obras';
  const chunks = [
    { src: 'D.O. Municipal SP · 2024-08', text: 'aditivo n°3 prorroga prazo de entrega', sim: 0.91 },
    { src: 'queridodiario.api · trecho',  text: 'custo revisto: R$1.6bi → R$4.8bi', sim: 0.84 },
    { src: 'G1 SP · 2024-12',             text: 'TCE-SP abre processo de fiscalização', sim: 0.71 },
  ];
  const generated = ['A',' linha',' 17-Ouro',' do',' metrô',' acumula',' aditivos',' que',' triplicaram',' o',' custo','.'];
  const cycle = t % (generated.length + 4);
  const visible = Math.min(generated.length, cycle);
  return (
    <div style={{ flex: 1, background: '#020608', padding: 12, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Scanlines opacity={0.08}/>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 10 }}>
        <span style={{ width: 8, height: 8, background: COL.acid, animation: 'blink 0.6s steps(2) infinite' }}/>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid, letterSpacing: 1 }}>RAG · BUSCA AUMENTADA</span>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkDim }}>top-3</span>
      </div>
      <div style={{ background: '#0a0a0e', border: `1.5px solid ${COL.line}`, padding: 7, marginBottom: 8 }}>
        <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1.2, marginBottom: 3 }}>QUERY</div>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.ink }}>"{query}"</div>
      </div>
      <div style={{ marginBottom: 8 }}>
        <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.inkMute, letterSpacing: 1.2, marginBottom: 5 }}>
          CHUNKS RECUPERADOS
        </div>
        {chunks.map((c, i) => (
          <div key={i} style={{
            background: '#0a0a0e', borderLeft: `3px solid ${COL.acid}`, border: `1px solid ${COL.line}`,
            borderLeftWidth: 3, padding: 6, marginBottom: 4,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 2 }}>
              <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.acid }}>{c.src}</span>
              <div style={{ flex: 1 }}/>
              <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.magenta }}>sim={c.sim}</span>
            </div>
            <div style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkDim }}>"{c.text}"</div>
          </div>
        ))}
      </div>
      <div style={{
        flex: 1, background: '#0a0e0a', border: `1.5px solid ${COL.acid}`, padding: 8,
        boxShadow: `0 0 12px ${COL.acid}22`, minHeight: 0,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 5 }}>
          <span style={{ fontFamily: FONT.pixel, fontSize: 7, color: COL.acid, letterSpacing: 1.2 }}>GERANDO COM CONTEXTO</span>
          <div style={{ flex: 1 }}/>
          <span style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.acid }}>{visible}/{generated.length}</span>
        </div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 3 }}>
          {generated.slice(0, visible).map((tk, i) => (
            <span key={i} style={{
              fontFamily: FONT.mono, fontSize: 11, padding: '2px 6px',
              background: COL.acid, color: '#000', border: `1.5px solid #000`,
            }}>{tk.trim() || '·'}</span>
          ))}
          {visible < generated.length && (
            <span style={{
              fontFamily: FONT.mono, fontSize: 11, padding: '2px 6px',
              background: '#000', color: COL.acid, border: `1.5px solid ${COL.acid}`,
              animation: 'blink 0.5s steps(2) infinite',
            }}>▮</span>
          )}
        </div>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderTokenRAG });
