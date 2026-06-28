# /token-launch-plan

Generate a personalized Solana token launch plan based on the founder's specific inputs.

## Instructions for Claude

When this command is invoked, do the following in order:

### Step 1 — Ask all 5 questions before doing anything else

Tell the founder you need 5 quick answers to generate their plan, then ask all questions together in a single message. Do not begin generating the plan until all 5 are answered.

```
Before I generate your launch plan, I need 5 quick answers:

1. **Project type** — What kind of token are you launching?
   (a) Memecoin  (b) DeFi utility  (c) DAO governance  (d) RWA  (e) Creator / brand token

2. **Budget** — What's your total launch budget in SOL?
   (a) Under 5 SOL  (b) 5–20 SOL  (c) 20–100 SOL  (d) 100+ SOL

3. **Compliance** — Do you need compliance features (transfer restrictions, KYC gating, regulatory freeze capability)?
   (a) Yes  (b) No

4. **Existing community** — How large is your current audience across all channels?
   (a) None  (b) Under 1k  (c) 1k–10k  (d) 10k+

5. **Timeline** — When do you need to launch?
   (a) Under 1 week  (b) 1–4 weeks  (c) 1–3 months
```

---

### Step 2 — Load the relevant skill files

Before generating the plan, read:
- `skill/launchpad.md` — for launchpad recommendation
- `skill/token-standard.md` — for SPL vs Token-2022 and extension routing
- `skill/authorities.md` — for authority strategy
- `skill/tokenomics.md` — for supply, decimals, and allocation
- `skill/liquidity.md` — for pool type and LP strategy
- `skill/gtm.md` — for GTM sequence and timeline
- `skill/red-flags.md` — for risk assessment at the end

---

### Step 3 — Generate the plan using this exact structure

Output the plan as a clean markdown document the founder can copy and save. Use their project type, budget, compliance need, community size, and timeline to personalize every section. Never give generic advice — every recommendation must reference their specific inputs.

---

## Output Template

