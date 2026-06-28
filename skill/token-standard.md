# Token Standard Selection

This decision must be made at mint initialization. It is irreversible — you cannot add Token-2022 extensions to a mint deployed under the SPL Classic program, and you cannot remove extensions from a Token-2022 mint after initialization. Get this right before writing any on-chain state.

---

## Section 1 — SPL Classic vs Token-2022

### Program IDs
- SPL Classic: `TokenkegQfeZyiMwAzb61madMZ6m1tocu39asSp9vUt`
- Token-2022: `TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb`

### Routing Decision Tree

```
IF token_requires_transfer_tax == TRUE:
    → Token-2022 (TransferFeeConfig)

ELSE IF token_requires_compliance_checks == TRUE:
    → Token-2022 (TransferHook)

ELSE IF token_represents_rwa_or_security == TRUE:
    → Token-2022 (PermanentDelegate + MetadataPointer)

ELSE IF gas_efficiency_at_mass_scale == HIGH_PRIORITY:
    → SPL Classic (P-Token compute pathways)

ELSE:
    → SPL Classic (default — maximum ecosystem compatibility)
```

### Comparison Table

| Attribute | SPL Classic | SPL Classic + P-Token | Token-2022 |
|---|---|---|---|
| **Typical transfer cost** | ~10,000 CU | ~500–1,000 CU | ~15,000–45,000 CU (varies by extension) |
| **CEX compatibility** | 100% native | 100% native (backwards compatible) | Fragmented — depends on active extensions |
| **Programmability** | None (static balance) | None (static balance) | Rich, modular — hooks, native fees, ZK |
| **Storage overhead** | Fixed 165 bytes | Fixed 165 bytes | Dynamic (TLV extension layout) |
| **ZK compression** | Traditional state | ZK Compression (~90% cost reduction) | Native ZK Compression |

### P-Token Engine (SIMD-0266)
In 2026, SPL Classic gained a drop-in execution upgrade via the P-Token engine. P-Token optimizes compute unit consumption at the runtime level, reducing transfer CU costs by ~95% (from ~10,000 CU to 500–1,000 CU). This is backwards-compatible — existing wallets, DEXes, and custodians require no changes. For high-throughput projects at mass scale, SPL Classic + P-Token now outperforms Token-2022 on execution cost while retaining universal compatibility.

### Irreversible Consequences

**Cannot add extensions post-initialization:** If you initialize a mint under the SPL Classic program and later decide you need transfer fees or compliance hooks, you must deploy a new mint and execute a full token migration. Migration disrupts secondary markets, may delay CEX listings, and requires coordinating liquidity moves across every active pool.

**CEX listing latency with Token-2022:** Exchanges with automated ledger parsing systems often cannot handle complex Token-2022 extensions (especially TransferHook and ConfidentialTransfer). Test CEX compatibility early — do not wait until listing conversations begin.

### 2026 Default
**SPL Classic** for all standard utility tokens, governance tokens, and memecoins. Reach for Token-2022 only when a specific extension is a hard business requirement, not a nice-to-have.

---

## Section 2 — Token-2022 Extension Selection

Extension parameters are declared in the `InitializeMint` instruction's TLV data structure. Once the mint is initialized, the extension set is frozen — no additions, removals, or amendments are possible.

### Extension Reference

**TransferFeeConfig**
Injects a protocol-level transfer tax natively into the runtime. Fees are withheld inside destination token accounts and must be harvested by the withdrawal authority (manually or via automation). Fees are collected in the project's own token — if you need SOL or USDC revenue, you must build an on-chain liquidation hook to convert them. Use for: sustainable project revenue, deflationary mechanics.

**TransferHook**
Invokes an external program via CPI on every transfer using `ExtraAccountMeta`. Enables custom compliance engines, dynamic blocklists, KYC gating, and transaction-level telemetry. Trade-off: adds extra accounts to every transaction and significantly increases CU consumption — this can push transactions past the 1,232-byte size limit or exhaust the default CU budget during congestion. Use for: KYC gating, allowlists, transaction monitoring. Requires thorough load testing before mainnet.

**ConfidentialTransfer**
Uses zero-knowledge proofs to encrypt balances and transfer amounts on-chain. Provides strong financial confidentiality. Requires special keypair derivation configurations in consumer wallets — standard wallets cannot display encrypted balances without explicit SDK support. Use for: enterprise payments, compliance-gated privacy. Note: was previously disabled on mainnet during security audits; verify mainnet availability before building on this.

