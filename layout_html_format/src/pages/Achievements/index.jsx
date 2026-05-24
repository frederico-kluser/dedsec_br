/**
 * @file pages/Achievements — collectible badges page (carousel + mosaic + share).
 */
function ScreenAchievements({ go, user }) {
  const { owned, unopened, open, total, ownedCount } = useAchievements();
  const [active, setActive] = React.useState(null);

  const pickBadge = (b) => {
    if (owned.has(b.id) && unopened.has(b.id)) open(b.id);
    setActive(b);
  };

  return (
    <ScreenRoot>
      <BackHeader label="VOLTAR" onBack={() => go('help')}>
        <PixelChip color={COL.acid} bg="#000" size={8}>{ownedCount}/{total} SELOS</PixelChip>
      </BackHeader>

      <ScrollArea padding="18px 16px 80px">
        <PixelChip color={COL.magenta} bg="#000">// COLEÇÃO</PixelChip>
        <Stencil size={36} style={{ marginTop: 10, lineHeight: 0.95 }}>
          SELOS<br/><span style={{ color: COL.magenta, textShadow: `3px 3px 0 ${COL.acid}` }}>CONQUISTADOS</span>
        </Stencil>
        <div style={{ fontFamily: FONT.body, fontSize: 13, color: COL.inkDim, marginTop: 10, lineHeight: 1.5 }}>
          Você desbloqueou <b style={{ color: COL.acid }}>{ownedCount}</b> de {total}.{' '}
          {unopened.size > 0 && (
            <span style={{ color: COL.magenta }}>{unopened.size} novos pra abrir.</span>
          )}
        </div>

        {/* CAROUSEL */}
        <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5, margin: '18px 0 4px' }}>
          // SEUS SELOS
        </div>
        <BadgeCarousel badges={BADGES} owned={owned} unopened={unopened} onPick={pickBadge}/>

        {/* MOSAIC */}
        <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5, margin: '14px 0 8px' }}>
          // MOSAICO DA COLEÇÃO · pinch / scroll p/ zoom
        </div>
        <BadgeMosaic badges={BADGES} owned={owned} unopened={unopened} onBadgeClick={pickBadge}/>

        {/* CATEGORY LEGEND */}
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 14 }}>
          {Object.entries(BADGE_CATEGORIES).map(([k, c]) => {
            const catBadges = BADGES.filter(b => b.category === k);
            const catOwned  = catBadges.filter(b => owned.has(b.id)).length;
            return (
              <div key={k} style={{
                fontFamily: FONT.pixel, fontSize: 8, padding: '6px 8px',
                background: '#000', color: c.color, border: `1px solid ${c.color}`,
                letterSpacing: 0.8,
              }}>{c.label} {catOwned}/{catBadges.length}</div>
            );
          })}
        </div>
      </ScrollArea>

      <BadgeShareModal
        badge={active}
        user={user}
        isLocked={active && !owned.has(active.id)}
        onClose={() => setActive(null)}
      />
    </ScreenRoot>
  );
}
Object.assign(window, { ScreenAchievements });
