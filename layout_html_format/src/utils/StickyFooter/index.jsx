/**
 * @file utils/StickyFooter — bottom action area sitting above a screen footer
 * (tab bar etc.) Wraps its children with a uniform border-top + padding.
 *
 * @param {{ children?: any, padding?: string, style?: object }} props
 */
function StickyFooter({ children, padding = '14px 18px', style = {} }) {
  return (
    <div style={{
      padding, background: COL.bg, borderTop: `1px solid ${COL.line}`,
      display: 'flex', alignItems: 'center', gap: 10,
      ...style,
    }}>{children}</div>
  );
}
Object.assign(window, { StickyFooter });
