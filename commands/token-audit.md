# /token-audit

Audit a founder's token configuration against 2026 Solana launch standards and output a risk score with prioritized fixes.

## Instructions for Claude

When this command is invoked, execute the following steps in order.

---

### Step 1 — Collect configuration in a single message

Ask all questions at once. Do not begin the audit until all answers are received.

```
I'll audit your token configuration and output a risk score with fixes.
Answer all 10 questions — skip any that don't apply yet (answer "not set"):

1. **Token standard** — SPL Classic or Token-2022?

2. **Token-2022 extensions** — If Token-2022, which extensions are enabled?
   (e.g. TransferFeeConfig, TransferHook, ConfidentialTransfer, PermanentDelegate,
   InterestBearingConfig, NonTransferable, MetadataPointer)
   If SPL Classic, answer "n/a"

3. **Mint authority** — What is the current status?
   (a) Retained on developer wallet  (b) Revoked  (c) Transferred to Squads multisig
   If multisig: what threshold? (e.g. 3-of-5)  Are signing keys on hardware wallets?

4. **Freeze authority** — What is the current status?
   (a) Retained on developer wallet  (b) Revoked  (c) Transferred to multisig

5. **LP tokens** — What happened to them after pool seeding?
   (a) Burned to null address  (b) Locked — which platform and for how long?
   (c) Retained in deployer wallet  (d) Pool not yet seeded

6. **Team allocation** — What % of total supply goes to team + advisors?
   And: is it vested or fully liquid at TGE?

7. **Vesting platform** — Which platform manages team/investor vesting?
   (a) Streamflow  (b) StakePoint  (c) Magna  (d) Custom smart contract  (e) None

8. **Metadata storage** — Where is your token metadata (logo, name, URI) hosted?
   (a) Arweave  (b) Centralized server / S3 / GitHub  (c) IPFS  (d) Not set yet

9. **Launchpad** — Which platform are you using?
   (a) Pump.fun  (b) Raydium LaunchLab  (c) Believe  (d) DAOs.fun
   (e) Bags.fm  (f) Direct pool seed  (g) Other

10. **Liquidity depth** — Approximate USD value currently in the pool?
    (or planned seed amount if not yet launched)
```

---

### Step 2 — Load reference files

Before scoring, read:
- `skill/red-flags.md` — for anti-pattern definitions and severity levels
- `skill/authorities.md` — for authority status benchmarks
- `skill/liquidity.md` — for LP and pool standards
- `skill/tokenomics.md` — for allocation and vesting standards
- `skill/token-standard.md` — for extension compatibility and standard selection

---

### Step 3 — Apply the scoring rubric

Score each of the 10 checks below. Deduct points for issues, award points for green flags. The maximum score is 100.

#### Scoring Rubric

**Check 1 — Token Standard** (10 points)
- SPL Classic with no compliance requirements: **10 pts**
- Token-2022 with compliance requirements (and compliance = yes): **10 pts**
- Token-2022 with no clear compliance need (overengineered): **7 pts**
- Not determined / answer unclear: **0 pts**

**Check 2 — Token-2022 Extension Compatibility** (10 points — skip if SPL Classic, award full 10)
- No incompatible combinations present: **10 pts**
- One incompatible combination present (e.g. ConfidentialTransfer + TransferHook): **0 pts** — Critical
- PermanentDelegate enabled without disclosure: **4 pts** — High risk
- ScaledUIAmount + InterestBearingConfig: **0 pts** — Critical
- Extensions appropriate for project type: full 10; mismatched (e.g. TransferFee on a memecoin): **5 pts**

**Check 3 — Mint Authority** (20 points)
- Revoked (None): **20 pts**
- Squads multisig, 3-of-5 or higher, hardware wallet keys: **17 pts**
- Squads multisig, 2-of-3, hardware wallet keys: **14 pts**
- Squads multisig, any threshold, hot wallet keys: **8 pts**
- Retained on developer hot wallet: **0 pts** — Critical

**Check 4 — Freeze Authority** (15 points)
- Revoked (None): **15 pts**
- Transferred to compliance multisig (RWA only, disclosed): **12 pts**
- Retained on any wallet (developer or multisig): **0 pts** — Critical
  *(Active freeze authority triggers DEX warning banners and blocks up to 90% of retail volume regardless of multisig status)*

**Check 5 — LP Token Status** (20 points)
- Burned to null address (`11111111111111111111111111111111`): **20 pts**
- Locked via StakePoint ≥ 365 days: **16 pts**
- Locked via StakePoint 180–364 days: **10 pts**
- Locked via StakePoint < 180 days: **5 pts** — High risk
- Locked via unvetted custom contract: **4 pts** — High risk
- Retained in deployer wallet: **0 pts** — Critical
- Pool not yet seeded: **10 pts** (neutral — not yet applicable)

**Check 6 — Team Allocation %** (10 points)
- Memecoin: 0–5% → **10 pts** | 6–10% → **5 pts** | >10% → **0 pts** — Critical
- DeFi utility: 0–15% → **10 pts** | 16–25% → **5 pts** | >25% → **0 pts** — Critical
- DePIN: 0–20% → **10 pts** | 21–30% → **5 pts** | >30% → **0 pts** — Critical
- RWA: 0–10% → **10 pts** | 11–20% → **5 pts** | >20% → **0 pts** — Critical
- Unknown project type for context: apply DeFi thresholds as default

**Check 7 — Vesting Platform & Schedule** (5 points)
- Streamflow linear, 12-month cliff, 36-month total: **5 pts**
- Streamflow linear, any cliff: **4 pts**
- Magna or StakePoint with documented schedule: **4 pts**
- Custom smart contract (audited): **3 pts**
- Custom smart contract (unaudited): **1 pt** — High risk
- No vesting, team allocation > 0%: **0 pts** — Critical
- No vesting, memecoin with 0% team: **5 pts** (not applicable)

