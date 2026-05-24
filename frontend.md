# Dedsec — Stack de Desenvolvimento Local: Flutter, Mac mini M1 e Mock Backend

## TL;DR

- **Vá de Flutter.** É a única decisão defensável em 2026 quando o critério #1 é rodar Gemma 3 1B on-device via MediaPipe LLM Inference: o plugin `flutter_gemma` (Sasha Denisov, Google Developer Expert) é o wrapper mais maduro do ecossistema cross-platform, suporta `.task` e `.litertlm`, GPU acceleration, function calling e on-device RAG; o equivalente RN (`expo-llm-mediapipe`, `react-native-llm-mediapipe`) tem manutenção mais frágil e nenhum mantenedor com vínculo claro com o time do Gemma.
- **Stack local definitivo no Mac mini M1 16GB:** Flutter (via fvm) + Xcode + Android Studio (1 emulador Pixel 6 API 34) + VS Code/Cursor + mise (Node/Go/Python/JDK) + Melos (monorepo) + Docker Compose (MinIO via Chainguard + Postgres + API Go mock + Caddy + Anubis + servidor OTS regtest) + Proxyman + mkcert + Ollama (Gemma 3 1B servindo o Mac para fixtures de pauta). Rode no máximo 1 simulador iOS + 1 emulador Android + 1 device físico ao mesmo tempo para não estourar os 16GB.
- **Mock = produção em miniatura.** Tudo num único `docker-compose.yml` reproduzível; o app aponta pra `https://api.dedsec.local` (mkcert) em dev e pra `https://api.dedsec.app` em prod via variável de ambiente — porta para Magalu é trocar o DNS/URL e nada mais.

---

## Key Findings

1. **`flutter_gemma` é o caminho de menor risco para o requisito #1.** Envelopa diretamente a MediaPipe LLM Inference API e a LiteRT-LM, suporta o arquivo `gemma3-1B-it-int4.task` (~530MB) sem conversão, oferece GPU acceleration no Android, isolates Dart para inferência em background, manutenção ativa em 2025-2026.
2. **MediaPipe LLM Inference foi marcada como "deprecated" pelo Google em favor de LiteRT-LM, mas continua sendo a forma recomendada para mobile hoje.** O LiteRT-LM ainda está em Early Preview no iOS. React Native ExecuTorch é uma boa alternativa, mas o ExecuTorch da Meta não consome o `.task` do Google.
3. **Performance medida do Gemma 3 1B int4 é robusta.** No Galaxy S24 Ultra (Snapdragon 8 Gen 3) o modelo entrega **322 tok/s prefill / 47 tok/s decode no CPU** e **2.585 tok/s prefill / 56 tok/s decode no GPU** via MediaPipe (HuggingFace `litert-community/Gemma3-1B-IT`). Em midrange brasileiro (Snapdragon 6/7 Gen 1, Dimensity 7050-7300) não há benchmark oficial publicado.
4. **Biometria e cripto são paridade técnica entre os frameworks**, com leve vantagem para Flutter na ergonomia: `flutter_secure_storage` + `local_auth` e `flutter_sodium`/`sodium` via dart:ffi não passam por bridge JSI.
5. **Mac mini M1 16GB é suficiente, mas apertado.** Xcode + iOS Simulator + 1 emulador Android + Docker stack + Flutter tooling + Ollama servindo Gemma 3 1B = ~13-14 GB. Não dá pra rodar 3 emuladores Android simultâneos.
6. **Mock backend em Docker Compose substitui Magalu Cloud 1:1.** MinIO = Object Storage. Postgres dockerizado = DBaaS. otsd+bitcoind regtest = OpenTimestamps+Bitcoin. Caddy+mkcert = Caddy+Cloudflare. Anubis tem imagem Docker oficial.

---

## Details

### PARTE 1 — Decisão Definitiva: Flutter

#### 1. Qualidade do LLM on-device — VENCEDOR: Flutter, com larga vantagem.

**`flutter_gemma`** (pub.dev/packages/flutter_gemma) é o plugin mais completo do ecossistema cross-platform mobile para LLMs locais em 2026:

- Suporta `.task` (MediaPipe), `.litertlm` (LiteRT-LM) e `.bin/.tflite` no mesmo API.
- Modelos suportados em produção: Gemma 4 E2B/E4B, Gemma 3n, Gemma-3 1B, FunctionGemma 270M, Qwen3 0.6B, Phi-4 Mini, DeepSeek R1, SmolLM 135M.
- GPU acceleration nativa via MediaPipe (Adreno/Mali/Apple GPU).
- Multimodal: texto + imagem + áudio (Gemma 3n).
- Function calling, thinking mode, on-device RAG com HNSW local, text embeddings.
- Mantenedor é Google Developer Expert, com posts técnicos regulares no Medium da Google Developer Experts atualizando o ecossistema em 2025-2026.
- Exemplo funcional de Gemma 3 1B int4 rodando no iPhone via Flutter está publicado (KennethanCeyer/gemma3-chat-app).

**Equivalente em React Native:**
- `expo-llm-mediapipe` (tirthajyoti-ghosh) — wrapper community-grade. Existe e funciona, mantenedor único.
- `react-native-llm-mediapipe` (cdiddy77) — README ainda menciona "as of 4/22/2024, MediaPipe supports four models". Desatualizado.
- `@subhajit-gorai/react-native-mediapipe-llm` — demo focada em Gemma 3N.
- `react-native-executorch` (Software Mansion) — bem mantido, mas usa formato `.pte` (ExecuTorch da Meta), não `.task`. Modelos oficialmente suportados: Llama 3.2/3.1/3, Qwen 3, Phi-4-mini, LiquidAI LFM2 — **Gemma não está na lista oficial**.

