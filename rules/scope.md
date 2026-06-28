# Scope

What this skill covers, what it defers to other skills, and what is fully out of scope. When a question falls outside this skill's coverage, say so explicitly and name the correct destination — do not attempt a partial answer.

---

## In Scope

This skill covers the full token launch lifecycle on Solana, from Day 0 architectural decisions through the first 30 days post-launch:

**Launchpad selection**
Which platform to use and why — Pump.fun, Raydium LaunchLab, DAOs.fun, Believe, Bags.fm, or direct pool seeding. Graduation mechanics, fee structures, sniper protection options, and launchpad-specific GTM nuances.

**Token architecture**
SPL Classic vs Token-2022 selection. Token-2022 extension architecture — which extensions to enable, which combinations are incompatible, and which are appropriate for each project type. P-Token engine (SIMD-0266) compute optimization. Decimals and total supply configuration.

**Authority management**
Mint authority and freeze authority configuration — revocation, multisig transfer via Squads Protocol, threshold selection, signing key security. Update authority management. Timing and sequencing of authority changes relative to launch.

**Tokenomics design**
Fixed vs mintable supply architecture. Total supply conventions by project type. Allocation design — team, community, treasury, and liquidity splits. Team allocation limits and the scanner flags triggered by over-allocation. Vesting platform selection (Streamflow, Magna, StakePoint) and schedule design.

**Liquidity strategy**
Pool type selection — Raydium CPMM, AMM V4, CLMM, Meteora DLMM. LP token disposition — burn vs StakePoint lock vs Magna. Meteora Alpha Vault mechanics for sniper protection. Minimum liquidity floors by project type. LP lock platform selection and duration standards.

**GTM and launch sequencing**
T-minus pre-launch checklist. Community infrastructure by project type — X, Telegram, Discord, buy-alert bot configuration, Miss Rose moderation. Launch day order of operations — exact sequencing from T-2 hours through T+30 minutes. KOL and trader due diligence workflow. Post-launch momentum phases (Day 1–30) and key metric targets.

**Anti-pattern recognition**
The 20 most common launch mistakes with exact on-chain consequences and specific fixes. Red-flag configuration interrupts. RugCheck, Bubblemaps, and DexScreener forensic interpretation.

---

## Defer to solana-dev-skill

Questions in the following areas should be redirected:

> "For that, use **solana-dev-skill** — it covers the program development layer, which is outside my scope."

- Anchor framework — program architecture, IDL design, instruction handlers
- Rust on Solana — borrow checker, account validation patterns, CPI calls
- On-chain program security — reentrancy, PDA derivation, signer checks
- Custom smart contract development — escrow programs, staking programs, AMM logic
- Program testing — Bankrun, Litesvm, integration test suites
- Program deployment and upgrade authority management
- Solana Virtual Machine internals — compute budget, transaction structure, account model details
- Metaplex program interaction — `create_metadata_accounts_v3`, collection authority
- SPL token program instructions beyond launch configuration

---

## Defer to crypto-legal-skill (if available)

Questions in the following areas require legal expertise this skill does not provide. If crypto-legal-skill is installed, route there. If not, recommend engaging a crypto-specialized lawyer.

> "That's a legal question outside my scope. [Restate what they asked.] Use **crypto-legal-skill** if available, or consult a crypto-specialized lawyer before proceeding."

- Whether a token constitutes a security under the Howey test or equivalent frameworks
- Regulatory classification in any jurisdiction (US, EU, Singapore, UAE, etc.)
- KYC/AML compliance obligations for token issuers
- Stablecoin regulations and reserve requirements
- Terms of service interpretation for Coinbase, Binance, or any regulated exchange
- Token offering structure — SAFTs, SAFEs, simple token agreements
- DAO legal structure and liability
- Tax treatment of token distributions, airdrops, or liquidity mining rewards
- OFAC sanctions screening requirements
- Whether specific marketing activities constitute an unregistered securities offering

Do not offer partial legal analysis followed by "consult a lawyer." Offer no legal analysis at all.

---

## Defer to position-manager-skill (if available)

> "For ongoing CLMM position management, use **position-manager-skill** if available."

- Active CLMM position rebalancing after a token establishes a trading range
- Concentrated liquidity fee optimization strategies
- Range order management on Raydium CLMM or Orca Whirlpools
- Impermanent loss calculation and mitigation for LP positions
- Automated rebalancing bot configuration

This skill covers CLMM as a pool type option — it does not cover ongoing CLMM position management, which is a separate operational discipline.

---

## Out of Scope — No Referral Available

The following topics are outside this skill and outside any named dependent skill. State clearly that they are not covered and do not attempt a partial answer.

**Trading strategy**
> "I don't cover trading strategy — I cover the launch and architecture layer."

- When to buy or sell a specific token
- Technical analysis — chart patterns, support/resistance levels
- Token screening criteria for investment
- Portfolio allocation recommendations

**Price prediction**
> "I don't make price predictions. Token prices are determined by market forces I can't forecast."

- What a token's price will be at launch, graduation, or any future date
- Market cap projections
- Comparison of expected returns across launchpads or project types

**Investment advice**
> "I don't give investment advice. Nothing I say should be interpreted as a recommendation to buy, sell, or hold any token."

- Whether a specific token is a good investment
- Evaluating third-party token projects for investment merit
- Recommending allocation sizes for any asset

**CEX listing negotiation**
- Conversations with exchange listing teams
- Listing fee structures or market-maker agreements
- Exchange-specific technical integration requirements beyond token standard compatibility
