# GTM & Launch Sequencing

Only ~0.89% of launchpad-deployed tokens graduate to a DEX. The technical deployment is the easiest part. The infrastructure, trust signaling, and sequencing discipline established before the launch block determine whether the project survives the first 24 hours.

---

## Section 1 — Pre-Launch T-Minus Checklist

### T-14: Brand Architecture & Permanent Metadata Storage
- Token logo: **1:1 aspect ratio**, PNG or JPG, renders cleanly in Phantom, Backpack, Solflare, and DEX explorers
- Upload all metadata (name, symbol, description, logo URI, social links) to **Arweave** — not a centralized server. A mutable metadata URI triggers automated scam warnings post-launch and allows rebrand attacks. This cannot be fixed after the mint is initialized.
- Establish unified visual assets across all channels before any public presence is created

### T-7: Multisig Setup & Public Infrastructure
- Initialize **Squads Protocol multisig** — minimum 2-of-3, recommended 3-of-5. All signing keys on hardware wallets. This becomes the treasury, deployer address, and program upgrade authority.
- Deploy informational landing page: tokenomics, utility, roadmap, team backgrounds
- Launch X account, Discord (if DeFi/DAO), and Telegram. Cross-verify all accounts on official domain. Document and publish official links now so clone accounts have no ambiguity window.

### T-3: Whitelist / Presale Infrastructure
- **Streamflow airdrop path:** Upload whitelist CSVs (supports up to 1M recipients). Configure vested or cliff-based airdrop schedules to prevent launch-day dump pressure from early recipients.
- **Meteora Presale Vault path:** Configure tiered or FCFS deposit rules, locking capital before open trading begins.
- Decide and configure now — do not improvise distribution under launch pressure.

### T-1: Authority Revocations, Vesting Deployment, Final Audit
- Execute mint authority revocation — set to `None` after full supply is minted
- Execute freeze authority revocation — active freeze authority triggers honeypot flags on every scanner and blocks up to 90% of retail purchase volume via execution terminals (BullX, Trojan, Photon)
- Deploy team, advisor, and investor allocations into Streamflow linear vesting contracts with minimum 12-month cliff
- Run RugCheck scan on the finalized token — resolve any flags before T-0
- Keep CA strictly confidential. Do not share, do not hint. Broadcasting CA pre-liquidity allows sniper bots to front-run or construct unauthorized pools.

### T-0: Atomic Launch Block
Execute in the same transaction block where possible:
1. Seed liquidity pool
2. Execute LP burn or StakePoint lock
3. Activate buy-alert bots on the new pool address
4. Simultaneously publish CA and verified proof links (LP burn hash, revoked authority signatures, Streamflow lock URLs) across all channels

There is no "publish CA first, then seed" sequencing. That window is the sniper window.

### Minimum Viable vs Full Production Stack

| Layer | Minimum viable (memecoin / social) | Full production (DeFi / institutional) |
|---|---|---|
| Asset custody | Single hardware-linked wallet for fast execution | Squads multisig, 2-of-3 minimum |
| Token standard | SPL Classic + basic metadata | Token-2022 with Transfer Fee or Hook extensions |
| Liquidity / AMM | Raydium CPMM or PumpSwap | Meteora DLMM with Alpha Vault |
| LP management | Immediate burn via launchpad mechanics | StakePoint lock with public proof link |
| Early participation | Open fair launch, no whitelist | Meteora Alpha Vault — pro-rata, anti-snipe |
| Security & analytics | RugCheck scan + DexScreener profile | OtterSec audit + DexScreener verification + Dune dashboard |
| Vesting | None (memecoin) | Streamflow linear, 36-month, 12-month cliff |

---

## Section 2 — Community Infrastructure by Project Type

### Channel Prioritization

**Memecoin / social token:** X is the primary broadcast engine. Telegram for real-time buy momentum. **Skip Discord** — the verification friction kills impulsive retail entry.

**DeFi utility:** X for macro announcements. Structured Discord for developer support, documentation, governance channels. Telegram optional.

**DAO:** X + secure Discord with formal proposal tracking and voting integrations. Telegram as **read-only announcement channel only** — prevents chat dilution and admin overhead.

