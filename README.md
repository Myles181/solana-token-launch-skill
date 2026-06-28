# solana-token-launch-skill

A Claude Code skill that guides founders through the full Solana token launch decision stack — from launchpad selection and token standard choice through authority configuration, tokenomics design, liquidity seeding, and launch day execution. It routes each question to the right reference document and branches advice by project type, so a memecoin founder and a DeFi protocol founder get different answers to the same question.

## The Problem

Launching a token on Solana in 2026 involves a sequence of irreversible architectural decisions — mint program, extension set, authority configuration, pool type, LP disposition — where a wrong choice at any step can strand liquidity, trigger rug-detection flags, block CEX listings, or permanently limit the protocol's upgrade path. No single resource walks founders through the full decision stack in the right order, with the right branching logic per project type. This skill fills that gap.

## What's Covered

| File | Topic |
|---|---|
| `skill/launchpad.md` | Pump.fun, Raydium LaunchLab, DAOs.fun, Believe, Bags.fm — decision routing by project type |
| `skill/token-standard.md` | SPL Classic vs Token-2022, P-Token engine (SIMD-0266), extension selection, incompatibility matrix |
| `skill/authorities.md` | Mint authority, freeze authority, revocation vs multisig, Squads setup standards |
| `skill/tokenomics.md` | Fixed vs mintable supply, decimals, total supply conventions, allocation design, vesting |
| `skill/liquidity.md` | Raydium CPMM/AMM V4/CLMM, Meteora DLMM, Alpha Vault mechanics, LP burn vs lock |
| `skill/gtm.md` | T-minus checklist, community infrastructure, launch day sequencing, KOL due diligence, post-launch |
| `skill/red-flags.md` | 20 launch anti-patterns with exact on-chain consequences and specific fixes |
| `skill/resources.md` | Official documentation URLs for every platform and tool covered in this skill |
| `commands/token-launch-plan.md` | `/token-launch-plan` slash command — generates a personalized launch plan from 5 inputs |
| `commands/token-audit.md` | `/token-audit` slash command — audits token configuration and outputs a 0–100 risk score with fixes |
| `commands/launch-day-checklist.md` | `/launch-day-checklist` slash command — generates a timestamped, launchpad-specific launch day checklist |
| `agents/token-launch-advisor.md` | Persistent session agent — acts as a technical co-founder for the full launch lifecycle |
| `rules/safety.md` | Non-overridable safety rules — hot wallet authority, LP locks, freeze warnings, wash trading, legal deflection |
| `rules/defaults.md` | Default assumptions for unspecified inputs — project type, standard, supply, pool, LP strategy, vesting, multisig |
| `rules/scope.md` | Skill coverage boundaries — what's in scope, what defers to solana-dev-skill / crypto-legal-skill, what's out of scope |

## Install

```bash
curl -sSL https://raw.githubusercontent.com/Myles181/solana-token-launch-skill/main/install.sh | bash
```

## Usage

This skill activates when you ask Claude Code about Solana token launches. Claude will ask for your project type first (memecoin / DeFi utility / DAO / RWA / creator token), then route to the relevant reference files.

**Example prompts:**

1. *"I'm launching a memecoin next week — which launchpad should I use and should I use SPL or Token-2022?"*

2. *"What Token-2022 extensions do I need for a real-world asset token and which ones can't be combined?"*

3. *"Should I revoke mint authority or transfer it to a multisig? My project is a DePIN network with ongoing reward emissions."*

4. *"Walk me through the exact launch day sequence — what order do I execute things in and what are the fatal mistakes?"*

5. *"What's the right total supply and team allocation for a DeFi utility token, and how should I structure vesting?"*

6. *"I'm launching on Believe — what's the GTM strategy, how do I incentivize scouts, and how does the Alpha Vault work?"*

7. `/token-launch-plan` — interactive command that asks 5 questions and generates a complete, personalized launch plan document

8. `/token-audit` — paste your current token configuration and get a 0–100 risk score with a prioritized fix list

9. `/launch-day-checklist` — answer 2 questions and get a timestamped, launchpad-specific checklist to run on launch day

**Or use the persistent session agent:**
Invoke `agents/token-launch-advisor` for a full advisory session — the agent tracks your project type and session context across every question, routes to the right skill file automatically, and interrupts immediately if you describe a configuration that matches a known anti-pattern.

## Dependencies

This skill depends on **solana-dev-skill** for foundational Solana development context (program architecture, account model, transaction structure). Install it first if you don't already have it:

```bash
curl -sSL https://raw.githubusercontent.com/Myles181/solana-dev-skill/main/install.sh | bash
```

## Author

Built by [Myles](https://github.com/Myles181)

## License

MIT

---

*Current as of the 2026 Solana ecosystem. Covers PumpSwap graduation mechanics (post-March 2025), Raydium CPMM as the modern pool default, Token-2022 P-Token optimizations (SIMD-0266), Meteora Alpha Vault anti-snipe mechanics, Streamflow + Umbra private vesting, and the Believe / Bags.fm SocialFi launchpad layer.*
