/**
 * @file organisms/AnalysisOverlay — full-bleed AI analysis overlay used by
 * the "Nova Pauta" flow. Reuses the TokenStreamPanel.
 */

const ANALYSIS_PHASES = [
  { id: 0, label: 'lendo conteúdo ...',            tech: 'tokenize + chunk · 142 tokens' },
  { id: 1, label: 'classificando tema ...',        tech: 'zero-shot · 20 categorias'     },
  { id: 2, label: 'identificando autoridades ...', tech: 'lookup TSE + Câmara API'       },
  { id: 3, label: 'gerando título + resumo ...',   tech: 'gemma-3-1b · prompt cidadania' },
];

/**
 * @param {{
 *   phase: 'idle'|'analyzing',
 *   currentPhase: number,
 *   inputText?: string,
 *   scope?: 'mun'|'est'|'fed',
 * }} props
 */
function AnalysisOverlay({ phase, currentPhase, inputText, scope }) {
  if (phase !== 'analyzing') return null;
  const cur = ANALYSIS_PHASES[currentPhase] || ANALYSIS_PHASES[0];

  let inputTokens = (inputText || '').split(/\s+/).filter(Boolean).slice(0, 10);
  if (inputTokens.length === 0) inputTokens = ['[vazio]'];
  inputTokens = ['[BOS]', ...inputTokens, '[EOS]'];

  const phaseOutputs = [
    ['lendo','·','142','tokens','✓'],
    ['tema','=','transporte','(','87%',')','✓'],
    ['autoridade','=','prefeito','·','câmara','✓'],
    ['título','=','linha','17-ouro','...','✓'],
  ];
  let outputTokens = [];
  for (let i = 0; i <= currentPhase; i++) outputTokens = outputTokens.concat(phaseOutputs[i] || []);

  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 100,
      background: 'rgba(2,6,8,0.98)', display: 'flex', flexDirection: 'column',
      overflow: 'hidden',
    }}>
      <div style={{ padding: '14px 16px', borderBottom: `1px solid ${COL.line}`, background: '#050a08' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
          <span style={{ width: 8, height: 8, background: COL.magenta, animation: 'blink 0.7s steps(2) infinite' }}/>
          <PixelChip color={COL.magenta} bg="#000" size={8}>IA LOCAL · PROCESSANDO</PixelChip>
        </div>
        <Stencil size={22} style={{ lineHeight: 1 }}>
          ANALISANDO<br/><span style={{ color: COL.magenta }}>PAUTA</span>
        </Stencil>
        <div style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.acid, marginTop: 8, letterSpacing: 1.2 }}>
          // {cur.label}
        </div>
        <div style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute, marginTop: 2 }}>
          // {cur.tech}
        </div>
      </div>
      <TokenStreamPanel inputTokens={inputTokens} outputTokens={outputTokens} modelLabel="GEMMA-3-1B · pt-BR"/>
      <div style={{ padding: '12px 14px', borderTop: `1px solid ${COL.line}`, display: 'flex', gap: 6 }}>
        {ANALYSIS_PHASES.map((p, i) => (
          <div key={i} style={{ flex: 1 }}>
            <div style={{
              height: 5, background: i <= currentPhase ? COL.magenta : COL.line,
              boxShadow: i === currentPhase ? `0 0 8px ${COL.magenta}` : 'none',
            }}/>
            <div style={{
              fontFamily: FONT.pixel, fontSize: 7,
              color: i === currentPhase ? COL.magenta : i < currentPhase ? COL.acid : COL.inkMute,
              marginTop: 4, letterSpacing: 1, textAlign: 'center',
            }}>{i < currentPhase ? '✓' : i + 1}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

Object.assign(window, { AnalysisOverlay, ANALYSIS_PHASES });