### Buy-Alert Bot Setup

A buy-alert bot is non-negotiable. The "silent group" effect — where no purchase notifications are visible — reads as a dead project and accelerates abandonment.

**Deluge Buy Bot** — Solana-native, fast DEX transaction parsing, built-in trending banners. Standard choice.

**Bobby Buy Bot** — Lightweight, immediate notification cards. Good fallback if Deluge has latency issues.

**Cielo Finance Bot** — High-signal tracking. Best for monitoring verified whale wallets and smart money addresses — surfaces when sophisticated capital enters.

**Configuration best practices:**
- Set a dynamic USD minimum threshold ($50–$100 depending on initial liquidity depth) to filter dust spam while surfacing meaningful buys
- Customize notification cards with project visual assets, dynamic progress bars (bonding curve completion or market cap targets), and single-click CTA buttons linking to Jupiter, Raydium, and Birdeye
- Connect to the pool address at T-0, not before

### Miss Rose Moderation (@MissRose_bot)

Deploy before the launch window opens. A single phishing link in a high-traffic channel destroys trust in minutes.

```
# Enable strict welcome captcha — blocks automated spam bots
/welcome captcha on

# 120-second challenge window before kicking unverified users
/setwelcometimeout 120

# Block phishing link vectors
/lock urls
/lock forward
/lock rtl

# Keyword blacklist — auto-delete common scam phrases
/addblacklist "free airdrop" "claim reward" "unstake now" "support help"

# Flood control — mute users sending rapid message sequences
/setflood 5
/setfloodmode mute
```

---

## Section 3 — Launch Day Order of Operations

### Timeline

**T-2 hours: Infrastructure dry run**
- Verify RPC endpoint stability — dedicated node required (Helius or Alchemy Yellowstone gRPC with ShredStream). Slot lag must be under 2 blocks. Public shared RPC throttles under congestion and causes loss of control over the initial order book.
- Confirm multisig is ready to sign immediately — no hardware key delays tolerated at T-0
- Verify all bot configs are pointed at correct pool address (staged, not yet active)

**T-30 minutes: Community pre-warm**
- Place Telegram and Discord in restricted / announcement-only mode
- Publish countdown banner with verified informational links (website, docs, socials)
- CA remains hidden

**T-5 minutes: Atomic seeding**
- Deploy liquidity pool
- In the same block: execute LP burn or StakePoint lock
- Generate verifiable public proof links from lock contracts

**T-0: Bot activation**
- Activate Telegram buy-alert bots on the new pool address
- Initialize market-making software for liquidity depth (see note below)

**T+1 minute: CA broadcast**
- Simultaneously publish CA across X, Telegram, Discord
- Include: direct trading links (Jupiter, DexScreener, Birdeye), recommended slippage (3–5% for high-volatility environments), priority fee guidance (minimum 0.001 SOL Jito tip)

**T+30 minutes: Trust signal verification**
- Pay for DexScreener and Birdeye profile verification
- Pin to top of all channels: LP burn tx hash, revoked authority signatures, Streamflow proof links
- Restore community channels to open interaction mode

> **Market making note:** Programmatic market-making tools (e.g., Smithii Volume Bot) can be used to generate consistent bid-ask spreads and initial liquidity depth. This supports price discovery and prevents extreme spread gaps that make the asset untradeable. Artificial wash trading — generating fake volume to deceive buyers about organic demand — violates exchange ToS and may constitute market manipulation under applicable law. Frame market-making tooling as what it is: a liquidity depth mechanism, not a volume inflation strategy.

### Fatal Mistakes

| Mistake | Consequence |
|---|---|
| Broadcasting CA before liquidity is seeded | Sniper bots front-run the initial pool transaction or construct unauthorized fake pools. Early capital is drained before retail buyers can participate. |
| Leaving freeze authority active at T-0 | RugCheck flags as honeypot. Execution terminals (BullX, Trojan, Photon) display risk banners. Up to 90% of retail purchase volume is blocked. |
| Running on shared/public RPC | Connection throttling and slot lag under congestion. Failed transactions, loss of order book control at the worst possible moment. |
| Publishing CA in stages across channels | Creates a window where one community sees it before others. Informed insiders front-run uninformed community members. |

