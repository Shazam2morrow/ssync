#!/bin/bash

### ================================
### GitHub Identity & Key Setup Tool
### ================================
### Author: shazam2morrow
### --------------------------------

# Uncomment for debug output:
# set -x

set -euo pipefail

### ==== Global Configuration Variables ====
GIT_NAME="[USERNAME]"
GIT_EMAIL="[NOREPLYEMAIL]"
SSH_KEY_PREFIX="id_ed25519_github"
TIMESTAMP=$(date +%y%m%d)
SSH_KEY_PATH="$HOME/.ssh/${SSH_KEY_PREFIX}_${TIMESTAMP}"

### ==== GPG Binary Detection ====
if command -v gpg2 >/dev/null 2>&1; then
  GPG_BIN="gpg2"
else
  GPG_BIN="gpg"
fi

### ==== Step 1: SSH Keys Generation ====
echo "🔐 [SSH] Generating private SSH key at $SSH_KEY_PATH"
ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY_PATH"

echo "🚀 [SSH] Starting ssh-agent if not already running..."
eval "$(ssh-agent -s)"

echo "➕ [SSH] Adding private key to ssh-agent..."
ssh-add "$SSH_KEY_PATH"

echo "📋 [SSH] Add the following public key to your GitHub account (https://github.com/settings/ssh/new):"
echo
cat "${SSH_KEY_PATH}.pub"
echo

echo "✅ SSH key setup complete!"

### ==== Step 2: GPG Key Generation ====
echo "🔑 [GPG] Generating GPG key (interactive)..."
echo "Use: Name=$GIT_NAME, Email=$GIT_EMAIL"
$GPG_BIN --full-generate-key

echo "🔎 [GPG] Extracting GPG key ID for $GIT_EMAIL..."
GPG_KEY_ID=$($GPG_BIN --list-secret-keys --with-colons "$GIT_EMAIL" | awk -F: '/^sec/ {print $5; exit}')

if [[ -z "$GPG_KEY_ID" ]]; then
  echo "❌ ERROR: No GPG key found for email $GIT_EMAIL"
  exit 1
fi

echo "🆔 [GPG] Found key ID: $GPG_KEY_ID"

echo "📦 [GPG] Exporting public key to /tmp/github_gpgkey.asc..."
$GPG_BIN --armor --export "$GPG_KEY_ID" > /tmp/github_gpgkey.asc

echo "📋 [GPG] Add the following GPG key to your GitHub account (https://github.com/settings/gpg/new):"
echo
cat /tmp/github_gpgkey.asc
echo

# Optional cleanup
rm -f /tmp/github_gpgkey.asc

### ==== Step 3: Git Global Configuration ====
echo "⚙️ [Git] Configuring global git identity and signing options..."

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global commit.gpgsign true
git config --global gpg.format openpgp
git config --global user.signingkey "$GPG_KEY_ID"
git config --global color.ui auto

echo
echo "✅ All steps completed!"
echo "🔐 SSH key added and ready for GitHub auth."
echo "🔒 GPG commit signing is now active."

echo
echo "🧾 Git config summary:"
git config --list --show-origin

echo "You can test your SSH connection using 'ssh -T git@github.com'"
