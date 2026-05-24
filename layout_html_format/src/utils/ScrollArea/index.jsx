/**
 * @file utils/ScrollArea — flex-grow scrollable region (`overflow: auto`).
 * Required `minHeight: 0` is set automatically so the area never blows past
 * its parent's bounds (preserves sticky footers).
 *
 * @param {{ padding?: string|number, children?: any, style?: object, refEl?: React.RefObject<HTMLDivElement> }} props
 */
function ScrollArea({ padding = 0, children, style = {}, refEl }) {
  return (
    <div ref={refEl} style={{
      flex: 1, overflow: 'auto', minHeight: 0, padding,
      ...style,
    }}>{children}</div>
  );
}
Object.assign(window, { ScrollArea });
