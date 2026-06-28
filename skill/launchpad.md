# Launchpad Selection

This is a Day 0 decision. Do not generate mint metadata, deploy on-chain programs, or lock in marketing assets until this is resolved.

## Routing Decision Tree

```
IF project_type == MEMECOIN:
    IF launch_trigger == TWEET_OR_REPLY:
        → Believe
    ELSE IF target == RETAIL_TRENCHES:
        → Pump.fun (USDC pair)
    ELSE:
        → Raydium LaunchLab

ELSE IF project_type == CREATOR_OR_BRAND_IP:
    → Bags.fm
    IF royalty_recirculation_required:
        → Enable @DividendsBot

ELSE IF project_type == INVESTMENT_DAO OR COLLECTIVE_FUND:
    → DAOs.fun

ELSE IF project_type == DEFI_UTILITY OR RWA:
    → Skip launchpads → Direct pool seed on Raydium CPMM or Meteora
```

---

## Platform Profiles

### Pump.fun
Optimized for high-velocity retail memecoins. Pricing is governed by a virtual bonding curve; graduation (~$69k–$100k market cap) migrates natively to **PumpSwap** (program ID: `pAMMBay6oceH9fJKBRHGP5D4bD4sWpmSwMn52FMfXEA`). The March 2025 vertical integration removed the legacy 6 SOL migration fee and eliminated Raydium routing latency. USDC trading pairs added May 2026 insulate early price action from SOL volatility. Zero creation cost.

### Raydium LaunchLab
Built for DeFi utility tokens, hybrid communities, and structured protocols. Offers customizable bonding curves, flexible fee tiers, and multiple quote tokens. Graduation routes directly into Raydium **CPMM or CLMM**, enabling immediate institutional routing and algorithmic market-making. 25% of protocol fees are used to buy and burn $RAY.

### DAOs.fun
For investment DAOs and decentralized hedge funds. Fixed-price 7-day fundraising window where investors deposit SOL for DAO tokens. A designated fund manager deploys the capital. Fund expires after a predetermined window (3–12 months); net assets dissolve and distribute proportionally to token holders at expiry. No secondary market graduation.

### Believe
Tweet-to-token SocialFi deployment. Initiate by replying to @launchcoin with `$TICKER Name`. Protocol abstracts wallet setup and deploys a bonding curve backed by **Meteora Dynamic Bonding Curves** (system authority: `5qWya6UjwWnGVhdSBL3hyZ7B45jbk6Byt1hwd7ohEGXE`). Graduates to locked Meteora liquidity at **$100k market cap**. Creator earns 1% of volume perpetually; scouts who surface the token earn 0.1% perpetually.

### Bags.fm
Creator and brand IP tokens with a **1% perpetual volume royalty** baked into the token design. Communities can mint on behalf of an influencer or brand; the creator claims royalties after verifying social identity via the Bags app. Activate **@DividendsBot** to auto-distribute royalties to the top 100 holders every 24h (triggers when unclaimed earnings exceed 10 SOL).

### Direct Pool Seeding
DeFi protocols and RWAs should skip launchpads entirely. Seed directly on Raydium CPMM (~0.3 SOL, no OpenBook ID required, Token-2022 compatible) or Meteora. Retains full control over initial price, liquidity depth, and pool configuration without bonding curve constraints.

---

## Comparison Table

| | Pump.fun | LaunchLab | DAOs.fun | Believe | Bags.fm |
|---|---|---|---|---|---|
| **Best for** | Retail memecoins | DeFi / serious community | Investment DAOs | Social / tweet memes | Creator / brand IP |
| **Graduation venue** | PumpSwap | Raydium CPMM or CLMM | Cash dissolution | Meteora DAMM | Meteora / Raydium |
| **Graduation cap** | $69k–$100k | Customizable | N/A (fixed term) | $100k | N/A (direct swap) |
| **Creation cost** | Zero | Variable | Variable | Zero | Zero |
| **Creator fee** | 0.05% of volume (post-grad) | Customizable | Performance carry | 1% perpetual + 0.1% scout | 1% perpetual volume royalty |
| **Anti-snipe** | None native | Configurable curve params | N/A | Bonding curve | Bonding curve |
| **Access** | Permissionless | Curated / permissionless | Whitelisted | Social (Twitter) | Permissionless / social claim |

---

## Consequences of Wrong Launchpad

**DeFi utility token on Pump.fun:** Exposes a serious protocol to extreme front-running and memecoin speculation culture. Fewer than 2% of non-memecoin launches on Pump.fun ever reach a DEX. Dilutes positioning, invites immediate exit by retail traders, and makes institutional conversations nearly impossible after the fact.

**Social IP token on a standard launchpad:** No system-level royalty fee mechanism means the creator earns nothing on secondary volume. Forces manual donation-based monetization. The creator has no on-chain claim to enforce, which destroys the core value proposition.

**Investment DAO on Pump.fun or LaunchLab:** The bonding curve structure is incompatible with a collective fund model. Investors get speculative exposure to a curve, not a proportional claim on managed assets. Legal and structural misalignment is severe.

**Skipping direct seeding for a DeFi protocol:** Launching a serious protocol through a memecoin launchpad anchors its reputation in retail speculation. The bonding curve prevents controlled price discovery and locks the team into graduation mechanics they don't control.

---

## 2026 Recommended Defaults by Project Type

| Project type | Default launchpad | Rationale |
|---|---|---|
| Memecoin (retail) | Pump.fun (USDC pair) | Eliminates SOL-denominated volatility during early curve phase |
| Memecoin (tweet-native) | Believe | Zero friction, social distribution built in |
| Community / project-backed | Raydium LaunchLab | Direct upgrade path to CPMM; credible fee structure |
| Creator / influencer token | Bags.fm + @DividendsBot | Only platform with a native perpetual royalty mechanism |
| Investment DAO | DAOs.fun | Only platform architected for collective fund mechanics |
| DeFi protocol / RWA | Direct CPMM or Meteora seed | Full control; launchpad constraints are net negative |
