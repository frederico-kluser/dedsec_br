/**
 * @file utils/ScreenRoot — full-height phone screen container.
 * Encapsulates the `flex column + minHeight: 0` pattern used on every page,
 * with optional `position: relative` for overlays.
 *
 * @param {{ relative?: boolean, children?: any, style?: object }} props
 */
function ScreenRoot({ relative = true, children, style = {} }) {
  return (
    <div style={{
      flex: 1, background: COL.bg, color: COL.ink,
      display: 'flex', flexDirection: 'column', minHeight: 0,
      position: relative ? 'relative' : 'static',
      ...style,
    }}>{children}</div>
  );
}
Object.assign(window, { ScreenRoot });
