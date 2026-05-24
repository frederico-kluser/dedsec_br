# Backend do Dedsec — Arquitetura, Custos e Defesas (Magalu Cloud + Cloudflare)

**TL;DR**
- A pilha mais barata e robusta para o Dedsec hoje é **Cloudflare Free na borda (DDoS L3/4/7 + CDN + WAF básico)** → **1 VM Magalu Cloud BV1-2-10 (Ubuntu) rodando Caddy + Anubis/mCaptcha + API em Go + SQLite/PostgreSQL local**, com **Magalu Object Storage (S3-compatível) servindo como log append-only e CDN de pautas/posts assinados**, e **hash-chain caseiro ancorado em Bitcoin via OpenTimestamps** como transparency log. Custo realista: **R$ 100–160/mês para 500–5.000 MAU**, **R$ 250–450/mês a 20–25k MAU**; acima disso o budget de R$ 500 estoura sem otimização agressiva de cache.
- A Magalu Cloud **não oferece proteção DDoS gerenciada** — é o ponto fraco mais relevante do provedor e a razão principal para colocar **Cloudflare Free** sempre na frente (DDoS ilimitada e sem custo desde 2017, conforme anúncio "Unmetered Mitigation" de Matthew Prince na Birthday Week 2017; a FAQ oficial reitera: *"Since 2017, Cloudflare offers free, unmetered, and unlimited DDoS protection. There is no limit to the number of DDoS attacks, their duration, or their size"*). O segundo gargalo é que o **Load Balancer da Magalu (LBaaS) só é gerenciado via CLI** atualmente e não tem WAF nativo, reforçando a necessidade da camada Cloudflare.
- Para o requisito de "admin não pode mexer sem que celulares detectem", a recomendação é **hash-chain assinado pelo servidor + âncora periódica via OpenTimestamps (Bitcoin, grátis) + auditoria gossip entre clientes** no MVP. Trillian (que o README oficial declara em "maintenance mode") e seu sucessor **Tessera** (apresentado no Transparency.Dev Summit em outubro/2024) ficam para o roadmap quando passar de 5.000 MAU. Para criptografia E2E em grupos (fórum de uma cidade), **MLS (RFC 9420) via mls-rs (AWS Labs) ou OpenMLS (Phoenix R&D)** é o padrão correto.

---

## Key Findings

1. **Magalu Cloud é viável e barato em compute/storage, mas tem buracos importantes.**
   - **Tem:** VMs (BV/DP), Object Storage S3-compat (Standard R$ 0,10/GiB-mês; Cold Instant R$ 0,06/GiB-mês; egress R$ 0,10/GiB), Block Storage SSD (a partir de R$ 0,58/GiB-mês), DBaaS gerenciado MySQL/PostgreSQL (mais barato: BV1-4-10 a **R$ 94,22/mês — R$ 0,1291/h**), Kubernetes gerenciado (control plane com taxa mensal pequena por cluster, nodes a preço de VM), Container Registry (lançado fim/2024), VPC, Security Groups, IAM Turia gratuito, LBaaS, 2 regiões (br-se1 São Paulo, br-ne1 Fortaleza).
   - **Não tem (ou não anuncia):** **proteção DDoS gerenciada**, **WAF gerenciado**, **CDN/edge cache**, **serverless functions**, **DNS gerenciado robusto**, **Redis gerenciado** (anunciado para roadmap mas ainda não GA), **MongoDB gerenciado** (idem). Não há free tier permanente — apenas **R$ 300 em créditos por 30 dias** para começar.
   - Suporte em português, faturamento em BRL, datacenters no Brasil (LGPD nativa). Preço de VM ~5× mais barato que GCP/AWS na mesma faixa (post PATOS em dev.to, janeiro/2025: BV2-4 a R$ 82,99 vs GCP R$ 485,55 em São Paulo para 2 vCPU/4 GB).

2. **Cloudflare Free na frente do Magalu resolve DDoS, WAF básico, CDN e DNS sem custar nada.**
   - Proteção DDoS ilimitada e sem custo desde 2017 (anúncio "Unmetered Mitigation" de Matthew Prince). Tráfego de ataque é excluído do billing automaticamente.
   - Caso documentado de capacidade real: Cloudflare mitigou um ataque de **26 milhões req/s contra um cliente do plano Free** (Omer Yoachimik, Product Manager da Cloudflare, blog post de 14/jun/2022 "Cloudflare mitigates 26 million request per second DDoS attack": *"The attack targeted a customer website using Cloudflare's Free plan"*).
   - Plano Free inclui: CDN global em 330+ cidades, SSL universal, DNS, 5 regras WAF custom, rate limiting básico, Page Rules limitadas, Bot Fight Mode.
   - **Limite informal do Free:** Cloudflare exige que ≥50% dos requests sejam HTML (ou seja, não use como armazenamento de vídeo/binários grandes). Para o Dedsec (API JSON pequena + listagem de pautas/posts) isso é folgadíssimo.
   - Integração trivial: aponta `api.dedsec.org` para o Cloudflare (proxy laranja) e o Cloudflare faz `origin pull` para o IP público da VM Magalu.

