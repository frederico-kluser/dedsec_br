/**
 * @file pages/City — choose city (single-pick).
 */
function ScreenCity({ go }) {
  const cities = [
    ['São Paulo','SP','11,4 mi'],['Rio de Janeiro','RJ','6,2 mi'],
    ['Belo Horizonte','MG','2,5 mi'],['Recife','PE','1,5 mi'],
    ['Porto Alegre','RS','1,3 mi'],['Curitiba','PR','1,7 mi'],
    ['Salvador','BA','2,4 mi'],['Fortaleza','CE','2,6 mi'],
  ];
  const [sel, setSel] = React.useState('São Paulo');
  return (
    <div style={{ flex: 1, background: COL.bg, color: COL.ink, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
      <div style={{ padding: '18px 20px 12px' }}>
        <PixelChip color={COL.acid} bg="#000">OP_03 / TRINCHEIRA</PixelChip>
        <Stencil size={40} style={{ marginTop: 10, lineHeight: 0.95 }}>
          QUAL É A SUA<br/><span style={{ color: COL.acid }}>CIDADE?</span>
        </Stencil>
        <div style={{ fontFamily: FONT.mono, fontSize: 11, color: COL.inkDim, marginTop: 8 }}>
          // só o nome. nunca coordenadas.
        </div>
      </div>
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{
          background: COL.panel, border: `1.5px solid ${COL.line}`,
          padding: '10px 12px', display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <span style={{ fontFamily: FONT.pixel, fontSize: 14, color: COL.magenta }}>{'>'}</span>
          <input placeholder="buscar entre 5.570 municípios..." style={{
            flex: 1, background: 'transparent', border: 'none', outline: 'none',
            color: COL.ink, fontFamily: FONT.mono, fontSize: 13,
          }}/>
        </div>
      </div>
      <div style={{ padding: '0 20px', fontFamily: FONT.pixel, fontSize: 9, color: COL.inkMute, letterSpacing: 1, marginBottom: 8 }}>// POPULARES</div>
      <div style={{ flex: 1, padding: '0 20px', overflow: 'auto', minHeight: 0 }}>
        {cities.map(([name, uf, pop]) => {
          const on = sel === name;
          return (
            <button key={name} onClick={() => setSel(name)} style={{
              display: 'flex', alignItems: 'center', gap: 12, width: '100%',
              background: on ? COL.panelHi : 'transparent',
              border: 'none', borderBottom: `1px solid ${COL.line}`,
              padding: '14px 4px', cursor: 'pointer', textAlign: 'left',
            }}>
              <div style={{
                width: 28, height: 28, background: on ? COL.acid : COL.panel,
                fontFamily: FONT.pixel, fontSize: 9, color: on ? '#000' : COL.inkDim,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                border: `1.5px solid ${on ? COL.acid : COL.line}`,
              }}>{uf}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontFamily: FONT.body, fontWeight: 600, fontSize: 14, color: COL.ink }}>{name}</div>
                <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute }}>{pop} hab.</div>
              </div>
              {on && <span style={{ color: COL.acid, fontFamily: FONT.pixel, fontSize: 12 }}>●</span>}
            </button>
          );
        })}
      </div>
      <div style={{ padding: '14px 20px 24px', display: 'flex', gap: 10 }}>
        <GhostBtn onClick={() => go('interests')} color={COL.inkDim}>VOLTAR</GhostBtn>
        <div style={{ flex: 1 }}/>
        <Btn color={COL.acid} onClick={() => go('perms')}>CONFIRMAR →</Btn>
      </div>
    </div>
  );
}
Object.assign(window, { ScreenCity });
