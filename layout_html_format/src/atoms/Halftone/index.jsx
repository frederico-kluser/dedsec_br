/**
 * @file atoms/Halftone — radial-gradient dotted texture.
 * @param {{color?: string, size?: number, opacity?: number, style?: object, children?: any}} props
 */
function Halftone({ color = '#000', size = 4, opacity = 0.4, style = {}, children }) {
  return (
    <div style={{
      position: 'relative',
      backgroundImage: `radial-gradient(${color} 1px, transparent 1.2px)`,
      backgroundSize: `${size}px ${size}px`,
      opacity,
      ...style,
    }}>{children}</div>
  );
}
Object.assign(window, { Halftone });
