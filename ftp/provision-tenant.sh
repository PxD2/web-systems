#!/usr/bin/env bash
# Provision one HOLD SFTP tenant on a Linux box we control.
# Usage: sudo ./provision-tenant.sh <slug>
set -euo pipefail
SLUG="${1:?slug required}"
USER="hold_${SLUG}"
ROOT="/hold/${USER}"
PUB="${ROOT}/public"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "run as root" >&2
  exit 1
fi

getent group hold >/dev/null || groupadd hold
if ! id -u "$USER" >/dev/null 2>&1; then
  useradd -M -d "$ROOT" -s /usr/sbin/nologin -g hold "$USER"
fi
mkdir -p "$PUB" "${ROOT}/.ssh"
chown root:root /hold "$ROOT"
chmod 755 /hold "$ROOT"
chown "${USER}:hold" "$PUB"
chmod 755 "$PUB"
touch "${ROOT}/.ssh/authorized_keys"
chown "${USER}:hold" "${ROOT}/.ssh" "${ROOT}/.ssh/authorized_keys"
chmod 700 "${ROOT}/.ssh"
chmod 600 "${ROOT}/.ssh/authorized_keys"

SSHD_DROPIN=/etc/ssh/sshd_config.d/hold.conf
if [[ ! -f "$SSHD_DROPIN" ]]; then
  cat >"$SSHD_DROPIN" <<'CONF'
Match User hold_*
  ChrootDirectory /hold/%u
  ForceCommand internal-sftp
  AllowTcpForwarding no
  X11Forwarding no
  PasswordAuthentication no
CONF
  systemctl reload sshd || systemctl reload ssh || true
fi

echo "tenant ready: user=$USER chroot=$ROOT public=$PUB"
echo "add client pubkey to ${ROOT}/.ssh/authorized_keys"
