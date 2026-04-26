#!/bin/bash
# ==============================================================================
# Script: Watari Studio - Method 1 Auto-Installer
# Description: Fully automated setup for the Legacy Buildozer/Python Engine
# ==============================================================================
set -e

echo -e "\e[1;34m[+] Initializing Watari v1.0.0 Setup...\e[0m"

# 1. Install System Dependencies & C-Compilers
echo -e "\e[1;33m[*] Installing required Linux packages...\e[0m"
apt-get update -y
apt-get install -y wget tar python3 python3-pip python3-venv git unzip zip build-essential openjdk-17-jdk autoconf libtool pkg-config zlib1g-dev libncurses-dev cmake libffi-dev libssl-dev

# Inject Legacy Libraries for Android NDK compatibility
cd /tmp
wget -q http://ports.ubuntu.com/pool/universe/n/ncurses/libtinfo5_6.3-2_arm64.deb
wget -q http://ports.ubuntu.com/pool/universe/n/ncurses/libncurses5_6.3-2_arm64.deb
dpkg -i libtinfo5*.deb libncurses5*.deb 2>/dev/null || true
rm -f libtinfo5*.deb libncurses5*.deb
cd ~

# 2. Download and Extract the Watari Master Payload
echo -e "\e[1;34m[*] Preparing the Watari Core Architecture...\e[0m"
mkdir -p ~/.watari_core
if [ ! -f "watari-arm64-toolchain.tar.xz" ]; then
    echo -e "\e[1;33m[*] Downloading payload from GitHub...\e[0m"
    wget --show-progress -O watari-arm64-toolchain.tar.xz "https://github.com/mikey-7x/Watari-ARM64-Studio/releases/download/v1.0.0/watari-arm64-toolchain.tar.xz"
fi
tar -xf watari-arm64-toolchain.tar.xz -C ~/.watari_core --strip-components=1

# 3. Forge the Architecture Bypasses (Physical Rename & Permissions)
echo -e "\e[1;32m[*] Applying NDK Architecture Bypasses...\e[0m"
NDK_PREBUILT="$HOME/.watari_core/android-ndk-arm64/toolchains/llvm/prebuilt"
if [ -d "$NDK_PREBUILT" ]; then
    cd "$NDK_PREBUILT"
    REAL_DIR=$(ls | grep -v "linux-x86_64" | head -n 1 || true)
    if [ -n "$REAL_DIR" ]; then
        rm -rf linux-x86_64
        mv "$REAL_DIR" linux-x86_64
    fi
    chmod -R 777 linux-x86_64/bin/ 2>/dev/null || true
fi
cd ~

# 4. Patch Python-for-Android OS Blindspots
echo -e "\e[1;32m[*] Patching p4a System Blindspots...\e[0m"
python3 -c "
import os
p4a_ep = os.path.expanduser('~/.watari_core/python-for-android/pythonforandroid/entrypoints.py')
if os.path.exists(p4a_ep):
    with open(p4a_ep, 'r') as f: data = f.read()
    if 'CONFIG_SHELL' not in data:
        injection = \"import os, sys\\nsys.platform = 'linux'\\nos.environ['CONFIG_SHELL'] = '/bin/sh'\\n\"
        for f in [\"sem_clockwait\", \"close_range\", \"getloadavg\", \"fexecve\", \"preadv2\", \"pwritev2\", \"copy_file_range\", \"explicit_bzero\", \"setpwent\", \"getpwent\", \"endpwent\", \"setgrent\", \"getgrent\", \"endgrent\", \"epoll_create1\", \"memfd_create\", \"statx\", \"makedev\", \"getgrouplist\", \"initgroups\"]:
            injection += f\"os.environ['ac_cv_func_{f}'] = 'no'\\n\"
        with open(p4a_ep, 'w') as f: f.write(injection + data)
"

# 5. Create Python Virtual Environment & Install Buildozer
echo -e "\e[1;33m[*] Creating Isolated Python Environment...\e[0m"
rm -rf ~/.watari_env
python3 -m venv ~/.watari_env
~/.watari_env/bin/pip install -q cython requests sh jinja2 toml packaging appdirs colorama setuptools wheel build

if [ -d "$HOME/.watari_core/buildozer_src" ]; then
    ~/.watari_env/bin/pip install -q "$HOME/.watari_core/buildozer_src"
else
    ~/.watari_env/bin/pip install -q buildozer
fi

# 6. Bypass Buildozer Root Warning
~/.watari_env/bin/python -c "
import buildozer.scripts.client as bz_client
path = bz_client.__file__
with open(path, 'r') as f: data = f.read()
data = data.replace('def check_root(self):', 'def check_root(self):\n        return\n    def check_root_old(self):')
with open(path, 'w') as f: f.write(data)
"

# 7. Generate Watari Command Aliases
echo -e "\e[1;34m[*] Injecting Studio Commands...\e[0m"
cat << 'EOF' > ~/.watari_env/watari_aliases.sh
export BUILDOZER_ALLOW_ROOT=1
export BUILDOZER_WARN_ON_ROOT=0

watari() {
    source ~/.watari_env/bin/activate
    mkdir -p ~/watari_project
    cd ~/watari_project
    if [ ! -f "buildozer.spec" ]; then
        buildozer init
        sed -i 's/android.skip_update = False/android.skip_update = True/' buildozer.spec
        sed -i "s|#android.ndk_path = .*|android.ndk_path = $HOME/.watari_core/android-ndk-arm64|" buildozer.spec
        sed -i "s|#p4a.source_dir = .*|p4a.source_dir = $HOME/.watari_core/python-for-android|" buildozer.spec
        echo -e "\033[1;33m[*] Auto-Configured Watari Specifications.\033[0m"
    fi
    echo -e "\033[1;32m[+] Watari Studio Online. Run 'watari-build' to compile.\033[0m"
}

watari-build() {
    yes | buildozer android debug || {
        echo -e "\033[1;33m[!] Injecting SDK Patches...\033[0m"
        cp -rf ~/.watari_core/sdk_tools_patch/build-tools/* ~/.buildozer/android/platform/android-sdk/build-tools/*/ 2>/dev/null || true
        yes | buildozer android debug
    }
}

watari-clean() {
    buildozer android clean
}

watari-exit() {
    deactivate 2>/dev/null || true
    cd ~
    echo -e "\033[1;33m[*] Watari Studio Offline.\033[0m"
}
EOF

if ! grep -q "watari_aliases.sh" ~/.bashrc; then
    echo 'source ~/.watari_env/watari_aliases.sh' >> ~/.bashrc
fi

echo -e "\e[1;32m======================================================================\e[0m"
echo -e "\e[1;32m                 [✔] WATARI v1.0.0 SUCCESSFULLY INSTALLED             \e[0m"
echo -e "\e[1;32m======================================================================\e[0m"
echo -e "To launch the studio, reload your terminal with: source ~/.bashrc"
echo -e "Then simply type: watari"
