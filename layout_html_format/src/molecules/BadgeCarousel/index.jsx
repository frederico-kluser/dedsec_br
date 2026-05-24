/**
 * @file molecules/BadgeCarousel — horizontal strip of owned badges.
 * Each entry shows a notification dot if it is in `unopened`.
 *
 * @param {{
 *   badges: Badge[],
 *   owned: Set<string>,
 *   unopened: Set<string>,
 *   onPick: (b: Badge) => void,
 * }} props
 */
function BadgeCarousel({ badges, owned, unopened, onPick }) {
  const ownedBadges = badges.filter(b => owned.has(b.id));
  if (ownedBadges.length === 0) {
    return (
      <div style={{
        padding: 14, fontFamily: FONT.mono, fontSize: 11, color: COL.inkMute,
        textAlign: 'center', border: `1.5px dashed ${COL.line}`,
      }}>// nenhum selo ainda. processe sua primeira pauta.</div>
    );
  }
  return (
    <div style={{
      display: 'flex', gap: 10, overflowX: 'auto', padding: '4px 2px 12px',
      WebkitOverflowScrolling: 'touch',
    }}>
      {ownedBadges.map(b => {
        const isNew = unopened.has(b.id);
        const cat = BADGE_CATEGORIES[b.category];
        return (
          <button key={b.id} onClick={() => onPick(b)} style={{
            position: 'relative', flexShrink: 0, width: 88,
            background: COL.panel, border: `2px solid ${cat.color}`,
            padding: '12px 6px 10px', cursor: 'pointer', textAlign: 'center',
            boxShadow: isNew ? `0 0 14px ${cat.color}88` : '4px 4px 0 #000',
          }}>
            <div style={{ fontSize: 32, lineHeight: 1, marginBottom: 6 }}>{b.emoji}</div>
            <div style={{
              fontFamily: FONT.pixel, fontSize: 7, color: COL.ink,
              letterSpacing: 0.5, lineHeight: 1.2,
              height: 18, display: 'flex', alignItems: 'center', justifyContent: 'center',
              overflow: 'hidden',
            }}>{b.title.toUpperCase()}</div>
            {isNew && (
              <div style={{
                position: 'absolute', top: -6, right: -6,
                width: 18, height: 18, background: COL.magenta, color: '#fff',
                border: '2px solid #000', borderRadius: '50%',
                fontFamily: FONT.pixel, fontSize: 7, lineHeight: '14px',
                animation: 'blink 1.5s steps(2) infinite',
              }}>!</div>
            )}
          </button>
        );
      })}
    </div>
  );
}
Object.assign(window, { BadgeCarousel });
