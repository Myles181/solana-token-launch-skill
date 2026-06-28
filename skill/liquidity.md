# Liquidity Seeding & LP Management

This stage is initiated when the token exits the launchpad bonding curve or when a DeFi protocol seeds a pool directly. Pool type selection and LP token disposition are both permanent or near-permanent decisions — get them right before execution.

---

## Section 1 — Pool Type Selection

### Raydium CPMM (Constant Product Market Maker)
The modern default for Solana token launches. Uses the x*y=k model. ~0.3 SOL setup cost. No OpenBook Market ID required. Fully compatible with Token-2022 extensions including transfer fees and metadata. Instant deployment in a single transaction. Supports all standard fee tiers (0.25%, 1%, etc.) selected at pool creation.

Use for: most SPL Classic and all Token-2022 launches. The right choice unless there is a specific reason to use something else.

### Raydium Legacy AMM V4
The traditional Raydium pool engine. Requires an OpenBook Market ID to be created first, bringing total setup cost to 0.45–0.6 SOL and adding multi-transaction setup latency. Widely integrated into older trading bots and legacy wallet extensions — some bots built before 2024 will only route through AMM V4 pools.

**Critical limitation:** AMM V4 does not support Token-2022 standards. Attempting to seed an AMM V4 pool with a Token-2022 token that has active extensions will result in failed transactions or permanently trapped liquidity.

Use only for SPL Classic tokens where legacy bot routing coverage is a specific requirement and the setup cost is not a constraint.

### Raydium CLMM (Concentrated Liquidity Market Maker)
Allows LPs to concentrate capital within specific price ranges, yielding higher fee revenue per dollar of liquidity for active trading pairs. Requires tick-range configuration at setup (~0.3 SOL). Capital outside the configured range earns nothing — pools require active rebalancing as price moves.

Not suitable for bootstrapping. Early-stage tokens have undefined price ranges and high volatility; concentrated liquidity in a narrow band will go out of range immediately on launch day. Use CLMM only after the token has established a stable trading range and the team has automated rebalancing in place.

Use for: mature trading pairs post-establishment, institutional market-making setups.

### Meteora DLMM (Dynamic Liquidity Market Maker)
Discrete bin architecture where liquidity is organized into fixed-width price bins rather than a continuous curve. Supports dynamic fees that automatically widen during high-volatility periods, protecting LPs from impermanent loss during launch spikes. Used natively by Believe graduates.

**Meteora Alpha Vault — sniper protection mechanism:**
Projects launching on Meteora can activate the Alpha Vault before pool creation. The vault operates as follows:
- **24-hour deposit window:** Whitelisted participants deposit SOL into the vault before the pool opens
- **Pro-rata settlement:** At close, all deposits are settled proportionally against the token allocation — no participant can front-run another
- **Zero-slippage atomic launch:** The vault executes its purchase as a single atomic transaction at pool initialization, before any external wallet can submit a buy
- **30-day linear vesting:** Tokens acquired through the vault vest linearly over 30 days, eliminating immediate dump pressure from vault participants

The net effect: snipers cannot extract value from the opening block, and early participants are economically aligned through vesting rather than incentivized to dump immediately.

Use Meteora DLMM + Alpha Vault for: serious community tokens and DeFi launches where sniper protection and fair price discovery are priorities.

---

## Section 2 — Pool Comparison Table

| | Raydium CPMM | Raydium AMM V4 | Raydium CLMM | Meteora DLMM |
|---|---|---|---|---|
| **Setup cost** | ~0.2–0.3 SOL | ~0.45–0.6 SOL | ~0.3 SOL | ~0.3 SOL |
| **OpenBook ID required** | No | Yes | No | No |
| **Token-2022 compatible** | Yes | No | Yes | Yes |
| **Execution speed** | Instant | Multi-transaction | Moderate (tick setup) | Instant |
| **Sniper protection** | None native | None | None | Alpha Vault |
| **Best for** | Most launches | Legacy bot coverage | Mature pairs | Believe graduates, fair launches |

---

## Section 3 — LP Token Management

After seeding the pool, the LP tokens representing the team's share of the liquidity position must be disposed of. This decision is read immediately by every security scanner and block explorer.

### Burn (send to null address)
Send LP tokens to `11111111111111111111111111111111`. Provides definitive, permanent, on-chain proof that the liquidity pool can never be pulled or modified by the team. The strongest possible trust signal. Rug-detection platforms flip to green. No counterparty risk — the liquidity is mathematically locked forever.

