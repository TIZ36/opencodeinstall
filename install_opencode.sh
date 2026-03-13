#!/bin/bash

#
# OpenCode CLI and OhMyOpenCode Installation Script
# Supports macOS and Linux
# Usage: bash install_opencode.sh
#

set -e

INSTALL_OHMYOPENCODE="ask"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        DISTRO=$(lsb_release -si 2>/dev/null || echo "Linux")
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macOS"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    print_success "Detected OS: $DISTRO"
}

# Parse command line options
parse_args() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --with-ohmyopencode)
                INSTALL_OHMYOPENCODE="yes"
                ;;
            --without-ohmyopencode)
                INSTALL_OHMYOPENCODE="no"
                ;;
            -h|--help)
                echo "Usage: bash install_opencode.sh [options]"
                echo ""
                echo "Options:"
                echo "  --with-ohmyopencode     Install OhMyOpenCode without prompt"
                echo "  --without-ohmyopencode  Skip OhMyOpenCode without prompt"
                echo "  -h, --help              Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help to see available options."
                exit 1
                ;;
        esac
        shift
    done
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check for curl or wget
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        print_error "curl or wget is required but not installed"
        exit 1
    fi
    print_success "curl/wget is installed"
    
    # Check for Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is required but not installed"
        print_info "Please install Node.js from https://nodejs.org/"
        exit 1
    fi
    print_success "Node.js is installed ($(node --version))"
    
    # Check for npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is required but not installed"
        exit 1
    fi
    print_success "npm is installed ($(npm --version))"
}

