#!/data/data/com.termux/files/usr/bin/env bash
set -euo pipefail

# ----------------------------------------
# 1) Install required packages
# ----------------------------------------
pkg update -y
pkg install -y git golang which ca-certificates openssl-tool

# ----------------------------------------
# 2) Clone or update dnsleak repo
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
# 3) Ensure Go modules are tidy & dependencies fetched
# ----------------------------------------
go mod tidy

# ----------------------------------------
# 4) Try to build without cgo first
# ----------------------------------------
if ! go build -o "$GOBIN/dnsleak" .; then
  echo "Build failed, installing additional build tools for cgo compatibility..."
  # Install additional build tools required for cgo (only if needed)
  pkg install -y clang make pkg-config autoconf automake libtool || true
  
  # Ensure Go environment and cgo settings for Termux/aarch64
  export CC=clang
  export CXX=clang++
  export CGO_ENABLED=0
fi

# ----------------------------------------
# 5) Build into GOBIN (retry if previous attempt failed)
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
echo "You can now run the app by typing: dnsleak"