**The cost:** No recovery. If the project later needs to migrate liquidity to a new pool version or adjust fee tiers, the seeded liquidity is stranded permanently. Plan accordingly — the initial seed should reflect long-term liquidity needs, not a minimal deployment intended to be adjusted later.

Use for: memecoins, creator tokens, any launch where "immutable liquidity" is part of the trust narrative.

### Lock via StakePoint
Escrow LP tokens in StakePoint's non-custodial locker. Zero-fee setup. All locks are publicly indexed and verifiable on Solana block explorers and security scanner integrations. The team retains the ability to reclaim liquidity after the lock expires.

Minimum recommended lock duration: **365 days**. Shorter locks signal that the team is planning an exit within the year and will be flagged as suspicious.

Use for: utility protocols and DeFi projects that need to demonstrate liquidity commitment while retaining the eventual ability to migrate, rebalance, or wind down the position.

### Keep (retain in hot wallet)
LP tokens remain in a developer-controlled wallet. The team can withdraw or adjust liquidity at any time, unilaterally and without notice.

Flagged as high-risk by every automated security scanner. Rug-detection bots post this status in community Telegram and Discord channels within minutes of launch. Sophisticated traders will not enter. This path is not viable for any token intended for real community adoption.

---

## Section 4 — Routing Logic

```
IF token_standard == TOKEN_2022:
    → Raydium CPMM (only compatible option on Raydium)
    → Select fee tier based on volatility:
        High volatility / memecoin: 1.0%
        Standard utility: 0.25%–0.5%

ELSE IF token_standard == SPL_CLASSIC:
    IF legacy_bot_routing_required AND budget >= 0.6 SOL:
        → Raydium AMM V4
    ELSE:
        → Raydium CPMM

IF launchpad == BELIEVE OR sniper_protection_required:
    → Meteora DLMM + Alpha Vault

IF trust_requirement == MAXIMUM (memecoin, creator token):
    → Burn LP tokens immediately after seeding

ELSE IF trust_requirement == PROFESSIONAL_ESCROW:
    → Lock LP via StakePoint, minimum 365 days
```

---

## Section 5 — Lock Platform Reference

**StakePoint** — LP token locks and custom staking pools. Non-custodial. Zero fees. All locks publicly indexed on Solana explorers. Natively supports Token-2022 transfer tax tokens. The standard choice for LP locks.

**Streamflow** — Linear, second-by-second token vesting for team and investor allocations. Integrates with Umbra privacy layer (May 2026) to shield recipient identities and unlock amounts from MEV front-running bots. Standard choice for team vesting.

**Magna** — Enterprise-grade platform for high-volume programmatic distributions, multi-tranche institutional vesting, and regulated airdrop management. Preferred for DePIN networks and institutional projects. Offers liquid vesting features and compliant registry management.

| Platform | Primary use | Token-2022 | Privacy | Verification |
|---|---|---|---|---|
| StakePoint | LP locks, staking pools | Native | Public (no privacy) | On-chain, Solscan indexed |
| Streamflow | Team & investor vesting | Native | Umbra integration available | Native dashboard |
| Magna | Institutional distributions | Enterprise API | Enterprise custody | Regulated platform reporting |

---

## Section 6 — Consequences of Misconfiguration

**AMM V4 + Token-2022 incompatibility:** Attempting to seed a Raydium AMM V4 pool with a Token-2022 token that has active extensions causes transaction failure or permanently traps the seeded liquidity in an unusable pool state. There is no recovery path — the tokens and SOL are locked in a non-functional position. Verify token standard before selecting pool type.

**Unlocked LP rug flag:** Automated on-chain tracking bots detect unlocked LP within minutes of pool creation and broadcast the status across Telegram signal bots, Birdeye, and DexScreener. The flag reads identically whether the team intends to rug or not. Even a legitimate team that plans to hold liquidity long-term will be treated as a rug risk until the LP is burned or locked. Execute LP disposition in the same transaction block as pool seeding where possible.

**CLMM at launch:** Seeding a concentrated liquidity pool with a narrow tick range on a newly launched token is almost guaranteed to go out of range within the first minutes of trading. When CLMM liquidity goes out of range, it stops earning fees and effectively functions as a limit order. The pool will look broken to traders who see no active liquidity depth.

**Short lock durations:** A 30-day or 90-day StakePoint lock signals to the market that the team plans to pull liquidity as soon as legally "locked" status expires. Scanners and community analysts read lock duration — 365 days is the minimum that reads as credible commitment.
