# Defaults

These are the assumptions Claude uses when the user has not specified a value. Apply them silently — do not announce that you are using a default. If a default leads to a recommendation, state the recommendation and mention the assumption inline so the user can correct it if wrong.

Example of correct usage:
> "Assuming you're on SPL Classic since you haven't mentioned compliance requirements — use Raydium CPMM for the pool. If you're actually on Token-2022, the answer is the same, but let me know."

Example of incorrect usage:
> "According to my defaults, I will now assume SPL Classic and apply the standard pool recommendation."

---

## Default: Project Type → Memecoin

Memecoins are the dominant token category launched on Solana in 2026 by volume. When project type is unspecified, apply memecoin-appropriate recommendations: zero or minimal team allocation, full authority revocation, LP burn, no formal vesting, Pump.fun as the primary launchpad consideration.

Trigger a project type clarification if the user's question is clearly inconsistent with memecoin assumptions — for example, asking about compliance features, team vesting schedules, or DAO governance implies a non-memecoin project type.

---

## Default: Token Standard → SPL Classic

Use SPL Classic (`TokenkegQfeZyiMwAzb61madMZ6m1tocu39asSp9vUt`) unless the user's project explicitly requires one of the following:

- Protocol-level transfer tax → Token-2022 (TransferFeeConfig)
- KYC gating or compliance hooks → Token-2022 (TransferHook)
- Asset recovery or regulatory freeze capability → Token-2022 (PermanentDelegate)
- Confidential balances → Token-2022 (ConfidentialTransfer)

SPL Classic with the P-Token engine (SIMD-0266) provides ~500–1,000 CU per transfer (vs ~15,000–45,000 for Token-2022 with extensions), universal CEX compatibility, and zero extension incompatibility risk. It is the correct choice for the majority of launches.

---

## Default: Total Supply → 1,000,000,000 with 6 decimals

1 billion tokens at 6 decimals is the 2026 Solana standard for memecoins, DeFi utility tokens, and governance tokens. This combination keeps raw unit counts well within JavaScript's safe integer range (`Number.MAX_SAFE_INTEGER` ≈ 9 × 10^15), preventing balance display bugs across standard wallet SDKs.

Deviations require explicit justification:
- 9 decimals: only for DePIN networks requiring micropayment granularity per device or epoch
- Supply above 1B: only with specific narrative reasoning (e.g., asset-backed RWA proportionality)
- Supply below 1B: only if the project has a specific reason to limit divisibility

---

## Default: Liquidity Pool → Raydium CPMM

Raydium CPMM is the modern default for Solana token launches: ~0.2–0.3 SOL setup cost, no OpenBook Market ID required, Token-2022 compatible, instant single-transaction deployment. It supports all standard fee tiers and is compatible with both SPL Classic and Token-2022.

Override this default when:
- The token is SPL Classic **and** legacy bot routing coverage is a hard requirement → Raydium AMM V4
- The project requires sniper protection and fair price discovery → Meteora DLMM + Alpha Vault
- The token has reached a stable trading range post-launch → Raydium CLMM (not for bootstrapping)

---

## Default: LP Strategy → Burn (memecoin) / StakePoint lock (utility)

**Memecoin default:** Burn LP tokens to `11111111111111111111111111111111` immediately after pool seeding. Provides the strongest trust signal, eliminates rug-pull flagging, and is the community expectation for retail tokens.

**Utility / DeFi / DAO default:** Lock LP via StakePoint with a minimum 365-day duration. Provides public, verifiable proof of liquidity commitment while preserving the eventual ability to migrate or rebalance. Publish the StakePoint lock URL alongside the CA broadcast.

**RWA default:** Lock via StakePoint or Magna, minimum 365 days, with documented unlock conditions aligned to the asset's compliance requirements.

Do not recommend retaining LP tokens for any public token under any default scenario.

---

## Default: Vesting → Streamflow linear, 12-month cliff, 36-month total

For any project with team, advisor, or investor allocations:

- **Platform:** Streamflow
- **Schedule:** Linear second-by-second streaming (not cliff-based discrete unlocks)
- **Cliff:** 12 months from TGE
- **Total duration:** 36 months
- **Privacy:** Standard public contract unless the user specifies privacy requirements, in which case activate Umbra integration to shield recipient identities and unlock amounts from MEV front-running

This default does not apply to memecoins with 0% team allocation — vesting is not applicable in that case.

Cliff-based vesting with discrete unlock dates is never the default — it creates predictable MEV targets. Only use cliff releases when contractually required by investor agreements, and always pair with Umbra private streaming if so.

---

## Default: Multisig → Squads 3-of-5

When a multisig is required (utility tokens, DePIN, RWA, any project retaining mint authority), default to Squads Protocol with a 3-of-5 threshold.

- All 5 signing keys must be on hardware wallets (Ledger or equivalent)
- No hot wallet keys in the signer set
- For mature protocols or high-value treasuries: upgrade to 5-of-7

Do not recommend 2-of-3 as a starting configuration — the reduced key count meaningfully lowers the threshold for compromise while providing limited operational benefit over 3-of-5.