3. **Para tamper-evidence rápido e barato, hash-chain + OpenTimestamps vence Trillian/Tessera no MVP.**
   - **Trillian (Google) declara-se em maintenance mode** no próprio README do repositório (`google/trillian` no GitHub): *"Trillian is in maintenance mode. The next generation of transparency logs uses Tiled APIs and are better supported by Tessera. We recommend that any new log operators first try Tessera."*
   - O sucessor é **Tessera** (transparency-dev/trillian-tessera), biblioteca Go para logs tile-based **apresentada no Transparency.Dev Summit em outubro de 2024** (não 2025), produção-ready em 2025, suportando POSIX (arquivos), MySQL e drivers de cloud (GCP/AWS). Mais barato e simples que Trillian v1, mas ainda é overkill para começar com 500 usuários.
   - O caminho enxuto: o servidor mantém um **hash chain append-only** (cada entrada = `H(entrada_n || hash_n-1)`), assina periodicamente a "cabeça" (tree head) com Ed25519, expõe `/transparency/head` e `/transparency/proof?index=N`. A cada 1 hora (ou a cada N entradas), o servidor envia o hash da cabeça para o **OpenTimestamps** (gratuito, ancora em Bitcoin), e armazena o `.ots` no Object Storage público. Os celulares baixam a cabeça periodicamente, comparam com seu histórico local e gritam se o servidor reescreveu algo. **Custo extra: ~zero.** Bibliotecas: `opentimestamps-client` (Python/CLI), `javascript-opentimestamps`, integração via simples HTTP POST.
   - Gossip entre clientes (Certificate Transparency-style): cada celular, ao consultar a árvore, compara com o que outros celulares viram. Detecção de "split-view attack" sem confiar no servidor.

4. **MLS (RFC 9420) é o padrão para fórum E2E em grupos grandes; bibliotecas estão prontas.**
   - **OpenMLS** (Rust, Phoenix R&D) e **mls-rs** (Rust, AWS Labs) são duas implementações maduras do RFC 9420 (julho/2023). Escalam até dezenas de milhares de membros, com forward secrecy e post-compromise security.
   - Para iOS/Android, ambas têm bindings via FFI (UniFFI). Para o caso de "qualquer cidadão de uma cidade pode ler o fórum", uma alternativa mais simples no MVP é **criptografia simétrica por sala** (uma chave AES-GCM por cidade, distribuída via wrap com chaves públicas dos membros via libsodium `crypto_box`). MLS vira upgrade no v2 quando o produto crescer.
   - **libsodium/NaCl** é a aposta para o resto: maduro, auditado, com bindings de primeira classe para **Swift (swift-sodium, jedisct1)**, **Kotlin/Android (Lazysodium-Android)**, e para o servidor em Go (`github.com/jamesruan/sodium`) ou Rust (`sodiumoxide`/`dalek-cryptography`).

5. **Sybil/spam: proof-of-work no cliente (estilo mCaptcha/Anubis) é a defesa certa para usuários anônimos sem IP confiável — mas como camada, não defesa única.**
   - **mCaptcha** (Rust, AGPL) faz exatamente isso: PoW SHA-256, sem IP, sem cookies, sem fingerprinting; rate limit por dificuldade dinâmica. **Anubis** (Xe Iaso, Go) é gateway PoW Hashcash-like em produção em GNOME GitLab, UNESCO, SourceHut. Ambos são "stop-gap" mas eficazes contra scripts e abuso em massa, com custo computacional desprezível para humanos.
   - **Atenção:** o post "Proof of Mutex: Outspeeding Anubis with Valid PoW" (Yumechi, yumechi.jp) demonstra que **com um único AMD Ryzen 9 7950X é possível empurrar ~11.5k provas válidas/segundo (~0,68–0,70 milhão em 60s) usando ~50% de CPU contra Anubis na dificuldade mais alta**, suficiente para saturar o validador. Pior ainda: conforme reportagem do The Register de 15/agosto/2025 ("Codeberg beset by AI bots that now bypass Anubis defense"), o Codeberg postou no Mastodon que *"It seems like the AI crawlers learned how to solve the Anubis challenges"*. Para o Dedsec, PoW é primeira barreira; combinar com rate-limit por chave criptográfica (não IP) e quotas por dispositivo é essencial.
   - **Cap (trycap.dev, 2026)** é uma evolução interessante: a homepage oficial (acessada maio/2026) declara *"1 billion solves in Q1 2026 alone"* e descreve a estratégia em dois layers — *"PoW (SHA-256 via WASM OR GPU-resistant time-lock challenges) + instrumentation challenges"* (JS gerado pelo servidor que verifica ambiente real de browser via operações DOM). Vale ficar de olho para v2.

6. **Custo real estimado (operação em produção):**

