/**
 * @file molecules/BadgeMosaic — hexagonal grid (6×4) showing owned/locked
 * badges. Magenta = owned, acid = locked. Supports drag-pan, wheel zoom,
 * pinch zoom and explicit +/- buttons.
 *
 * @param {{
 *   badges: Badge[],
 *   owned: Set<string>,
 *   unopened: Set<string>,
 *   onBadgeClick: (b: Badge) => void,
 * }} props
 */
function BadgeMosaic({ badges, owned, unopened, onBadgeClick }) {
  const COLS = 6, ROWS = 4, hexW = 52, hexH = 58;

  const cells = React.useMemo(() => {
    const list = [];
    for (let r = 0; r < ROWS; r++) {
      for (let c = 0; c < COLS; c++) {
        const idx = r * COLS + c;
        const badge = badges[idx];
        if (!badge) continue;
        const y = r * hexH + (c % 2 === 1 ? hexH * 0.5 : 0);
        const x = c * hexW * 0.78;
        list.push({ x, y, badge });
      }
    }
    return list;
  }, [badges]);

  const totalW = COLS * hexW * 0.78 + hexW * 0.22;
  const totalH = ROWS * hexH + hexH * 0.5;

  const [zoom, setZoom] = React.useState(1);
  const [pan, setPan]   = React.useState({ x: 0, y: 0 });
  const drag  = React.useRef({ active: false, x: 0, y: 0, sx: 0, sy: 0 });
  const pinch = React.useRef({ active: false, d0: 0, z0: 1 });

  const clamp = (v, min, max) => Math.max(min, Math.min(max, v));
  const setZoomClamped = (z) => setZoom(clamp(z, 0.7, 2.5));

  // ── Mouse + single-touch drag ──────────────────────────────
  const startDrag = (cx, cy) => {
    drag.current = { active: true, x: cx, y: cy, sx: pan.x, sy: pan.y };
  };
  const moveDrag = (cx, cy) => {
    if (!drag.current.active) return;
    setPan({ x: drag.current.sx + (cx - drag.current.x), y: drag.current.sy + (cy - drag.current.y) });
  };
  const endDrag = () => { drag.current.active = false; };

  const onMouseDown = (e) => { e.preventDefault(); startDrag(e.clientX, e.clientY); };
  const onMouseMove = (e) => moveDrag(e.clientX, e.clientY);
  const onMouseUp   = endDrag;
  const onWheel = (e) => {
    e.preventDefault();
    setZoomClamped(zoom + (e.deltaY < 0 ? 0.12 : -0.12));
  };

  // ── Touch (single + pinch) ─────────────────────────────────
  const onTouchStart = (e) => {
    if (e.touches.length === 2) {
      const [a, b] = e.touches;
      const dx = a.clientX - b.clientX, dy = a.clientY - b.clientY;
      pinch.current = { active: true, d0: Math.hypot(dx, dy), z0: zoom };
    } else if (e.touches.length === 1) {
      startDrag(e.touches[0].clientX, e.touches[0].clientY);
    }
  };
  const onTouchMove = (e) => {
    if (e.touches.length === 2 && pinch.current.active) {
      const [a, b] = e.touches;
      const d = Math.hypot(a.clientX - b.clientX, a.clientY - b.clientY);
      setZoomClamped(pinch.current.z0 * (d / pinch.current.d0));
    } else if (e.touches.length === 1) {
      moveDrag(e.touches[0].clientX, e.touches[0].clientY);
    }
  };
  const onTouchEnd = (e) => {
    if (e.touches.length === 0) {
      endDrag();
      pinch.current.active = false;
    }
  };

  const reset = () => { setZoom(1); setPan({ x: 0, y: 0 }); };

  return (
    <div style={{
      position: 'relative', background: '#0a0a0a',
      border: `1.5px solid ${COL.line}`, overflow: 'hidden',
      touchAction: 'none', userSelect: 'none', cursor: drag.current.active ? 'grabbing' : 'grab',
      height: 290,
    }}
    onMouseDown={onMouseDown}
    onMouseMove={onMouseMove}
    onMouseUp={onMouseUp}
    onMouseLeave={onMouseUp}
    onWheel={onWheel}
    onTouchStart={onTouchStart}
    onTouchMove={onTouchMove}
    onTouchEnd={onTouchEnd}
    >
      <Scanlines opacity={0.06}/>
      <div style={{
        position: 'absolute', left: '50%', top: '50%',
        width: totalW, height: totalH,
        marginLeft: -totalW / 2, marginTop: -totalH / 2,
        transform: `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`,
        transformOrigin: 'center center',
        transition: pinch.current.active || drag.current.active ? 'none' : 'transform 0.18s',
      }}>
        {cells.map(({ x, y, badge }) => {
          const isOwned = owned.has(badge.id);
          const isNew   = unopened.has(badge.id);
          return (
            <button key={badge.id} onClick={(e) => { e.stopPropagation(); onBadgeClick(badge); }}
              title={badge.title}
              style={{
                position: 'absolute', left: x, top: y,
                width: hexW, height: hexH, padding: 0,
                background: isOwned ? COL.magenta : '#0e1010',
                border: `2px solid ${isOwned ? '#000' : COL.acid + '55'}`,
                clipPath: 'polygon(25% 0%, 75% 0%, 100% 50%, 75% 100%, 25% 100%, 0% 50%)',
                cursor: 'pointer',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: isOwned ? '#000' : COL.acidD,
                boxShadow: isNew ? `0 0 14px ${COL.magenta}` : 'none',
                transition: 'transform 0.12s',
              }}
              onMouseEnter={e => e.currentTarget.style.transform = 'scale(1.1)'}
              onMouseLeave={e => e.currentTarget.style.transform = 'scale(1)'}
            >
              <span style={{
                fontSize: 20, lineHeight: 1,
                filter: isOwned ? 'none' : 'grayscale(1) opacity(0.45)',
              }}>{isOwned ? badge.emoji : '?'}</span>
              {isNew && (
                <span style={{
                  position: 'absolute', top: 4, right: 6,
                  width: 8, height: 8, background: COL.acid,
                  border: '1.5px solid #000', borderRadius: '50%',
                }}/>
              )}
            </button>
          );
        })}
      </div>

      {/* zoom controls */}
      <div style={{
        position: 'absolute', right: 8, bottom: 8, display: 'flex', flexDirection: 'column', gap: 4,
      }}>
        {[
          { glyph: '+', onClick: () => setZoomClamped(zoom + 0.2) },
          { glyph: '−', onClick: () => setZoomClamped(zoom - 0.2) },
          { glyph: '↺', onClick: reset },
        ].map(b => (
          <button key={b.glyph} onClick={(e) => { e.stopPropagation(); b.onClick(); }} style={{
            width: 28, height: 28, background: '#000',
            border: `1.5px solid ${COL.acid}`, color: COL.acid,
            fontFamily: FONT.pixel, fontSize: 14, cursor: 'pointer', padding: 0,
          }}>{b.glyph}</button>
        ))}
      </div>

      {/* zoom indicator */}
      <div style={{
        position: 'absolute', left: 8, bottom: 8,
        fontFamily: FONT.pixel, fontSize: 8, color: COL.acid, letterSpacing: 1,
        background: 'rgba(0,0,0,0.6)', padding: '4px 6px',
      }}>{Math.round(zoom * 100)}%</div>

      {/* legend */}
      <div style={{
        position: 'absolute', left: 8, top: 8,
        fontFamily: FONT.pixel, fontSize: 7, color: COL.inkDim, letterSpacing: 1,
        background: 'rgba(0,0,0,0.6)', padding: '4px 6px',
        display: 'flex', alignItems: 'center', gap: 8,
      }}>
        <span><span style={{ display: 'inline-block', width: 8, height: 8, background: COL.magenta, marginRight: 3, verticalAlign: 'middle' }}/> SEU</span>
        <span><span style={{ display: 'inline-block', width: 8, height: 8, background: '#0e1010', border: `1.5px solid ${COL.acid}`, marginRight: 3, verticalAlign: 'middle' }}/> FALTA</span>
      </div>
    </div>
  );
}
Object.assign(window, { BadgeMosaic });
