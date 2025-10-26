# DNS Leak Test

A Go application to test for DNS leaks. This tool checks if your DNS queries are being routed through your ISP or if they're being securely routed through your VPN or DNS service.

## Features

- 🔍 Tests for DNS leaks
- 🎨 Colorful terminal interface
- 🖥️ Cross-platform support (Windows, macOS, Linux, Android/Termux)
- 🔄 Retry functionality - Press 'q' to quit or any other key to retry after each test
- 🏗️ Clean, modular architecture

## Installation

### From Release (Recommended)

Visit the [Releases page](https://github.com/code3-dev/dnsleak/releases) and download the appropriate binary for your platform.

### From Source

```bash
git clone https://github.com/code3-dev/dnsleak
cd dnsleak
```

**Build with default name:**

```bash
go build .
```

**Or build with custom name:**

```bash
# Linux/macOS/Android(Termux)
go build -o your-custom-name .

# Windows
go build -o your-custom-name.exe .
```

### Windows Setup

For Windows users, you can use the provided batch file for easier setup and execution:

1. Run `setup\windows_setup.bat` to automatically:
   - Check for Go installation
   - Set up Go environment variables
   - Build the application
   - Create a desktop shortcut

After setup, you can run `dnsleak` directly from the command line.

```bash
# Run setup
.\windows_setup.bat

# Windows (PowerShell/CMD)
dnsleak
```

### Linux Setup

For Linux users, you can use the provided shell script for easier setup and execution:

1. Run `setup/linux_setup.sh` to automatically:
   - Check for Go installation
   - Set up Go environment variables
   - Build the application
   - Create a symlink for easy access

After setup, you can run `dnsleak` directly from the command line.

```bash
# Make script executable
chmod +x setup/linux_setup.sh

# Run setup
./setup/linux_setup.sh

# Run application (after adding to PATH or creating symlink)
dnsleak
```

### macOS Setup

For macOS users, you can use the provided shell script for easier setup and execution:

1. Run `setup/macos_setup.sh` to automatically:
   - Check for Go installation
   - Set up Go environment variables
   - Build the application
   - Create a symlink for easy access

After setup, you can run `dnsleak` directly from the command line.

```bash
# Make script executable
chmod +x setup/macos_setup.sh

# Run setup
./setup/macos_setup.sh

# Run application (after adding to PATH or creating symlink)
dnsleak
```

### Android/Termux Setup

For Android users using Termux, you can use the provided shell script for automatic installation:

1. Run `setup/android_setup.sh` directly in Termux to automatically:
   - Install required packages (git, golang, etc.)
   - Set up Go environment variables
   - Clone or update the dnsleak repository
   - Build the application
   - Create a symlink for easy access

After setup, you can run `dnsleak` directly from the Termux command line.

```bash
# Make script executable
chmod +x setup/android_setup.sh

# Run setup (in Termux)
./setup/android_setup.sh

# Run application (after setup)
dnsleak
```

## Supported Platforms

- Windows (x86, x64)
- macOS (x64, ARM64)
- Linux (x86, x64)
- Android (Termux - ARMv7a, ARMv8a, x86, x86_64)

## GitHub Actions

This repository uses GitHub Actions for continuous integration and cross-platform builds:

- **Test**: Runs on Ubuntu, Windows, and macOS
- **Build**: Cross-compiles for multiple platforms
- **Release**: Automatically creates GitHub releases with all binaries when tagging

### Built Artifacts

The GitHub Actions workflow automatically builds and releases the following binaries:

**Standard Platforms:**
- `dnsleak-linux-x64` (Linux x64)
- `dnsleak-linux-x86` (Linux x86)
- `dnsleak-windows-x64.exe` (Windows x64)
- `dnsleak-windows-x86.exe` (Windows x86)
- `dnsleak-macos-x64` (macOS x64)
- `dnsleak-macos-arm64` (macOS ARM64)

**Android/Termux Architectures:**
- `dnsleak-android-arm64` (ARMv8a 64-bit)
- `dnsleak-android-arm` (ARMv7a 32-bit)
- `dnsleak-android-x86` (x86 32-bit)
- `dnsleak-android-x86_64` (x86_64 64-bit)

## Usage

Simply run the executable based on your operating system:

```bash
# Linux/macOS/Android(Termux)/Windows (after setup)
dnsleak

# Windows (PowerShell/CMD) (without setup or if not in PATH)
.\dnsleak.exe
```

**For Android/Termux users experiencing certificate errors:**

If you encounter TLS certificate verification errors on Termux, try one of these solutions:

**Solution 1: Update certificates**
```bash
pkg update && pkg upgrade
pkg install ca-certificates openssl-tool
export SSL_CERT_FILE=$PREFIX/etc/tls/cert.pem
./dnsleak-android-arm64
```

**Solution 2: Set certificate file directly**
```bash
SSL_CERT_FILE=$PREFIX/etc/tls/cert.pem ./dnsleak-android-arm64
```

**Solution 3: Bypass certificate verification (less secure)**
```bash
DNSLEAK_INSECURE=true ./dnsleak-android-arm64
```

**Note:** You can customize the executable name during the build process by using the `-o` flag with `go build` (e.g., `go build -o my-dns-test.exe .`).

The tool will:
1. Obtain a test ID from bash.ws
2. Perform fake DNS lookups
3. Analyze the results
4. Display your IP, DNS servers, and leak status
5. Prompt to quit (q) or retry (any other key) after completion or error

## Architecture

```
internal/
├── api/          # API client for bash.ws
├── model/        # Data structures
└── ui/           # Terminal user interface
```

## Author

Hossein Pira - [h3dev.pira@gmail.com](mailto:h3dev.pira@gmail.com)