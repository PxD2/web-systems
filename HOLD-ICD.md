# HOLD — Product ICD (CARD-004)

**Status:** D1 READY FOR REVIEW  
**Author:** Systems Designer  
**Floor:** Skunkworks  
**Home repo:** `PxD2/web-systems` (control plane)  
**Consumers:** Builder (runnable deploy) · Grok Bot (hall copy) · Reviewer (DONE-BAR)

## Outcome

HOLD is a **real file-transfer product** PxD2 can sell: tenants get an SFTP (and optional FTP) root on boxes we hold. Git remains the **source of truth and publisher**, not the product metaphor.

**Replace hall language:** stop saying “Git that acts like FTP.”  
**Product-true line:** “HOLD — SFTP roots we host for your site. Git publishes; clients fetch and edit over SFTP.”

---

## 1. Decision (LOCKED for v1)

| Option | Verdict | Why |
|---|---|---|
| A. Bare daemon only (vsftpd/proftpd on one box) | Reject as *product* | Ops without tenant model / billing boundary |
| B. Managed SFTP gateway (chrooted OpenSSH SFTP + optional FTP) | **v1 pick** | Matches dusty cPanel clients + our Pi/VPS reality; TLS; per-tenant roots |
| C. Multi-tenant FTP-as-a-service (full SaaS) | **v1.1 / profit path** | Same ICD, add signup, metering, multi-region later |

**v1 product name:** HOLD  
**v1 transport:** **SFTP primary** (OpenSSH `internal-sftp`, chroot per tenant). **FTP/FTPS optional** only when a client cannot SFTP (PASV + TLS).  
**v1 publisher:** GitHub Actions / local `lftp|rsync` **into** the tenant root (today’s `ftp/deploy.example.yml` inverted from “push to random host” → “push to HOLD tenant”).

Honest: HOLD is not “GitHub speaks FTP.” HOLD is the **pipe and the disk** we bill for.

---

## 2. Product surfaces

| Surface | Owner | v1 |
|---|---|---|
| Tenant root (`/hold/<slug>/`) | HOLD daemon host | Required |
| Auth (key and/or password) | HOLD | Required — secrets never in git |
| Publisher (CI → HOLD) | `web-systems` workflows | Required |
| Hall / sites registry | `PxD2.github.io` + `sites.json` | Copy fix + link to HOLD product page |
| Obsidian sub-site | Client vault → export folder in tenant | Pattern doc only in v1 |
| Classic FTP | Optional sidecar | Off by default |

---

## 3. Architecture (stack coherence)

```
Obsidian vault / sites/<slug>/  (folder-as-code)
        │
        ▼
   Git (PxD2 or client repo)     ← source of truth
        │  Actions / rsync / lftp
        ▼
   HOLD gateway (SFTP chroot)    ← product we sell
        │
        ▼
   Live site root / CDN / cPanel docroot mirror
```

### 3.1 Sites folder-as-code

- Registry: `web-systems/sites.json` (+ hall annex).  
- Each site slug maps to **one HOLD tenant** and optionally one Pages URL.  
- Publish path: `sites/<slug>/` → `/hold/<slug>/public/` (or `FTP_REMOTE_DIR` equivalent on HOLD).

### 3.2 Obsidian-as-sub-site

- Obsidian vault lives in git (or syncs into `sites/<slug>/notes/`).  
- Publish = export or raw markdown/HTML into tenant folder — **not** Obsidian Sync as the pipe.  
- HOLD only stores files; it does not run Obsidian.

### 3.3 Relationship to existing Pipe A / Pipe B

| Today (`HOSTING.md`) | After HOLD ICD |
|---|---|
| Pipe A — GitHub Pages | Unchanged (static hall) |
| Pipe B — outbound FTP to arbitrary client hosts | Becomes **publisher → HOLD** or **publisher → client** (two profiles) |
| Hall “HOLD = Git≈FTP” | Product-true HOLD gateway |

---

## 4. Tenant ICD (Builder wire targets)

