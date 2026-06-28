# Launch Anti-Patterns & Red Flags

The 20 mistakes that kill Solana token launches in 2026 — each with the exact on-chain consequence and the specific fix. Load this file when a founder describes a setup that matches any pattern below, or when they ask what can go wrong.

---

## Category 1 — Pre-Launch Mistakes

### ❌ Metadata Hosted on a Centralized Server
**Consequence:** The token URI points to a mutable server. Post-launch, the metadata can be silently changed — logo swapped, name rebranded, social links redirected to a new project. RugCheck flags mutable metadata as a threat indicator. Wallets that cached the original display stale data while new wallets show the altered version, causing community confusion and scanner warnings.
**Fix:** Host all metadata on Arweave before mint initialization. The URI embedded in the mint account must be a permanent `ar://` link. Use Metaplex's `create_metadata_accounts_v3` with the Arweave URI — never a server you control.
**Severity:** Critical

---

### ❌ Skipping Arweave for Token URI (Using IPFS or HTTP)
**Consequence:** IPFS pinning is not permanent — if the pinning service drops the CID, the metadata 404s. HTTP links are worse: centralized, mutable, and flagged immediately by automated scam scanners. Phantom and Backpack display a broken image or "unknown token" for any wallet that fetches post-expiry. DexScreener and Birdeye fail to render the token logo, hurting trust on trading interfaces.
**Fix:** Upload metadata JSON and logo to Arweave via Bundlr (now Irys). Confirm the `ar://[txid]` resolves before submitting the `InitializeMint` instruction. IPFS is not an acceptable substitute.
**Severity:** High

---

### ❌ Announcing the Contract Address Before Liquidity Is Seeded
**Consequence:** Sniper bots monitor the Solana mempool and new mint accounts in real time via Yellowstone gRPC feeds. Broadcasting the CA before the pool exists gives bots a window to detect the mint on-chain, prepare sandwich transactions, or construct unauthorized copycat pools on Raydium. When liquidity lands, bots execute in the same block — retail buyers get a worse price, early supply concentrates in bot wallets, and the chart shows an immediate sell cliff.
**Fix:** Keep the CA strictly internal until the liquidity seed transaction and LP lock/burn are confirmed on-chain. Publish the CA simultaneously with the LP burn transaction hash and RugCheck proof link. No exceptions — not for KOLs, not for early community members.
**Severity:** Critical

---

### ❌ Launching a Utility Token Without a Squads Multisig
**Consequence:** Mint authority and treasury funds sit on a single developer hot wallet. One phishing attack, seed phrase leak, or SIM swap compromises the entire protocol. An attacker with the hot wallet key can mint arbitrary supply in a single transaction, draining all community value instantly. Security scanners (RugCheck, RugShield Pro) flag single-key authority as an extreme threat — institutional traders will not enter.
**Fix:** Initialize a Squads multisig at T-7 days with a minimum 3-of-5 threshold. All signing keys must be on hardware wallets (Ledger). Transfer mint authority to the Squads PDA before launch. Revoke freeze authority separately (freeze authority active on a Squads multisig still triggers DEX warning banners).
**Severity:** Critical

---

### ❌ Wrong Decimals for Project Type
**Consequence:** A high-supply token (e.g., 10^15 raw units) with 9 decimals hits JavaScript's `Number.MAX_SAFE_INTEGER` ceiling (~9 × 10^15). Standard wallet SDKs (Phantom, Backpack) and price trackers display incorrect balances. Swap UIs generate broken quotes. Users attempting large transfers get failed transactions. This cannot be fixed after mint initialization — decimals are immutable. A DePIN project using 6 decimals for micropayment emissions will run into precision gaps for sub-cent rewards.
**Fix:** Memecoins, DeFi utility, governance, RWA → 6 decimals. DePIN networks with micropayment emissions → 9 decimals. Pair 9 decimals only with supply sizes that stay safely below 10^12 raw units. Verify with a test calculation before mint creation.
**Severity:** High

---

## Category 2 — Authority & Security Mistakes

