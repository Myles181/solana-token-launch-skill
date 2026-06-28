# Supply Architecture & Tokenomics Design

Finalize these parameters before constructing the `InitializeMint` instruction. Supply, decimals, and initial allocation are all set at mint creation. Decimals cannot be changed after initialization; supply model is effectively locked once mint authority is revoked.

---

## Section 1 — Fixed vs Mintable Supply

### Fixed Supply
Total supply is minted at initialization and mint authority is revoked. The protocol is permanently deflationary — no new tokens can enter circulation.

**When to use:** Memecoins, store-of-value assets, governance tokens where dilution is politically unacceptable, and any token where "no admin keys" is part of the trust narrative. Fixed supply pairs naturally with full authority revocation.

**The trade-off:** Zero flexibility. No staking rewards, no ecosystem grants minted over time, no programmatic emission schedules. All future distribution must come from the initial treasury allocation.

### Mintable (Dynamic) Supply
Mint authority is retained (under multisig) to support programmatic expansion. Emission schedules are controlled by governance or automated on-chain logic.

**When to use:** DePIN networks paying hardware operators, play-to-earn reward pools, algorithmic stablecoin collateral layers, and any protocol where on-chain contributions need to be compensated in the native token over time.

**The trade-off:** Requires active trust management. Holders will scrutinize every mint event. Without a public emission cap and verifiable multisig control, dynamic supply reads as a rug vector to scanners and sophisticated traders. Always pair with a publicly communicated max supply ceiling.

### Routing

```
IF project_type == MEMECOIN OR STORE_OF_VALUE:
    → Fixed supply — revoke mint authority at launch

IF project_type == DEFI_UTILITY OR GOVERNANCE:
    → Fixed or max-capped — decide based on whether
      staking emissions are required

IF project_type == DEPIN OR REWARD_PROTOCOL:
    → Mintable with hard cap — mint authority under Squads multisig,
      emission schedule published on-chain

IF project_type == STABLECOIN OR TRANSACTION_RAIL:
    → Dynamic, issuer-gated — mint authority never revoked,
      controlled by compliance multisig
```

---

## Section 2 — Decimals

Decimals cannot be changed after mint initialization. This is a permanent parameter.

### 6 Decimals
Standard for memecoins, stablecoins (USDC uses 6), and transactional assets. Matches the precision of standard Solana trading pairs, minimizing calculation overhead and UI rendering issues across wallets, DEX interfaces, and portfolio trackers.

Use for: memecoins, DeFi utility tokens, governance tokens, RWA platforms.

### 9 Decimals
Standard for native SOL. Supports hyper-fractionalized micropayments and high-precision DeFi calculations. Required when reward emissions need to be distributed at sub-cent granularity per device or per transaction.

Use for: DePIN networks paying hardware operators, high-precision staking reward calculators.

### The floating-point consequence
Launching a high-supply token (e.g., 10^15 raw units) with 9 decimals causes JavaScript's 64-bit float to hit precision limits. Standard wallets and price trackers lose accuracy at large magnitudes — users see incorrect balances, broken swap quotes, and failed transaction flows. The safe combination is 1,000,000,000 total supply with 6 decimals: the raw unit count stays well within safe integer range for all standard tooling.

### Decimals by project type

| Project type | Decimals | Reason |
|---|---|---|
| Memecoin | 6 | Standard DEX pair precision, no fractional edge cases |
| DeFi utility | 6 | CEX and wallet compatibility |
| Governance | 6 | Vote counting doesn't require sub-unit precision |
| DePIN rewards | 9 | Micropayment granularity per device/epoch |
| RWA | 6 | Matches stablecoin pair precision |
| Stablecoin | 6 | Mirrors USDC standard |

---

## Section 3 — Total Supply Conventions

