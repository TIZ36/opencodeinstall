# OpenCode CLI and OhMyOpenCode Installation Guide

A unified installer script for both **OpenCode CLI** and **OhMyOpenCode** that works seamlessly on both macOS and Linux.

## Features

- ✅ Automatic OS detection (macOS and Linux)
- ✅ Prerequisite validation (Node.js, npm, curl/wget)
- ✅ OpenCode CLI installation via npm
- ✅ OhMyOpenCode framework installation and setup
- ✅ Automatic shell configuration updates
- ✅ Colored output for better readability
- ✅ Error handling and user feedback

## Requirements

- **macOS** (10.13+) or **Linux** (Ubuntu, Debian, CentOS, etc.)
- **Node.js** (v14+) and npm
- **curl** or **wget** for downloads
- **bash** shell

## Quick Start

### Option 1: Direct Installation

```bash
curl -sSL https://example.com/install_opencode.sh | bash
```

### Option 2: Local Installation

1. Download the script:
```bash
wget https://example.com/install_opencode.sh
# or
curl -O https://example.com/install_opencode.sh
```

2. Make it executable:
```bash
chmod +x install_opencode.sh
```

3. Run the installer:
```bash
./install_opencode.sh
```

## What Gets Installed

### OpenCode CLI
- Global npm package: `@anomalyco/opencode`
- Available as: `opencode` command
- Provides CLI interface for OpenCode tools

### OhMyOpenCode
- Installed to: `~/.ohmyopencode`
- Shell integration for enhanced OpenCode experience
- Automatic shell configuration updates

## Platform-Specific Details

### macOS
- Detects macOS version
- Updates `.zprofile` or `.bash_profile`
- Works with both zsh and bash

### Linux
- Supports all major distributions (Ubuntu, Debian, CentOS, etc.)
- Updates `.bashrc` or `.profile`
- Auto-detects distribution

## Post-Installation

After running the installer, reload your shell:

**macOS:**
```bash
source ~/.zprofile
```

**Linux:**
```bash
source ~/.bashrc
```

Then verify the installation:
```bash
opencode --version
```

## Usage

After installation, you can start using OpenCode:

```bash
# View available commands
opencode --help

# Start OpenCode interactive CLI
opencode
```

## Troubleshooting

### Node.js is not installed
Install Node.js from https://nodejs.org/

### npm permission errors
Try installing with:
```bash
sudo npm install -g @anomalyco/opencode
```

Or use a Node version manager (nvm, fnm) to avoid sudo:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install node
./install_opencode.sh
```

### Shell configuration not found
Manually add to your shell config:
```bash
[ -f "$HOME/.ohmyopencode/init.sh" ] && source "$HOME/.ohmyopencode/init.sh"
```

### Git is required but not available
The script will attempt to download OhMyOpenCode as a zip file if git is unavailable.

## Manual Installation

If you prefer manual installation:

### Install OpenCode CLI
```bash
npm install -g @anomalyco/opencode
```

### Install OhMyOpenCode
```bash
git clone https://github.com/anomalyco/ohmyopencode.git ~/.ohmyopencode
```

Then add to your shell config:
```bash
[ -f "$HOME/.ohmyopencode/init.sh" ] && source "$HOME/.ohmyopencode/init.sh"
```

## Uninstallation

To uninstall, run:

```bash
# Uninstall OpenCode CLI
npm uninstall -g @anomalyco/opencode

# Remove OhMyOpenCode
rm -rf ~/.ohmyopencode
```

Then remove the initialization line from your shell config file.

## Support

For issues or feature requests, visit:
- **OpenCode Docs**: https://opencode.ai/docs
- **GitHub Issues**: https://github.com/anomalyco/opencode/issues
- **OhMyOpenCode Repo**: https://github.com/anomalyco/ohmyopencode

## License

This installation script is provided as-is for setting up OpenCode CLI and OhMyOpenCode.

---

**Happy coding with OpenCode!** 🚀
