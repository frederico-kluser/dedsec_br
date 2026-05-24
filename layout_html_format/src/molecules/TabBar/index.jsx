/**
 * @file molecules/TabBar — bottom navigation.
 * @param {{active?: string, onTab?: (id: string) => void}} props
 */
const TABS = [
  { id: 'home',     label: 'PAUTAS', glyph: '▣' },
  { id: 'help',     label: 'AJUDAR', glyph: '✦' },
  { id: 'forum',    label: 'FÓRUM',  glyph: '◉' },
  { id: 'settings', label: 'CONFIG', glyph: '⚙' },
];

function TabBar({ active, onTab }) {
  return (
    <div style={{ display: 'flex', background: '#000', borderTop: `2px solid ${COL.line}` }}>
      {TABS.map(t => (
        <button key={t.id} onClick={() => onTab && onTab(t.id)} style={{
          flex: 1, background: active === t.id ? COL.magenta : 'transparent',
          border: 'none', cursor: 'pointer', padding: '10px 0',
          display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3,
          color: active === t.id ? '#000' : COL.inkDim,
        }}>
          <span style={{ fontSize: 16, lineHeight: 1 }}>{t.glyph}</span>
          <span style={{ fontFamily: FONT.pixel, fontSize: 7, letterSpacing: 1 }}>{t.label}</span>
        </button>
      ))}
    </div>
  );
}
Object.assign(window, { TabBar, TABS });
