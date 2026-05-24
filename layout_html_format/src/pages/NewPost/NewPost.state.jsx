/**
 * @file pages/NewPost/NewPost.state — composer flow (idle → analyzing → preview).
 */

/**
 * @returns {{
 *   scope: 'mun'|'est'|'fed', setScope: Function,
 *   text: string, setText: Function,
 *   url: string, setUrl: Function,
 *   phase: 'idle'|'analyzing'|'preview',
 *   currentPhase: number,
 *   result: AnalysisResult|null,
 *   startAnalysis: () => void,
 *   regenerate: () => void,
 * }}
 */
function useNewPostFlow() {
  const [scope, setScope]               = React.useState('mun');
  const [text, setText]                 = React.useState('');
  const [url, setUrl]                   = React.useState('');
  const [phase, setPhase]               = React.useState('idle');
  const [currentPhase, setCurrentPhase] = React.useState(0);
  const [result, setResult]             = React.useState(null);

  const startAnalysis = React.useCallback(() => {
    if (!text.trim() || phase !== 'idle') return;
    setPhase('analyzing');
    setCurrentPhase(0);
    let p = 0;
    const id = setInterval(() => {
      p += 1;
      if (p < ANALYSIS_PHASES.length) {
        setCurrentPhase(p);
      } else {
        clearInterval(id);
        setResult(analyzeText(text, scope));
        setPhase('preview');
      }
    }, 950);
  }, [text, scope, phase]);

  const regenerate = React.useCallback(() => {
    setPhase('idle');
    setResult(null);
  }, []);

  return { scope, setScope, text, setText, url, setUrl, phase, currentPhase, result, startAnalysis, regenerate };
}

Object.assign(window, { useNewPostFlow });