**Performance medida (HuggingFace `litert-community/Gemma3-1B-IT`):**

| Device | Chip | Backend | Prefill (tok/s) | Decode (tok/s) | RAM peak |
|---|---|---|---|---|---|
| Galaxy S24 Ultra | SD 8 Gen 3 | MediaPipe CPU (int4 QAT, ekv=2048) | 322 | 47 | 1.138 MB |
| Galaxy S24 Ultra | SD 8 Gen 3 | MediaPipe GPU | 2.585 | 56 | 1.205 MB |
| Galaxy S25 Ultra | SD 8 Elite | LiteRT NPU (a16w4) | 5.836 | 85 | 626 MB |
| Galaxy A56 | Exynos 1580 | MediaPipe CPU (Gemma 3 **270M**) | — | 23,12 | 482 MB |
| iPhone 17 Pro | A19 Pro | MLX (Russet, ctx 690 in) | TTFT 1.330ms | ~30 | — |
| OnePlus 12 | SD 8 Gen 3 | ExecuTorch XNNPACK (**Llama 3.2 1B**) | 260 | 50,2 | — |

**Caveats:** O Google só publicou números no S24 Ultra com cpufreq fixado em "performance" (citação do Google Developers Blog, mar/2025: *"Measurements were taken on an Android Samsung Galaxy S24 Ultra with cpufreq governor set to performance"*). Não há benchmark oficial publicado para Snapdragon 6 Gen 1, 7 Gen 1, 7s Gen 2, ou Dimensity 7050-7300 com Gemma 3 1B. **Você tem que medir nos devices reais.**

**No iPhone, um detalhe importante:** segundo a documentação do `flutter_gemma` (pub.dev), o iOS Simulator fica em CPU-only porque o Metal sim tem cap de 256 MB por alocação — *"The Simulator stays CPU-only because Metal sim has a 256 MB single-allocation cap."* Para testar Gemma 3 1B em iOS, use device físico.

**Veredito do critério 1:** Flutter ganha porque você consome o modelo distribuído pelo próprio Google (.task) com um plugin maduro, sem pipeline de conversão.

#### 2. Biometria — empate técnico, ligeira vantagem para Flutter.

Ambos chegam às mesmas APIs nativas (iOS Keychain com Secure Enclave / Android Keystore com StrongBox quando disponível).

- **Flutter:** `flutter_secure_storage` + `local_auth`. Para exigir biometria a cada acesso: `IOSOptions(accessibility: KeychainAccessibility.passcode)` + accessControl com `kSecAccessControlBiometryCurrentSet` via plataforma. Android: `setUserAuthenticationRequired(true)` e `setUserAuthenticationValidityDurationSeconds(-1)`.
- **React Native:** `react-native-keychain` com `ACCESS_CONTROL.BIOMETRY_CURRENT_SET` + `ACCESSIBLE.WHEN_PASSCODE_SET_THIS_DEVICE_ONLY`.

Para Ed25519 dentro do Secure Enclave/StrongBox: nenhum dos dois oferece API direta cross-platform. Você vai precisar de MethodChannel/TurboModule custom para gerar chave non-exportable. Flutter tem ligeira vantagem porque dart:ffi simplifica chamadas nativas comparado ao bridge JSI do RN.

#### 3. Cripto nativa (libsodium) — empate.

- **`sodium`/`flutter_sodium`** (Dart) — usam dart:ffi com libsodium pré-compilada. Sem bridge.
- **`react-native-libsodium`** (sodium-friends/serenity-kit) — JSI, API espelha `libsodium-wrappers`.
- **`sodium-react-native-direct`** (synonymdev) — wrapper "thin" mais performante.

Para hash-chain com Ed25519 + X25519 + AES-GCM + Argon2id, ambos resolvem.

#### 4. UX cyberpunk — VENCEDOR: Flutter.

Flutter Impeller (default em ambos iOS/Android desde 3.27, 2026) entrega 60/120fps consistentes mesmo com animações complexas, pré-compilação de shaders elimina jank no primeiro render. Segundo a Foresight Mobile (foresightmobile.com, 2026), *"under heavy rendering loads, Flutter with Impeller delivers consistent 60/120 FPS, while React Native's JS thread contention can cause drops to 45-50 FPS during complex animations."*

#### 5. Comunidade — empate efetivo.

Em 2026: segundo o Stack Overflow Developer Survey 2023, publicado via Statista (nov. 2025), *"46 percent of software developers used Flutter"* contra ~35% para React Native. Em volume de pacotes: pub.dev ~40k pacotes Flutter, npm ~1.8M (maioria não-mobile). React Native tem 6x mais vagas nos EUA (mais relevante para hiring que para qualidade técnica). Para o domínio Dedsec (LLM on-device + cripto + protocolos custom), os pacotes que importam estão todos maduros nos dois ecossistemas.

#### 6. Curva de aprendizado — leve vantagem para Flutter para time pequeno do zero.

