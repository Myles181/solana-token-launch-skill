# /launch-day-checklist

Generate a personalized, timestamped launch day checklist based on the founder's launchpad and sniper protection setup.

## Instructions for Claude

When this command is invoked, execute the following steps in order.

---

### Step 1 — Ask two questions in a single message

```
Two quick questions and I'll generate your launch day checklist:

1. **Launchpad** — Which platform are you launching on?
   (a) Pump.fun
   (b) Raydium LaunchLab
   (c) Believe
   (d) DAOs.fun
   (e) Bags.fm
   (f) Direct pool seed (Raydium CPMM or Meteora DLMM)

2. **Sniper protection** — Are you using Meteora Alpha Vault?
   (a) Yes — Alpha Vault deposit window configured
   (b) No — standard pool seeding
```

---

### Step 2 — Load reference file

Read `skill/gtm.md` for the canonical launch day sequencing before generating output.

---

### Step 3 — Generate the checklist using the template below

Substitute the correct launchpad-specific tasks into the marked sections. Output as clean markdown with checkboxes. The founder should be able to copy this, paste it into a document, and work through it on launch day.

---

## Output Template

````markdown
# Launch Day Checklist
**Launchpad:** [their launchpad]
**Sniper protection:** [Alpha Vault / Standard seeding]
**Print this. Check boxes as you go. Do not skip steps.**

---

## ⛔ Read Before Starting

The single rule that overrides everything else:

> **Do not broadcast the contract address until liquidity is seeded, LP is burned or locked, and the transaction hashes are in hand.**

There is no recovering from a CA broadcast before liquidity. Sniper bots will front-run the pool initialization and drain early capital before any community member can buy.

---

## T-2 HOURS — Infrastructure Dry Run

- [ ] Switch to dedicated RPC endpoint (Helius or Alchemy Yellowstone gRPC) — do not use public mainnet RPC
- [ ] Confirm slot lag on dedicated node is under 2 blocks
- [ ] Verify multisig signing keys are accessible and hardware wallets are charged and unlocked
- [ ] Confirm deployer wallet has sufficient SOL for pool creation + LP burn/lock + gas buffer (minimum 2 SOL headroom above estimated costs)
- [ ] Verify all authority revocations are confirmed on-chain (mint authority, freeze authority) — check Solana Explorer
- [ ] Confirm RugCheck scan is clean — trust score ≥ 80, zero active threat indicators
- [ ] Confirm Arweave metadata URI resolves correctly and logo renders in Phantom or Backpack
- [ ] Verify Streamflow vesting contracts are live and public proof links are accessible
[IF ALPHA VAULT:]
- [ ] Confirm Alpha Vault deposit window has closed and settlement is complete
- [ ] Verify pro-rata token allocation is correct before proceeding to pool seeding

---

## T-30 MINUTES — Community Lock-Down

- [ ] Put Telegram into announcement-only mode (restrict all member messages)
- [ ] Put Discord into announcement-only mode [if applicable]
- [ ] Post countdown announcement in Telegram — include website URL, docs link, and social links. **Do not include CA.**
- [ ] Confirm Miss Rose moderation is active: `/welcome captcha on`, `/lock urls`, `/lock forward`
- [ ] Confirm buy-alert bot (Deluge / Bobby / Cielo) is configured on standby — pointed at pool address slot, not yet active
- [ ] Verify all team members are online and assigned roles for T-0 execution
[PLATFORM-SPECIFIC T-30 TASKS]

---

## T-5 MINUTES — Seeding & Lock Execution

- [ ] Deploy liquidity pool:
[IF PUMP.FUN:]
  - [ ] Initialize token on Pump.fun interface — confirm bonding curve is live
[IF LAUNCHLAB:]
  - [ ] Seed LaunchLab bonding curve pool — confirm fee tier is set correctly
[IF BELIEVE:]
  - [ ] Post the @launchcoin tweet: `@launchcoin $TICKER TokenName` — confirm reply is accepted and token is initialized
[IF DAOS.FUN:]
  - [ ] Confirm DAO fund pool is initialized and deposit window is open
[IF BAGS.FM:]
  - [ ] Confirm token is initialized and bonding curve is live on Bags.fm