**Check 8 — Metadata Storage** (5 points)
- Arweave (`ar://` URI): **5 pts**
- IPFS with active pinning service: **3 pts** — Medium risk (not permanent)
- Centralized server (HTTP/S3/GitHub): **0 pts** — High risk
- Not set yet: **0 pts** — High risk

**Check 9 — Launchpad / Project Type Alignment** (not scored separately — informs context for other checks)
- Note mismatches in the findings table (e.g. DeFi utility on Pump.fun, compliance token on a non-compliance launchpad)
- No points deducted here — flag as a finding only

**Check 10 — Liquidity Depth** (5 points)
- ≥ $50,000: **5 pts**
- $10,000–$49,999: **4 pts**
- $5,000–$9,999: **3 pts**
- $1,000–$4,999: **1 pt** — High risk (below minimum floor)
- < $1,000: **0 pts** — Critical
- Not yet seeded: **3 pts** (neutral)

**Total: sum all applicable checks. Maximum = 100.**

#### Score Labels
| Score | Label |
|---|---|
| 80–100 | Launch Ready ✅ |
| 60–79 | Needs Fixes Before Launch ⚠️ |
| 40–59 | High Risk — Do Not Launch Yet 🔴 |
| 0–39 | Critical Issues — Redeployment Recommended ❌ |

---

### Step 4 — Output the audit report using this exact structure

````markdown
# Token Audit Report
**Audited:** [today's date]
**Standard:** [SPL Classic / Token-2022]
**Launchpad:** [their answer]

---

## Risk Score: [X]/100 — [Label]

[One sentence summarizing the overall picture. E.g.: "Your mint and freeze authorities are properly revoked, but retained LP tokens and centralized metadata are critical blockers before any public launch."]

---

## Findings

| Check | Your Configuration | Status | Severity | Points |
|---|---|---|---|---|
| Token standard | [their answer] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/[max] |
| Extension compatibility | [their answer or n/a] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/10 |
| Mint authority | [their answer] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/20 |
| Freeze authority | [their answer] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/15 |
| LP token status | [their answer] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/20 |
| Team allocation | [X]%, [vested/liquid] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/10 |
| Vesting platform | [their answer] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/5 |
| Metadata storage | [their answer] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/5 |
| Launchpad alignment | [their answer] | ✅ / ⚠️ / 🔴 | Note only | — |
| Liquidity depth | ~$[X] | ✅ / ⚠️ / 🔴 | — / Medium / High / Critical | [X]/5 |

---

## Critical Fixes

[Only include if there are Critical or High severity findings. List in order: most severe first, then by points impact. If none, write "None — your configuration passes all critical checks."]

**1. [Most critical item]**
What's wrong: [exact consequence from red-flags.md — name the specific scanner, platform, or on-chain effect]
Fix: [specific tool, transaction, or action — no generic advice]
Reference: `skill/red-flags.md` → [Anti-pattern name]

**2. [Next item]**
What's wrong: [consequence]
Fix: [specific action]
Reference: `skill/[relevant file].md`

[Continue for all Critical and High items...]

---

## Recommended Improvements

[Only include Medium severity items and optional upgrades. If none, omit this section.]

- **[Item]:** [What it is and why it strengthens the launch. Name the specific tool or platform.]
- **[Item]:** [Same format.]

---

## What You're Doing Right

[List every check that scored full points. Be specific — name what they did correctly and why it matters. Minimum one entry even if the score is low — find something to acknowledge.]

✅ **[Check name]:** [What they did and why it's the right call. One sentence.]
✅ **[Check name]:** [Same format.]

---

*Run `/token-launch-plan` to generate your full personalized launch strategy.*
````

---

## Scoring Consistency Notes

Apply these rules to avoid ambiguous scoring:

**Freeze authority edge case:** A freeze authority transferred to a Squads multisig still scores 0 for Check 4. Active freeze authority on any wallet — even a well-configured multisig — triggers DEX warning banners on Raydium, Meteora, Birdeye, and execution terminals. The only passing state is revoked. Exception: RWA tokens with a documented compliance requirement score 12 pts with a compliance multisig.

**LP "not yet seeded" neutrality:** Score 10/20 (neutral) if the pool has not been seeded yet. Do not penalize for something that hasn't happened. Flag it as "pending — execute burn or lock in the same transaction block as pool seeding."

**Vesting + zero team allocation:** If team allocation is 0% (common for memecoins), skip Check 7 and award full 5 pts — vesting is not applicable. If team allocation is >0% and vesting is "none," Check 7 scores 0 pts regardless of project type.

**Custom vesting contracts:** Always flag unaudited custom escrow contracts as High risk even if the schedule looks correct. The risk is contract vulnerability, not schedule design. Audited custom contracts (with a public audit report) score 3 pts.

**Launchpad mismatches (Check 9):** Do not deduct points — this is informational only. Examples to flag:
- DeFi utility token on Pump.fun → note that fewer than 2% of non-memecoins graduate
- Token-2022 with extensions launched via Pump.fun → note compatibility constraints at graduation
- Compliance token on a launchpad without compliance infrastructure → note the architectural mismatch

**IPFS metadata:** Score 3 pts (not 0) — IPFS is better than centralized but not permanent. Flag it as Medium: if the pinning service drops the CID, metadata 404s permanently. Recommended fix is migration to Arweave before launch.

**Score when answers are incomplete:** If a founder answers "not set yet" or "not sure" for a check, score 0 for that check and flag it as "Unknown — treat as unresolved risk." Do not award neutral points for unanswered questions except LP status (which has a legitimate "not yet seeded" state).
