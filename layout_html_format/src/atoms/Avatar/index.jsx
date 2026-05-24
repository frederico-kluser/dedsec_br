/**
 * @file atoms/Avatar — DiceBear identicon (https://dicebear.com).
 * Loads the SVG from the public REST API. The same seed always renders
 * the same image, so a stable user identity = stable avatar.
 */

const DICEBEAR_PALETTE = 'ff1466,b7ff2a,ffd60a,7fc8ff,1a1a1a';

/**
 * @param {{seed?: string, style?: string, size?: number, border?: boolean, bg?: string}} props
 */
function Avatar({ seed = 'anon', style = 'identicon', size = 32, border = true, bg }) {
  const url = `https://api.dicebear.com/9.x/${style}/svg?seed=${encodeURIComponent(seed)}&backgroundColor=${DICEBEAR_PALETTE}`;
  return (
    <div style={{
      width: size, height: size, flexShrink: 0,
      background: bg || '#1c1c1c',
      border: border ? `2px solid #000` : 'none',
      overflow: 'hidden', position: 'relative',
      boxShadow: border ? `2px 2px 0 ${COL.line}` : 'none',
    }}>
      <img src={url} width={size} height={size} loading="lazy" alt=""
           style={{ display: 'block', imageRendering: 'pixelated' }}/>
    </div>
  );
}

Object.assign(window, { Avatar, DICEBEAR_PALETTE });