[IF DIRECT SEED:]
  - [ ] Execute Raydium CPMM pool creation transaction — note pool address
  - [ ] Confirm pool parameters: fee tier, token amounts, initial price
[IF ALPHA VAULT:]
  - [ ] Execute Alpha Vault atomic swap — zero-slippage purchase executes at pool initialization price
- [ ] In the same block as pool seeding: execute LP burn or StakePoint lock
  - [ ] **LP burn:** Send LP tokens to `11111111111111111111111111111111` — copy transaction hash immediately
  - [ ] **LP lock:** Submit StakePoint lock transaction — copy lock contract address and public proof URL immediately
- [ ] Verify LP burn/lock transaction is confirmed on Solana Explorer before proceeding

---

## T-0 — Launch Block

- [ ] Activate buy-alert bot — point to confirmed pool address
[IF PUMP.FUN:]
- [ ] Execute bundled buy transactions across prepared wallets in the initialization block
[IF LAUNCHLAB:]
- [ ] Activate LaunchLab bump bot — confirm it is running against the correct pool
[IF DIRECT SEED:]
- [ ] Activate market-making software for initial liquidity depth (randomized interval: 5–25 seconds between executions)
- [ ] Confirm first buy-alert notification fires in Telegram — if silent, the bot is misconfigured. Fix before broadcasting CA.

---

## T+1 MINUTE — CA Broadcast

Broadcast simultaneously across all channels. Do not stagger. Every channel gets the CA at the same time.

- [ ] Post in Telegram:
  ```
  CA: [contract address]
  Buy: [Jupiter link] | [Raydium/PumpSwap link]
  Chart: [DexScreener link] | [Birdeye link]
  LP: [burn tx hash OR StakePoint lock URL]
  Audit: [RugCheck link]
  Slippage: Set 3–5% for launch conditions
  ```
- [ ] Post same on X (Twitter) — include CA, trading links, LP proof
- [ ] Post same in Discord [if applicable]
[IF PUMP.FUN:]
- [ ] Launch coordinated X raid — post viral meme assets prepared at T-2 hours, tag relevant crypto accounts
[IF BELIEVE:]
  - [ ] Notify identified Scouts on X that the token is live — Scouts earn 0.1% perpetual fee for surfacing it
- [ ] Restore Telegram to open chat mode — members can now send messages

---

## T+30 MINUTES — Verification & Trust Signals

- [ ] Pay for DexScreener token profile verification — submit official website, socials, CA
- [ ] Pay for Birdeye token profile verification
- [ ] Update Solana Explorer and Solscan token profile with official social links
- [ ] Pin to top of Telegram:
  - LP burn/lock proof link
  - Revoked mint authority transaction hash
  - Revoked freeze authority transaction hash
  - Streamflow vesting contract public URLs
  - RugCheck link (confirm score is still ≥ 80)
- [ ] Monitor Telegram for coordinated FUD — have on-chain transparency dashboard URL ready to paste
- [ ] Check DexScreener chart for healthy transaction pattern — confirm makers count is increasing
[IF LAUNCHLAB:]
- [ ] Verify token appears in Raydium LaunchLab trending feed
[IF PUMP.FUN:]
- [ ] Monitor bonding curve progress — confirm graduation trajectory is on track
[IF BELIEVE:]
- [ ] Post first utility update on X — do not let the conversation stay purely price-focused

---

## T+24 HOURS — Day 1 Close

- [ ] Host X Spaces or AMA — pivot narrative from price to product milestones
- [ ] Review Day 1 metrics:
  - [ ] Unique holder count (target: [2,000+ DeFi / 5,000+ memecoin])
  - [ ] Liquidity / market cap ratio (target: [≥0.15 DeFi / ≥0.08 memecoin])
  - [ ] Unique daily makers (target: [≥1,000 DeFi / ≥5,000 memecoin])
- [ ] Post on-chain transparency dashboard link publicly — pre-empt FUD with verifiable data
- [ ] Confirm Streamflow vesting contracts are publicly visible on the dashboard
[IF LAUNCHLAB:]
- [ ] Confirm LaunchLab bump bot is sustaining maker count and trending position
[IF PUMP.FUN:]
- [ ] Assess bonding curve graduation timeline — adjust community momentum strategy accordingly

---

## ⚠️ FATAL MISTAKES — Do Not Do These

[PLATFORM-SPECIFIC — insert the correct block below]