| Cenário | Compute (VM) | Storage (Object + Block) | DBaaS / Backup | Egress estimado | Total/mês (R$) |
|---|---|---|---|---|---|
| **500 MAU / 10k req/dia** | 1× BV1-2-10 ≈ R$ 60 | 20 GiB Standard + 80 GiB Cold ≈ R$ 7 | SQLite na VM (R$ 0) | ~3 GiB ≈ R$ 0,30 | **~R$ 75–95** |
| **5.000 MAU / 100k req/dia** | 1× BV2-4-10 ≈ R$ 83 + IP público | 200 GiB Standard + 500 GiB Cold ≈ R$ 50 | DBaaS BV1-4-10 R$ 94,22 | ~20 GiB ≈ R$ 2 | **~R$ 245–300** |
| **50.000 MAU / 1M req/dia** | 2× BV4-8-10 (HA) ≈ R$ 360 + LB | 2 TiB Standard + 5 TiB Cold ≈ R$ 500 | DBaaS BV2-4-10 + réplica ≈ R$ 200 | ~30 GiB real (cache 90%+) ≈ R$ 3 | **~R$ 1.100** ⚠️ acima do budget |

   - **Gatilhos de explosão de custo:** (a) egress sem cache Cloudflare (cada GiB = R$ 0,10); (b) Block Storage SSD provisionado e não usado; (c) DBaaS multi-zona (3× o preço single); (d) snapshots acumulados; (e) IPs públicos ociosos. Mitigação: TTL agressivo no Cloudflare (Cache-Everything em endpoints listáveis), Cold Instant para dados raros, single-AZ no MVP.

---

## Details

### A) Magalu Cloud — Mapa de Serviços e Preços (maio/2026)

| Serviço | Disponível? | Preço de referência (BRL) |
|---|---|---|
| Virtual Machines (compute) | ✅ BV (shared CPU) e DP (dedicated) | BV1-1-10 (1 vCPU/1GB/10GB SSD): faixa estimada R$ 40–55/mês; BV2-4-10 (2 vCPU/4GB) ≈ R$ 83/mês (PATOS dev.to, jan/2025) |
| Object Storage (S3-compat) | ✅ | Standard **R$ 0,10/GiB-mês**, Cold Instant **R$ 0,06/GiB-mês**, egress **R$ 0,10/GiB**, ingress grátis (Standard) |
| Block Storage (SSD) | ✅ | A partir de R$ 0,58/GiB-mês (volume básico, baixo IOPS) |
| DBaaS PostgreSQL/MySQL | ✅ | BV1-4-10 (1vCPU/4GB) = **R$ 94,22/mês**; BV2-4-10 = R$ 100; BV4-8-10 = R$ 188; cluster multi-AZ = 3× single |
| Kubernetes gerenciado | ✅ | Pequena taxa mensal por cluster + nodes a preço de VM; suporta até 2000 nodes/cluster |
| Container Registry | ✅ | Lançado fim/2024 |
| Load Balancer (LBaaS) | ✅ (CLI-only por enquanto) | Cobrança por hora de operação + egress |
| VPC / Security Groups | ✅ | Gratuito |
| IPv4 público | ✅ | Cobrado separadamente (confirmado no Termos de Serviço e na Help Center) |
| IAM (Turia) | ✅ | Gratuito |
| **DDoS protection** | ❌ | **Não advertido. Apenas Security Groups (firewall L3/4 básico).** |
| **WAF gerenciado** | ❌ | Não anunciado |
| **CDN** | ❌ | Não anunciado |
| **Functions/Serverless** | ❌ | Não anunciado |
| **Redis/MongoDB gerenciado** | 🟡 | Anunciado para roadmap (Cloud Futures 2024), ainda não GA em maio/2026 |
| Free tier | 🟡 | **R$ 300 em créditos por 30 dias**, sem free tier permanente |
| Regiões | ✅ | br-se1 (SP), br-ne1 (Fortaleza), e zonas privadas Dell |

**Comparação com alternativas brasileiras** (preços médios pesquisados em portais de comparação 2025–2026):

| Provedor | VPS 2vCPU/4GB SSD | Object Storage S3-compat | DDoS nativa | Postgres gerenciado |
|---|---|---|---|---|
| **Magalu Cloud** | ~R$ 83/mês | ✅ R$ 0,10/GiB | ❌ | ✅ R$ 94/mês |
| Locaweb VPS | R$ 80–120/mês | ❌ | 🟡 básica | ❌ (gerencie você) |
| KingHost VPS | R$ 90–110/mês | ❌ | ✅ básica | ❌ |
| Hostinger VPS BR | R$ 60–90/mês | ❌ | 🟡 básica | ❌ |
| HostGator Cloud | R$ 100+/mês | ❌ | 🟡 básica | ❌ |
| UOL Host | mais caro | ❌ | 🟡 | ❌ |