| Project type | Supply model | Total supply | Decimals |
|---|---|---|---|
| Memecoin | Fixed | 1,000,000,000 | 6 |
| DeFi utility | Fixed or max-capped | 1,000,000,000 | 6 |
| DePIN network | Mintable with hard cap | Protocol-defined | 9 |
| RWA platform | Fixed, asset-backed | Asset-proportional | 6 |
| Stablecoin / rail | Dynamic, issuer-gated | Demand-driven | 6 |

The 1B supply with 6 decimals combination is the 2026 Solana standard. Deviating requires a specific justification — not preference.

---

## Section 4 — Allocation Design

### Team allocation limits by project type

| Project type | Max team + advisors | Vesting requirement | Notes |
|---|---|---|---|
| Memecoin | 0–5% | Direct public seeding — no lock required | Any team allocation over 5% will be flagged by scanners |
| DeFi utility | 15% | Escrowed on Streamflow or Magna | Include investors in this cap |
| DePIN network | 20% | Automated payroll routing via Streamflow | Higher cap justified by long emission timelines |
| RWA platform | 10% | Compliance multisig escrow | Regulatory scrutiny makes lower caps safer |

### Distribution conventions by project type

**Memecoin**
- 0–5% team (optional, often 0%)
- 85–95% public via launchpad bonding curve
- 0–10% marketing / KOL wallets (funded from team allocation)
- No treasury; no ecosystem fund

**DeFi utility**
- 15% team + advisors (vested 36 months, 12-month cliff)
- 10–15% investors (vested, separate schedule)
- 20–30% community / ecosystem incentives (multi-year release)
- 10–15% treasury (multisig-controlled)
- 30–40% public sale / liquidity

**DePIN network**
- 20% team (vested, long-term)
- 10% investors
- 40–50% network rewards (emitted over protocol lifetime)
- 10% treasury
- 10–15% ecosystem / grants

**RWA platform**
- 10% team (compliance escrow)
- 10% institutional investors
- 50–60% asset-backing reserve (1:1 with underlying asset)
- 10–15% liquidity
- 10% operations

### Vesting platform guidance
For team and investor vesting: **Streamflow** (linear second-by-second streaming, optional Umbra privacy layer to shield unlock amounts from MEV front-running). For institutional or high-volume distributions: **Magna**. See `skill/liquidity.md` for LP lock guidance.

---

## Section 5 — Consequences of Misconfiguration

**Over-allocated team without vesting:** Direct allocation of more than 30% to team and advisor wallets without a vesting contract is flagged immediately by automated security scanners. High wallet concentration — even if the team is legitimate — reads as a structural dump risk. Sophisticated traders will not enter, and Telegram bots will post the scanner result in every community channel within minutes of launch.

**Cliff-based unlocks instead of linear streaming:** Large discrete unlock events create public targets for speculation. MEV bots and short sellers track public vesting contracts on-chain and coordinate positions before known unlock dates. Linear second-by-second streaming (Streamflow's model) removes the discrete event — there is no cliff date for bots to front-run.

**Wrong decimals for supply magnitude:** A 9-decimal token with a 10^15 raw unit supply hits JavaScript's safe integer limit (`Number.MAX_SAFE_INTEGER` = 2^53 - 1 ≈ 9 × 10^15). At that boundary, standard wallet SDKs display incorrect balances and swap UIs produce broken quotes. This is not caught in low-volume testing — it surfaces when real users with large holdings try to transact.

**No ecosystem fund allocation:** Launching with 100% of supply seeded to the bonding curve or liquidity works for memecoins but leaves DeFi and DePIN projects with no capital for grants, integrations, or protocol-owned liquidity after launch. Retroactively creating a treasury allocation post-launch requires a new mint event (only possible with mintable supply) or buying tokens on the open market.

---

## 2026 Defaults

- **Total supply:** 1,000,000,000 (1 billion)
- **Decimals:** 6
- **Team cap:** 15% (DeFi/utility), 0–5% (memecoin)
- **Vesting:** 36-month linear stream, 12-month cliff, on Streamflow
- **Supply model:** Fixed for memecoins and governance; mintable with hard cap for DePIN