````markdown
# Solana Token Launch Plan
**Project type:** [their answer]
**Budget:** [their answer]
**Timeline:** [their answer]
**Generated:** [today's date]

---

## 1. Recommended Launchpad

**Platform:** [name]

**Why:** [2-3 sentences specific to their project type and budget. Reference the routing logic from skill/launchpad.md. Name the graduation venue they'll end up on.]

**Graduation venue:** [PumpSwap / Raydium CPMM / Raydium CLMM / Meteora / N/A]

**Estimated launchpad cost:** [specific SOL amount or range]

---

## 2. Token Architecture

**Token standard:** [SPL Classic / Token-2022]

**Why:** [1-2 sentences. If Token-2022, name which extensions and exactly why based on their compliance answer and project type. If SPL Classic, note P-Token compute optimization. Reference skill/token-standard.md.]

[If Token-2022:]
**Extensions to enable:**
- [Extension name] — [why, specific to their use case]
- [Extension name] — [why]
⚠️ Do not combine: [list any incompatible pairs relevant to their extension set]

**Total supply:** [number — 1,000,000,000 for most; note any deviation and why]

**Decimals:** [6 or 9 — with reason tied to their project type]

**Authority strategy:** [one of three options from skill/authorities.md]
- Mint authority: [Revoke / Transfer to Squads 3-of-5 / Transfer to Squads 5-of-7]
- Freeze authority: [Revoke (recommended for all tradable tokens)]
[If Squads:] Squads setup: minimum [threshold], all keys on hardware wallets

---

## 3. Liquidity Strategy

**Pool type:** [Raydium CPMM / Meteora DLMM / Raydium AMM V4 (only if SPL Classic + legacy bot requirement)]

**Why:** [1 sentence tied to their token standard and budget]

**Minimum seed amount:** [specific SOL or USD figure based on their budget tier]
- Under 5 SOL budget: seed at least $[X] — below the $5k–$10k floor is high risk
- 5–20 SOL budget: target $[X] initial liquidity
- 20–100 SOL budget: seed $[X], reserve $[X] for post-launch operations
- 100+ SOL budget: seed $[X], consider Meteora Alpha Vault

**LP token strategy:** [Burn / StakePoint lock — minimum 365 days]
- [If burn:] Send to `11111111111111111111111111111111`, include tx hash in trust proof bundle
- [If lock:] StakePoint, minimum 365 days, publish public verification link at T+30 min

**Sniper protection:** [Yes — Meteora Alpha Vault / No — standard pool seeding]
[If Alpha Vault:] 24-hour deposit window → pro-rata settlement → zero-slippage atomic launch → 30-day linear vesting on acquired tokens

---

## 4. Tokenomics

**Team allocation cap:** [0–5% memecoin / 15% DeFi / 20% DePIN / 10% RWA]

**Vesting platform:** Streamflow
**Schedule:** [12-month cliff, 36-month linear stream / none for memecoins]
[If community > 1k or budget > 20 SOL:] Enable Umbra private streaming to shield unlock amounts from MEV front-running

**Suggested allocation breakdown:**

| Bucket | % | Notes |
|---|---|---|
| Public / launchpad | [X]% | Bonding curve or direct seed |
| Team + advisors | [X]% | Streamflow linear vest |
| Community / ecosystem | [X]% | Multi-year release |
| Treasury | [X]% | Squads multisig |
| Liquidity | [X]% | Seeded at launch, LP burned/locked |

[Memecoin:] Keep team allocation at 0–5% or expect scanner flags. No treasury needed.
[DeFi/RWA:] Treasury controlled by Squads multisig, not deployer wallet.

---

## 5. GTM Sequence

### T-Minus Checklist

[Compress or expand based on their timeline answer:]

**Under 1 week (compressed):**
- [ ] Upload metadata to Arweave — logo at 1:1 PNG, all social links included
- [ ] Initialize Squads multisig [if utility token]
- [ ] Configure buy-alert bot (Deluge or Bobby) on pool address — do not activate yet
- [ ] Set up Miss Rose moderation on Telegram (`/welcome captcha on`, `/lock urls`, `/lock forward`)
- [ ] Deploy Streamflow vesting contracts [if team allocation exists]
- [ ] Execute authority revocations — mint and freeze both to `None` [if memecoin]
- [ ] Dry run: verify dedicated RPC (Helius/Alchemy), confirm slot lag < 2 blocks
- [ ] Seed liquidity pool + execute LP burn/lock in same block
- [ ] Activate buy-alert bot at T-0
- [ ] Broadcast CA simultaneously with LP burn tx hash and RugCheck proof

**1–4 weeks:**
- T-14: Brand assets, Arweave metadata upload, 1:1 logo, social account launch
- T-7: Squads multisig initialized [if utility], landing page live, all socials cross-verified
- T-3: Whitelist/airdrop configured via Streamflow or Meteora Presale Vault [if applicable]
- T-1: Authority revocations, Streamflow vesting deployed, final RugCheck scan — resolve all flags
- T-0: Atomic seed + lock/burn + CA broadcast simultaneously

**1–3 months:**
- T-14: Brand architecture, Arweave hosting, social infrastructure
- T-7: Squads multisig, landing page, community verification
- T-3: Whitelist/airdrop setup, Streamflow configuration, Meteora Alpha Vault setup [if applicable]
- T-1: Full revocation audit, vesting deployment, OtterSec or Zellic audit [budget permitting], final RugCheck scan
- T-0: Atomic seed + lock/burn + CA broadcast

### Community Infrastructure

[Memecoin:] X (primary) + Telegram. Skip Discord — verification friction kills retail momentum.
[DeFi utility:] X + structured Discord (support, dev, governance channels) + Telegram.
[DAO:] X + Discord (governance, proposals, voting) + Telegram read-only announcements only.

**Buy-alert bot:** [Deluge / Bobby / Cielo Finance]
- Minimum threshold: $[50–100] based on initial liquidity depth
- Customize cards with project branding + single-click Jupiter/Raydium/Birdeye links

[If community > 1k:] **Miss Rose commands to run now:**
```
/welcome captcha on
/setwelcometimeout 120
/lock urls
/lock forward
/lock rtl
/addblacklist "free airdrop" "claim reward" "unstake now" "support help"
/setflood 5
/setfloodmode mute
```

### Launch Day Order of Operations

1. **T-2 hours:** RPC dry run — confirm slot lag < 2 blocks on dedicated Helius/Alchemy node. Multisig signing keys confirmed ready.
2. **T-30 min:** Telegram/Discord into announcement-only mode. Publish countdown with verified links — CA still hidden.
3. **T-5 min:** Seed liquidity pool. In same block: execute LP burn or StakePoint lock.
4. **T-0:** Activate buy-alert bot. [If applicable: initialize market-making for liquidity depth.]
5. **T+1 min:** Broadcast CA across all channels with LP burn tx hash, revoked authority signatures, RugCheck link.
6. **T+30 min:** Pay for DexScreener + Birdeye verification. Pin trust proof bundle. Restore channels to open.

### First 30 Days

| Phase | Days | Focus |
|---|---|---|
| Narrative anchoring | 1–3 | X Spaces, AMAs, pivot from price to product/milestones |
| Trending maintenance | 4–10 | Sustain DEX trending — target volume/liquidity ratio ≥ [2.0 memecoin / 1.5 DeFi] |
| Community raids | 11–20 | Coordinated X engagement, Chatter Shield activation |
| Liquidity expansion | 21–30 | Secondary pool on Meteora or Orca, staking features [if applicable] |

**Day 1–30 target metrics:**

| Metric | Target |
|---|---|
| Unique holders by Day 7 | [10k memecoin / 500 DeFi] |
| Unique holders by Day 14 | [varies — set realistic target based on community size] |
| Liquidity / market cap ratio | ≥ [0.08 memecoin / 0.15 DeFi] |
| Unique daily makers | ≥ [5,000 memecoin / 1,000 DeFi] |

---

## 6. Risk Summary

[Evaluate their specific inputs against skill/red-flags.md and flag any high-risk combinations. Be direct — do not soften the assessment.]

**Risk level:** [Low / Medium / High / Very High]

[Generate flags from their inputs. Examples:]

🔴 **CRITICAL — Timeline too compressed for setup required:**
Under 1 week is insufficient to properly initialize a Squads multisig, deploy and verify Streamflow vesting, upload Arweave metadata, and run a dry run on dedicated RPC. Launching without these steps risks [list specific consequences from red-flags.md]. Recommended minimum: 2 weeks.

🔴 **CRITICAL — Budget below liquidity floor:**
[X] SOL at current prices is below the $5k–$10k minimum liquidity floor. Thin liquidity causes severe price impact on any meaningful trade and will fail the entry threshold of sophisticated traders. Delay launch until budget allows proper seeding.

🟡 **HIGH — No existing community for a [project type] launch:**
[Project type] tokens depend on [viral momentum / governance participation / holder conviction]. Launching into silence with no existing audience requires [specific mitigation: KOL strategy, launchpad-native distribution, Believe scout incentivization, etc.].

🟡 **HIGH — Compressed timeline with compliance requirements:**
Token-2022 compliance extensions (TransferHook, PermanentDelegate) require integration testing on devnet before mainnet. Under 1 week is insufficient. CEX listing latency risk if extensions are not pre-tested.

🟢 **LOW RISK inputs:**
[List any inputs that are well-suited to each other — e.g., 1–3 month timeline with 20–100 SOL budget and existing 1k–10k community is a well-resourced setup.]

---

*Plan generated using solana-token-launch-skill. Cross-reference: skill/launchpad.md, skill/token-standard.md, skill/authorities.md, skill/tokenomics.md, skill/liquidity.md, skill/gtm.md, skill/red-flags.md*
````

---

## Routing Notes for Claude

Use these decision shortcuts when filling in the template:

**Launchpad routing:**
- Memecoin + no compliance → Pump.fun (USDC pair)
- Memecoin + tweet-native → Believe
- Creator/brand → Bags.fm
- DAO → DAOs.fun
- DeFi utility or RWA → Raydium LaunchLab or direct CPMM seed

**Token standard routing:**
- Compliance = yes → Token-2022 (TransferHook + PermanentDelegate + MetadataPointer)
- Compliance = no, any project type → SPL Classic

**Authority routing:**
- Memecoin → revoke both
- DeFi/DePIN → Squads 3-of-5 for mint, revoke freeze
- RWA → separate Squads for mint and freeze

**Budget → liquidity floor:**
- Under 5 SOL → flag as below minimum, advise delay
- 5–20 SOL → seed $5k–$8k, keep remainder for operations
- 20–100 SOL → seed $15k–$30k, Alpha Vault if DeFi
- 100+ SOL → seed $50k+, Meteora Alpha Vault recommended

**Timeline → risk flags:**
- Under 1 week → always flag as high risk unless memecoin with zero team allocation
- 1–4 weeks → achievable for memecoin, tight for DeFi
- 1–3 months → recommended for DeFi, required for RWA
