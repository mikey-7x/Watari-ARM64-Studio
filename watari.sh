#!/bin/bash
# ==============================================================================
# Script: Watari Native Forge - Universal Linux ARM64 Installer
# Repository: https://github.com/mikey-7x/Watari-ARM64-Studio
# Description: Installs the Pure Native Android Java Compiler across all Linux distros.
# ==============================================================================
set -e

GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
CYAN="\e[1;36m"
RESET="\e[0m"

echo -e "${BLUE}[+] Initializing Universal Watari Forge Deployment...${RESET}"

# 1. Architecture Safety Check
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
    echo -e "${RED}[!] WARNING: System architecture detected as '$ARCH'.${RESET}"
    echo -e "${RED}Watari Forge is physically compiled for ARM64/AArch64 processors.${RESET}"
    echo -e "${RED}It may fail to compile on standard Intel/AMD (x86_64) PCs.${RESET}"
    echo -e "${YELLOW}Continuing in 5 seconds...${RESET}"
    sleep 5
fi

# 2. Sudo / Root Detection
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        echo -e "${RED}[!] Root privileges required. Please run as root or install 'sudo'.${RESET}"
        exit 1
    fi
fi
if [ -n "$TERMUX_VERSION" ] && [ "$(id -u)" -ne 0 ]; then
    SUDO=""
fi

# 3. Universal Package Manager Detection
echo -e "${YELLOW}[*] Detecting Package Manager and installing dependencies...${RESET}"

if command -v pacman >/dev/null 2>&1; then
    echo -e "${CYAN} -> Detected Arch Linux / pacman${RESET}"
    $SUDO pacman -Sy --noconfirm jdk17-openjdk wget curl unzip zip tar xz tree
elif [ -f "/etc/os-release" ] && grep -qi "ubuntu\|debian" /etc/os-release; then
    echo -e "${CYAN} -> Detected Debian/Ubuntu / apt${RESET}"
    $SUDO apt-get update -y
    $SUDO apt-get install -y openjdk-17-jdk wget curl unzip zip tar xz-utils tree
elif command -v dnf >/dev/null 2>&1; then
    echo -e "${CYAN} -> Detected Fedora/RHEL / dnf${RESET}"
    $SUDO dnf install -y java-17-openjdk-devel wget curl unzip zip tar xz tree
elif command -v zypper >/dev/null 2>&1; then
    echo -e "${CYAN} -> Detected openSUSE / zypper${RESET}"
    $SUDO zypper install -y -n java-17-openjdk-devel wget curl unzip zip tar xz tree
elif command -v apk >/dev/null 2>&1; then
    echo -e "${CYAN} -> Detected Alpine / apk${RESET}"
    $SUDO apk add --no-cache openjdk17 wget curl unzip zip tar xz tree
elif command -v pkg >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
    echo -e "${CYAN} -> Detected Termux / pkg${RESET}"
    pkg update -y
    pkg install -y openjdk-17 wget curl unzip zip tar xz-utils tree
elif command -v apt-get >/dev/null 2>&1; then
    echo -e "${CYAN} -> Detected Generic apt-get${RESET}"
    $SUDO apt-get update -y
    $SUDO apt-get install -y openjdk-17-jdk wget curl unzip zip tar xz-utils tree
else
    echo -e "${RED}[!] Unsupported Package Manager.${RESET}"
    echo -e "Please manually install: Java JDK 17, wget, curl, unzip, zip, tar, xz, tree"
    sleep 3
fi

# 4. Download Master Payload from GitHub
PAYLOAD_URL="https://github.com/mikey-7x/Watari-ARM64-Studio/releases/download/v2.0.0/Watari-Native-Forge-ARM64.tar.xz"
PAYLOAD_FILE="Watari-Native-Forge-ARM64.tar.xz"

echo -e "${BLUE}[+] Fetching the Native ARM64 Compiler Engine...${RESET}"
if [ ! -f "$PAYLOAD_FILE" ]; then
    wget --show-progress -O "$PAYLOAD_FILE" "$PAYLOAD_URL"
else
    echo -e "${YELLOW}[*] Payload '$PAYLOAD_FILE' detected locally, skipping download.${RESET}"
fi

# 5. Extract the Payload
echo -e "${BLUE}[+] Unpacking the Forge into your environment...${RESET}"
rm -rf "$HOME/.watari_forge"
tar -xf "$PAYLOAD_FILE" -C "$HOME/"

# 6. Inject Path
for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc_file" ] || [ "$rc_file" == "$HOME/.bashrc" ]; then
        if ! grep -q "watari_forge/bin" "$rc_file"; then
            echo 'export PATH="$HOME/.watari_forge/bin:$PATH"' >> "$rc_file"
        fi
    fi
done

echo -e "${GREEN}======================================================================${RESET}"
echo -e "${GREEN}                 [✔] WATARI FORGE INSTALLED                           ${RESET}"
echo -e "${GREEN}======================================================================${RESET}"
echo -e "The compiler is successfully integrated into your Linux environment."
echo -e "To start, restart your terminal or run: ${CYAN}source ~/.bashrc${RESET}"
echo -e "Then type ${YELLOW}watari${RESET} to see the command menu."
echo -e "${GREEN}======================================================================${RESET}"
