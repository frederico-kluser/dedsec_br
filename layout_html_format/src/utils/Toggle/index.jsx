/**
 * @file utils/Toggle — on/off switch in dedsec style. Replaces the inline
 * version that was duplicated in Perms, Help and Settings.
 *
 * @param {{
 *   value: boolean,
 *   onChange: () => void,
 *   size?: 'sm'|'md',
 *   onColor?: string,
 *   offColor?: string,
 * }} props
 */
function Toggle({ value, onChange, size = 'md', onColor, offColor }) {
  const dim = size === 'sm' ? { w: 46, h: 24, k: 16 } : { w: 50, h: 26, k: 18 };
  const on  = onColor  || COL.acid;
  const off = offColor || COL.panel;
  return (
    <button onClick={onChange} style={{
      width: dim.w, height: dim.h,
      background: value ? on : off,
      border: `1.5px solid ${value ? on : COL.line}`, cursor: 'pointer',
      position: 'relative', padding: 0, flexShrink: 0,
    }}>
      <div style={{
        position: 'absolute', top: 2, left: value ? dim.w - dim.k - 4 : 2,
        width: dim.k, height: dim.k, background: '#000', transition: 'left 0.18s',
      }}/>
    </button>
  );
}
Object.assign(window, { Toggle });
