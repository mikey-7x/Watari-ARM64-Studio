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
    pkg update -y && pkg install -y openjdk-17 wget curl unzip zip git tree
else
    SUDO=""
    [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1 && SUDO="sudo"
    if command -v apt-get >/dev/null 2>&1; then
        $SUDO apt-get update -y && $SUDO apt-get install -y openjdk-17-jdk wget curl unzip zip git tree
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

# AAPT2 ARM64 Patch
AAPT2_TEMP="/tmp/watari_aapt2"
mkdir -p "$AAPT2_TEMP"
wget -q -O "$AAPT2_TEMP/tools.zip" https://github.com/lzhiyong/android-sdk-tools/releases/download/35.0.2/android-sdk-tools-static-aarch64.zip
unzip -q "$AAPT2_TEMP/tools.zip" -d "$AAPT2_TEMP"
find "$AAPT2_TEMP" -type f -name "aapt2" -exec cp {} "$WATARI_BIN/aapt2" \;
chmod +x "$WATARI_BIN/aapt2"
rm -rf "$AAPT2_TEMP"

# Generate CLI Tools
echo -e "${YELLOW}[*] Generating Watari Executables...${RESET}"

cat << 'EOF' > "$WATARI_BIN/watari"
#!/bin/bash
echo -e "\e[1;36m=========================================\e[0m"
echo -e "\e[1;36m      WATARI PRO ENGINE (by mikey-7x)    \e[0m"
echo -e "\e[1;36m=========================================\e[0m"
echo -e "\e[1;33mCommands:\e[0m"
echo -e "  \e[1;32mwatari-init <Name>\e[0m : Scaffold Android/Desktop project with Play Store Keys."
echo -e "  \e[1;32mwatari-build\e[0m       : Compile Debug APK."
echo -e "  \e[1;32mwatari-build --release\e[0m : Compile & Sign Release APK for Play Store."
echo -e "  \e[1;32mwatari-build --desktop\e[0m : Compile cross-platform Desktop App (Windows/Mac/Linux)."
echo -e "\e[1;36m=========================================\e[0m"
EOF

cat << 'EOF' > "$WATARI_BIN/watari-init"
#!/bin/bash
set -e
export WATARI_HOME="$HOME/.watari_forge"
export ANDROID_HOME="$WATARI_HOME/android_sdk"
export WATARI_BIN="$WATARI_HOME/bin"
export GRADLE_BIN="$WATARI_HOME/gradle/latest/bin/gradle"

if [ -z "$1" ]; then echo -e "\e[1;31mUsage: watari-init <ProjectName>\e[0m"; exit 1; fi
PROJECT_NAME="$1"
PROJECT_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')
PACKAGE_NAME="com.watari.$PROJECT_LOWER"
PKG_PATH="src/main/java/com/watari/$PROJECT_LOWER"

echo -e "\e[1;34m[*] Scaffolding Watari Project: $PROJECT_NAME...\e[0m"
mkdir -p "$PROJECT_NAME/app/$PKG_PATH" "$PROJECT_NAME/app/src/main/res/layout"
cd "$PROJECT_NAME"

echo -e "\e[1;33m[*] Generating Official Play Store RSA Keystore...\e[0m"
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias watari_alias -dname "CN=Watari Developer, OU=Watari Studio, O=mikey-7x, C=US" -storepass "watari123" -keypass "watari123" > /dev/null 2>&1

cat << INNER_EOF > local.properties
sdk.dir=$ANDROID_HOME
INNER_EOF

cat << INNER_EOF > gradle.properties
android.useAndroidX=true
android.aapt2FromMavenOverride=$WATARI_BIN/aapt2
INNER_EOF

cat << 'INNER_EOF' > settings.gradle.kts
pluginManagement { repositories { google(); mavenCentral(); gradlePluginPortal() } }
dependencyResolutionManagement { repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS); repositories { google(); mavenCentral() } }
rootProject.name = "WatariApp"
include(":app")
INNER_EOF

cat << 'INNER_EOF' > build.gradle.kts
plugins { id("com.android.application") version "8.1.0" apply false; id("org.jetbrains.kotlin.android") version "1.8.0" apply false }
INNER_EOF

cat << INNER_EOF2 > app/build.gradle.kts
plugins { id("com.android.application"); id("org.jetbrains.kotlin.android") }
android {
    namespace = "$PACKAGE_NAME"
    compileSdk = 34
    defaultConfig { applicationId = "$PACKAGE_NAME"; minSdk = 26; targetSdk = 34; versionCode = 1; versionName = "1.0" }
    signingConfigs {
        create("release") {
            storeFile = file("../release.jks")
            storePassword = "watari123"
            keyAlias = "watari_alias"
            keyPassword = "watari123"
        }
    }
    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
    }
    compileOptions { sourceCompatibility = JavaVersion.VERSION_1_8; targetCompatibility = JavaVersion.VERSION_1_8 }
    kotlinOptions { jvmTarget = "1.8" }
}
dependencies { implementation("androidx.core:core-ktx:1.10.1"); implementation("androidx.appcompat:appcompat:1.6.1"); implementation("androidx.constraintlayout:constraintlayout:2.1.4") }
INNER_EOF2

cat << INNER_EOF2 > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:label="$PROJECT_NAME" android:theme="@style/Theme.AppCompat.Light.NoActionBar">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter><action android:name="android.intent.action.MAIN" /><category android:name="android.intent.category.LAUNCHER" /></intent-filter>
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
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android" android:layout_width="match_parent" android:layout_height="match_parent" />
INNER_EOF

"$GRADLE_BIN" wrapper --gradle-version 8.7 > /dev/null 2>&1 || true
echo -e "\e[1;32m[✔] Workspace '$PROJECT_NAME' forged and ready!\e[0m"
EOF

cat << 'EOF' > "$WATARI_BIN/watari-build"
#!/bin/bash
set -e
if [ ! -f "settings.gradle.kts" ]; then echo -e "\e[1;31m[!] Error: Not a valid Watari project.\e[0m"; exit 1; fi
chmod +x gradlew

if [ "$1" == "--release" ]; then
    echo -e "\e[1;33m[*] Forging Play Store Release APK...\e[0m"
    ./gradlew assembleRelease --console=plain
    APK_PATH=$(find app/build/outputs/apk/release -name "*-release.apk" | head -n 1)
elif [ "$1" == "--desktop" ]; then
    echo -e "\e[1;33m[*] Forging Universal Desktop App (Windows/Mac/Linux)...\e[0m"
    echo -e "\e[1;36mNote: Desktop compilation requires Kotlin Multiplatform Compose plugin. Generating standard JVM Jar...\e[0m"
    ./gradlew assemble --console=plain
    APK_PATH=$(find app/build/outputs -name "*.jar" | head -n 1)
else
    echo -e "\e[1;34m[*] Forging Debug APK...\e[0m"
    ./gradlew assembleDebug --console=plain
    APK_PATH=$(find app/build/outputs/apk/debug -name "*.apk" | head -n 1)
fi

if [ -n "$APK_PATH" ]; then
    mkdir -p build/
    cp "$APK_PATH" build/
    echo -e "\e[1;32m[✔] BUILD SUCCESSFUL! Output saved to: build/\e[0m"
else
    echo -e "\e[1;31m[!] Build failed.\e[0m"
fi
EOF

chmod +x "$WATARI_BIN/watari" "$WATARI_BIN/watari-init" "$WATARI_BIN/watari-build"

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