**Veredito:** Magalu é o **único provedor brasileiro com stack hyperscaler-like** (S3, K8s, DBaaS, Terraform provider oficial — `MagaluCloud/mgc` no Terraform Registry). Locaweb/KingHost/Hostinger são VPS clássicos sem ecossistema de managed services. Para o Dedsec, ficar em Magalu compensa pela combinação Object Storage + DBaaS + K8s no futuro. O gap DDoS é resolvido com Cloudflare.

### B) Arquitetura Recomendada (topologia textual)

```
                       ┌──────────────────────────────┐
        Apps mobile ─→ │  Cloudflare (Free Plan)      │
        iOS/Android    │  - DNS dedsec.org             │
                       │  - Proxy laranja              │
                       │  - DDoS L3/4/7 ilimitado      │
                       │  - 5 regras WAF + rate-limit  │
                       │  - Cache estático (TTL longo) │
                       │  - Bot Fight Mode             │
                       └────────────┬─────────────────┘
                                    │ origin pull HTTPS
                                    │ (Cloudflare Origin CA cert)
                                    ▼
                       ┌──────────────────────────────┐
                       │ VM Magalu BV2-4-10 (br-se1)  │
                       │ Ubuntu 24.04 LTS              │
                       │ ┌──────────────────────────┐  │
                       │ │ Caddy (TLS, reverse-px)  │  │
                       │ │   └─→ Anubis/mCaptcha    │  │
                       │ │       (PoW gateway)      │  │
                       │ │       └─→ API Go         │  │
                       │ │            ├─ SQLite/PG  │  │
                       │ │            └─ hash-chain │  │
                       │ │               (→Tessera) │  │
                       │ └──────────────────────────┘  │
                       └────────────┬─────────────────┘
                                    │
                ┌───────────────────┴────────────────────┐
                ▼                                        ▼
   ┌───────────────────────┐               ┌──────────────────────────┐
   │ Magalu Object Storage │               │ OpenTimestamps Calendars │
   │ (S3-compat)           │               │ (Bitcoin anchoring)      │
   │ - posts assinados     │               │ - âncora hash horária    │
   │ - pautas validadas    │               │ - prova .ots no bucket   │
   │ - tiles do trans.log  │               │ - grátis                 │
   │ - snapshots backup    │               └──────────────────────────┘
   └───────────────────────┘
```

**Por que essa arquitetura:**
- **Single VM é OK até 5.000 MAU** porque a IA roda no celular do usuário (Gemma 3 1B local, sem inferência cara no servidor). O servidor é I/O bound, não CPU.
- **Stateless quando possível:** o servidor não guarda estado de sessão (chave Ed25519 do usuário é "a sessão"). Toda requisição assinada pela chave.
- **Object Storage como banco append-only para conteúdo público:** pautas validadas + posts do fórum + tiles do transparency log viram objetos imutáveis em buckets públicos. Cloudflare cacheia. Servidor central só agrega e roteia.
- **DBaaS é opcional no MVP:** SQLite na VM funciona perfeitamente até ~5k MAU se você usar WAL mode e backup contínuo para Object Storage. Migra para Postgres gerenciado quando o write throughput pedir.
- **Escalar horizontalmente é uma reescrita pequena:** quando o BV2 saturar, sobe um BV4, depois 2× BV4 atrás de LBaaS da Magalu. Stateless ajuda.

### C) Transparency Log — Caminho Pragmático

**MVP (até 5k MAU):**
1. Cada requisição que modifica estado público (post, pauta validada) gera uma **entrada serializada canonicamente** (JSON com campos ordenados + assinatura Ed25519 do servidor).
2. Servidor mantém `state.head = H(entry_n || state.head_n-1)`, com sequência monotônica.
3. A cada N entradas (ou X minutos), gera **Signed Tree Head (STH)** = `{tree_size, root_hash, timestamp, signature}` e publica em `https://api.dedsec.org/transparency/sth` e em arquivo público no Object Storage (`https://dedsec.br-se1.magaluobjects.com/transparency/sth-N.json`).
4. STH é enviado para **OpenTimestamps** (`https://a.pool.opentimestamps.org`) para ancorar no Bitcoin — chega ao bloco em ~1-2h, custa zero. O `.ots` resultante volta para o bucket.
5. Apps mobile, em background, baixam STH periodicamente, **verificam continuidade** (consistency proof — Tessera/Trillian já implementam o algoritmo) e gritam alarme se detectarem rewrite.
6. Apps também fazem **gossip**: trocam STHs entre si via fórum criptografado. Servidor mentiroso com split view fica exposto.

**Quando crescer (>5k MAU):**
- Migrar para **Tessera** (transparency-dev/trillian-tessera, Go), biblioteca apresentada no Transparency.Dev Summit em outubro/2024, com backend POSIX ou MySQL — biblioteca, não microserviço, então embute no Go API.
- Trillian v1 está em modo manutenção, conforme declaração oficial do README do `google/trillian` no GitHub — não recomendado para novos projetos.

**Custo do log:** uma entrada ~512 bytes; 1M entradas = 500 MB; em Object Storage Standard = R$ 0,05/mês. Inviabilizar isso seria absurdo.

