/**
 * @file atoms/Skull — small original pixel skull glyph.
 * NOT a Watch_Dogs / Ubisoft asset; an original 16x16 pixel composition.
 * @param {{size?: number, color?: string}} props
 */
function Skull({ size = 20, color }) {
  const c = color || COL.ink;
  return (
    <svg width={size} height={size} viewBox="0 0 16 16" style={{ display: 'inline-block', verticalAlign: 'middle' }}>
      <rect x="3" y="2" width="10" height="2" fill={c}/>
      <rect x="2" y="4" width="12" height="6" fill={c}/>
      <rect x="5" y="6" width="2" height="2" fill="#000"/>
      <rect x="9" y="6" width="2" height="2" fill="#000"/>
      <rect x="7" y="9" width="2" height="1" fill="#000"/>
      <rect x="3" y="10" width="2" height="2" fill={c}/>
      <rect x="6" y="10" width="1" height="2" fill={c}/>
      <rect x="9" y="10" width="1" height="2" fill={c}/>
      <rect x="11" y="10" width="2" height="2" fill={c}/>
      <rect x="3" y="12" width="3" height="1" fill={c}/>
      <rect x="10" y="12" width="3" height="1" fill={c}/>
    </svg>
  );
}
Object.assign(window, { Skull });
