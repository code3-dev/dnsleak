#!/bin/bash
set -euo pipefail

# ----------------------------------------
# Linux Setup Script for DNSLeak Application
# ----------------------------------------

echo "----------------------------------------"
echo "1) Checking for Go installation"
echo "----------------------------------------"

if ! command -v go &> /dev/null; then
    echo "Error: Go is not installed or not in PATH"
    echo "Please download and install Go from https://golang.org/dl/"
    exit 1
fi

echo "Go is installed"
go version

echo "----------------------------------------"
echo "2) Setting up Go environment variables"
echo "----------------------------------------"

# Set GOPATH to user's home directory
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

# Add GOBIN to PATH if not already present
if [[ ":$PATH:" != *":$GOBIN:"* ]]; then
    export PATH="$PATH:$GOBIN"
    echo "Added GOBIN to PATH"
else
    echo "GOBIN already in PATH"
fi

# Create GOBIN directory if it doesn't exist
if [ ! -d "$GOBIN" ]; then
    mkdir -p "$GOBIN"
    echo "Created GOBIN directory"
else
    echo "GOBIN directory already exists"
fi

echo "GOPATH=$GOPATH"
echo "GOBIN=$GOBIN"

echo "----------------------------------------"
echo "3) Building DNSLeak application"
echo "----------------------------------------"

# Change to the parent directory (where the Go source files are located)
cd "$(dirname "$0")/.."

# Tidy modules
echo "Running go mod tidy..."
go mod tidy
if [ $? -ne 0 ]; then
    echo "Error: Failed to tidy Go modules"
    exit 1
fi

# Build the application
echo "Building application..."
go build -o "$GOBIN/dnsleak" .
if [ $? -ne 0 ]; then
    echo "Error: Failed to build application"
    exit 1
fi

echo "Successfully built dnsleak"

echo "----------------------------------------"
echo "4) Creating symlink for easy access"
echo "----------------------------------------"

# Create a symlink in ~/bin if it exists or create it
if [ -d "$HOME/bin" ]; then
    ln -sf "$GOBIN/dnsleak" "$HOME/bin/dnsleak"
    echo "Created symlink in ~/bin"
elif [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
    ln -sf "$GOBIN/dnsleak" "/usr/local/bin/dnsleak"
    echo "Created symlink in /usr/local/bin"
else
    echo "Note: Could not create symlink in standard locations"
    echo "You can manually add $GOBIN to your PATH or create a symlink"
fi

echo "----------------------------------------"
echo "5) Verification"
echo "----------------------------------------"

echo "GOPATH=$GOPATH"
echo "GOBIN=$GOBIN"
echo "PATH contains GOBIN: $(if [[ ":$PATH:" == *":$GOBIN:"* ]]; then echo "Yes"; else echo "No"; fi)"

echo "Checking if dnsleak exists in GOBIN:"
if [ -f "$GOBIN/dnsleak" ]; then
    echo "  Found: $GOBIN/dnsleak"
else
    echo "  Not found: $GOBIN/dnsleak"
fi

echo ""
echo "----------------------------------------"
echo "Setup Complete!"
echo "----------------------------------------"
echo "You can now run the application in two ways:"
echo "1. From any terminal: dnsleak"
echo "   (If GOBIN is in your PATH or symlink was created)"
echo "2. Directly: $GOBIN/dnsleak"
echo ""
echo "To test now, you can run:"
echo "  $GOBIN/dnsleak"
echo "or simply type:"
echo "  dnsleak"
echo ""