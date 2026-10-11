# PXD2 client sites — the offer

**One payment, built once.** The client pays PXD2 one time for the site. That covers:

- Design and build: a classic site or a **3D / VR storefront** on the PXD2 VR Store engine (walk the store in a browser, on a phone, or in a VR headset).
- Hosting on PXD2's pipes (GitHub Pages or HOLD) with no monthly hosting bill.
- Their names in **PXD2 Names**: `pxd2.github.io/<name>` on the public web and `<name>.pxd` on the PXD2 network.
- Payment setup on the platforms they choose: Stripe, PayPal, Square, Cash App, Venmo, Coinbase Commerce, BTCPay, and direct crypto wallets (BTC, ETH, SOL, USDC and more).

**What the client still pays, always:** the merchant fees of whichever payment platform they use. Those come out of their own payouts, charged by the platform, never by PXD2.

**After launch:** inventory and product updates. The client edits their own `store.json`, or PXD2 does it per update.

## How the money moves

Every sale goes **straight to the client's own** payment account or wallet. PXD2 never collects, holds or forwards a customer's money. Keeping it that way keeps PXD2 a web studio, not a payment processor (which would need money-transmitter licensing).

## Build a client VR store

1. Copy `pxd2.github.io/clients/_template/` to `clients/<slug>/`.
2. Fill `store.json`: name, contact, products (price, description, optional `model` = a `.glb` scan from Meshworks), the client's own pay links and wallet addresses.
3. Add the slug to `names.json` in PxD2.github.io and run `python tools/names_build.py`.
4. Add a row here in `sites.json` with `"pxd": "<slug>.pxd"`. Push. Live.
