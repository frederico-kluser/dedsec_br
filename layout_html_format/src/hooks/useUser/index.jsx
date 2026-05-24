/**
 * @file useUser/index.jsx
 * Anonymous identity. Pseudonym is generated once and is STABLE for the
 * session. `regenerateUser` rotates ONLY the avatar seed.
 */

/**
 * @typedef {Object} DedsecUser
 * @property {string} seed       DiceBear seed (rotates on regenerate)
 * @property {string} style      DiceBear style ('identicon')
 * @property {string} pseudonym  Stable display name
 * @property {string} city       'SP' (single-city prototype)
 */

/** @returns {string} short hex seed */
function randomSeed() {
  const chars = 'abcdef0123456789';
  let s = '';
  for (let i = 0; i < 6; i++) s += chars[Math.floor(Math.random() * chars.length)];
  return s;
}

/**
 * Derive a pseudonym from a seed (uses last 4 chars).
 * @param {string} seed
 * @param {string} [city='SP']
 * @returns {string}
 */
function pseudonymFromSeed(seed, city = 'SP') {
  return `Cidadão_${city}_${seed.slice(-4)}`;
}

/**
 * Hook that owns the local-only user identity.
 * @returns {{ user: DedsecUser, setUser: (u: DedsecUser) => void, regenerateUser: () => void }}
 */
function useUser() {
  const [user, setUser] = React.useState(() => {
    const seed = randomSeed();
    return { seed, style: 'identicon', pseudonym: pseudonymFromSeed(seed, 'SP'), city: 'SP' };
  });
  const regenerateUser = React.useCallback(() => {
    setUser(u => ({ ...u, seed: randomSeed() }));
  }, []);
  return { user, setUser, regenerateUser };
}

Object.assign(window, { useUser, randomSeed, pseudonymFromSeed });
