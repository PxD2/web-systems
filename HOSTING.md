# PXD2 hosting board

One git tree can feed **many** live sites. Two pipes. No secrets in the repo.

**HOLD** is the sellable **FTP/SFTP product** pipe (accounts, mirror deploy, secrets out of git) — product target / in progress. **GitHub Pages** is the static pipe only. Do not describe HOLD as "git that acts like FTP."

## Pipe A — GitHub Pages (static)

Use when the site is HTML/CSS/JS and can live under `*.github.io`.

| Kind | URL | Repo |
| --- | --- | --- |
| User site (the hall) | https://pxd2.github.io/ | `PxD2/PxD2.github.io` |
| Project site | https://pxd2.github.io/<repo>/ | any public repo with Pages on |
| Annex on the hall | https://pxd2.github.io/sites/ | folder on the user site |

Turn Pages on once per repo:

1. Repo → Settings → Pages
2. Source: **GitHub Actions** (preferred) or **Deploy from a branch** (`main` / `/`)
3. Save. First push after that publishes.

This repo already has `.github/workflows/pages.yml`. It will stay yellow until Pages is enabled. That is expected. The hall annex is live without waiting on this switch.

Custom domain later: add `CNAME` file + DNS `CNAME` or `ALIAS` to `pxd2.github.io`.

## Pipe B — HOLD / FTP / SFTP / rsync (product pipe)

HOLD is the product name for shipping sites to real boxes via FTP/SFTP/rsync: per-site accounts, mirror deploy, credentials in secrets (never git).

`ftp/` in this repo is **templates only** (`.env.example` + `deploy.example.yml`). No live FTP/SFTP daemon is claimed here. Base1 had no live FTP daemon as of Sep 2026. ICD options for Systems: managed SFTP gateway vs daemon-on-box vs multi-tenant FTP-as-a-service — see CARD-004 discovery note.

Use when a client already has cPanel, a VPS, or a dusty shared host — or when HOLD product accounts exist.

1. Copy `ftp/.env.example` to a local `.env` that is **gitignored**, or set the same names as GitHub Actions secrets.
2. Pick one driver:

```bash
# SFTP / FTP with lftp
lftp -c "set ssl:verify-certificate no; open -u $FTP_USER,$FTP_PASS $FTP_HOST; mirror -R --delete --verbose ./public $FTP_REMOTE_DIR"

# rsync over SSH (preferred when we have a key)
rsync -az --delete -e "ssh -i $SSH_KEY -p ${SSH_PORT:-22}" ./public/ "$SSH_USER@$SSH_HOST:$REMOTE_DIR"

# git-ftp if the host only speaks FTP
git ftp push --user "$FTP_USER" --passwd "$FTP_PASS" "ftp://$FTP_HOST$FTP_REMOTE_DIR"
```

3. Optional: copy `ftp/deploy.example.yml` to `.github/workflows/ftp-<site>.yml` and fill secrets. Do not commit passwords.

## How to add a site

1. Give it a slug. Add a row to `sites.json`.
2. Put the static files in `sites/<slug>/` (this repo) **or** keep a dedicated repo and list it in `sites.json`.
3. Choose the pipe: Pages folder on the hall, Pages on the dedicated repo, or HOLD FTP/SFTP to the box.
4. Link it from the hall annex `pxd2.github.io/sites/` and from the profile README.

## What this repo is not

Not a claim that GitHub Pages is FTP. Pages stays the static pipe. HOLD is the real FTP/SFTP product (in progress) — not a metaphor. Credentials stay in secrets or on the box, never in the tree. Do not invent live host credentials or claim a daemon is running until Systems ICD + Builder ship proof.
