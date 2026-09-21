# PXD2 hosting board

One git tree can feed **many** live sites. Two pipes. No secrets in the repo.

Product ICD for the HOLD pipe: [`HOLD-ICD.md`](./HOLD-ICD.md).

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

## Pipe B — publish to a file root

Git is the source of truth and the publisher. Pipe B is **not** “GitHub is FTP.”

### B1 — publish → HOLD (product we sell)

HOLD is SFTP roots **we host** (chrooted tenants on boxes we operate). CI or a local mirror pushes `sites/<slug>/` into `/hold/<slug>/public/`. Clients fetch and edit over SFTP. See `HOLD-ICD.md`.

Hall line (product-true): **SFTP roots we host. Git publishes.**

### B2 — publish → client box

Use when a client already has cPanel, a VPS, or a dusty shared host and we are only the publisher.

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

HOLD_* vars (`HOLD_HOST`, `HOLD_USER`, `HOLD_KEY`, `HOLD_ROOT`) are for B1 once Builder lands `ftp/deploy-hold.yml`.

## How to add a site

1. Give it a slug. Add a row to `sites.json`.
2. Put the static files in `sites/<slug>/` (this repo) **or** keep a dedicated repo and list it in `sites.json`.
3. Choose the pipe: Pages on the hall, Pages on the dedicated repo, publish → HOLD, or publish → client box.
4. Link it from the hall annex `pxd2.github.io/sites/` and from the profile README.

## What this repo is not

Not a claim that GitHub is an FTP server. GitHub holds the source. HOLD is the SFTP disk we bill for. Outbound FTP/SFTP to a client box is only when we already have credentials. Credentials stay in secrets or on the Pi, never in the tree.