Dart é mais fácil de aprender que TypeScript+React+RN+Expo combinados. O time não vai tropeçar em "RN architecture old vs new", "Hermes vs JSC", "Expo vs bare workflow". Flutter tem caminho único.

#### 7. Performance em background — VENCEDOR: Flutter.

Flutter compila Dart AOT para ARM nativo, sem runtime JavaScript no caminho da inferência. `flutter_gemma` rodando em Isolate Dart consegue inferir sem bloquear UI thread. Em Android use `WorkManager` via plugin (`workmanager`); em iOS use BGProcessingTask.

#### Recomendação final: **Flutter**

Justificativa em uma frase: o ativo crítico do Dedsec é Gemma 3 1B rodando bem em qualquer celular brasileiro, e o caminho oficial Google para Gemma → mobile é MediaPipe LiteRT, cujo wrapper mais maduro é `flutter_gemma`.

#### Quando reconsiderar:
- Se já tivesse time React/TypeScript senior — RN ganharia em time-to-market.
- Se Gemma fosse opcional/cloud — RN seria melhor.
- Se precisasse de OTA updates frequentes — Expo EAS Update é mais maduro que Shorebird (Flutter).

---

### PARTE 2 — Stack de Desenvolvimento Local no Mac mini M1 16GB

#### Comandos de instalação

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# mise (version manager unificado, Rust, ~10ms startup)
brew install mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

# .mise.toml na raiz do monorepo
cat > ~/dedsec/.mise.toml <<EOF
[tools]
node = "20.18.0"
python = "3.12.7"
go = "1.23.4"
java = "temurin-21"
ruby = "3.3.5"
EOF

# Flutter via fvm
brew tap leoafarias/fvm
brew install fvm
cd ~/dedsec
fvm install 3.35.3        # stable; use master se precisar de native-assets pro LiteRT-LM iOS
fvm use 3.35.3
fvm flutter config --enable-native-assets

# Xcode — App Store
sudo xcodebuild -license accept
xcodebuild -downloadPlatform iOS
sudo gem install cocoapods

# Android Studio — developer.android.com → SDK Manager
# Baixe: SDK Platform 34 + 26, Build-Tools 34.x, Emulator, Platform-Tools, x86_64 system image API 34 com Google Play

# Docker e ferramentas de rede
brew install --cask docker
brew install --cask proxyman
brew install mkcert nss
mkcert -install
brew install cloudflared
brew install ollama

# IDE
brew install --cask visual-studio-code  # ou cursor
code --install-extension Dart-Code.flutter
code --install-extension blaugold.melos-code
code --install-extension golang.go

# Tooling
fvm dart pub global activate melos
brew install maestro              # E2E mobile testing
brew install --cask lm-studio     # opcional GUI

