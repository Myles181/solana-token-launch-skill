# Mint & Freeze Authority Architecture

Resolve this after the initial supply is minted and before seeding liquidity or launching publicly. The state you set here is visible on every block explorer and scanned automatically by rug-detection tools. It directly affects whether DEXes show warning banners and whether institutional custodians will touch the token.

There are two authorities to manage independently: **Mint Authority** (who can create new tokens) and **Freeze Authority** (who can freeze individual user token accounts). They can be set differently and should be for some project types.

---

## The Three Paths

### Path 1 — Keep Authorities (Developer Retains)

The developer wallet holds both authorities after launch. Allows emergency balance interventions and dynamic supply adjustments without governance overhead.

**When it might be justified:** Pre-launch testnet phases, internal tooling tokens not held by the public, or compliance-gated assets where the developer IS the regulated entity and a full multisig setup hasn't been established yet.

**The problem:** Every rug-detection scanner flags retained authorities as extreme risk. Raydium, Jupiter, and Birdeye display prominent warnings on the trading interface. Sophisticated traders will not buy. Retail traders who do buy will be told by bots and community members that it's a rug. Even if the project is legitimate, retained hot-wallet authorities create a single-key exploit vector — one compromised private key allows minting arbitrary supply or freezing every holder's account simultaneously.

This path is not viable for any token intended for public trading.

### Path 2 — Revoke All (Burn to Null)

Both authorities are set to `None`. This is irreversible. On-chain proof that no new supply can ever be minted and no user balance can ever be frozen.

The strongest possible trust signal for retail traders. Warning banners disappear. Security scanners flip to green. No coordination required for future on-chain actions because there are no future on-chain authority actions — the protocol is now static.

**The cost:** Zero upgrade path. If the business model later requires minting ecosystem rewards, adjusting compliance state, or responding to a regulatory freeze requirement, the only option is deploying a new mint and migrating. That is an extremely disruptive operation.

Use this path when the token's value proposition is explicitly immutability — memecoins, pure store-of-value assets, and any token where the "no admin keys" narrative is part of the pitch.

### Path 3 — Transfer to Multisig (Squads Protocol)

Authorities are transferred to a Squads multisig PDA. The developer team loses unilateral control; any authority action requires M-of-N key holders to co-sign a transaction.

Maintains operational flexibility (minting rewards, compliance actions, protocol upgrades) while eliminating the single-key exploit vector. Squads multisigs are publicly readable on-chain — security scanners recognize them and rate them as low risk rather than flagging them.

**Squads setup standards:**
- Minimum threshold for early-stage protocols: **3-of-5**
- Recommended threshold for mature protocols: **5-of-7**
- All signing keys should be hardware wallets (Ledger or equivalent) — never hot wallets
- Signers should be geographically distributed to prevent physical compromise of a quorum
- Document the signer list publicly if the project requires institutional trust

---

## Comparison Table

| Configuration | Retail signal | Security scanner rating | Custodian / institutional suitability | Upgrade path |
|---|---|---|---|---|
| **Developer retained** | High fraud risk | Red flag — extreme threat | Unusable | Instantaneous (single key) |
| **Fully revoked** | Maximum trust | Green — safe | High (pure commodities only) | None — protocol is static |
| **Squads multisig** | Moderate trust | Low flag — vetted setup | Mandatory standard | Structured governance |

---

## Routing by Project Type

```
IF project_type == MEMECOIN OR DEGEN_RETAIL:
    → RevokeMintAuthority()
    → RevokeFreezeAuthority()
    (Both to None — irreversible)

ELSE IF project_type == DEPIN OR REWARD_PROTOCOL:
    → Transfer MINT_AUTHORITY to Squads multisig (3-of-5 minimum)
    → RevokeFreezeAuthority()
    (Freeze revoked to eliminate DEX warning banners;
     mint retained under governance for reward emissions)

ELSE IF project_type == COMPLIANT_RWA:
    → Transfer MINT_AUTHORITY to institutional multisig
    → Transfer FREEZE_AUTHORITY to registered compliance multisig
    (Separate signers for each authority — operational and compliance
     controls should not share the same key set)
```

Note: For DePIN and utility protocols, revoking freeze authority even while retaining mint authority under multisig is the correct call. Freeze authority on a tradable token triggers DEX warnings regardless of how the mint authority is configured.

---

## Consequences of Misconfiguration

**DEX warning banners (active freeze authority):** Seeding a Raydium or Meteora pool while freeze authority is retained triggers visible warnings on the trading UI. Birdeye, Jupiter, and Dexscreener surface these prominently. Retail buyer participation drops immediately. The banner does not go away until freeze authority is revoked — and revoking it after launch, while it helps, means the damage from the initial warning period has already accumulated.

**Single-key exploit (retained hot wallet authority):** A compromised developer wallet allows an attacker to mint arbitrary token quantities in a single transaction. Supply dilutes instantly. There is no recovery — the attacker can repeat the mint until the market price is zero. Physical theft, phishing, and seed phrase leaks are all viable attack vectors against a hot wallet holding mint authority.

**Rug detection flags (retained authorities without multisig):** Automated scanners used by Telegram bots, Discord security bots, and aggregators like RugCheck flag retained authorities as high-risk within minutes of launch. These flags circulate faster than any marketing the team can run. Even a legitimate project with retained authorities will spend most of its early community energy defending against rug accusations rather than building.

**Compliance multisig not separated from operational multisig (RWA):** For regulated assets, using the same Squads multisig for both mint authority and freeze authority concentrates regulatory control in a single governance body. Regulators and institutional custodians typically require these to be independently controlled to satisfy segregation-of-duties requirements.

---

## 2026 Defaults

| Project type | Mint authority | Freeze authority |
|---|---|---|
| Memecoin | Revoke | Revoke |
| Creator / social token | Revoke | Revoke |
| DeFi utility | Squads 3-of-5 | Revoke |
| DePIN / reward protocol | Squads 3-of-5 | Revoke |
| DAO governance token | Squads 5-of-7 | Revoke |
| Compliant RWA | Institutional multisig | Separate compliance multisig |
