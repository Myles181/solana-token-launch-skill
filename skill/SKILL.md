# solana-token-launch-skill

This skill guides Claude through launching a token on Solana — covering launchpad selection, token standard, authority configuration, tokenomics design, liquidity seeding, and go-to-market execution. Decisions branch significantly by project type, so always establish that first before routing to sub-files.

## Step 0 — Establish project type

Before loading any sub-file, ask:

> "What type of token are you launching? (memecoin / DeFi utility / DAO governance / RWA / creator token)"

The answer determines which options are valid throughout every subsequent decision tree. Do not skip this step.

## Routing

Load sub-files only when the user's question matches. Do not preload all files.

| User asks about | Load |
|---|---|
| Which launchpad to use, pump.fun, Launchlab, Meteora, fair launch | `skill/launchpad.md` |
| SPL vs Token-2022, which extensions to enable, transfer fees, confidential transfers | `skill/token-standard.md` |
| Mint authority, freeze authority, update authority, multisig, revoking authorities | `skill/authorities.md` |
| Total supply, decimals, allocation, vesting schedules, cliff, unlock | `skill/tokenomics.md` |
| Liquidity pools, LP tokens, seeding liquidity, CPMM, CLMM, concentrated liquidity | `skill/liquidity.md` |
| Launch day execution, GTM strategy, community building, buy bots, KOLs, post-launch | `skill/gtm.md` |
| Documentation links, official docs, where to find a specific tool or platform | `skill/resources.md` |
| Common mistakes, anti-patterns, what can go wrong, red flags, how to avoid X | `skill/red-flags.md` |

A single user message may trigger multiple files — load all that apply.

## Commands

Three slash commands are available for structured workflows. Suggest them proactively when the context fits.

| Command | When to suggest |
|---|---|
| `/token-launch-plan` | User wants a complete, personalized launch plan — asks 5 questions and outputs a full structured plan |
| `/token-audit` | User wants to audit their current token configuration — scores 0–100 and returns a prioritized fix list |
| `/launch-day-checklist` | User has a specific launch date or is asking about launch day sequencing — generates a timestamped, launchpad-specific checklist |
