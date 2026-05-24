/**
 * @file organisms/loaders/LoaderTokenStream — L7: LLM token streaming.
 * Thin wrapper that just frames the shared TokenStreamPanel.
 */
function LoaderTokenStream() {
  return (
    <div style={{ flex: 1, background: '#020608', display: 'flex', flexDirection: 'column' }}>
      <TokenStreamPanel/>
    </div>
  );
}
Object.assign(window, { LoaderTokenStream });