### D) Criptografia Prática

**Identidade do usuário:**
- Par de chaves **Ed25519** gerado on-device no primeiro launch. Chave privada em **Keychain (iOS) / Keystore (Android)**, idealmente protegida por biometria. Chave pública = identidade do usuário no servidor.
- **DiceBear avatar** derivado deterministicamente do hash da chave pública.
- **Troca de celular:** usuário exporta a chave privada cifrada com passphrase (Argon2id via libsodium `crypto_pwhash`) e importa no novo aparelho. Sem cadastro = sem recuperação se perder; mantenha cópia offline.

**Conteúdo cifrado:**
- **Post individual com destinatário:** `crypto_box` (X25519 + XSalsa20-Poly1305 via libsodium).
- **Fórum por cidade (qualquer cidadão lê):** No MVP, **chave simétrica AES-256-GCM por sala**, distribuída via "key bundle" cifrado para cada novo membro com `crypto_box`. Rotação manual quando alguém sai. Limitação: sem forward secrecy contra ex-membros.
- **Roadmap v2:** **MLS (RFC 9420)** via **mls-rs (AWS Labs, Rust)** com bindings UniFFI para Swift/Kotlin. MLS dá forward secrecy + post-compromise security + escalabilidade para 50k membros. OpenMLS (Phoenix R&D) é alternativa equivalente.
- **Assinatura por 3+ celulares para validação de pauta:** schema simples = cada celular processador assina um objeto canônico `{news_hash, classification, embedding}`; servidor coleta 3+ assinaturas, valida cosine similarity dos embeddings >85%, e emite **certificado agregado** com as assinaturas dos 3 anexadas. Validação no celular do leitor = checar 3 Ed25519 + recomputar similaridade. Servidor nunca aprende o conteúdo interno; só processa hashes e embeddings (que já são públicos por design).

**Bibliotecas:**

| Plataforma | Lib recomendada | Notas |
|---|---|---|
| iOS (Swift) | **swift-sodium** (jedisct1) | xcframework pronto, suporta arm64/sim/Catalyst/watchOS |
| Android (Kotlin) | **Lazysodium-Android** | wrapper Java-friendly em JNI |
| Servidor Go | `crypto/ed25519` stdlib + `github.com/jamesruan/sodium` | stdlib basta para Ed25519 + assinaturas |
| Servidor Rust | `sodiumoxide` ou `dalek-cryptography` | dalek é pure-Rust, mais idiomático |
| MLS (roadmap) | **mls-rs** (AWS Labs) ou **OpenMLS** (Phoenix R&D) | bindings UniFFI viáveis |

### E) DDoS — Solução Mais Barata e Eficaz

**Camada 1 — Cloudflare Free (sempre na frente):**
- Proteção L3/4/7 ilimitada — o caso de 26 milhões req/s mitigado em cliente Free (Yoachimik, 2022) é a evidência mais forte que essa promessa se sustenta sob pressão real.
- 5 regras WAF custom: configurar uma `block` para User-Agents claramente automatizados, uma para geo-fence (se quiser limitar a Brasil), uma para método HTTP, deixar 2 livres para emergência.
- **Bot Fight Mode** (Free): tenta desafiar bots conhecidos automaticamente.
- **Rate limiting nativo** do Free: suficiente para "100 req/min por IP" no MVP.

**Camada 2 — PoW gateway (na origem):**
- **Anubis** (Go, Xe Iaso): roda como reverse-proxy entre Caddy e a API. Desafio SHA-256 Hashcash, ~1-2s no celular do usuário, válido por 1 semana via JWT em cookie. **Caveat:** o User-Agent default do Anubis libera tudo que não tem "Mozilla" — útil para apps mobile (que podem mandar UA próprio que passa direto se assinado corretamente). Conforme demonstrado pelo Yumechi com Ryzen 9 7950X (~11,5k provas/s saturando o validador) e pelo Codeberg em agosto/2025 ("AI crawlers learned how to solve the Anubis challenges", via Mastodon + The Register), Anubis é camada complementar, não única defesa.
- **mCaptcha** (Rust): alternativa AGPL, mais focada em formulários do que em proxy reverso.
- **Cap (trycap.dev)** se for projeto novo: PoW (SHA-256 via WASM OR GPU-resistant time-lock) + instrumentation challenges, mais robusto contra solvers nativos. Documentou *"1 billion solves in Q1 2026 alone"* na própria homepage — biblioteca jovem mas em crescimento.

**Camada 3 — Rate limit por chave Ed25519 (não IP):**
- Cada request chega assinada com a chave do usuário. No middleware Go: `golang.org/x/time/rate` por `pubkey` em sliding window. Redis local ou in-memory para até 5k MAU. Bucket de **N requests/minuto por chave**, com proof-of-work obrigatório para criar chave nova (custo de entrada controla sybil).
- **Custo de criar chave:** PoW pesado (~10s no celular) cobrado uma vez. Quem quer 10k sybils gasta 100k segundos de CPU.