[IF PUMP.FUN:]
---
### Pump.fun — 3 Things That Kill the Launch

**1. Announcing the CA before the bonding curve is live.**
Sniper bots monitor new Pump.fun mint accounts in real time via Yellowstone gRPC. A public CA before initialization gives bots a window to buy the first blocks of the bonding curve at base price. The chart will show an immediate cliff when they dump. Keep the CA internal until the curve is live and the buy bot is active.

**2. Launching without bundled buys.**
An unbundled Pump.fun launch is maximally exposed to snipers in the first block. Bundled multi-wallet buys at initialization distribute early supply, protect the curve from sniper concentration, and accelerate graduation. Without them, a single sniper wallet can control a significant portion of the early supply.

**3. Letting the bonding curve stall.**
Any visible pause in Pump.fun graduation progress signals to the market that momentum is dead. Once a curve stalls, retail exits and it rarely recovers. Have your X raid, buy bot, and community activation ready to execute the moment the curve goes live — not after you see it stalling.

---

[IF LAUNCHLAB:]
---
### Raydium LaunchLab — 3 Things That Kill the Launch

**1. Missing the front-page window.**
Raydium's homepage surfaces tokens by transaction volume and unique maker counts. The first 2–4 hours of a LaunchLab launch determine whether the token appears on the front page. If the bump bot is not active from T-0 and maker count doesn't build immediately, the token is buried and never recovers the visibility it would have had.

**2. Launching without profile verification.**
LaunchLab's audience is more sophisticated than Pump.fun's. An unverified token profile — missing website, socials, and audit links — reads as a scam or abandoned project. Sophisticated capital will not enter. Complete verification before the CA is broadcast, not after.

**3. Leaving freeze authority active.**
LaunchLab pools on Raydium surface freeze authority warnings prominently. An active freeze authority will show a honeypot flag on every DEX aggregator that lists the token. The 25% fee buyback narrative that makes LaunchLab appealing to serious investors becomes irrelevant if the security scanner flags are live.

---

[IF BELIEVE:]
---
### Believe — 3 Things That Kill the Launch

**1. Leading with price instead of utility.**
The Believe community explicitly rejects low-effort celebrity hype. Launching with price-first messaging ("this will 100x") signals that the project has no substance. The community will not engage, Scouts will not surface it, and the token will not graduate. The narrative must lead with the idea — what the token funds, builds, or enables.

**2. Failing to activate Scouts before the tweet.**
Scouts are Believe's distribution mechanism. An identified Scout who champions the token earns 0.1% of all future trading fees — they are highly motivated. If no Scouts are pre-briefed and ready to amplify the launch tweet, the token launches into silence. Reach out to active on-chain Scouts on X before posting the @launchcoin reply.

**3. Incorrect @launchcoin reply format.**
The token initialization is triggered by the exact reply format: `@launchcoin $TICKER TokenName`. A malformed reply — wrong account tag, missing ticker symbol, incorrect spacing — will fail to initialize the token. Test the format against recent successful launches before posting. Once the tweet is sent, the transaction is initiated — there is no edit.

---

[IF DAOS.FUN:]
---
### DAOs.fun — 3 Things That Kill the Launch

**1. Insufficient capital commitment in the 7-day window.**
DAOs.fun uses a fixed-price 7-day fundraising window. If the fund does not reach its target capitalization, the DAO cannot be established with sufficient operating capital. Have committed capital sources confirmed before opening the window — do not rely on organic discovery to fill a cold start.

**2. Ambiguous fund mandate.**
Investors deposit SOL expecting a clear fund strategy. A vague or undefined mandate (e.g., "we'll invest in good projects") will not attract serious capital. The fund manager's track record, investment thesis, and asset focus must be documented and public before the window opens.

**3. Unclear dissolution mechanics.**
DAOs.fun funds expire after 3–12 months and dissolve proportionally to token holders. If this is not clearly communicated upfront, token holders will panic when they see the expiry date approaching. Publish the exact expiry date, dissolution mechanism, and expected return process at launch — not when holders start asking.

---

[IF BAGS.FM:]
---
### Bags.fm — 3 Things That Kill the Launch

