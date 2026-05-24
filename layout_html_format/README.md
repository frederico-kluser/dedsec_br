# Dedsec_BR — protótipo de interface

Protótipo de alta fidelidade, em web, para o app cívico **Dedsec_BR**: um celular brasileiro que processa pautas localmente com IA, sem login e sem coletar dados pessoais. Roda 100% no navegador, sem build, sem servidor — abrir o HTML é o suficiente.

> ⚠ Visual original inspirado em estética pop-art / glitch / cyberpunk. **Não** usa logo, ilustrações ou UI do jogo Watch_Dogs® (Ubisoft®) — só o conceito de "célula cívica" como inspiração temática.

---

## Stack

| Camada | Tecnologia |
|---|---|
| UI | React 18 (UMD) + JSX via Babel-standalone |
| Estilo | CSS + inline styles + tokens de design (`COL`, `FONT`) |
| Avatares | [DiceBear 9.x](https://www.dicebear.com) — estilo `identicon` |
| Build | **nenhum** — `<script type="text/babel" src="...">` em ordem |
| Tipos | JSDoc — todos os componentes e hooks documentados |

---

## Como rodar

Abra `Dedsec BR Prototype.html` em qualquer navegador moderno. Pronto. Sem `npm install`, sem `npm run dev`. Os arquivos `.jsx` são carregados pelo Babel diretamente.

### Servir localmente (opcional)

Se quiser fontes/avatares com CORS limpo, suba um servidor estático:

```bash
python3 -m http.server 8000
# abrir http://localhost:8000/Dedsec%20BR%20Prototype.html
```

---

## Estrutura — Atomic Design

```
src/
├── constants/                       Tokens de design e regras puras
│   ├── colors.jsx                   COL — paleta (magenta/acid/alert/danger…)
│   ├── fonts.jsx                    FONT — stacks tipográficos
│   └── moderation.jsx               BLOCKED_WORDS + moderateText()
│
├── hooks/                           Lógica reativa (state isolado da view)
│   ├── useTick/                     contador para animações
│   ├── useScramble/                 efeito de "decoding text"
│   ├── useUser/                     identidade anônima estável
│   ├── useTopics/                   tópicos do fórum + replies
│   └── useForumNav/                 escopo selecionado + tópico atual
│
├── atoms/                           14 componentes mínimos reutilizáveis
│   ├── Halftone/    Grain/      Scanlines/   Glitch/
│   ├── Wordmark/    Stencil/    PixelChip/   PixelBar/
│   ├── Btn/         GhostBtn/   CautionTape/
│   └── Skull/       Eye/        Avatar/
│
├── molecules/                       7 composições pequenas
│   ├── TopBar/        TabBar/         ComicPanel/
│   ├── NewsCard/      ScopeChip/      LoaderShowcase/
│   └── TokenStreamPanel/
│
├── organisms/                       Composições maiores e overlays
│   ├── ModerationOverlay/           overlay full-bleed: checking | blocked
│   ├── AnalysisOverlay/             overlay full-bleed: análise IA + fases
│   └── loaders/                     15 loaders temáticos (L1 – L15)
│       ├── LoaderTerminal/          L1  CRT boot log
│       ├── LoaderHalftone/          L2  pulso pop-art
│       ├── LoaderRadar/             L3  varredura P2P
│       ├── LoaderDataTape/          L4  fita de dados vertical
│       ├── LoaderCounter/           L5  contador + caveiras
│       ├── LoaderGlitch/            L6  glitch + comic burst
│       ├── LoaderTokenStream/       L7  stream de tokens LLM
│       ├── LoaderBinaryRain/        L8  chuva binária matrix-style
│       ├── LoaderSpectrum/          L9  equalizer
│       ├── LoaderHexMosaic/         L10 mosaico hexagonal
│       ├── LoaderGlyphDecode/       L11 decifrador de arquivo
│       ├── LoaderTokenAttention/    L12 matriz de atenção
│       ├── LoaderTokenBeam/         L13 top-K sampling
│       ├── LoaderTokenRAG/          L14 retrieval-augmented gen
│       └── LoaderTokenLayers/       L15 transformer stack viz
│
├── templates/                       Layouts de página
│   ├── AndroidDevice/               bezel + status bar + nav bar
│   └── AppShell/                    sidebar + stage + frame
│
├── utils/                           Primitivas e dados compartilhados (DRY)
│   ├── ScreenRoot/                  flex column + minHeight: 0 (root de toda tela)
│   ├── ScrollArea/                  área rolável (flex 1 + overflow auto)
│   ├── BackHeader/                  header com ← VOLTAR + slot à direita
│   ├── StickyFooter/                barra inferior com border-top
│   ├── Toggle/                      switch on/off (sm | md)
│   ├── StatBox/                     label pixel + número grande
│   ├── RankingPanel/                ranking cidade/estado/país + top 5
│   ├── format.jsx                   formatRank, formatNum, topPercent
│   └── ranking.jsx                  LEADERBOARD_CITY, SCOPE_TOTALS, computeRanks
│
├── pages/                           15 telas — state e view separados
│   ├── Splash/         Onboarding/    Interests/      City/        Perms/
│   ├── Home/                          → index.jsx + Home.data.jsx (NEWS)
│   ├── Detail/         Channels/
│   ├── Generate/                      → index.jsx + Generate.state.jsx
│   ├── Help/                          → index.jsx + Help.state.jsx (useHelpFlow)
│   ├── ForumScope/     ForumList/
│   ├── Topic/                         → index.jsx + Topic.state.jsx (useTopicComposer)
│   ├── NewPost/                       → index.jsx + NewPost.state.jsx + NewPost.analysis.jsx
│   └── Settings/
│
├── app/                             Composição de topo
│   ├── screenRegistry.jsx           SCREENS, PHASES, LOADER_META, LOADER_COMP
│   ├── App.state.jsx                useAppState() — wiring central
│   └── index.jsx                    <App/> + ReactDOM.createRoot()
│
└── styles.css                       resets + keyframes (blink, sweep, pulse-out…)
```

### Por que `index.jsx` em vez de `index.ts`

O ambiente roda Babel-no-browser, sem bundler. TypeScript real não é executável aqui. Para preservar o espírito do pedido, cada componente:

- mora em sua **própria pasta**
- expõe um único `index.jsx` (entrada pública)
- tem **JSDoc completo** com `@typedef`, `@param`, `@returns`
- é exportado via `Object.assign(window, { ... })` ao final do arquivo

Editores modernos (VS Code, WebStorm) leem JSDoc e dão autocomplete/checagem como se fosse TypeScript.

---

## Padrão de separação `state ↔ view`

Para páginas com lógica não trivial, o estado fica em um arquivo `.state.jsx` (um hook custom) e o componente da view consome esse hook:

```jsx
// pages/Topic/Topic.state.jsx
function useTopicComposer({ replies, addReply }) {
  const [input, setInput] = React.useState('');
  // … toda a lógica
  return { input, setInput, send, mod, /* … */ };
}

// pages/Topic/index.jsx
function ScreenTopic(props) {
  const { input, setInput, send, mod } = useTopicComposer(props);
  return ( /* JSX puro */ );
}
```

Páginas triviais (Splash, Interests, City, Perms…) mantêm tudo no `index.jsx` — separar daria mais ruído do que clareza.

O **topo da árvore** está dividido em três:

| Arquivo | Papel |
|---|---|
| `app/App.state.jsx` | `useAppState()` — único hook que cria toda a árvore de estado |
| `app/screenRegistry.jsx` | Dados puros: lista de telas, cores de fase, registry de loaders |
| `app/index.jsx` | Composição final: `<App>` → `<AppShell>` + `renderScreen()` |
| `templates/AppShell/index.jsx` | View pura (sidebar + stage) — não conhece estado |

---

## Telas

| # | Tela | Path | Notas |
|---|---|---|---|
| 01 | Splash | `pages/Splash` | boot + download do modelo |
| 02 | Onboarding | `pages/Onboarding` | 3 cards pop-art |
| 03 | Interesses | `pages/Interests` | seleção de causas, mín. 3 |
| 04 | Cidade | `pages/City` | single-pick municipal |
| 05 | Permissões | `pages/Perms` | manifesto de privacidade |
| 06 | Home / Feed | `pages/Home` | feed por escopo |
| 07 | Detalhe da pauta | `pages/Detail` | autoridades alvo |
| 08 | Gerar mensagem | `pages/Generate` | 3 variações tonais |
| 09 | Canais | `pages/Channels` | deep links p/ IG/X/WA |
| 10 | Ajude a Célula | `pages/Help` | crowdsourcing LLM com Token Stream |
| 11 | Fórum · escopo | `pages/ForumScope` | mun / est / fed (badges de novos) |
| 12 | Fórum · pautas | `pages/ForumList` | lista filtrada + FAB nova pauta |
| 13 | Post | `pages/Topic` | thread + envio + apagar (sem editar) + moderação |
| 14 | Nova Pauta + IA | `pages/NewPost` | form → análise → preview → publicar |
| 15 | Config | `pages/Settings` | regerar avatar (pseudônimo é estável) |

---

## Loaders (sessão dedicada na sidebar)

| ID | Tema | Notas |
|---|---|---|
| L1 | Terminal de Boot | logs CRT verde-ácido |
| L2 | Pulso Halftone | pop-art breathing + scramble |
| L3 | Varredura Radar | P2P sweep com blips |
| L4 | Fita de Dados | streaming vertical |
| L5 | Contador de Células | número grande + caveiras |
| L6 | Glitch Embaralhado | wordmark com RGB-split |
| **L7** | **Stream de Tokens** | **usado na tela "Processar 1 pauta"** |
| L8 | Chuva Binária | matrix-style com DEDSEC infiltrado |
| L9 | Espectro de Sinal | equalizer dançando |
| L10 | Mosaico Hex | hexágonos revelando do centro |
| L11 | Decifrador | scramble com lista de arquivos |
| L12 | Tokens · Atenção | attention weights coloridos |
| L13 | Tokens · Top-K | candidatos com probabilidade |
| L14 | Tokens · RAG | query → chunks → geração |
| L15 | Tokens · Camadas | grid 12×8 do transformer |

---

## Convenções de código

- Toda função/componente tem **JSDoc** com `@param`, `@returns` e `@typedef` quando aplicável
- `COL` e `FONT` são **únicos imports lógicos** — paletas e tipografia nunca hard-coded fora dali
- Componentes preferem `flex` / `grid` com `gap`, não margens em filhos
- `position: relative` no root + `position: absolute` em overlays de tela cheia
- Footer fixo: root é `flex column minHeight: 0`, áreas roláveis recebem `overflow: auto, minHeight: 0`
- Pseudo-código fica em comentários `// ...` em mono, parte do visual

---

## Identidade do usuário

- **Pseudônimo é estável** (`Cidadão_SP_xxxx`) — não muda enquanto a aba estiver aberta
- Apenas a **seed do avatar** é regenerável via Settings → REGERAR AVATAR
- Sem CPF, e-mail, telefone, geolocalização exata
- A `seed` é gerada localmente (`randomSeed()`) e usada como input do DiceBear

---

## Moderação local

`src/constants/moderation.jsx` traz uma lista mock de palavras bloqueadas — no momento apenas `['shit']` para teste. Antes de publicar qualquer reply, o `ModerationOverlay` simula 1.8s de inferência local. Se cair na blocklist, o usuário vê a tela "DISCURSO OFENSIVO" com botão pra editar ou descartar.

Em produção, esse passo seria a passada de classificação do Gemma 3 1B local — a estrutura está pronta para troca.

---

## Análise IA de pautas

Em `NewPost`, o conteúdo passa por 4 fases simuladas com tokens reais sendo "gerados" no `TokenStreamPanel`:

1. **lendo conteúdo** — tokenize + chunk
2. **classificando tema** — zero-shot · 20 categorias
3. **identificando autoridades** — lookup TSE + Câmara API
4. **gerando título + resumo** — gemma-3-1b · prompt cidadania

A classificação real (`analyzeText`) faz match de keywords em PT-BR e roteia para 9 temas (TRANSPORTE, SAÚDE, EDUCAÇÃO, ORÇAMENTO, MEIO AMBIENTE, CULTURA, SEGURANÇA, MORADIA, CORRUPÇÃO) com autoridades certas por escopo (municipal / estadual / federal).

---

## Adicionando uma tela nova

1. Criar `src/pages/MinhaTela/index.jsx` exportando `ScreenMinhaTela` via `Object.assign(window, ...)`
2. (Opcional) `src/pages/MinhaTela/MinhaTela.state.jsx` para o hook
3. Registrar em `src/app/screenRegistry.jsx` na lista `SCREENS`
4. Adicionar o `case` em `src/app/index.jsx` → `renderScreen()`
5. Adicionar `<script type="text/babel" src="src/pages/MinhaTela/index.jsx"></script>` no HTML (depois de molecules, antes de `app/`)

---

## Adicionando um loader

1. `src/organisms/loaders/LoaderXYZ/index.jsx` — função `LoaderXYZ()`
2. Registrar em `src/app/screenRegistry.jsx` em `SCREENS`, `LOADER_META` e `LOADER_COMP`
3. Adicionar `<script>` no HTML, junto dos outros loaders

---

## Privacidade — princípios

```
NÃO exigimos login.
NÃO coletamos nome, e-mail, telefone.
NÃO usamos localização exata.
NÃO rastreamos suas redes sociais.
NÃO postamos por você. Você revisa, você publica.
```

---

## Licença

AGPLv3 (declarada na tela de Settings) — a estrutura está pronta para liberação como open source.