**Camada 4 — Quota por dispositivo (anti-sybil):**
- O celular ao registrar uma chave faz **attestation** (DeviceCheck no iOS, Play Integrity no Android) e amarra à chave. Não é perfeito (custo: cada attestation = uma "vida" de sybil), mas eleva a barra.

**Escalabilidade automática sob ataque:** se Cloudflare bloquear 99% do ataque (cenário típico), o pico que chega no Magalu cai para escala normal. Para o 1% restante, ter Anubis na frente ajuda. Sobe BV mais robusta manualmente em caso de pico — Terraform provider oficial da Magalu facilita.

### F) Custo Mensal Real — Cenários

(valores em BRL, baseados em pricing maio/2026 da Magalu Cloud + Cloudflare Free)

**Cenário 1 — 500 MAU / 10k req/dia:**
- 1× VM BV1-2-10 (1 vCPU/2GB/10GB SSD): ~R$ 55–70
- Object Storage: 20 GiB Standard (R$ 2) + 80 GiB Cold Instant (R$ 4,80) = R$ 7
- Egress (com Cloudflare cacheando 70%): ~3 GiB out × R$ 0,10 = R$ 0,30
- IP público + Block Storage extra: ~R$ 10
- DBaaS: 0 (usar SQLite na VM)
- **Total: R$ 75–95/mês.** Cloudflare grátis. Os R$ 300 de crédito Magalu cobrem os primeiros 3 meses.

**Cenário 2 — 5.000 MAU / 100k req/dia:**
- 1× VM BV2-4-10: ~R$ 83
- DBaaS BV1-4-10 (Postgres gerenciado, single-AZ): R$ 94,22
- Object Storage: 200 GiB Standard (R$ 20) + 500 GiB Cold (R$ 30) = R$ 50
- Egress (cache hit 80%): ~20 GiB out × R$ 0,10 = R$ 2
- IP + extras: R$ 15
- **Total: R$ 245/mês.** Ainda confortável no budget de R$ 500.

**Cenário 3 — 50.000 MAU / 1M req/dia:**
- 2× VM BV4-8-10 atrás de LB Magalu (HA): R$ 360 + LB ~R$ 30 = R$ 390
- DBaaS BV2-4-10 single + 1 réplica: R$ 200
- Object Storage: 2 TiB Standard (R$ 200) + 5 TiB Cold (R$ 300) = R$ 500
- Egress (com Cloudflare cacheando 90%+): ~30 GiB out reais × R$ 0,10 = R$ 3
- **Total: ~R$ 1.100/mês** — **acima do budget de R$ 500**. Opções:
  - Mover mais agressivamente para Cold Instant e reduzir Standard;
  - Particionar dados antigos para Cold (que custa 40% menos);
  - Configurar Cache-Everything no Cloudflare para todos endpoints `GET /pautas/*` e `/forum/*` (provavelmente derruba egress para ~0);
  - Comprimir entradas do log (gzip nos JSONs canônicos).
- Com otimizações: realista chegar a **R$ 600–800/mês** a 50k MAU. Ainda é 1,2–1,6× o budget — momento certo para abrir uma campanha de financiamento coletivo ou aceitar doações, se o projeto chegar nessa escala.

**Gatilhos de explosão de custo a evitar:**
1. **Egress sem CDN** — cada GiB out custa R$ 0,10 na Magalu. Sem Cloudflare, 1 TiB out/mês = R$ 100 só de egress.
2. **DBaaS multi-AZ desnecessário** — 3× o preço. Single-AZ + backup para Object Storage basta no MVP.
3. **Snapshots Block Storage acumulados** — cobrados por GiB armazenado.
4. **IPs públicos órfãos** após desalocação.
5. **Logs verbosos** crescendo indefinidamente em Block Storage SSD (use Object Storage Cold para retenção longa).

### G) Riscos e Trade-offs

| Decisão | Ganho | Perda / Risco |
|---|---|---|
| Cloudflare Free na frente | DDoS resolvido, CDN, WAF básico, $0 | Dependência de uma multinacional americana (jurisdição EUA); Cloudflare pode banir o domínio se receber reclamações; análise de tráfego visível a eles |
| Magalu Cloud no Brasil | LGPD nativa, BRL, latência boa, jurisdição brasileira | Provedor ainda jovem; sem DDoS nativa; documentação irregular; Magalu é varejista, não cloud-first; possibilidade de mudança de prioridade corporativa |
| VM única + SQLite | Custo mínimo, simplicidade, sem refactor de banco | SPOF — se a VM cair, app fica fora; backup precisa ser religioso para Object Storage |
| Object Storage como "CDN" | Barato, cacheável atrás de Cloudflare, escalável | Object Storage não é uma CDN — depende de Cloudflare para edge; egress da Magalu é caro se cache miss |
| Hash-chain + OpenTimestamps | Implementação simples, prova externa imutável (Bitcoin), grátis | Latência da prova (~1-2h até confirmar no Bitcoin); depende de calendar servers OTS estarem no ar |
| MLS no roadmap, AES-GCM por sala no MVP | Velocidade de entrega, libs simples | Sem forward secrecy contra ex-membros; rotação manual é frágil em fóruns abertos |
| PoW gateway (Anubis/mCaptcha) | Defesa econômica eficaz contra bots | Penaliza dispositivos antigos; UX de "carregando..." pode irritar; solvers nativos e crawlers de IA contornam (Codeberg, ago/2025) |
| Chave Ed25519 = identidade | Sem cadastro, anonimato real | Sem recuperação se usuário perder o celular; pressuposto de que biometria do Keychain/Keystore é confiável |
| Sem DDoS nativo Magalu | — | Se Cloudflare for contornado (ataque direto ao IP de origem), VM cai. **Mitigação: nunca expor IP real, só por Cloudflare; usar IP novo se vazar.** |