**PermanentDelegate**
Grants the mint owner unrestricted authority over every token account for that mint — including burn, freeze, and force-transfer of user balances. Flagged as high-risk by security scanners like RugShield Pro. Legitimate use is narrow but real: compliance-gated assets that require asset recovery or regulatory freeze capabilities. Use for: RWA security tokens, regulated assets. Expect community scrutiny — communicate the rationale clearly.

**InterestBearingConfig**
Natively accrues interest by applying a dynamic multiplier based on on-chain validator timestamps. The client must use specialized SDK calculations to display the correct balance — raw account values will show an incorrect (non-compounded) figure in standard wallets. Use for: tokenized debt instruments, on-chain bonds, yield-bearing assets.

**NonTransferable**
Permanently binds the token to the initializing wallet address. All outbound transfer instructions are rejected at the program level. This is a one-way door — the token can never leave the minting wallet. Use for: identity credentials, achievement badges, soulbound reputation layers.

**MetadataPointer + Metadata**
Integrates name, symbol, and URI pointer directly into mint account state, bypassing external Metaplex accounts. Lowers rent requirements and ensures standard wallets can resolve and display the token logo without external calls. Use for: all Token-2022 tokens — this is the baseline extension every Token-2022 mint should include.

### Extension Comparison Table

| Extension | Function | Primary use case | Security flag |
|---|---|---|---|
| TransferFeeConfig | Native transfer tax | Revenue, deflation | Low |
| TransferHook | CPI on every transfer | KYC, compliance, blocklists | Medium (CU risk) |
| ConfidentialTransfer | ZK-encrypted balances | Enterprise privacy | High (wallet compat) |
| PermanentDelegate | Force-control all accounts | RWA, regulated compliance | High (RugShield flag) |
| InterestBearingConfig | On-chain yield accrual | Bonds, debt tokens | Low (display risk) |
| NonTransferable | Soulbound — no transfers | Credentials, badges | None |
| MetadataPointer | On-chain metadata | Universal — all tokens | None |

### Incompatibility Matrix

| Extension | Incompatible with | Reason |
|---|---|---|
| NonTransferable | TransferFeeConfig, TransferHook, ConfidentialTransfer | Soulbound tokens never transfer — fee, hook, and privacy extensions all depend on transfer execution to function |
| ConfidentialTransfer | TransferHook | Cryptographic conflict: hooks require plaintext transfer amounts to execute rules; confidential transfers encrypt those amounts |
| ConfidentialTransfer | TransferFeeConfig | Token-2022 does not support combined ZK proofs with native transfer fee calculations |
| ScaledUIAmount | InterestBearingConfig | Runtime rejects this combination — both attempt to apply conflicting cosmetic multipliers to the base amount |

Attempting to initialize a mint with an incompatible combination causes the transaction to fail immediately at program execution. There is no partial initialization.

### Routing by Asset Type

```
IF asset_type == REAL_WORLD_ASSET_OR_SECURITY:
    → Enable [MetadataPointer, PermanentDelegate, TransferHook]

ELSE IF asset_type == SOULBOUND_CREDENTIAL:
    → Enable [NonTransferable, MetadataPointer]

ELSE IF asset_type == REBASING_YIELD_TOKEN:
    → Enable [InterestBearingConfig, MetadataPointer]

ELSE IF asset_type == TAX_OR_REVENUE_TOKEN:
    → Enable [TransferFeeConfig, MetadataPointer]

ELSE:
    → Enable [MetadataPointer] only
```

### Consequences of Misconfiguration

**Incompatible initialization:** Combining `ConfidentialTransfer` + `TransferHook`, or `NonTransferable` + `TransferFeeConfig`, causes an immediate transaction failure. The mint is not created. You restart from zero — no recovery path.

**CU exhaustion in production:** `TransferHook` with an unoptimized external program can push transaction size past the 1,232-byte limit or exhaust the CU budget under load. Users cannot complete transfers. This is not caught in low-traffic testing — stress test at scale before launch.

**Balance display failures:** `InterestBearingConfig` requires custom SDK logic to show the compounded balance. Without it, wallets display the raw uncompounded figure. Users see "wrong" balances and assume a bug or exploit.

### 2026 Default
Always include `MetadataPointer` + native `Metadata` as the baseline. Add further extensions only when they are a hard business requirement with a tested implementation. When in doubt, the safer path is SPL Classic.
