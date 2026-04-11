#!/bin/bash
# ==============================================================================
# Script: Watari Native Forge PRO v3.0 - Universal Master Installer
# Repository: https://github.com/mikey-7x/Watari-ARM64-Studio
# Description: All-in-one automated deployment for offline Kotlin/Gradle 
#              Android app compilation on Linux ARM64 (Termux/Ubuntu PRoot).
# ==============================================================================
set -e

GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
CYAN="\e[1;36m"
RESET="\e[0m"

echo -e "${BLUE}======================================================${RESET}"
echo -e "${CYAN}   INITIALIZING WATARI PRO FORGE (KOTLIN/GRADLE)      ${RESET}"
echo -e "${BLUE}======================================================${RESET}"

# 1. Architecture Check
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
    echo -e "${RED}[!] WARNING: System architecture detected as '$ARCH'. Expected ARM64.${RESET}"
    sleep 3
fi

# 2. Dependency Installation
SUDO=""
[ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1 && SUDO="sudo"

echo -e "${YELLOW}[*] Step 1: Installing System Dependencies...${RESET}"
if [ -f "/etc/os-release" ] && grep -qi "ubuntu\|debian" /etc/os-release; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y openjdk-17-jdk wget curl unzip zip git tree gradle
else
    echo -e "${RED}[!] This script is optimized for Ubuntu/Debian PRoot. Please ensure Java 17 and Gradle are installed.${RESET}"
fi

# 3. Setup Directories
export WATARI_HOME="$HOME/.watari_forge"
export ANDROID_HOME="$WATARI_HOME/android_sdk"
export CMDLINE_TOOLS="$ANDROID_HOME/cmdline-tools/latest/bin"
export WATARI_BIN="$WATARI_HOME/bin"

echo -e "${YELLOW}[*] Step 2: Generating Directory Structure...${RESET}"
rm -rf "$WATARI_HOME"
mkdir -p "$ANDROID_HOME/cmdline-tools"
mkdir -p "$WATARI_BIN"

# 4. Download SDK Command Line Tools
SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
ZIP_FILE="cmdline-tools.zip"

echo -e "${YELLOW}[*] Step 3: Fetching Official Android SDK CLI Tools...${RESET}"
wget --show-progress -O "$ZIP_FILE" "$SDK_URL"
unzip -q "$ZIP_FILE" -d "$ANDROID_HOME/cmdline-tools/"
mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
rm "$ZIP_FILE"

# 5. Install SDK Packages
echo -e "${YELLOW}[*] Step 4: Installing Android Platforms & Build Tools...${RESET}"
yes | $CMDLINE_TOOLS/sdkmanager --licenses > /dev/null 2>&1
$CMDLINE_TOOLS/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 6. Generate Watari CLI Tools
echo -e "${YELLOW}[*] Step 5: Generating Watari Executables...${RESET}"

# ---> GENERATE: watari (Main Menu)
cat << 'EOF' > "$WATARI_BIN/watari"
#!/bin/bash
echo -e "\e[1;36m=========================================\e[0m"
echo -e "\e[1;36m         WATARI PRO CLI ENGINE           \e[0m"
echo -e "\e[1;36m=========================================\e[0m"
echo -e "\e[1;33mCommands:\e[0m"
echo -e "  \e[1;32mwatari-init <ProjectName>\e[0m : Scaffold a new Kotlin/Gradle project."
echo -e "  \e[1;32mwatari-build\e[0m              : Compile project to APK (Requires internet first time)."
echo -e "  \e[1;32mwatari-build --offline\e[0m    : Compile project using cached offline dependencies."
echo -e "\e[1;36m=========================================\e[0m"
EOF

# ---> GENERATE: watari-init (Project Scaffolder)
cat << 'EOF' > "$WATARI_BIN/watari-init"
#!/bin/bash
set -e
if [ -z "$1" ]; then
    echo -e "\e[1;31mUsage: watari-init <ProjectName>\e[0m"
    exit 1
fi
PROJECT_NAME="$1"
PROJECT_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')
PACKAGE_NAME="com.watari.$PROJECT_LOWER"
PKG_PATH="src/main/java/com/watari/$PROJECT_LOWER"

echo -e "\e[1;34m[*] Scaffolding Watari Gradle/Kotlin Project: $PROJECT_NAME...\e[0m"
mkdir -p "$PROJECT_NAME/app/$PKG_PATH"
mkdir -p "$PROJECT_NAME/app/src/main/res/layout"
mkdir -p "$PROJECT_NAME/app/src/main/res/values"
cd "$PROJECT_NAME"

# Core Gradle Configuration Files
cat << INNER_EOF > local.properties
sdk.dir=$ANDROID_HOME
INNER_EOF

cat << 'INNER_EOF' > gradle.properties
android.useAndroidX=true
android.enableJetifier=true
android.suppressUnsupportedCompileSdk=34
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
INNER_EOF

cat << 'INNER_EOF' > settings.gradle.kts
pluginManagement {
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories { google(); mavenCentral() }
}
rootProject.name = "WatariApp"
include(":app")
INNER_EOF

cat << 'INNER_EOF' > build.gradle.kts
plugins {
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.0" apply false
}
INNER_EOF

cat << INNER_EOF2 > app/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}
android {
    namespace = "$PACKAGE_NAME"
    compileSdk = 34
    defaultConfig {
        applicationId = "$PACKAGE_NAME"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
}
dependencies {
    implementation("androidx.core:core-ktx:1.10.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.9.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
}
INNER_EOF2

# Android Source Files
cat << INNER_EOF2 > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:allowBackup="true"
        android:label="$PROJECT_NAME"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat.Light.NoActionBar">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
INNER_EOF2

cat << INNER_EOF2 > app/$PKG_PATH/MainActivity.kt
package $PACKAGE_NAME

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
INNER_EOF2

cat << 'INNER_EOF' > app/src/main/res/layout/activity_main.xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout 
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
</androidx.constraintlayout.widget.ConstraintLayout>
INNER_EOF

echo -e "\e[1;33m[*] Initializing Local Gradle Wrapper...\e[0m"
gradle wrapper --gradle-version 8.0 > /dev/null 2>&1 || true

echo -e "\e[1;32m[✔] Workspace '$PROJECT_NAME' forged and ready!\e[0m"
echo -e "\e[1;36m    -> cd $PROJECT_NAME\e[0m"
echo -e "\e[1;36m    -> watari-build\e[0m"
EOF

# ---> GENERATE: watari-build (The Compiler Engine)
cat << 'EOF' > "$WATARI_BIN/watari-build"
#!/bin/bash
set -e
if [ ! -f "settings.gradle.kts" ]; then
    echo -e "\e[1;31m[!] Error: Not a valid Watari/Gradle project root.\e[0m"
    exit 1
fi

echo -e "\e[1;34m[*] Engaging Watari Professional Gradle Engine...\e[0m"
chmod +x gradlew

if [ "$1" == "--offline" ]; then
    echo -e "\e[1;33m[*] Running in STRICT OFFLINE mode...\e[0m"
    ./gradlew assembleDebug --offline --console=plain
else
    ./gradlew assembleDebug --console=plain
fi

APK_PATH=$(find app/build/outputs/apk/debug -name "*.apk" | head -n 1)

if [ -n "$APK_PATH" ]; then
    mkdir -p build/
    cp "$APK_PATH" build/app-debug.apk
    echo -e "\e[1;32m==================================================\e[0m"
    echo -e "\e[1;32m[✔] APP FORGED! Location: build/app-debug.apk\e[0m"
    echo -e "\e[1;32m==================================================\e[0m"
else
    echo -e "\e[1;31m[!] Build failed or APK not found.\e[0m"
fi
EOF

# 7. Set executable permissions
chmod +x "$WATARI_BIN/watari"
chmod +x "$WATARI_BIN/watari-init"
chmod +x "$WATARI_BIN/watari-build"

# 8. Inject Path
echo -e "${YELLOW}[*] Step 6: Injecting Environment Variables...${RESET}"
for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc_file" ] || [ "$rc_file" == "$HOME/.bashrc" ]; then
        if ! grep -q "watari_forge/bin" "$rc_file"; then
            echo "" >> "$rc_file"
            echo "# Watari Pro Forge Environment" >> "$rc_file"
            echo "export ANDROID_HOME=\"$ANDROID_HOME\"" >> "$rc_file"
            echo 'export PATH="$ANDROID_HOME/platform-tools:$HOME/.watari_forge/bin:$PATH"' >> "$rc_file"
        fi
    fi
done

echo -e "${GREEN}======================================================================${RESET}"
echo -e "${GREEN}                 [✔] WATARI PRO FORGE INSTALLED                       ${RESET}"
echo -e "${GREEN}======================================================================${RESET}"
echo -e "1. Reload your terminal to apply changes: ${CYAN}source ~/.bashrc${RESET}"
echo -e "2. Type ${YELLOW}watari${RESET} to view the command menu."
echo -e "3. Generate your first project: ${YELLOW}watari-init MyFirstApp${RESET}"
echo -e "${GREEN}======================================================================${RESET}"

