/**
 * @file utils/StatBox — pixel label + big number, the unit used across
 * Help, Counter loader and NewPost preview.
 *
 * @param {{ label: string, value: any, color?: string, size?: number }} props
 */
function StatBox({ label, value, color, size = 22 }) {
  return (
    <div style={{ padding: '12px 14px', textAlign: 'left' }}>
      <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.2 }}>{label}</div>
      <div style={{ fontFamily: FONT.pixel, fontSize: size, color: color || COL.ink, marginTop: 4 }}>{value}</div>
    </div>
  );
}
Object.assign(window, { StatBox });