**1. Creator fails to claim the token.**
Bags.fm allows permissionless community minting of creator tokens, but the 1% perpetual royalty only flows to the creator after they verify their social identity in the Bags app. If the creator never claims the token, the royalty accumulates unclaimed and the core value proposition — creator monetization — is never activated. Coordinate with the creator to complete verification before or immediately after launch.

**2. Not activating @DividendsBot.**
Without @DividendsBot, the 1% royalty accrues to the creator wallet but is never redistributed to holders. The holder distribution mechanic — which fires when unclaimed earnings exceed 10 SOL and distributes to the top 100 holders — is the primary retention mechanism. Activating it immediately signals that holding the token has direct economic value.

**3. No community narrative beyond the creator.**
Bags.fm tokens launched purely on a creator's existing following without an independent community narrative stall when the creator stops posting. Build a token-specific narrative (what the community does with the token, how holders interact with the creator) that can sustain itself independently of the creator's content cadence.

---

[IF DIRECT SEED:]
---
### Direct Pool Seed — 3 Things That Kill the Launch

**1. Using Raydium AMM V4 with a Token-2022 token.**
AMM V4 does not support Token-2022. Seeding an AMM V4 pool with a Token-2022 token that has active extensions causes failed transactions or permanently trapped liquidity. There is no recovery path — the tokens and SOL are locked. Verify your token program (`TokenkegQfeZyiMwAzb61madMZ6m1tocu39asSp9vUt` = SPL Classic, `TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb` = Token-2022) before touching AMM V4.

**2. Seeding without Alpha Vault on a serious launch.**
A direct pool seed without Meteora Alpha Vault is maximally exposed to sniper bots from the first block. For memecoins this is sometimes acceptable. For DeFi protocols and RWA projects where early supply concentration in bot wallets permanently damages the holder distribution and scanner scores, it is not. If the budget and timeline support it, Alpha Vault is not optional for direct seeds.

**3. Under-seeding liquidity below the $5k–$10k floor.**
Thin liquidity causes severe price impact on every trade. A $500 buy moves the price enough to look like manipulation. Jupiter deprioritizes thin pools. Sophisticated traders use liquidity/market-cap ratio as an entry filter — below 0.08 for memecoins or 0.15 for DeFi tokens, they will not enter. Delay the launch until the liquidity budget is sufficient. A thin pool launch is worse than a delayed launch.

---
````

---

## Routing Notes for Claude

When generating the checklist, substitute into `[PLATFORM-SPECIFIC T-30 TASKS]` for the T-30 section:

**Pump.fun:**
```
- [ ] Confirm bundled buy wallets are funded and ready — each wallet needs SOL for the buy + gas
- [ ] Stage viral meme assets for X raid — images, captions, and target accounts identified
- [ ] Confirm buy-alert bot is pointed at the Pump.fun bonding curve address (not a Raydium pool address)
```

**Raydium LaunchLab:**
```
- [ ] Complete Raydium token profile verification — website, socials, and CA submitted
- [ ] Confirm graduation pool fee tier is set (0.25% standard / 1% high-volatility)
- [ ] Stage LaunchLab bump bot configuration — confirm wallet funding and interval settings
```

**Believe:**
```
- [ ] Draft @launchcoin reply tweet — format: `@launchcoin $TICKER TokenName` — no variations
- [ ] Identify minimum 3 active Scouts on X and brief them on the launch
- [ ] Prepare utility narrative thread for X Spaces within 2 hours of launch
```

**DAOs.fun:**
```
- [ ] Confirm fund mandate document is public and linked from all community channels
- [ ] Brief committed capital sources on the exact deposit window open time
- [ ] Prepare fund manager introduction post for X and Telegram
```

**Bags.fm:**
```
- [ ] Confirm creator has downloaded Bags app and is ready to verify social identity post-launch
- [ ] Activate @DividendsBot on Telegram — confirm unclaimed earnings threshold is set
- [ ] Prepare creator collaboration announcement for X at T+1 min
```

**Direct seed:**
```
- [ ] Confirm Raydium CPMM pool parameters: token amounts, fee tier, initial price
- [ ] Verify token standard compatibility with chosen pool type (Token-2022 → CPMM only, not AMM V4)
[IF ALPHA VAULT:]
- [ ] Confirm Alpha Vault deposit window close time — all deposits must be settled before T-5 min
- [ ] Verify pro-rata allocation calculation is correct
```
