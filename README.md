# PXD2 Web Systems

Client and house sites we **design, host, and hold**.

The hall is [pxd2.github.io](https://pxd2.github.io/). This repo is the **control plane** for many sites — not a second floor.

## Live now

- Hall annex: [pxd2.github.io/sites](https://pxd2.github.io/sites/)
- Open builds index (Comparee Hub map): [pxd2.github.io/sites/open-builds](https://pxd2.github.io/sites/open-builds/)
- Registry: [`sites.json`](./sites.json)
- How to ship: [`HOSTING.md`](./HOSTING.md)

## Two pipes

1. **GitHub Pages** — static sites on the hall or on a project URL. Static pipe only.
2. **HOLD / FTP / SFTP / rsync** — sellable product pipe (accounts, mirror deploy, secrets out of git). Templates under `ftp/` (`.env.example`). Product ICD open — not "git that acts like FTP."

Pages on *this* repo is optional. Enable it under Settings → Pages → GitHub Actions if you want `pxd2.github.io/web-systems/` as a second copy. The hall annex already publishes from `PxD2.github.io`.

## Add a site

Slug in `sites.json` → files in `sites/<slug>/` or a dedicated repo → pick Pages or HOLD FTP → link it on the hall annex and on [github.com/PxD2](https://github.com/PxD2).
