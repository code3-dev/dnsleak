#!/data/data/com.termux/files/usr/bin/env bash
set -euo pipefail

# 1) install packages
pkg update -y
pkg install -y git golang which

# 2) persistent Go env (use ~/.profile so Termux shells load it)
# Avoid duplicate lines by grepping first
grep -qxF 'export GOPATH=$HOME/go' ~/.profile || echo 'export GOPATH=$HOME/go' >> ~/.profile
grep -qxF 'export GOBIN=$GOPATH/bin' ~/.profile || echo 'export GOBIN=$GOPATH/bin' >> ~/.profile
# Append PATH entry but avoid repeating GOBIN multiple times
if ! grep -q 'export PATH=.*\$GOBIN' ~/.profile; then
  echo 'export PATH=$PATH:$GOBIN' >> ~/.profile
fi

# apply to current shell
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
mkdir -p "$GOBIN"

# 3) clone (or update) the dnsleak repo and build
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
# Ensure Go modules are tidy & dependencies fetched
# ----------------------------------------
go mod tidy

# build into GOBIN (handles module path mismatch by building locally)
go build -o "$GOBIN/dnsleak" .

# 4) make executable and symlink into Termux prefix (safe, overwrites existing symlink)
chmod +x "$GOBIN/dnsleak"
ln -sf "$GOBIN/dnsleak" "$PREFIX/bin/dnsleak"
chmod +x "$PREFIX/bin/dnsleak"

# 5) verification
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
echo "You can now run the app by typing: dnsleak"
