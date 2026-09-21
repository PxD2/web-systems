#!/usr/bin/env bash
# Local staged mirror proof (no network). Maps sites/<slug>/ → fake chroot public/.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SLUG="${1:-lab}"
SRC="$ROOT/sites/$SLUG"
DST="$ROOT/ftp/proof/fake-hold/hold_${SLUG}/public"
LOG="$ROOT/ftp/proof/staged-mirror.log"
mkdir -p "$DST"
if [[ ! -d "$SRC" ]]; then
  echo "missing $SRC" >&2
  exit 1
fi
# prefer rsync; fall back to cp -a for lab boxes without rsync
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete "$SRC/" "$DST/"
else
  find "$DST" -mindepth 1 -delete 2>/dev/null || true
  cp -a "$SRC"/. "$DST"/
fi
{
  echo "HOLD staged mirror proof"
  echo "ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "src=$SRC"
  echo "dst=$DST"
  echo "files:"
  find "$DST" -type f | sort | sed "s|^|  |"
  echo "result=OK"
} | tee "$LOG"
