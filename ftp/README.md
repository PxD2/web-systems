# HOLD publisher + tenant runbook (CARD-004 DONE-BAR #3)

Product-true: **HOLD hosts SFTP roots. Git publishes; clients fetch/edit over SFTP.**  
Source ICD: [`../HOLD-ICD.md`](../HOLD-ICD.md) §4.

## A. Provision a lab tenant (on the HOLD box)

```bash
# as root on the HOLD host
sudo ./ftp/provision-tenant.sh lab
# adds user hold_lab, chroot /hold/hold_lab, ForceCommand internal-sftp
# drop pubkey into /hold/hold_lab/.ssh/authorized_keys (outside chroot map — see script)
```

OpenSSH sketch (also applied by the script):

```
Match User hold_*
  ChrootDirectory /hold/%u
  ForceCommand internal-sftp
  AllowTcpForwarding no
  X11Forwarding no
```

FTPS/vsftpd remains **off by default** (HOLD-ICD §1).

## B. Secrets (never commit)

Repo Actions secrets / local env (see `ftp/.env.example`):

| Var | Meaning |
|---|---|
| `HOLD_HOST` | HOLD gateway hostname |
| `HOLD_PORT` | usually `22` |
| `HOLD_USER` | e.g. `hold_lab` |
| `HOLD_KEY` | private key PEM (Actions secret) |
| `HOLD_ROOT` | remote path inside chroot, e.g. `public` |
| `HOLD_SLUG` | sites.json slug, e.g. `lab` |

## C. Publish (CI)

Workflow: [`.github/workflows/deploy-hold.yml`](../.github/workflows/deploy-hold.yml)

- `workflow_dispatch` with `slug` input, or push under `sites/<slug>/`
- Checks out repo → `rsync`/`sftp` mirror of `sites/<slug>/` → `HOLD_USER@HOLD_HOST:HOLD_ROOT`

Local dry-run (no secrets):

```bash
./ftp/proof/stage-mirror.sh lab
# writes ftp/proof/staged-mirror.log
```

## D. Staged proof

See [`proof/staged-mirror.log`](proof/staged-mirror.log) — local mirror rehearsal proving path map `sites/<slug>/` → tenant `public/` without contacting a live host.
