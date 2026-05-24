/**
 * @file useTick/index.jsx
 * Lightweight animation tick. Returns a monotonically-increasing counter
 * that updates every `ms` milliseconds.
 */

/**
 * Re-renders the caller every `ms` ms.
 * @param {number} [ms=80]
 * @returns {number} current tick
 */
function useTick(ms = 80) {
  const [t, setT] = React.useState(0);
  React.useEffect(() => {
    const id = setInterval(() => setT(x => x + 1), ms);
    return () => clearInterval(id);
  }, [ms]);
  return t;
}

Object.assign(window, { useTick });