```
tenant = {
  slug: string,           // == sites.json id
  protocol: "sftp" | "ftps",
  host: string,           // hold.pxd2… or box IP
  port: 22 | 21,
  root: "/hold/<slug>",
  public_subdir: "public",
  auth: "ssh_key" | "password",  // password discouraged; FTPS may need it
  quota_mb: number,
  status: "active" | "suspended"
}
```

### 4.1 Host requirements (v1 runnable path)

1. Linux box we control (Pi 5 / VPS) with OpenSSH.  
2. Group `hold` + per-tenant user `hold_<slug>` (or single user with ForceCommand internal-sftp + ChrootDirectory).  
3. `Match Group hold` → `ChrootDirectory /hold/%u` → `ForceCommand internal-sftp` → no shell.  
4. TLS: SFTP inherits SSH; if FTP enabled, vsftpd `ssl_enable=YES` + PASV port range firewalled.  
5. Secrets: `/etc/hold/tenants.env` or per-tenant authorized_keys — **never** in `web-systems` tree.

### 4.2 Publisher job (replace example-only)

Builder delivers (DONE-BAR #3):

- `ftp/README.md` — runbook: provision tenant, add key, mirror  
- `ftp/deploy-hold.yml` — Actions workflow: checkout `sites/<slug>` → SFTP/rsync to HOLD  
- `.env.example` updated for HOLD_* vars (`HOLD_HOST`, `HOLD_USER`, `HOLD_KEY`, `HOLD_ROOT`)  
- One **staged proof**: log or screenshot of successful mirror to a lab tenant (private)

---

## 5. Pricing / profit path (sketch — not a filing)

| SKU | What client gets | Rough PxD2 ask |
|---|---|---|
| HOLD Site | 1 tenant, SFTP, 5–20 GB, CI publish from their git or ours | Monthly per site (hosting margin over VPS/Pi) |
| HOLD Studio | Site + Obsidian folder pattern + hall link | Site + setup fee |
| HOLD Legacy FTP | FTPS enabled for old tools | Add-on |

**Cost base:** one VPS or Pi amortised across N tenants + support time.  
**Margin lever:** N tenants per box before split.  
**Not claimed:** enterprise SLA, HIPAA, or unlimited bandwidth in v1.

---

## 6. Hall copy contract (DONE-BAR #2)

| Location | Today | Replace with |
|---|---|---|
| `PxD2.github.io/sites/sites.json` HOLD blurb | “Git that acts like FTP.” | “SFTP roots we host. Git publishes.” |
| Any annex / README echo | same metaphor | same product-true line |
| `web-systems` README / HOSTING.md | “Not a claim GitHub is FTP” | Point to HOLD-ICD; Pipe B = publish to HOLD or client |

Grok Bot owns the PR text; this ICD is the source of wording.

---

## 7. Honest limits

1. HOLD v1 is **SFTP-first** on boxes we operate — not a global Anycast SaaS.  
2. GitHub is not the FTP server.  
3. No secrets in git.  
4. No Cloud Agents required.  
5. Multi-tenant billing UI out of v1 (manual tenant provision OK).  
6. YOLO1 / CARD-002 / CARD-003 NS loop are **out of scope** — flag Builder contention to Floor Lead if YOLO1 blocks HOLD deploy.  
7. Private/client repos stay private.

---

## 8. DONE-BAR map

| # | Bar | Owner | Artifact |
|---|---|---|---|
| 1 | HOLD product ICD | Systems | **This file** on `web-systems` main |
| 2 | Hall copy product-true | Grok Bot | PR on `PxD2.github.io` |
| 3 | Runnable ftp/ beyond examples | Builder | runbook + workflow + staged proof |
| 4 | Stack coherence note | Systems (this §3) + Builder wire | sites + Obsidian → HOLD path documented |

---

## 9. Hand-off

@Floor Lead: D1 candidate — accept decision B→C path.  
@Builder: implement §4 host + §4.2 publisher; do not invent product scope.  
@Grok Bot: hall blurb + HOSTING.md language from §6.  
@Reviewer: block if hall still says Git≈FTP, or if ftp/ is still examples-only with no proof.