### ❌ Keeping Freeze Authority Active at Launch
**Consequence:** Every major execution terminal — BullX, Trojan, Photon — displays a prominent risk warning banner on tokens with active freeze authority. RugCheck flags it as a honeypot indicator. Up to 90% of retail purchase volume is blocked because users see the warning and exit. Raydium and Meteora pool interfaces surface the flag. The token looks like a honeypot regardless of the team's actual intentions, and the reputation damage persists even after revocation.
**Fix:** Execute `RevokeFreezeAuthority()` before T-0. This must happen before the liquidity pool is seeded — the pool creation transaction and authority revocation should be in close sequence. Confirm revocation on Solana Explorer and include the transaction hash in the public trust proof bundle.
**Severity:** Critical

---

### ❌ Retaining Mint Authority on a Hot Wallet
**Consequence:** A single compromised private key — via phishing, clipboard hijack, or physical theft — allows an attacker to mint unlimited token supply in one transaction. Supply inflates to any amount, price crashes to near zero, and the exploit cannot be reversed. Automated rug-detection bots (RugCheck, RugShield Pro) flag retained hot-wallet mint authority as an extreme threat, broadcasting the flag to Telegram signal bots within minutes of launch.
**Fix:** For memecoins: execute `RevokeMintAuthority()` immediately after initial supply mint, before any other public action. For utility protocols: transfer mint authority to a Squads 3-of-5 multisig where all signers hold hardware wallets. Never leave mint authority on a wallet that is used for day-to-day operations.
**Severity:** Critical

---

### ❌ Using Incompatible Token-2022 Extension Combinations
**Consequence:** The Token-2022 program rejects incompatible extension combinations at the `InitializeMint` instruction level — the transaction fails immediately, no mint is created. The worst combinations: `ConfidentialTransfer` + `TransferHook` (cryptographic conflict — hooks require plaintext amounts that confidential transfer encrypts), `NonTransferable` + `TransferFeeConfig` (soulbound tokens never transfer, so fee logic can never execute), and `ScaledUIAmount` + `InterestBearingConfig` (both attempt conflicting multipliers on the base amount). There is no partial initialization — you restart from zero.
**Fix:** Before constructing the `InitializeMint` payload, verify your extension set against the incompatibility matrix in `skill/token-standard.md`. Validate on devnet with the exact extension combination before mainnet deployment. RWA tokens (MetadataPointer + PermanentDelegate + TransferHook) and soulbound tokens (NonTransferable + MetadataPointer) are the two safe multi-extension patterns.
**Severity:** Critical

---

### ❌ Enabling Permanent Delegate Without Community Disclosure
**Consequence:** Permanent Delegate grants the mint owner unrestricted authority to burn, freeze, or force-transfer tokens from any holder's account without their consent. RugShield Pro flags it as a high-risk vector automatically. If discovered post-launch without prior disclosure, the community will interpret it as a hidden rug mechanism regardless of stated intent. Sophisticated traders who run Bubblemaps and RugCheck will surface it and broadcast it widely.
**Fix:** If Permanent Delegate is a legitimate compliance or RWA requirement, disclose it explicitly in the whitepaper, landing page, and pinned community posts before launch. Transfer the delegate authority to a transparent compliance multisig with documented signers — not a developer wallet. Document the exact conditions under which it can be exercised.
**Severity:** High

---

### ❌ Deploying on Shared or Public RPC During Launch
**Consequence:** Public RPC endpoints (api.mainnet-beta.solana.com) are rate-limited and throttled under congestion. During a high-traffic launch window, shared RPC causes slot lag exceeding 2 blocks, failed buy-alert bot transactions, failed volume maker transactions, and loss of control over the initial order book. The team cannot execute the atomic T-0 sequence reliably. Failed transactions from community members during the launch window cause immediate negative sentiment.
**Fix:** Use dedicated single-tenant RPC nodes via Helius or Alchemy with Yellowstone gRPC + ShredStream feeds active before T-2 hours. Verify slot lag is under 2 blocks during the dry run. Configure all bots, market-making software, and the deployer wallet to use the dedicated endpoint. Budget this into launch costs — shared RPC is not viable for any production launch.
**Severity:** High

---

## Category 3 — Liquidity Mistakes

