# PXD2 Web Systems

Client and house sites we **design, host, and hold**.

The hall is [pxd2.github.io](https://pxd2.github.io/). This repo is the **control plane** for many sites — not a second floor.

## Live now

- Hall annex: [pxd2.github.io/sites](https://pxd2.github.io/sites/)
- Open builds index (Comparee Hub map): [pxd2.github.io/sites/open-builds](https://pxd2.github.io/sites/open-builds/)
- Registry: [`sites.json`](./sites.json)
- How to ship: [`HOSTING.md`](./HOSTING.md)
- The client offer (one-time build, VR stores, payments): [`OFFER.md`](./OFFER.md)
- VR Net and sub-hubs: [`SUBHUBS.md`](./SUBHUBS.md) · [pxd2.github.io/vr](https://pxd2.github.io/vr/)
- PXD2 Names: [pxd2.github.io/names](https://pxd2.github.io/names/) · private `.pxd` ending via PXD2 Root

## Two pipes

1. **GitHub Pages** — static sites on the hall or on a project URL.
2. **FTP / SFTP / rsync** — boxes we already hold. Secrets stay out of git (`ftp/.env.example`).

Pages on *this* repo is optional. Enable it under Settings → Pages → GitHub Actions if you want `pxd2.github.io/web-systems/` as a second copy. The hall annex already publishes from `PxD2.github.io`.

## Add a site

Slug in `sites.json` → files in `sites/<slug>/` or a dedicated repo → pick Pages or FTP → link it on the hall annex and on [github.com/PxD2](https://github.com/PxD2).
