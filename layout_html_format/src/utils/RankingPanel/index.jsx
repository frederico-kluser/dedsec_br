/**
 * @file utils/RankingPanel — your rank in city/state/country + city top-5.
 * Belongs to the Ajude-a-Célula page, exposed via utils so the same data
 * could later appear in Settings or a public profile.
 *
 * @param {{ user: DedsecUser, score: number }} props
 */
function RankingPanel({ user, score }) {
  const ranks = computeRanks(score);
  const scopes = [
    { key: 'cidade', label: 'CIDADE', sub: 'São Paulo / SP', color: COL.magenta, data: ranks.cidade },
    { key: 'estado', label: 'ESTADO', sub: 'SP',             color: COL.acid,    data: ranks.estado },
    { key: 'pais',   label: 'PAÍS',   sub: 'Brasil',         color: COL.alert,   data: ranks.pais   },
  ];

  // user appears in the list at the bottom — synthesized row
  const userRow = { rank: ranks.cidade.rank, who: user.pseudonym, seed: user.seed, score, mine: true };
  // top 5 + user (skip dup if user is somehow in top 5)
  const top = LEADERBOARD_CITY.slice(0, 5);
  const showUserSeparately = !top.some(r => r.who === user.pseudonym);

  return (
    <div>
      {/* RANK CARDS */}
      <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5, margin: '0 0 8px' }}>
        // SEU RANKING
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 6 }}>
        {scopes.map(s => (
          <div key={s.key} style={{
            background: COL.panel, border: `1.5px solid ${COL.line}`,
            padding: '10px 8px', display: 'flex', flexDirection: 'column', gap: 3,
            borderTop: `3px solid ${s.color}`,
          }}>
            <div style={{ fontFamily: FONT.pixel, fontSize: 7, color: s.color, letterSpacing: 1 }}>{s.label}</div>
            <div style={{ fontFamily: FONT.pixel, fontSize: 16, color: COL.ink, lineHeight: 1 }}>
              {formatRank(s.data.rank)}
            </div>
            <div style={{ fontFamily: FONT.mono, fontSize: 9, color: COL.inkDim }}>
              de {formatNum(s.data.total)}
            </div>
            <div style={{ fontFamily: FONT.mono, fontSize: 9, color: s.color }}>
              top {topPercent(s.data.rank, s.data.total)}
            </div>
          </div>
        ))}
      </div>

      {/* TOP 5 */}
      <div style={{ fontFamily: FONT.pixel, fontSize: 8, color: COL.inkMute, letterSpacing: 1.5, margin: '18px 0 8px' }}>
        // TOP DA CIDADE
      </div>
      <div style={{ background: COL.panel, border: `1.5px solid ${COL.line}` }}>
        {top.map((row) => {
          const medal = row.rank === 1 ? '🥇' : row.rank === 2 ? '🥈' : row.rank === 3 ? '🥉' : null;
          return (
            <div key={row.rank} style={{
              display: 'flex', alignItems: 'center', gap: 10, padding: '10px 12px',
              borderBottom: `1px solid ${COL.line}`,
            }}>
              <span style={{
                width: 22, textAlign: 'center', fontFamily: FONT.pixel, fontSize: 10,
                color: row.rank <= 3 ? COL.acid : COL.inkMute,
              }}>{medal || '#' + row.rank}</span>
              <Avatar seed={row.seed} size={26}/>
              <span style={{
                flex: 1, minWidth: 0, fontFamily: FONT.mono, fontSize: 11, color: COL.ink,
                overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
              }}>{row.who}</span>
              <span style={{ fontFamily: FONT.pixel, fontSize: 11, color: COL.acid, flexShrink: 0 }}>
                {row.score}
              </span>
            </div>
          );
        })}
        {showUserSeparately && (
          <>
            <div style={{
              padding: '4px 12px', fontFamily: FONT.mono, fontSize: 9, color: COL.inkMute,
              background: '#0a0a0a', textAlign: 'center', letterSpacing: 1,
            }}>···  vários ranks abaixo  ···</div>
            <div style={{
              display: 'flex', alignItems: 'center', gap: 10, padding: '10px 12px',
              background: '#1a0a14', borderTop: `1.5px solid ${COL.magenta}`,
            }}>
              <span style={{
                width: 22, textAlign: 'center', fontFamily: FONT.pixel, fontSize: 10,
                color: COL.magenta,
              }}>#{userRow.rank}</span>
              <Avatar seed={userRow.seed} size={26}/>
              <span style={{
                flex: 1, minWidth: 0, fontFamily: FONT.mono, fontSize: 11, color: COL.ink,
                overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
              }}>{userRow.who}</span>
              <PixelChip color={COL.magenta} bg="#000" size={6}>VOCÊ</PixelChip>
              <span style={{ fontFamily: FONT.pixel, fontSize: 11, color: COL.magenta, flexShrink: 0 }}>
                {userRow.score}
              </span>
            </div>
          </>
        )}
      </div>

      <div style={{
        marginTop: 10, padding: 10, fontFamily: FONT.mono, fontSize: 10, color: COL.inkMute,
        border: `1px dashed ${COL.line}`, lineHeight: 1.5,
      }}>
        ranking atualiza em tempo real conforme você processa pautas.
      </div>
    </div>
  );
}

Object.assign(window, { RankingPanel });