**Features aspiracionais vs realistas para MVP:**

| Feature | MVP (v1) | Roadmap (v2+) |
|---|---|---|
| E2E criptografia básica | ✅ libsodium box + AES-GCM | MLS RFC 9420 |
| Transparency log | ✅ hash-chain + OpenTimestamps | Tessera tile-based |
| PoW anti-sybil | ✅ Anubis ou mCaptcha | Cap (PoW + instrumentation) ou PoW custom integrado à chave |
| Auditoria de log pelos clientes | ✅ download de STH + consistency check | gossip P2P automático entre apps |
| Atestation de dispositivo | 🟡 opcional | DeviceCheck/Play Integrity obrigatório |
| Modelo de consenso 3+ celulares | ✅ assinaturas agregadas | Threshold signatures (FROST) |
| Multi-região / HA | ❌ single VM | br-se1 + br-ne1 ativo-passivo |
| Fórum por cidade scalable | 🟡 AES-GCM compartilhada | MLS groups por cidade |

---

## Recommendations

**Próximos 30 dias (semanas 1–4 do MVP):**
1. **Reservar domínio dedsec.org (ou .br) e configurar Cloudflare Free** — DNS, SSL universal, proxy laranja ativo, regras WAF mínimas (block bots óbvios, rate-limit 60 req/min).
2. **Resgatar os R$ 300 de crédito da Magalu Cloud**, provisionar 1× VM BV1-2-10 em br-se1 (São Paulo), Ubuntu 24.04 LTS, com IP público.
3. **Stack na VM:** Caddy (TLS auto + reverse proxy), Anubis em modo "soft" (challenge só em endpoints sensíveis: criação de chave, post de fórum), API em Go (Go tem `crypto/ed25519` stdlib e binários estáticos), SQLite com WAL mode para começar.
4. **Bucket Object Storage** público para servir pautas validadas, posts do fórum e STHs do transparency log. Apontar Cloudflare com Cache-Everything TTL 1h.
5. **Bibliotecas mobile:** swift-sodium no iOS, Lazysodium-Android no Android. Implementar geração/armazenamento da chave Ed25519 no Secure Enclave/Keystore.
6. **Hash-chain mínimo:** middleware Go que serializa cada mutation, append-only em SQLite, expõe `/transparency/{head,proof,range}`. Cron horário gera STH + envia para OpenTimestamps.
7. **Anti-sybil:** ao criar chave nova, exigir PoW (mCaptcha ou implementação custom Hashcash) de dificuldade ~22 bits = ~5-10s no celular mediano. Não exigir attestation no v1.

**Trigger para mudar de fase (escalar para Cenário 2 / 5k MAU):**
- DAU > 2.000 por 7 dias seguidos, OU
- p95 de latência > 500ms, OU
- SQLite WAL > 1 GiB.

**Ações ao cruzar o trigger:**
1. Migrar SQLite → DBaaS PostgreSQL BV1-4-10 (R$ 94/mês). Backup automático.
2. Subir VM para BV2-4-10.
3. Habilitar Cloudflare Argo Smart Routing se latência for issue (custo: US$ 5/mês — opcional).
4. Considerar Redis local (em container na mesma VM) para rate-limit por chave.

**Trigger para Cenário 3 (50k MAU):**
- DAU > 20k por 14 dias seguidos.
- Erro 5xx > 0,1%.

**Ações:**
1. Provisão 2× VM atrás de LBaaS Magalu (CLI).
2. DBaaS multi-AZ.
3. Migrar transparency log para Tessera com backend POSIX no Block Storage.
4. Avaliar abrir doações públicas (Liberapay, OpenCollective) — projeto cívico legítimo tende a ter sponsorship.
5. Considerar migração de MLS para fórum por cidade.

**Decisões a NÃO tomar agora (evitar over-engineering):**
- ❌ Kubernetes desde o início — desnecessário até 50k MAU. Custo extra + complexidade operacional.
- ❌ Trillian/Tessera no dia 1 — overkill. Hash-chain caseiro + OpenTimestamps entrega 80% do valor.
- ❌ MLS no dia 1 — biblioteca ainda jovem em mobile; AES-GCM por sala é suficiente.
- ❌ DBaaS no dia 1 — SQLite WAL aguenta 5k MAU fácil.
- ❌ Múltiplas regiões — single-AZ + backup contínuo no Object Storage Cold Instant é o trade-off correto.

