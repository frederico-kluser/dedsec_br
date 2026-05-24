/**
 * @file molecules/LoaderShowcase — chrome wrapper for previewing a loader.
 * @param {{id?: string, Component: React.ComponentType, title?: string, subtitle?: string}} props
 */
function LoaderShowcase({ id, Component, title, subtitle }) {
  return (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', background: '#000' }}>
      <div style={{
        padding: '12px 16px', borderBottom: `1px solid ${COL.line}`,
        display: 'flex', alignItems: 'center', gap: 10,
      }}>
        <span style={{ fontFamily: FONT.pixel, fontSize: 9, color: COL.acid, letterSpacing: 1.5 }}>{id}</span>
        <span style={{ fontFamily: FONT.body, fontSize: 13, color: COL.ink, fontWeight: 600 }}>{title}</span>
        <div style={{ flex: 1 }}/>
        <span style={{ fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute }}>{subtitle}</span>
      </div>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
        <Component/>
      </div>
    </div>
  );
}
Object.assign(window, { LoaderShowcase });
