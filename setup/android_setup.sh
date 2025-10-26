#!/data/data/com.termux/files/usr/bin/env bash
set -euo pipefail

# ----------------------------------------
# 1) Install required packages
# ----------------------------------------
pkg update -y
pkg install -y git golang which ca-certificates openssl-tool

# ----------------------------------------
# 2) Persistent Go environment
# ----------------------------------------
# Avoid duplicate lines
grep -qxF 'export GOPATH=$HOME/go' ~/.profile || echo 'export GOPATH=$HOME/go' >> ~/.profile
grep -qxF 'export GOBIN=$GOPATH/bin' ~/.profile || echo 'export GOBIN=$GOPATH/bin' >> ~/.profile
if ! grep -q 'export PATH=.*\$GOBIN' ~/.profile; then
  echo 'export PATH=$PATH:$GOBIN' >> ~/.profile
fi

# Apply to current shell
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
mkdir -p "$GOBIN"

# ----------------------------------------
# 3) Clone or update dnsleak repo
# ----------------------------------------
WORKDIR="$HOME/src"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

if [ -d "$WORKDIR/dnsleak" ]; then
  cd "$WORKDIR/dnsleak"
  git fetch --all --prune
  git reset --hard origin/HEAD
else
  git clone https://github.com/code3-dev/dnsleak.git
  cd dnsleak
fi

# ----------------------------------------
# 4) Ensure Go modules are tidy & dependencies fetched
# ----------------------------------------
go mod tidy

# ----------------------------------------
# 5) Build into GOBIN
# ----------------------------------------
go build -o "$GOBIN/dnsleak" .

# ----------------------------------------
# 6) Make executable & symlink into Termux prefix
# ----------------------------------------
chmod +x "$GOBIN/dnsleak"
ln -sf "$GOBIN/dnsleak" "$PREFIX/bin/dnsleak"
chmod +x "$PREFIX/bin/dnsleak"

# ----------------------------------------
# 7) Verification
# ----------------------------------------
echo "---- verification ----"
echo "GOPATH=$GOPATH"
echo "GOBIN=$GOBIN"
echo "PATH=$PATH"
echo "ls -l \$GOBIN/dnsleak:"
ls -l "$GOBIN/dnsleak" || true
echo "ls -l \$PREFIX/bin/dnsleak:"
ls -l "$PREFIX/bin/dnsleak" || true
echo "which dnsleak (from current shell):"
which dnsleak || true
echo "dnsleak:"
dnsleak || true

echo "Done. If a new shell doesn't see the command, run: . ~/.profile or restart Termux."