/**
 * @file molecules/TopBar — phone-internal status bar (wordmark + counters).
 * @param {{score?: number, supporters?: number}} props
 */
function TopBar({ score = 12, supporters = 4328 }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 8,
      padding: '10px 14px 8px', background: COL.bg,
      borderBottom: `1px solid ${COL.line}`,
    }}>
      <Wordmark size={11} />
      <div style={{ flex: 1 }} />
      <div style={{
        fontFamily: FONT.pixel, fontSize: 8, color: COL.acid,
        display: 'flex', alignItems: 'center', gap: 4,
      }}>
        <Eye size={11} color={COL.acid}/> {score}
      </div>
      <div style={{
        fontFamily: FONT.pixel, fontSize: 8, color: COL.magenta,
        display: 'flex', alignItems: 'center', gap: 4,
      }}>
        <Skull size={11} color={COL.magenta}/> {supporters.toLocaleString('pt-BR')}
      </div>
    </div>
  );
}
Object.assign(window, { TopBar });