---

## Section 4 — KOL & Trader Due Diligence

Professional traders and tier-1 CT influencers run a forensic workflow before committing capital or promotion. Design the launch to pass this audit, not to hope it won't happen.

### Forensic Workflow

```
Step 1 — On-chain scan
RugCheck.xyz → verify trust score ≥ 80, confirm mint and freeze
authorities are both permanently disabled

Step 2 — Holder cluster check
Bubblemaps.io → map top 150–250 holder wallets
Green: unconnected, decentralized bubble structure
Red: interconnected cluster funded by shared parent wallet

Step 3 — Market depth check
DexScreener / Birdeye → volume-to-liquidity ratio stability,
unique maker count, verification status
```

### Green Flag vs Red Flag Table

| Parameter | Green flag | Red flag |
|---|---|---|
| Authority status | Both mint and freeze permanently revoked | Either authority remains active |
| LP ownership | Burned to `1111...` or locked with verifiable public proof | LP tokens in deployer EOA with no lock |
| Holder distribution | No connected cluster above 5% of supply on Bubblemaps | Coordinated cluster holding >15% of supply |
| Token-2022 transfer fee (if applicable) | Hard-coded immutable cap ≤5% | Mutable fee — can be changed to 99% post-launch (honeypot vector) |
| Team vesting | Streamflow linear contracts with 12-month cliff, on-chain verifiable | Large team allocation fully liquid at launch |
| Deployer wallet history | History of graduated projects, no rapid liquidity pulls | Linked to failed launches or historical rug patterns |
| Metadata storage | Arweave permanent storage | Mutable centralized server — rebrand / redirect possible |

### Minimum Credibility Bar

These are the minimum requirements for professional capital to consider entry:

- **Clean RugCheck scan:** Low Risk score, zero active threat indicators
- **Liquidity floor:** $5k–$10k for standard launches; $50k+ for serious utility projects (below this, any meaningful trade causes severe price impact)
- **Vested team supply:** On-chain proof that team and advisor allocations are locked in linear vesting — zero immediate dump exposure

---

## Section 5 — Post-Launch Day 1–30

### Phase Breakdown

**Phase 1 — Narrative anchoring (Day 1–3)**
Immediately after launch, pivot community attention from price to product. Host X Spaces and AMAs with ecosystem partners. Focus announcements on roadmap execution milestones. Teams that let the conversation stay purely price-focused lose control of the narrative within 48 hours.

**Phase 2 — Trending maintenance (Day 4–10)**
DexScreener trending algorithms score on volume, transaction frequency, unique maker counts, and paid boosts. The target volume-to-liquidity ratio for maintaining trending position is ≥2.0 (24-hour volume / total liquidity pool depth). Market-making software configured to execute at randomized intervals (e.g., 5–25 second variance) prevents the "flat chart" pattern that triggers mass sell signals. See market-making note in Section 3.

**Phase 3 — Community raids (Day 11–20)**
Integrate community engagement bots (e.g., Chatter Shield) that lock the main group chat until the community hits engagement targets on official posts. This drives viral activity on X without requiring constant admin effort. Coordinate holder communities around specific viral moments — ecosystem announcements, partnership reveals, product demos.

**Phase 4 — Liquidity expansion (Day 21–30)**
Seed secondary pools on Meteora or Orca to capture additional fee revenue and diversify liquidity risk away from a single pool. Introduce staking or yield features if the protocol supports them. This is when serious DeFi projects begin converting speculative holders into protocol participants.

### Key Metrics — First 30 Days

| Metric | DeFi utility target | Memecoin target | Warning signal |
|---|---|---|---|
| Unique holder count | ≥2,000 by Day 14 (steady linear growth) | ≥10,000 by Day 7 (exponential) | Stagnant or declining holder count signals centralized supply and approaching dump |
| Liquidity / market cap ratio | ≥0.15 | ≥0.08 | Below threshold = high price impact per trade, severe volatility risk |
| Unique daily makers | ≥1,000 | ≥5,000 | Declining maker count → dropping off DEX trending feeds |
| 24-hour volume | $500k–$2M (sustainable organic) | $5M–$25M (momentum-driven) | Low volume limits fee generation and operational funding |
| Holders-to-makers ratio | ≥2:1 (holders outnumber active traders) | ~1:1 (high-velocity speculation normal) | Ratio below 1:1 for utility tokens signals pure speculation with no conviction holders |

