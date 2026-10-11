# PXD2 client sites — the offer

**One payment, built once.** The client pays PXD2 one time for the site. That covers:

- Design and build: a classic site or a **3D / VR storefront** on the PXD2 VR Store engine (walk the store in a browser, on a phone, or in a VR headset).
- Hosting on PXD2's pipes (GitHub Pages or HOLD) with no monthly hosting bill.
- Their names in **PXD2 Names**: `pxd2.github.io/<name>` on the public web and `<name>.pxd` on the PXD2 network.
- Payment setup on the platforms they choose: Stripe, PayPal, Square, Cash App, Venmo, Coinbase Commerce, BTCPay, and direct crypto wallets (BTC, ETH, SOL, USDC and more).

**What the client still pays, always:** the merchant fees of whichever payment platform they use. Those come out of their own payouts, charged by the platform, never by PXD2.

**After launch:** inventory and product updates. The client edits their own `store.json`, or PXD2 does it per update.

## Lifetime: no site lost to time

Every site PXD2 builds is kept by **PXD2 Vault** (`PxD2.github.io/tools/vault.py`) in four places at once: full git history on GitHub, a dated offline archive on PXD2's own disk (base1 / HOLD), Internet Archive snapshots of every page, and optionally a permanent Arweave copy paid once inside the build fee (Arweave's one-time payment is designed to cover 200+ years of storage). The client's names stay in the PXD2 Names registry, which is itself vaulted the same way.

## How the money moves

Every sale goes **straight to the client's own** payment account or wallet. PXD2 never collects, holds or forwards a customer's money. Keeping it that way keeps PXD2 a web studio, not a payment processor (which would need money-transmitter licensing).

## Win the client: the store upgrade pitch

1. Pick a business whose online store underserves them.
2. On base1: `python tools/store_import.py https://their-store.com --name "Their Store" --serve` (in PxD2.github.io). It reads their public catalog the way their own storefront does (Shopify, WooCommerce, or schema.org product data), respects robots.txt, and builds a **private** VR store preview of their real products on your machine.
3. Show the owner their store, rebuilt as a walk-through 3D/VR shop with every payment option.
4. Nothing goes public until they sign. Then it moves to `clients/<slug>/` with their own pay links, their approval of their images and text, and a `.pxd` name.

Pitch previews never get published or sent as a public link: a page that looks like their store under someone else's control would read as impersonation.

## Build a client VR store

1. Copy `pxd2.github.io/clients/_template/` to `clients/<slug>/`.
2. Fill `store.json`: name, contact, products (price, description, optional `model` = a `.glb` scan from Meshworks), the client's own pay links and wallet addresses.
3. Add the slug to `names.json` in PxD2.github.io and run `python tools/names_build.py`.
4. Add a row here in `sites.json` with `"pxd": "<slug>.pxd"`. Push. Live.