# Install OpenCode CLI
install_opencode_cli() {
    print_header "Installing OpenCode CLI"

    local latest_version
    local installed_version

    latest_version=$(npm view @anomalyco/opencode version 2>/dev/null || true)
    installed_version=$(npm list -g @anomalyco/opencode --depth=0 2>/dev/null | grep -Eo '@anomalyco/opencode@[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | cut -d'@' -f3)

    if [ -z "$latest_version" ]; then
        print_error "Could not fetch latest OpenCode CLI version from npm"
        exit 1
    fi

    print_info "Latest version on npm: $latest_version"

    if [ -n "$installed_version" ]; then
        print_info "Installed version: $installed_version"
    else
        print_info "OpenCode CLI is not currently installed"
    fi

    if [ "$installed_version" = "$latest_version" ]; then
        print_success "OpenCode CLI is already up to date"
    else
        print_info "Installing/updating OpenCode CLI to latest..."
        npm install -g @anomalyco/opencode@latest
        print_success "OpenCode CLI installed/updated successfully"
    fi
    
    # Verify installation
    if command -v opencode &> /dev/null; then
        print_success "OpenCode CLI is ready to use"
        print_info "Version: $(opencode --version 2>/dev/null || echo 'unknown')"
    else
        print_error "OpenCode CLI installation verification failed"
        exit 1
    fi
}

# Install OhMyOpenCode
install_ohmyopencode() {
    print_header "Installing OhMyOpenCode"
    
    # Determine shell config file
    if [ "$OS" = "macos" ]; then
        SHELL_CONFIG_FILE="$HOME/.zprofile"
        if [ ! -f "$SHELL_CONFIG_FILE" ]; then
            SHELL_CONFIG_FILE="$HOME/.bash_profile"
        fi
    else
        SHELL_CONFIG_FILE="$HOME/.bashrc"
        if [ ! -f "$SHELL_CONFIG_FILE" ]; then
            SHELL_CONFIG_FILE="$HOME/.profile"
        fi
    fi
    
    print_info "Using shell config: $SHELL_CONFIG_FILE"
    
    # Clone or update OhMyOpenCode repository
    OHMYOPENCODE_DIR="$HOME/.ohmyopencode"
    
    if [ -d "$OHMYOPENCODE_DIR" ]; then
        print_info "OhMyOpenCode directory already exists, updating..."
        cd "$OHMYOPENCODE_DIR"
        git pull origin main &>/dev/null || git pull origin master &>/dev/null || print_info "Could not update via git"
    else
        print_info "Cloning OhMyOpenCode repository..."
        git clone https://github.com/anomalyco/ohmyopencode.git "$OHMYOPENCODE_DIR" 2>/dev/null || {
            # Fallback: download as zip if git is not available
            print_info "Downloading OhMyOpenCode as zip file..."
            if command -v curl &> /dev/null; then
                mkdir -p "$OHMYOPENCODE_DIR"
                curl -L https://github.com/anomalyco/ohmyopencode/archive/main.zip -o /tmp/ohmyopencode.zip 2>/dev/null
                cd "$OHMYOPENCODE_DIR"
                unzip -q /tmp/ohmyopencode.zip
                mv ohmyopencode-main/* .
                rm -rf ohmyopencode-main /tmp/ohmyopencode.zip
            fi
        }
    fi
    
    if [ -d "$OHMYOPENCODE_DIR" ]; then
        print_success "OhMyOpenCode installed to $OHMYOPENCODE_DIR"
    else
        print_error "OhMyOpenCode installation failed"
        exit 1
    fi
    
    # Add to shell config
    INIT_SCRIPT="[ -f \"$OHMYOPENCODE_DIR/init.sh\" ] && source \"$OHMYOPENCODE_DIR/init.sh\""
    
    if ! grep -q "$OHMYOPENCODE_DIR" "$SHELL_CONFIG_FILE" 2>/dev/null; then
        print_info "Adding OhMyOpenCode to $SHELL_CONFIG_FILE..."
        echo "" >> "$SHELL_CONFIG_FILE"
        echo "# OhMyOpenCode initialization" >> "$SHELL_CONFIG_FILE"
        echo "$INIT_SCRIPT" >> "$SHELL_CONFIG_FILE"
        print_success "OhMyOpenCode added to shell configuration"
    else
        print_info "OhMyOpenCode is already in shell configuration"
    fi
}

ask_ohmyopencode_install() {
    if [ "$INSTALL_OHMYOPENCODE" = "yes" ] || [ "$INSTALL_OHMYOPENCODE" = "no" ]; then
        return
    fi

    if [ -t 0 ]; then
        printf "Do you want to install OhMyOpenCode plugin? [y/N]: "
        read -r reply
        case "$reply" in
            y|Y|yes|YES)
                INSTALL_OHMYOPENCODE="yes"
                ;;
            *)
                INSTALL_OHMYOPENCODE="no"
                ;;
        esac
    else
        INSTALL_OHMYOPENCODE="no"
    fi
}

# Setup complete
setup_complete() {
    print_header "Installation Complete!"
    
    echo ""
    if [ "$INSTALL_OHMYOPENCODE" = "yes" ]; then
        print_success "OpenCode CLI and OhMyOpenCode have been installed"
    else
        print_success "OpenCode CLI has been installed"
        print_info "OhMyOpenCode was skipped"
    fi
    echo ""
    echo "Next steps:"
    echo "1. Reload your shell configuration:"
    if [ "$OS" = "macos" ]; then
        echo "   ${BLUE}source ~/.zprofile${NC}"
    else
        echo "   ${BLUE}source ~/.bashrc${NC}"
    fi
    echo ""
    echo "2. Verify OpenCode CLI installation:"
    echo "   ${BLUE}opencode --version${NC}"
    echo ""
    echo "3. Start using OpenCode:"
    echo "   ${BLUE}opencode${NC}"
    echo ""
    echo "For more information, visit:"
    echo "   ${BLUE}https://opencode.ai${NC}"
    echo ""
}

# Main execution
main() {
    parse_args "$@"

    print_header "OpenCode & OhMyOpenCode Installer"
    echo "This script will install the latest OpenCode CLI"
    echo "OhMyOpenCode plugin installation is optional"
    echo ""
    
    detect_os
    check_prerequisites
    install_opencode_cli
    ask_ohmyopencode_install

    if [ "$INSTALL_OHMYOPENCODE" = "yes" ]; then
        install_ohmyopencode
    else
        print_info "Skipping OhMyOpenCode installation"
    fi
    setup_complete
}

# Run main function
main "$@"