### Handling FUD

Establish an **on-chain transparency dashboard** before launch — a dedicated page linking directly to: verified audit reports (OtterSec, Zellic), LP burn transaction hash, revoked authority signatures, Streamflow public lock contracts. When FUD spreads, respond with a pinned link to verifiable on-chain data, not emotional rebuttals. The dashboard resolves concerns through ledger history. Teams without this infrastructure waste hours arguing with screenshots.

---

## Section 6 — Launchpad-Specific GTM Nuances

### Pump.fun

**Asset profile:** Viral meme-centric tokens, high-beta, retail-first. Community expects immediate bonding curve graduation — any delay reads as failure.

**Key tactics:**
- **Velocity is the only metric that matters.** Slow graduation = death. Every community action should funnel toward curve completion.
- **Bundled buys at launch:** Use bundler tools to execute multi-wallet buy transactions in the exact initialization block. Distributes early supply across controlled wallets, accelerates graduation, and limits sniper extraction window.
- **X raiding:** High-frequency meme generation and coordinated community raids on X are the primary distribution mechanism. Discord is unnecessary overhead. Telegram for buy momentum.

**Anti-snipe protection:** Low by default — highly vulnerable without launch bundling. Plan the bundle execution as part of the T-0 sequence.

### Raydium LaunchLab

**Asset profile:** Professionally backed projects, serious community tokens, early-stage utility. Graduates to Raydium CPMM or CLMM. 25% of launch fees buy and burn $RAY — align community narrative around this.

**Key tactics:**
- **Front-page visibility is the metric.** Raydium's homepage surfaces tokens by transaction volume and unique maker counts. Volume matters from Day 1.
- **LaunchLab bump bots:** Market-making software (e.g., Smithii's LaunchLab Bump Bot) configured to simulate organic transactions across multiple addresses drives maker counts and trending position. Frame internally as liquidity depth maintenance, not volume inflation.
- **Professional branding is mandatory.** Complete token profile verification immediately. All social links, websites, and any audit badges must be updated before significant capital enters. Raydium's audience is more sophisticated than Pump.fun's — they check.

### Believe

**Asset profile:** Value-driven creative projects, tech startups, SocialFi experiments, Internet Capital Markets (ICM) movement. Community rejects low-effort celebrity hype explicitly — the platform ethos is "Believe in Something, not Someone."

**Key tactics:**
- **Utility narrative is the launch.** GTM content must emphasize product updates, developer tooling, and real-world application from Day 1. Price narrative alone causes rapid community abandonment on this platform.
- **Scout incentivization:** Actively promote project posts to active on-chain Scouts on X. Scouts earn a perpetual 0.1% share of all future trading fees — they are highly motivated to surface high-quality projects early. Identified scouts who champion the project become permanent aligned stakeholders.
- **1% creator fee as runway positioning:** The 1% perpetual volume royalty paid directly to the creator (claimable in the Believe iOS app) should be positioned publicly as development funding that reduces VC dependency. This narrative resonates specifically with the ICM community and differentiates the project from pure speculation plays.
- **Anti-snipe protection is built in:** Believe's dynamic anti-snipe fee decays to standard 2% as liquidity builds — leverage this in community communications as a fairness signal for retail buyers.

### Launchpad GTM Comparison

| Parameter | Pump.fun | Raydium LaunchLab | Believe |
|---|---|---|---|
| Anti-snipe protection | Low (bundling required) | Moderate | High (dynamic decay fee) |
| Graduation venue | PumpSwap / Raydium V4 | Raydium CPMM or CLMM | Meteora |
| Graduation cap | ~$69k–$100k | ~$73k (500 SOL) | $100k |
| GTM primary lever | Velocity + viral X raids | Front-page maker count + professional branding | Utility narrative + scout incentivization |
| Community channel priority | X + Telegram | X + Discord | X + Scout network |