### ❌ Seeding Raydium AMM V4 With a Token-2022 Token
**Consequence:** Raydium Legacy AMM V4 does not support Token-2022 standards. Attempting to seed an AMM V4 pool with a token that has active Token-2022 extensions (TransferFeeConfig, TransferHook, etc.) results in failed transactions or permanently trapped liquidity. If liquidity is somehow forced into an incompatible pool state, the tokens and SOL are locked in a non-functional position with no recovery path. This is an unrecoverable error.
**Fix:** Token-2022 tokens must use Raydium CPMM (~0.3 SOL, no OpenBook ID required) or Meteora DLMM. Only SPL Classic tokens should use AMM V4, and only when legacy bot routing coverage is a specific requirement. Verify the token program before selecting pool type — checking `solana account <mint>` will show whether the token is under `TokenkegQfeZyiMwAzb61madMZ6m1tocu39asSp9vUt` (SPL Classic) or `TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb` (Token-2022).
**Severity:** Critical

---

### ❌ Not Burning or Locking LP Tokens After Seeding
**Consequence:** LP tokens held in the deployer wallet allow the team to remove 100% of pool liquidity in one transaction at any time with no warning. Automated on-chain tracking bots detect unlocked LP within minutes of pool creation and broadcast the status to Telegram signal channels, Birdeye, and DexScreener. The token is flagged as a rug risk immediately, regardless of team intent. Sophisticated traders will not enter. Community members who do enter are exposed to unilateral liquidity withdrawal at any moment.
**Fix:** Execute LP burn (send to `11111111111111111111111111111111`) or StakePoint lock in the same transaction block as pool seeding. For burns: include the burn transaction hash in the public trust proof bundle. For locks: use StakePoint with a minimum 365-day lock duration and publish the public verification link. Anything under 365 days reads as a planned exit.
**Severity:** Critical

---

### ❌ Under-Seeding Initial Liquidity (Below $5k–$10k Floor)
**Consequence:** Insufficient liquidity depth means every trade causes severe price impact. A $500 buy moves the price significantly, making the chart look manipulated. Sophisticated traders use liquidity/market-cap ratio as a key filter — below 0.08 for memecoins or 0.15 for DeFi tokens, the token fails their entry threshold. Jupiter's smart routing deprioritizes thin pools. Any meaningful sell order from a whale dumps the price catastrophically, triggering panic from remaining holders.
**Fix:** Seed a minimum $5k–$10k for standard launches; $50k+ for serious DeFi protocols. Calculate the target liquidity/market-cap ratio before deployment and seed to hit it. If the budget doesn't support the floor, delay the launch rather than seed thin liquidity — a thin pool launch is worse than no launch.
**Severity:** High

---

### ❌ Skipping Meteora Alpha Vault for Serious Launches
**Consequence:** Standard CPMM and AMM pools are open to sniper bots from the first block. Without Alpha Vault protection, bots using Yellowstone gRPC feeds execute buy transactions in the same block as pool initialization — before any retail buyer can react. Early supply concentrates in bot wallets that dump immediately after, creating a pump-and-dump chart pattern on the first candle. This pattern destroys community trust within the first 30 minutes and is visible permanently on DexScreener.
**Fix:** Configure Meteora Alpha Vault before pool creation for any launch targeting serious community building or DeFi positioning. The 24-hour deposit window, pro-rata settlement, and 30-day linear vesting on acquired tokens eliminate the sniper advantage. The vault executes as a zero-slippage atomic transaction at pool initialization, before any external wallet can submit a buy. Pump.fun and memecoin fair launches without Alpha Vault are acceptable — this fix is for LaunchLab, Meteora DLMM, and direct-seed launches.
**Severity:** High

---

### ❌ Retaining LP Tokens in Deployer Wallet
**Consequence:** Identical consequence to not locking — but with additional reputational damage because it's the deployer wallet specifically, which is already under scrutiny. On-chain analysts running Bubblemaps will link LP holdings directly to the deployer address. RugCheck surfaces this as a critical threat. DexScreener and Birdeye show the LP ownership publicly. Even if the team never intends to pull, the market will price in the risk as if they will.
**Fix:** There is no acceptable reason to retain LP tokens in the deployer wallet for a public token. Burn to `11111111111111111111111111111111` for maximum trust, or transfer to a StakePoint lock with a minimum 365-day duration. The lock or burn must happen before the CA is broadcast publicly.
**Severity:** Critical

