#!/bin/bash
# ==============================================================================
# Script: Watari Native Forge - Universal Linux ARM64 Installer
# Author: Mikey (@mikey-7x)
# License: Watari Proprietary Non-Commercial License (Strict)
# Description: High-speed Pure Java Android Compiler. Play Store Ready.
# ==============================================================================
set -e

GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
CYAN="\e[1;36m"
RESET="\e[0m"

echo -e "${BLUE}[+] Initializing Watari Native Forge Deployment (by mikey-7x)...${RESET}"

# 1. Architecture Safety Check
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
    echo -e "${RED}[!] WARNING: System architecture detected as '$ARCH'. Expected ARM64.${RESET}"
    sleep 3
fi

# 2. Sudo / Root Detection
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    fi
fi
if [ -n "$TERMUX_VERSION" ] && [ "$(id -u)" -ne 0 ]; then
    SUDO=""
fi

# 3. Universal Package Manager Detection
echo -e "${YELLOW}[*] Detecting Package Manager and installing dependencies...${RESET}"
if command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -Sy --noconfirm jdk17-openjdk wget curl unzip zip tar xz tree
elif [ -f "/etc/os-release" ] && grep -qi "ubuntu\|debian" /etc/os-release; then
    $SUDO apt-get update -y && $SUDO apt-get install -y openjdk-17-jdk wget curl unzip zip tar xz-utils tree
elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y java-17-openjdk-devel wget curl unzip zip tar xz tree
elif command -v zypper >/dev/null 2>&1; then
    $SUDO zypper install -y -n java-17-openjdk-devel wget curl unzip zip tar xz tree
elif command -v apk >/dev/null 2>&1; then
    $SUDO apk add --no-cache openjdk17 wget curl unzip zip tar xz tree
elif command -v pkg >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
    pkg update -y && pkg install -y openjdk-17 wget curl unzip zip tar xz-utils tree
else
    echo -e "${RED}[!] Unsupported Package Manager. Install Java 17 manually.${RESET}"
    exit 1
fi

# 4. Download Master Payload
PAYLOAD_URL="https://github.com/mikey-7x/Watari-ARM64-Studio/releases/download/v2.0.0/Watari-Native-Forge-ARM64.tar.xz"
PAYLOAD_FILE="Watari-Native-Forge-ARM64.tar.xz"

echo -e "${BLUE}[+] Fetching the Native ARM64 Compiler Engine...${RESET}"
if [ ! -f "$PAYLOAD_FILE" ]; then
    wget --show-progress -q -O "$PAYLOAD_FILE" "$PAYLOAD_URL"
fi

# 5. Extract & Setup
echo -e "${BLUE}[+] Unpacking the Forge into your environment...${RESET}"
rm -rf "$HOME/.watari_forge"
tar -xf "$PAYLOAD_FILE" -C "$HOME/"

# 6. Inject Path Safely
for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
    touch "$rc_file" # Creates the file if it doesn't exist
    if ! grep -q "watari_forge/bin" "$rc_file"; then
        echo 'export PATH="$HOME/.watari_forge/bin:$PATH"' >> "$rc_file"
    fi
done

echo -e "${GREEN}======================================================================${RESET}"
echo -e "${GREEN}                 [✔] WATARI FORGE INSTALLED                           ${RESET}"
echo -e "${GREEN}                 Proprietary Engine by mikey-7x                       ${RESET}"
echo -e "${GREEN}======================================================================${RESET}"
echo -e "Restart your terminal or run: ${CYAN}source ~/.bashrc${RESET}"
