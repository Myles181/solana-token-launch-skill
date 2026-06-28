# solana-token-launch-skill

A Claude Code skill that guides founders through the full Solana token launch decision stack — from launchpad selection and token standard choice through authority configuration, tokenomics design, liquidity seeding, and launch day execution. It routes each question to the right reference document and branches advice by project type, so a memecoin founder and a DeFi protocol founder get different answers to the same question.

## The Problem

Launching a token on Solana in 2026 involves a sequence of irreversible architectural decisions — mint program, extension set, authority configuration, pool type, LP disposition — where a wrong choice at any step can strand liquidity, trigger rug-detection flags, block CEX listings, or permanently limit the protocol's upgrade path. No single resource walks founders through the full decision stack in the right order, with the right branching logic per project type. This skill fills that gap.

## What's Covered

| File | Topic |
|---|---|
| `skill/launchpad.md` | Pump.fun, Raydium LaunchLab, DAOs.fun, Believe, Bags.fm — decision routing by project type |
| `skill/token-standard.md` | SPL Classic vs Token-2022, P-Token engine (SIMD-0266), extension selection |
| `skill/token-standard.md` | Token-2022 extension architecture, incompatibility matrix, routing by asset type |
| `skill/authorities.md` | Mint authority, freeze authority, revocation vs multisig, Squads setup standards |
| `skill/tokenomics.md` | Fixed vs mintable supply, decimals, total supply conventions, allocation design, vesting |
| `skill/liquidity.md` | Raydium CPMM/AMM V4/CLMM, Meteora DLMM, Alpha Vault mechanics, LP burn vs lock |
| `skill/gtm.md` | T-minus checklist, community infrastructure, launch day sequencing, KOL due diligence, post-launch |

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

## Dependencies

This skill depends on **solana-dev-skill** for foundational Solana development context (program architecture, account model, transaction structure). Install it first if you don't already have it:

```bash
curl -sSL https://raw.githubusercontent.com/Myles181/solana-dev-skill/main/install.sh | bash
```

## License

MIT

---

*Current as of the 2026 Solana ecosystem. Covers PumpSwap graduation mechanics (post-March 2025), Raydium CPMM as the modern pool default, Token-2022 P-Token optimizations (SIMD-0266), Meteora Alpha Vault anti-snipe mechanics, Streamflow + Umbra private vesting, and the Believe / Bags.fm SocialFi launchpad layer.*
