/**
 * @file pages/Topic/Topic.state — reply composer + moderation pipeline.
 */

/**
 * Composes the topic view's input/moderation state.
 * @param {{ replies: ForumReply[], addReply: (t: string) => void, deleteReply: (id: string) => void }} args
 * @returns {{
 *   input: string,
 *   setInput: (s: string) => void,
 *   mod: { phase: 'idle'|'checking'|'blocked', text: string, word: string },
 *   confirmId: string|null,
 *   setConfirmId: (id: string|null) => void,
 *   scrollRef: React.RefObject<HTMLDivElement>,
 *   send: () => void,
 *   dismissMod: () => void,
 *   discardInput: () => void,
 * }}
 */
function useTopicComposer({ replies, addReply }) {
  const [input, setInput]       = React.useState('');
  const [confirmId, setConfirmId] = React.useState(null);
  const [mod, setMod]           = React.useState({ phase: 'idle', text: '', word: '' });
  const scrollRef               = React.useRef(null);
  const prevLengthRef           = React.useRef(replies.length);

  // Auto-scroll ONLY when a new reply is appended (not on mount or topic-switch).
  React.useEffect(() => {
    if (replies.length > prevLengthRef.current && scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
    prevLengthRef.current = replies.length;
  }, [replies.length]);

  const send = React.useCallback(() => {
    const text = input.trim();
    if (!text || mod.phase !== 'idle') return;
    setMod({ phase: 'checking', text, word: '' });
    setTimeout(() => {
      const result = moderateText(text);
      if (result.blocked) {
        setMod({ phase: 'blocked', text, word: result.word });
      } else {
        addReply(text);
        setInput('');
        setMod({ phase: 'idle', text: '', word: '' });
      }
    }, 1800);
  }, [input, mod.phase, addReply]);

  const dismissMod   = React.useCallback(() => setMod({ phase: 'idle', text: '', word: '' }), []);
  const discardInput = React.useCallback(() => { setInput(''); dismissMod(); }, [dismissMod]);

  return { input, setInput, mod, confirmId, setConfirmId, scrollRef, send, dismissMod, discardInput };
}

Object.assign(window, { useTopicComposer });
