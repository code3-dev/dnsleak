# DNS Leak Test

A Go application to test for DNS leaks. This tool checks if your DNS queries are being routed through your ISP or if they're being securely routed through your VPN or DNS service.

## Features

- 🔍 Tests for DNS leaks
- 🎨 Colorful terminal interface
- 🖥️ Cross-platform support (Windows, macOS, Linux, Android/Termux)
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

**Run the application:**

```bash
# Linux/macOS/Android(Termux)
./dnsleak
# or if you used a custom name:
./your-custom-name

# Windows (PowerShell/CMD)
.\dnsleak.exe
# or if you used a custom name:
.\your-custom-name.exe
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

The GitHub Actions workflow builds the following binaries:

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
# Linux/macOS/Android(Termux)
./dnsleak

# Windows (PowerShell/CMD)
.\dnsleak.exe
```

**Note:** You can customize the executable name during the build process by using the `-o` flag with `go build` (e.g., `go build -o my-dns-test.exe .`).

The tool will:
1. Obtain a test ID from bash.ws
2. Perform fake DNS lookups
3. Analyze the results
4. Display your IP, DNS servers, and leak status

## Architecture

```
internal/
├── api/          # API client for bash.ws
├── model/        # Data structures
└── ui/           # Terminal user interface
```

## Author

Hossein Pira - [h3dev.pira@gmail.com](mailto:h3dev.pira@gmail.com)