---

## Category 4 — GTM & Post-Launch Mistakes

### ❌ No Buy-Alert Bot Active at Launch (Silent Group Effect)
**Consequence:** A Telegram group that shows no purchase activity during a live launch reads as a dead project. New users who join during the launch window see silence, assume no one is buying, and leave. This compounds — fewer perceived buyers means even fewer actual buyers. The "silent group" effect can kill momentum within the first 10 minutes even if actual on-chain buys are occurring. Without visual buy confirmation, the community has no feedback signal.
**Fix:** Configure Deluge Buy Bot, Bobby Buy Bot, or Cielo Finance Bot on the pool address before T-0 and activate at the launch block. Set the minimum buy threshold at $50–$100 to filter dust spam. Customize notification cards with project branding, bonding curve progress bars, and single-click buy links to Jupiter, Raydium, and Birdeye. The bot must be live before the CA is broadcast.
**Severity:** High

---

### ❌ Large Team Allocation Fully Liquid at TGE
**Consequence:** Automated security scanners flag wallet concentration above 30% as a structural dump risk. Sophisticated traders who run Bubblemaps will see large unlocked team wallets connected to the deployer address and exit immediately. Even if the team doesn't sell, the market prices in the overhang. Any team wallet movement — even for operational purposes — is interpreted as a sell signal. Projects with unlocked team allocations above 15% at TGE rarely sustain price discovery past Day 3.
**Fix:** Deploy all team, advisor, and investor allocations into Streamflow linear vesting contracts with a 12-month cliff and 36-month linear release before the token goes public. Publish the Streamflow public proof links alongside the LP burn hash at T+30 minutes. The on-chain vesting contract is the proof — verbal commitments are not.
**Severity:** Critical

---

### ❌ Cliff-Based Vesting With Public Unlock Dates
**Consequence:** Large discrete unlock events are public knowledge via on-chain vesting contracts. MEV bots and short sellers track these contracts and coordinate short positions before known unlock dates. When the cliff arrives, even if team members don't sell, bot-driven sell pressure from anticipatory shorts can cascade into panic selling from the broader community. Cliff-based unlocks consistently produce a predictable price dump in the days surrounding the unlock date.
**Fix:** Use Streamflow's linear second-by-second streaming model instead of cliff releases. Linear streaming distributes unlock pressure smoothly over years — there is no discrete unlock event for bots to target. If a cliff is contractually required (e.g., investor agreements), integrate Streamflow's Umbra privacy layer to shield recipient identities and unlock amounts from public MEV tracking.
**Severity:** High

---

### ❌ Skipping DexScreener and Birdeye Verification Post-Launch
**Consequence:** Unverified tokens display no project branding, no social links, and no official website on DexScreener and Birdeye — the two primary interfaces where traders evaluate tokens before buying. Without verification, the token looks indistinguishable from a scam or abandoned project. Copycat tokens with similar names can create verified profiles first, capturing search traffic and defrauding community members. The verification window is most critical in the first 30 minutes when initial momentum is forming.
**Fix:** Pay for DexScreener and Birdeye profile verification at T+30 minutes, immediately after restoring community channels to open mode. Both platforms require submitting official social links, website URL, and contract address. Include the verification badges in community pinned messages. Also update the token profile on Solana Explorer and Solscan to link official social accounts.
**Severity:** Medium

---

### ❌ No On-Chain Transparency Dashboard for FUD Handling
**Consequence:** When coordinated FUD or exploit rumors spread (and they will, for any token with meaningful volume), teams without verifiable on-chain proof links are forced to argue with screenshots and verbal denials. Screenshots are easily forged. Verbal denials have zero credibility in the Solana community. FUD that goes unanswered with verifiable data for more than 2–3 hours can cause 30–50% price drops that don't fully recover. Without a dashboard, every piece of negative content requires manual response.
**Fix:** Before launch, build a dedicated transparency page linking directly to: the OtterSec or Zellic audit report, the LP burn transaction hash on Solana Explorer, the revoked mint and freeze authority transaction signatures, and the Streamflow public vesting contract URLs. Pin this URL at the top of Telegram and Discord on Day 1. When FUD hits, the response is a single link — not an argument.
**Severity:** High
