#!/bin/bash
# ==============================================================================
# Script: Watari PRO Engine - Universal Master Installer
# Author: Mikey (@mikey-7x)
# License: Watari Proprietary Non-Commercial License (Strict)
# Description: Offline Kotlin/Gradle Android & Desktop app compilation on ARM64.
# Features: Play Store Release Keystores, Multi-Distro, Desktop JVM Support.
# ==============================================================================
set -e

GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
CYAN="\e[1;36m"
RESET="\e[0m"

echo -e "${BLUE}======================================================${RESET}"
echo -e "${CYAN}   INITIALIZING WATARI PRO ENGINE (by mikey-7x)       ${RESET}"
echo -e "${BLUE}======================================================${RESET}"

# Pre-flight Internet Check
if ! wget -q --spider http://google.com; then
    echo -e "${RED}[!] Error: No internet connection detected.${RESET}"
    exit 1
fi

# Universal Dependency Installation
if [ -n "$PREFIX" ] && [ -x "$PREFIX/bin/pkg" ]; then
    # Termux specific: Ignore mirror sync errors gracefully
    pkg update -y || true
    pkg install -y openjdk-17 wget curl unzip zip git tree
else
    SUDO=""
    [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1 && SUDO="sudo"
    if command -v apt-get >/dev/null 2>&1; then
        $SUDO apt-get update -y || true
        $SUDO apt-get install -y openjdk-17-jdk wget curl unzip zip git tree
    elif command -v pacman >/dev/null 2>&1; then
        $SUDO pacman -Sy --noconfirm jre17-openjdk jdk17-openjdk wget curl unzip zip git tree
    elif command -v dnf >/dev/null 2>&1; then
        $SUDO dnf install -y java-17-openjdk wget curl unzip zip git tree
    fi
fi

# Fix for Termux and Linux JAVA_HOME detection
echo -e "${YELLOW}[*] Configuring Java Environment...${RESET}"
hash -r
if [ -n "$PREFIX" ] && [ -d "$PREFIX/lib/jvm/java-17-openjdk" ]; then
    export JAVA_HOME="$PREFIX/lib/jvm/java-17-openjdk"
else
    export JAVA_HOME="$(dirname $(dirname $(readlink -f $(command -v java))))"
fi
export PATH="$JAVA_HOME/bin:$PATH"

export WATARI_HOME="$HOME/.watari_forge"
export ANDROID_HOME="$WATARI_HOME/android_sdk"
export CMDLINE_TOOLS="$ANDROID_HOME/cmdline-tools/latest/bin"
export WATARI_BIN="$WATARI_HOME/bin"
export GRADLE_HOME="$WATARI_HOME/gradle/latest"

rm -rf "$WATARI_HOME"
mkdir -p "$ANDROID_HOME/cmdline-tools" "$WATARI_BIN" "$WATARI_HOME/gradle"

# Fetch Portable Gradle
echo -e "${YELLOW}[*] Fetching Portable Standalone Gradle Engine...${RESET}"
wget --show-progress -q -O "$WATARI_HOME/gradle/gradle.zip" "https://services.gradle.org/distributions/gradle-8.7-bin.zip"
unzip -q "$WATARI_HOME/gradle/gradle.zip" -d "$WATARI_HOME/gradle/"
mv "$WATARI_HOME/gradle/gradle-8.7" "$GRADLE_HOME"
rm "$WATARI_HOME/gradle/gradle.zip"

# Fetch SDK Tools
echo -e "${YELLOW}[*] Fetching Official Android SDK CLI Tools...${RESET}"
wget --show-progress -q -O "$WATARI_HOME/cmdline-tools.zip" "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
unzip -q "$WATARI_HOME/cmdline-tools.zip" -d "$ANDROID_HOME/cmdline-tools/"
mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
rm "$WATARI_HOME/cmdline-tools.zip"

# Install SDK Packages
echo -e "${YELLOW}[*] Installing Android Platforms & Build Tools...${RESET}"
set +e 
yes | $CMDLINE_TOOLS/sdkmanager --licenses > /dev/null 2>&1
set -e
$CMDLINE_TOOLS/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# AAPT2 ARM64 Patch (Fixed for Termux compatibility)
AAPT2_TEMP="$WATARI_HOME/tmp_aapt2"
mkdir -p "$AAPT2_TEMP"
wget -q -O "$AAPT2_TEMP/tools.zip" https://github.com/lzhiyong/android-sdk-tools/releases/download/35.0.2/android-sdk-tools-static-aarch64.zip
unzip -q "$AAPT2_TEMP/tools.zip" -d "$AAPT2_TEMP"
find "$AAPT2_TEMP" -type f -name "aapt2" -exec cp {} "$WATARI_BIN/aapt2" \;
chmod +x "$WATARI_BIN/aapt2"
rm -rf "$AAPT2_TEMP"

# Fetch Secure CLI Tools (Replaced plain-text generation)
echo -e "${YELLOW}[*] Fetching Secure Watari Executables...${RESET}"
wget --show-progress -q -O "$WATARI_HOME/tools.tar.gz" "https://raw.githubusercontent.com/mikey-7x/Watari-ARM64-Studio/refs/heads/main/watari-pro-binaries.tar.gz"
tar -xzf "$WATARI_HOME/tools.tar.gz" -C "$WATARI_BIN/"
chmod +x "$WATARI_BIN/watari" "$WATARI_BIN/watari-init" "$WATARI_BIN/watari-build"
rm "$WATARI_HOME/tools.tar.gz"

# Safely inject paths into bashrc/zshrc
for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
    touch "$rc_file" # Creates the file if it doesn't exist
    if ! grep -q "watari_forge/bin" "$rc_file"; then
        echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$rc_file"
        echo "export ANDROID_HOME=\"$ANDROID_HOME\"" >> "$rc_file"
        echo 'export PATH="$ANDROID_HOME/platform-tools:$HOME/.watari_forge/gradle/latest/bin:$HOME/.watari_forge/bin:$PATH"' >> "$rc_file"
    fi
done

echo -e "${GREEN}[✔] WATARI PRO ENGINE INSTALLED (by mikey-7x)${RESET}"
echo -e "Run: ${CYAN}source ~/.bashrc${RESET} then type ${YELLOW}watari${RESET}"
