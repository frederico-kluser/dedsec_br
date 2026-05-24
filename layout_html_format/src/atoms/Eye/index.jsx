/**
 * @file atoms/Eye — surveillance eye glyph.
 * @param {{size?: number, color?: string}} props
 */
function Eye({ size = 16, color }) {
  const c = color || COL.acid;
  return (
    <svg width={size} height={size} viewBox="0 0 16 16" style={{ display: 'inline-block', verticalAlign: 'middle' }}>
      <rect x="2" y="6" width="12" height="4" fill={c}/>
      <rect x="1" y="7" width="14" height="2" fill={c}/>
      <rect x="6" y="6" width="4" height="4" fill="#000"/>
      <rect x="7" y="7" width="2" height="2" fill={c}/>
    </svg>
  );
}
Object.assign(window, { Eye });