# Gemma 3 1B no Mac
ollama pull gemma3:1b
```

#### Versões para fixar

| Ferramenta | Versão (maio 2026) | Por quê |
|---|---|---|
| Flutter | 3.35.x stable (ou master) | `flutter_gemma` requer native-assets para iOS |
| Xcode | 16.x | iOS 18 SDK |
| Android SDK | API 34 alvo, minSdk 26 | MediaPipe LLM exige Android 8+ |
| JDK | Temurin 21 LTS | AGP 8.x exige 17+ |
| Node | 20 LTS | Tooling |
| Go | 1.23.4 | API mock idêntica à produção |
| Docker Desktop | 4.34+ | M1 Rosetta |
| flutter_gemma | ^0.16.0+ | Verifique pub.dev |
| flutter_secure_storage | ^9.x | |
| local_auth | ^2.3.x | |

#### Emulação

- **iOS Simulator:** gratuito, performance excelente em Apple Silicon. NÃO roda GPU do MediaPipe (Metal sim cap de 256 MB). Para testar Gemma 3 1B em iOS real, use device físico com sideload via Xcode.
- **Android Emulator:** use API 34 x86_64 com Google Play. Aloque 4 GB de RAM ao AVD; menos derruba o Gemma 3 1B int4. Hardware acceleration via Hypervisor.framework (default no M1).
- **Genymotion:** não vale em 2026. Android Emulator nativo está mais rápido.

#### Sideload iOS sem conta Developer

Funciona com Apple ID grátis, **7 dias de validade do certificado**, máximo 3 apps simultâneos, sem push/CloudKit/Widget. Para demo aos sócios: cadastre Apple ID grátis no Xcode → Preferences → Accounts, selecione team "Personal" no Runner.xcodeproj, build, confie no perfil em Settings → General → VPN & Device Management. **Para distribuição séria, pague Apple Developer Program ($99/ano).**

#### Inspeção de tráfego: **Proxyman**

Ganha contra Charles e mitmproxy:
- Instalação 1-click do cert SSL no Simulator iOS (sem dragdrop manual de PEM).
- UI nativa macOS otimizada para Apple Silicon.
- Setup automático para Android Emulator.
- Map Local, Map Remote, Breakpoints, JavaScript scripting.
- Versão gratuita cobre dev; Pro ($59 perpétuo) destrava Map Local ilimitado.

mitmproxy é gratuito mas exige scripts shell. Charles está envelhecendo no Apple Silicon.

#### Monorepo: **Melos** (Flutter)

Como você vai de Flutter, abandone pnpm/Nx/Turborepo:
- **Pub Workspaces** (nativo Dart 3.6+).
- **Melos** (invertase/melos) — bootstrap, version, exec paralelo, filtros por pacotes alterados.

Estrutura:

```
dedsec/
├── pubspec.yaml              # workspace: [app, packages/*]
├── melos.yaml
├── .mise.toml
├── docker-compose.yml
├── app/
├── packages/
│   ├── dedsec_core/          # tipos, hash-chain
│   ├── dedsec_crypto/        # wrapper libsodium
│   ├── dedsec_llm/           # camada flutter_gemma + prompts
│   ├── dedsec_api_client/    # cliente HTTP
│   ├── dedsec_ui/            # componentes cyberpunk
│   └── dedsec_otslog/        # transparency log
├── tools/
│   ├── seed/
│   ├── go_api_mock/
│   └── ots_helper/
└── docs/
```

`melos.yaml` essencial:

```yaml
name: dedsec
packages: [app, packages/*]
command:
  bootstrap:
    hooks:
      post: dart run build_runner build -d --delete-conflicting-outputs
scripts:
  analyze: { run: "melos exec -- flutter analyze" }
  test: { run: "melos exec --concurrency=1 -- flutter test" }
  up: { run: "docker compose up -d" }
  ios: { run: "cd app && fvm flutter run -d iphone --flavor dev" }
  android: { run: "cd app && fvm flutter run -d android --flavor dev" }
```

#### Limites de RAM no Mac M1 16GB

| Componente | RAM aprox |
|---|---|
| macOS + apps base | 3-4 GB |
| Xcode + iOS Simulator | 3-4 GB |
| Android Emulator API 34 (4GB alocados) | 3-4 GB |
| Docker stack | 2 GB |
| VS Code + Dart Analysis Server | 1.5 GB |
| Ollama servindo Gemma 3 1B | 1.5 GB |
| **Total** | **~14-16 GB** |

**Regra:** rode **um simulator OU um emulator**, nunca os dois. Para cross-platform, conecte device físico. Para demo de 3 clientes: 1 emulator + 2 devices físicos.

---

### PARTE 3 — Mock Backend Local

#### Diagrama da arquitetura mock

```
Mac mini M1 (host)
└─ Docker Compose network "dedsec-net"
   │
   │   Caddy :443 (mkcert) ─▶ Anubis :8923 (PoW) ─▶ API Go :8000
   │       │                                              │
   │       │              ┌──────────────────┬───────────┤
   │       │              ▼                   ▼            ▼
   │       │       MinIO :9000        Postgres :5432   OTS calendar :14788
   │       │       (S3-compat)        (hash-chain)        │
   │       │       buckets:                                ▼
   │       │       pautas/posts/                      bitcoind :18443
   │       │       tiles/forum-msgs                   (regtest)
   │       │
   │       └ HTTPS api.dedsec.local (mkcert)
   │
   ├─ iOS Simulator (iPhone 15)  ──┐
   ├─ Android Emulator (Pixel 6)  ─┼─▶ falam com api.dedsec.local
   └─ Ollama :11434 (Gemma 3 1B fixtures)
        ▲
        │ via cloudflared tunnel (opcional)
        │
   iPhone físico
```

#### Orquestração: **Docker Compose**

Tilt/Skaffold são otimizados para Kubernetes. Você não vai usar K8s no MVP — Magalu Cloud é VM única com Caddy. Docker Compose é o que sobrevive ao Magalu sem mudanças.

#### `docker-compose.yml` de referência (essencial)

```yaml
name: dedsec-mock
networks:
  dedsec-net: { driver: bridge }
volumes:
  minio_data: {}
  postgres_data: {}
  bitcoin_data: {}
  ots_data: {}

services:
  minio:
    # Importante: MinIO parou de publicar no Docker Hub E Quay.io em 23/out/2025.
    # Use a imagem mantida pela Chainguard:
    image: cgr.dev/chainguard/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: dedsec
      MINIO_ROOT_PASSWORD: dedsec_dev_password_change_me
    volumes: [minio_data:/data]
    networks: [dedsec-net]
    ports: ["9000:9000", "9001:9001"]
    healthcheck:
      test: ["CMD", "mc", "ready", "local"]
      interval: 10s

  minio-init:
    image: quay.io/minio/mc:latest
    depends_on: { minio: { condition: service_healthy } }
    networks: [dedsec-net]
    entrypoint: >
      sh -c "mc alias set dev http://minio:9000 dedsec dedsec_dev_password_change_me &&
             mc mb -p dev/pautas dev/posts dev/tiles dev/forum-msgs || true &&
             mc anonymous set download dev/pautas dev/tiles"

  postgres:
    image: postgres:17-alpine
    environment:
      POSTGRES_DB: dedsec
      POSTGRES_USER: dedsec
      POSTGRES_PASSWORD: dedsec_dev
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./tools/seed/schema.sql:/docker-entrypoint-initdb.d/01-schema.sql:ro
    networks: [dedsec-net]
    ports: ["5432:5432"]

  bitcoind:
    image: lncm/bitcoind:v25.0
    command: >
      -regtest -server=1 -rpcuser=dedsec -rpcpassword=dedsec_dev
      -rpcbind=0.0.0.0 -rpcallowip=0.0.0.0/0 -fallbackfee=0.0001 -txindex=1
    volumes: [bitcoin_data:/data/.bitcoin]
    networks: [dedsec-net]
    ports: ["18443:18443"]

  ots-server:
    build: ./tools/ots-server
    depends_on: [bitcoind]
    environment:
      OTS_BITCOIN_RPC: http://dedsec:dedsec_dev@bitcoind:18443
      OTS_CHAIN: regtest
    volumes: [ots_data:/root/.otsd]
    networks: [dedsec-net]
    ports: ["14788:14788"]

  anubis:
    image: ghcr.io/techarohq/anubis:latest
    environment:
      BIND: ":8923"
      TARGET: http://api:8000
      DIFFICULTY: "3"
    networks: [dedsec-net]
    ports: ["8923:8923"]

  api:
    build: ./tools/go_api_mock
    depends_on: [postgres, minio, ots-server]
    environment:
      DATABASE_URL: postgres://dedsec:dedsec_dev@postgres:5432/dedsec?sslmode=disable
      S3_ENDPOINT: http://minio:9000
      OTS_CALENDAR: http://ots-server:14788
    networks: [dedsec-net]
    ports: ["8000:8000"]

  caddy:
    image: caddy:2-alpine
    depends_on: [anubis, api]
    volumes:
      - ./tools/caddy/Caddyfile:/etc/caddy/Caddyfile:ro
      - ./tools/caddy/certs:/certs:ro
    networks: [dedsec-net]
    ports: ["443:443", "80:80"]

  toxiproxy:
    image: ghcr.io/shopify/toxiproxy:latest
    networks: [dedsec-net]
    ports: ["8474:8474", "8666:8666"]
```

`Caddyfile`:

```caddy
{ auto_https off }
api.dedsec.local:443 {
    tls /certs/api.dedsec.local.pem /certs/api.dedsec.local-key.pem
    reverse_proxy anubis:8923
}
```

Gerar certs:
```bash
cd tools/caddy/certs && mkcert api.dedsec.local minio.dedsec.local
echo "127.0.0.1 api.dedsec.local minio.dedsec.local" | sudo tee -a /etc/hosts
```

#### Substituições componente a componente

| Produção (Magalu/CF) | Mock local |
|---|---|
| Magalu Object Storage | MinIO (`cgr.dev/chainguard/minio:latest`) |
| Magalu DBaaS Postgres | Postgres 17 alpine |
| OpenTimestamps + Bitcoin mainnet | otsd regtest + bitcoind regtest |
| Cloudflare Free borda | Caddy local com mkcert |
| Anubis produção | Anubis container local |
| API Go produção | Mesmo binário Go |
| Tunelar para device | cloudflared tunnel |

#### MinIO vs LocalStack — e cuidado com a imagem

MinIO ganha — você só precisa de S3-compat, MinIO é mais leve, console web pronto. **Importante:** conforme a Chainguard (chainguard.dev, 2025): *"On October 23, 2025, the MinIO maintainers ended their former practice of providing pre-compiled binary releases of the community version. As a result, the container images for MinIO were pulled from Docker Hub and Quay repositories."* — ou seja, tanto Docker Hub quanto Quay.io estão sem imagens novas. **Use `cgr.dev/chainguard/minio:latest`** (imagem mantida, distroless, sem vulnerabilidades reportadas) ou builde a sua própria a partir do código-fonte. Não puxe `minio/minio:latest`.

#### Servidor OTS local

`opentimestamps-server` (otsd) roda em **regtest** com bitcoind regtest. Mine blocos sob demanda com `bitcoin-cli -regtest -generate 1`. Dockerfile sugerido (`tools/ots-server/Dockerfile`):

```dockerfile
FROM python:3.11-slim
RUN apt-get update && apt-get install -y git build-essential libssl-dev libffi-dev
RUN git clone https://github.com/opentimestamps/opentimestamps-server.git /opt/otsd
WORKDIR /opt/otsd
RUN pip install -e .
RUN mkdir -p /root/.otsd/calendar && \
    echo "http://0.0.0.0:14788" > /root/.otsd/calendar/uri && \
    dd if=/dev/urandom of=/root/.otsd/calendar/hmac-key bs=32 count=1
EXPOSE 14788
CMD ["otsd", "-v", "--btc-regtest"]
```

No app, mantenha o mesmo cliente Dart de OpenTimestamps; só muda a URL do calendar via env var.

#### Múltiplos celulares para consenso 3+

Dada a RAM do Mac M1 16GB:
1. **1 iOS Simulator + 1 Android Emulator + 1 device físico.** (Recomendado para dev diário.)
2. **3 devices físicos.** (Ideal para demo.)
3. **3 Android Emulators.** Só em Mac 32GB+.

Para o emulador Android falar com API no Mac, use `10.0.2.2:443`. Para devices físicos, IP local do Mac na Wi-Fi.

#### TLS local — `mkcert`

```bash
mkcert -install
mkcert api.dedsec.local minio.dedsec.local localhost 127.0.0.1 10.0.2.2 ::1
```

iOS Simulator: drag-and-drop `rootCA.pem` (em `~/Library/Application Support/mkcert/`) na janela do simulator → Settings → General → About → Certificate Trust Settings → Enable Full Trust.

Android Emulator API 34+: `adb push rootCA.pem /sdcard/` e instale via Settings → Security. Para apps em release: configure `networkSecurityConfig.xml` com `<debug-overrides>` aceitando user certificates.

#### Mock de RSS

Use fixtures estáticas em JSON dentro do bucket MinIO `pautas/`. Job `tools/seed/seed_rss.dart` baixa snapshots de G1/Folha/UOL uma vez, anonimiza, popula MinIO. Reproduzível entre devs, não depende de rede no demo, você controla as notícias.

#### Simular 3G brasileiro

**Toxiproxy** (Shopify) é o padrão:

```bash
# 3G brasileiro: ~300ms RTT, ~1-3% packet loss, ~400 kbps
curl -X POST http://localhost:8474/proxies -d \
  '{"name":"api_3g","listen":"0.0.0.0:8666","upstream":"api:8000"}'
curl -X POST http://localhost:8474/proxies/api_3g/toxics -d \
  '{"type":"latency","attributes":{"latency":300,"jitter":50}}'
```

No app, aponte Dio pra `http://10.0.2.2:8666` quando quiser testar condições ruins.

#### Seed de dados de vereadores

Use o **TSE — Repositório de Dados Eleitorais** (cdn.tse.jus.br). Para vereadores 2024, baixe ZIP por estado em CSV. Script Dart em `tools/seed/seed_tse.dart`:

```dart
final csv = await http.get('https://cdn.tse.jus.br/...eleicao_2024_uf.zip');
for (final row in csv.rows) {
  if (row.cargo == 'VEREADOR' && row.situacao == 'ELEITO') {
    await api.post('/seed/vereador', body: jsonEncode(row));
  }
}
```

#### IA no Mac M1 — Ollama vs MLX/LM Studio

Conforme Rif Kiamil em *"Gemma 3 Performance: Tokens Per Second in LM Studio vs. Ollama on Mac Studio M3 Ultra"* (Google Cloud Community / Medium, 27 mai. 2025) — em hardware Mac Studio M3 Ultra com 512 GB unified RAM, **Gemma 3 1B:** LM Studio (engine MLX) entregou **237 tokens/s** com 1,72 GB de RAM; Ollama (Metal/llama.cpp) entregou **149 tokens/s** com 1,58 GB. No Mac M1 16GB você verá números proporcionalmente menores (estimativa ~60-100 tok/s decode no M1 base, ainda mais que suficiente para gerar fixtures de classificação).

| Ferramenta | Setup | Quando usar |
|---|---|---|
| **Ollama** | `brew install ollama && ollama pull gemma3:1b` | **Default. API HTTP em :11434, OpenAI-compatible.** |
| LM Studio | App + download GUI | GUI para ajustar prompts, MLX ~1,6× mais rápido que Ollama na mesma máquina |
| llama.cpp | `brew install llama.cpp` | Flags exóticas |
| MLX (Apple) | `pip install mlx-lm` | Fine-tuning |

**Recomendação:** Ollama, servindo na :11434, gerando fixtures durante dev. **Não tente rodar Gemma 3 1B dentro do iOS Simulator ou Android Emulator** — Simulator não tem GPU acceleration (Metal sim cap de 256 MB), emulator x86_64 não tem XNNPACK i8mm. Para "rodar no celular": device físico, sempre.

Para o app no simulator chamar Ollama no host:
- iOS Simulator: `http://localhost:11434`.
- Android Emulator: `http://10.0.2.2:11434`.

Use isso para desenvolver UI antes de meter `flutter_gemma`: sua camada `dedsec_llm` tem `LlmProvider` abstrato com `OllamaProvider` (dev no Mac) e `FlutterGemmaProvider` (device real). Troca via flavor.

#### Hot reload

Flutter `flutter run` faz hot reload em <1s pra Dart. **Não funciona para mudanças em `flutter_gemma` plumbing nativo** — precisa full rebuild (`R` no terminal). Use Maestro para reproduzir cenários rapidamente.

#### Reproduzir em qualquer máquina

`README.md` na raiz:

```bash
git clone https://github.com/dedsec-team/dedsec && cd dedsec
mise install
fvm install
melos bootstrap
mkcert -install
cd tools/caddy/certs && mkcert api.dedsec.local minio.dedsec.local && cd ../../..
docker compose up -d
./tools/seed/run.sh
ollama serve & ollama pull gemma3:1b
melos run ios
```

---

### PARTE 4 — Roteiro de Demo aos Sócios (8 minutos)

**Setup prévio:** Mac mini M1 no projetor + 3 celulares (2 iPhones físicos com Apple ID free + 1 Android físico ou emulator). Mesma Wi-Fi, apontando para `https://api.dedsec.local` via cloudflared ou IP local. Docker stack rodando antes do início. Rebuild os iPhones com Xcode no mesmo dia (certificado de 7 dias).

**0:00 — 0:30 — Hook.** "Vocês acabaram de votar em alguém. Em 4 anos vocês não sabem se essa pessoa votou no que prometeu. Dedsec resolve isso, mas a parte interessante é COMO."

**0:30 — 2:00 — Onboarding criptográfico.** Celular 1: tela de criação de identidade. O app gera Ed25519 keypair, exige Face ID para proteger chave no Secure Enclave. Tela: "Você é @articulador-7f3a — seu nome existe só nesse dispositivo." Falar: "Ed25519, mesma cripto que o Signal, mas a chave NUNCA sai do iPhone. Nem nós conseguimos saber quem é."

**2:00 — 4:30 — Consenso ao vivo.** Projetor com 3 celulares. Celular 1 simula que baixou "notícia mockada" do feed (veio do MinIO). Tela: "Sua IA Gemma 3 1B classificou: PAUTA POSSÍVEL → Vereador X votou contra Y". Indicador de tokens/s rolando. Mesmo nos celulares 2 e 3 em paralelo. Os 3 enviam classificações assinadas Ed25519 para a API. API valida 3 assinaturas → publica pauta. Em ~10s, os 3 celulares vibram: "Nova pauta confirmada por consenso descentralizado". "3 IAs independentes em 3 celulares concordaram. Nenhum servidor decidiu nada."

**4:30 — 5:30 — Fórum E2E.** Fórum no celular 1, mande mensagem. Mostre no Proxyman (projetado) o payload trafegando — só ciphertext, X25519 + ChaCha20-Poly1305. Celular 2 abre, mensagem decriptada. Celular 3 não está no fórum, não vê. "Nem nossa API consegue ler."

**5:30 — 6:30 — Detecção de tampering.** Terminal projetado, conecta no Postgres do mock e **edita manualmente uma linha** da hash-chain (`UPDATE chain SET prev_hash='deadbeef...' WHERE seq=42;`). Em ~5s, os 3 celulares acusam: "ALERTA: TRANSPARENCY LOG INCONSISTENTE — STH não bate com último OTS proof." "OpenTimestamps ancorou o estado anterior no Bitcoin. Não tem como o servidor reescrever a história sem o app detectar."

**6:30 — 7:30 — Progressão de jogador.** Tela de perfil no celular 1: "@articulador-7f3a — Nível Articulador → Próximo: Organizador (12 contribuições)". Emblemas: "Primeiro consenso", "Fórum verificado", "Pauta viral". "Gamificação leve. Não vendemos cosméticos. O emblema É a contribuição."

**7:30 — 8:00 — Fechamento.** "Tudo isso rodou no meu Mac. Sem servidor de nuvem. Vocês viram o stack inteiro: cliente Flutter, IA local Gemma 3 1B no celular, backend mock idêntico ao de produção, Bitcoin ancorando a verdade. Custo do MVP até beta: $X. Próximo: alpha fechado com 50 ativistas em São Paulo."

---

### PARTE 5 — Caminho de Produção (Magalu Cloud)

#### Estratégia: contratos imutáveis

O app só conhece **duas variáveis** entre ambientes:
1. `API_BASE_URL` — `https://api.dedsec.local` (dev) → `https://api.dedsec.app` (prod).
2. `OTS_CALENDAR_URL` — `http://ots-server:14788` (dev) → `https://a.pool.opentimestamps.org` (prod).

Tudo mais (rotas, payloads, assinaturas, formato de hash-chain, bucket layout) é **idêntico**. O mesmo binário Go que roda em `tools/go_api_mock/` é o que vai pra Magalu (você só substitui `S3_ENDPOINT` por `https://br-se1.magaluobjects.com`).

#### Flavors Flutter

```dart
class Config {
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
}
```

```bash
flutter run --dart-define=ENV=dev \
  --dart-define=API_BASE_URL=https://api.dedsec.local

flutter build apk --flavor prod \
  --dart-define=ENV=prod \
  --dart-define=API_BASE_URL=https://api.dedsec.app \
  --obfuscate --split-debug-info=build/symbols
```

#### Tunelamento para device físico em dev

```bash
cloudflared tunnel --url https://api.dedsec.local
# Cloudflare devolve URL pública tipo https://abc-def.trycloudflare.com
```

Quick Tunnel é gratuito, sem cadastro, e dá uma URL pública por sessão.

#### CI/CD: **GitHub Actions** + Magalu

Magalu Cloud é VM Linux (Ubuntu); sobe via SSH + systemd unit do binário Go. Pipeline:

```yaml
name: release
on:
  push:
    tags: ['v*']
jobs:
  build-api:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with: { go-version: '1.23.4' }
      - run: cd tools/go_api_mock && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /tmp/dedsec-api
      - name: Deploy to Magalu VM
        env: { MAGALU_SSH_KEY: ${{ secrets.MAGALU_SSH_KEY }} }
        run: |
          echo "$MAGALU_SSH_KEY" > key.pem && chmod 600 key.pem
          scp -i key.pem /tmp/dedsec-api ubuntu@$MAGALU_HOST:/opt/dedsec/api.new
          ssh -i key.pem ubuntu@$MAGALU_HOST 'sudo systemctl restart dedsec-api'
  build-app:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.35.3' }
      - run: melos bootstrap
      - run: cd app && flutter build apk --release --flavor prod --dart-define=API_BASE_URL=${{ secrets.API_BASE_URL }}
```

Segundo a documentação oficial do GitHub e referências consolidadas em 2026, **GitHub Actions oferece 2.000 minutos Linux/mês grátis no plano Free para repos privados** (3.000 min no plano Team a $4/usuário/mês, 50.000 min no Enterprise). Suficiente para MVP. Quando estourar, considere **Gitea Actions** self-hosted numa VM Magalu (sintaxe compatível).

#### Profiles sem expor URLs

Use **GitHub Encrypted Secrets** + **`.env.dev/.env.staging/.env.prod`** ignorados pelo git (commit apenas `.env.example`). URLs prod só em Secrets. No app, **sempre** via `--dart-define` no build.

---

## Recommendations

### Próximos passos imediatos (semana 1):
1. Instale o stack do PARTE 2 no Mac mini M1.
2. Crie o monorepo com Melos e estrutura proposta.
3. Coloque o `docker-compose.yml` para rodar e valide com `curl https://api.dedsec.local/health`.
4. **Faça `flutter_gemma` rodar com Gemma 3 1B int4 num iPhone físico seu via sideload. Meça tokens/segundo. Esse é o GO/NO-GO técnico.**
5. Decida se fica com `flutter_gemma` ou prototipar paralelamente `react-native-executorch`. Mantenho a recomendação Flutter.

### Marcos (próximos 2 meses):
- Semana 2-3: identidade Ed25519 + Secure Enclave + onboarding.
- Semana 4-5: feed (MinIO → cliente → UI) + classificação local Gemma.
- Semana 6-7: consenso multi-device + hash-chain + transparency log.
- Semana 8: fórum E2E + demo end-to-end.

### Critérios para mudar de rumo:
- Se Gemma 3 1B no Snapdragon 6 Gen 1 (Moto G84) der **menos de 8 tok/s decode sustentado**: degradar para Gemma 3 270M ou exigir Snapdragon 7+ como requisito mínimo.
- Se `flutter_gemma` quebrar em alguma atualização crítica do MediaPipe: migrar para MediaPipe via MethodChannel direto (1 sprint).
- Se o time crescer com devs JS senior antes do MVP: revisar React Native + react-native-executorch.

### Investimentos baratos que valem:
- **Apple Developer Program $99/ano** depois do MVP funcional — TestFlight.
- **Proxyman Pro $59 perpétuo** — economiza muito tempo.
- **2 devices Android midrange + 1 baixo** (Moto G84 ~R$1.500, Galaxy A35 ~R$1.800, Moto G14 ~R$900) — benchmark real do Gemma. Vale mais que outra licença de software.

---

## Caveats

1. **MediaPipe LLM Inference API foi marcada como deprecated em 2025 pelo Google** em favor de LiteRT-LM (citação direta da doc: *"Deprecated: MediaPipe LLM Inference API is still available, but we recommend migrating to LiteRT-LM"*). O `.task` continua suportado e `flutter_gemma` consome ambos os formatos. Mas iOS no LiteRT-LM ainda está em Early Preview até maio/2026. Acompanhe o blog do Google AI Edge.

2. **Benchmarks de Gemma 3 1B em midrange brasileiro são lacuna pública.** O único número confiável é Galaxy S24 Ultra (322/47 tok/s CPU). O número mais próximo de midrange é Galaxy A56 (Exynos 1580) com Gemma 3 **270M** entregando 23 tok/s decode (TecAce, 2025) — extrapolação por escala sugere ~10-15 tok/s decode com Gemma 3 1B num Snapdragon 6 Gen 1, mas isso não é fato medido. **Reserve uma semana de testes em 3-4 devices reais antes de fechar requisito mínimo de hardware.**

3. **Sideload iOS sem Developer Program é frágil para demos.** Certificado expira em 7 dias. Para reuniões agendadas com mais de uma semana de antecedência, planeje rebuild no dia. Para demo de alta visibilidade, pague os $99.

4. **Mac mini M1 16GB é o piso.** Funciona, mas você vai fechar Chrome/Slack/Spotify quando estiver com Xcode + Android Emulator + Docker + Ollama. M2/M3 com 24-32 GB elimina a maior parte do atrito.

5. **OTS regtest local não é equivalente a Bitcoin mainnet.** Ancoragem real demora ~10 min/bloco em mainnet; em regtest é instantâneo. Para a demo isso é uma vantagem; para testes de integração próximos da realidade, aponte o calendar local para testnet com bitcoind testnet.

6. **`flutter_gemma` no master channel é experimental.** Para usar `.litertlm` em iOS, o autor recomenda Flutter master (não stable). Isso significa quebras eventuais de build. Em sprints com release iminente, pinne uma versão específica do master.

7. **MinIO sem imagem Docker Hub *nem Quay.io* a partir de 23/out/2025.** Conforme a Chainguard: *"the container images for MinIO were pulled from Docker Hub and Quay repositories."* Use `cgr.dev/chainguard/minio:latest` (mantida, distroless) ou builde do source. Não puxe `minio/minio:latest`. **Atenção:** o exemplo de docker-compose acima foi ajustado para refletir isso — versões antigas de tutoriais (incluindo trechos deste documento gerados antes da atualização) podem ainda referenciar `quay.io/minio/minio:RELEASE.2025-09-06T17-38-46Z`; essa imagem específica existe mas não recebe mais updates de segurança.

8. **A imagem Anubis (`ghcr.io/techarohq/anubis:latest`) precisa ser verificada quanto à licença e estabilidade no seu uso.** Confira o repositório upstream antes de adotar em produção; pode ser preferível mCaptcha conforme o design original do seu backend.

9. **React Native ExecuTorch oficialmente não suporta Gemma como first-class model.** A lista oficial cobre Llama 3.2/3.1/3, Qwen 3, Phi-4-mini, LiquidAI LFM2. Você pode exportar Gemma 3 1B manualmente via `optimum-cli export executorch`, mas o pipeline é menos testado que `.task` em MediaPipe.

10. **Nenhuma fonte consultada publicou números oficiais de bateria/energia em mAh/token para Gemma 3 1B via MediaPipe.** O número "2 watts, 11 tok/s" no iPhone vem de fonte vendor (gemma4-ai.com) sobre Gemma 4 E2B via CoreML, não Gemma 3 1B via MediaPipe — não use isso em material institucional.