/**
 * @file pages/Interests — multi-select causes (min 3).
 */
function ScreenInterests({ go }) {
  const causes = [
    'Educação','Saúde','Transporte','Seg. Pública','Meio Ambiente',
    'Moradia','Cultura','Mobilidade','Saneamento','Orçamento',
    'LGBTQIA+','Indígenas','Mulheres','Negros','ECA',
    'Idosos','PCD','Trabalho','Hab. Popular','Corrupção',
  ];
  const [sel, setSel] = React.useState(new Set(['Educação','Transporte','Corrupção','Orçamento']));
  const toggle = c => { const n = new Set(sel); n.has(c) ? n.delete(c) : n.add(c); setSel(n); };
  const min = sel.size >= 3;
  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <div style={{ padding: '18px 20px 14px' }}>
        <PixelChip color={COL.magenta} bg="#000">OP_02 / INTERESSES</PixelChip>
        <Stencil size={40} style={{ marginTop: 10, lineHeight: 0.95 }}>
          ESCOLHA SUAS<br/><span style={{ color: COL.magenta }}>CAUSAS</span>
        </Stencil>
        <div style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, marginTop: 8 }}>
          // mín. 3 marcadas · {sel.size}/3 {min ? '✓' : ''}
        </div>
      </div>
      <div style={{ flex: 1, padding: '0 20px 20px', overflow: 'auto', minHeight: 0 }}>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {causes.map(c => {
            const on = sel.has(c);
            return (
              <button key={c} onClick={() => toggle(c)} style={{
                fontFamily: FONT.pixel, fontSize: 9, padding: '10px 11px',
                background: on ? COL.acid : 'transparent',
                color: on ? '#000' : COL.ink,
                border: `1.5px solid ${on ? COL.acid : COL.line}`,
                cursor: 'pointer', letterSpacing: 0.5,
              }}>{c}</button>
            );
          })}
        </div>
      </div>
      <div style={{ padding: '0 20px 24px', display: 'flex', gap: 10 }}>
        <GhostBtn onClick={() => go('onb1')} color={COL.inkDim}>VOLTAR</GhostBtn>
        <div style={{ flex: 1 }}/>
        <Btn disabled={!min} color={COL.acid} onClick={() => go('city')}>CONTINUAR →</Btn>
      </div>
    </div>
  );
}
Object.assign(window, { ScreenInterests });
