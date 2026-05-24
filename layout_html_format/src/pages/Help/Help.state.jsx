/**
 * @file pages/Help/Help.state — processing flow for "crowdsource a pauta".
 */

/**
 * Returns processing state + actions for the Ajude-a-Célula screen.
 * Phases:
 *  - 'idle'       — ready to start
 *  - 'processing' — token stream visible for ~6.5s
 *  - 'done'       — brief success splash, auto-returns to idle in 2.4s
 */
function useHelpFlow() {
  const [auto, setAuto]               = React.useState(true);
  const [processState, setProcessState] = React.useState('idle');
  const [score, setScore]             = React.useState(12);

  const startProcessing = React.useCallback(() => {
    if (processState !== 'idle') return;
    setProcessState('processing');
    setTimeout(() => {
      setScore(s => s + 1);
      setProcessState('done');
      setTimeout(() => setProcessState('idle'), 2400);
    }, 6500);
  }, [processState]);

  const cancel = React.useCallback(() => setProcessState('idle'), []);

  return { auto, setAuto, processState, score, startProcessing, cancel };
}

Object.assign(window, { useHelpFlow });