---

## Caveats

1. **Preços exatos de algumas VMs da Magalu não foram extraídos da página oficial** (a página `precos/virtual-machines/` renderiza valores via JavaScript que não é capturado por crawlers; retornou 404 nas tentativas de fetch direto). Valores para BV1-1-10, BV1-2-10 e BV2-4-10 standalone (compute, não DBaaS) foram estimados a partir de um post no dev.to (PATOS, jan/2025) que reportou BV2-4 a R$ 82,99/mês, e da analogia com o DBaaS BV2-4-10 a R$ 100/mês (que inclui licenciamento adicional de DB). **Recomenda-se confirmar na calculadora oficial** (https://magalu.cloud/blog/calculadora-precos-magalu-cloud/) antes do commit financeiro. Os preços de DBaaS (BV1-4-10 R$ 94,22; BV2-4-10 R$ 100; BV4-8-10 R$ 188; e a tabela DP completa) **estão confirmados** na página oficial https://magalu.cloud/precos/dbaas/.

2. **Magalu Cloud não advertise proteção DDoS** em nenhuma página, doc ou Terms of Service consultados — é um vácuo confirmado, não uma omissão acidental do pesquisador. O risco residual é: se um atacante descobrir o IP de origem da VM (vazamento via headers HTTP, certificado SSL antigo, scanning IPv4 da Magalu) e atacar diretamente, o Cloudflare é contornado. **Mitigação obrigatória:** usar Cloudflare Origin CA cert exclusivo (não Let's Encrypt público), filtro de Security Group permitindo apenas IPs do Cloudflare na porta 443, rotacionar IP da VM se houver suspeita de vazamento.

3. **Cloudflare Free pode ter limites informais não públicos** — o Terms aceita que >50% do tráfego seja HTML/API, mas se a Cloudflare classificar a aplicação como "tipo CDN de vídeo/objetos pesados", pode forçar upgrade. Para o Dedsec (API JSON pequena + listagem de pautas) o risco é baixo, mas vale monitorar e ter plano B (Cloudflare Pro $20/mês ou migrar CDN para bunny.net se necessário).

4. **OpenTimestamps depende de calendar servers públicos** (a.pool.opentimestamps.org etc) que são operados por voluntários. Se sumirem, as âncoras passadas continuam verificáveis no Bitcoin, mas novas âncoras precisam de alternativa. Risco baixo (o projeto existe desde 2016 com uptime alto), mas o servidor do Dedsec deve cachear o `.ots` final no próprio Object Storage como redundância.

5. **Anubis e PoW captchas têm sido contornados por solvers nativos e crawlers de IA em 2025** (caso documentado pelo Codeberg em agosto/2025 via The Register; análise técnica de Yumechi mostrando saturação do validador com Ryzen 9 7950X). Não devem ser a defesa única. Estratégia em camadas (Cloudflare + Anubis/Cap + rate limit por chave + attestation no roadmap) é o que efetivamente sustenta.

6. **MLS é seguro mas as bibliotecas mobile são jovens** — mls-rs (AWS Labs) e OpenMLS são auditadas, mas integração com Swift/Kotlin via FFI exige cuidado com memory management. Para o MVP, AES-GCM por sala via libsodium (maduríssimo, >10 anos de produção) é a aposta menos arriscada.

7. **Trillian v1 está em modo manutenção** conforme declaração explícita do README do `google/trillian` no GitHub — não usar para novos projetos. O caminho moderno é Tessera (transparency-dev), apresentada no Transparency.Dev Summit em outubro/2024 e production-ready em 2025. No MVP, hash-chain caseiro evita essa dependência.

8. **Sem doações garantidas + budget de R$ 500/mês** implica que o **Cenário 3 (50k MAU) já estoura o budget** sem otimizações agressivas de caching. Plano realista: o projeto opera autossustentável até ~20-25k MAU; acima disso, captação ativa de financiamento (Liberapay, OpenCollective) é necessária. Esta é uma limitação estrutural, não um problema de design — apps cívicos com milhares de usuários genuinamente custam mais que R$ 500/mês.

9. **Anonimato sem cadastro é trade-off duro:** se o usuário perder a chave privada (celular roubado, factory reset), perde o acesso. Não há fluxo de "esqueci a senha". Documentar isso claramente no onboarding e oferecer **export de chave cifrada** para backup é essencial.

10. **Resistência a captura coordenada do consenso** depende fortemente do design no celular (escolha de quais 3+ celulares processam cada notícia, randomização, prevenção contra Sybils correlacionados). O backend reforça mas não substitui. Sybils em massa só são detectáveis se o custo de criar chave for alto (PoW pesado + attestation no v2).