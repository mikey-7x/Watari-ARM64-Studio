# Watari-ARM64-Studio

# 🛠️[1]Watari Legacy Engine (Python / Buildozer)

**Version:** v1.0.0 (Legacy)

**Architecture:** ARM64 / aarch64

**Framework:** Python 3, Kivy, Buildozer, Python-for-Android (p4a)

The **Watari Legacy Engine** is an automated, offline Buildozer cross-compilation toolchain. It is uniquely engineered to run natively on ARM64 processors (such as the OnePlus 13R or ARM-based Linux boards) bypassing the traditional requirement for an Intel/AMD x86_64 PC.
​This method uses the watari_legacy.sh script to automatically fetch the custom .tar.xz payload, resolve all Ubuntu dependencies, patch the PRoot OS blindspots, and establish a ready-to-use virtual studio.

### ✨ Features
 * **Bypasses x86 PC Requirements:** Compiles Python code to Android .apk directly on an Android smartphone or ARM64 Linux board.
 * **Pre-Compiled Offline Wheelhouse:** Contains custom .whl files for instant dependency resolution without breaking on modern Python versions.
 * **Custom Omni-Symlinks:** Automatically routes hardcoded x86 paths to the native aarch64 compilers.
 * **Hardware-Ready:** Perfect for Python-based hardware telemetry apps (e.g., PySerial ESP32 interfaces, OpenCV camera modules).

## 📦Installation & Configuration
To deploy the Legacy Engine on your Ubuntu/Debian environment, download and execute the automated setup script directly from this repository:

**Step 1: Download the Installer**
```bash
wget -O watari_legacy.sh https://raw.githubusercontent.com/mikey-7x/Watari-ARM64-Studio/main/watari_legacy.sh

```
*(Note: If your script is on a different branch, replace main with your branch name).*
**Step 2: Grant Execution Rights & Run**
```bash
chmod +x watari_legacy.sh
./watari_legacy.sh

```
**Step 3: Reload Your Terminal**
Once the installation finishes, reload your environment variables to activate the custom studio commands:
```bash
source ~/.bashrc

```
## ⚙️Creating Your First Application
The Watari Studio operates in an isolated virtual environment. Follow this practical example to initialize the studio and compile a clean, minimalist UI.

### Step 1: Initialize the Studio
Launch the environment by typing:
```bash
watari

```
This command automatically creates your ~/watari_project directory, activates the Python virtual environment, and injects the perfected buildozer.spec configuration file.

### Step 2: Write the Application Logic
Inside your watari_project folder, create a file named main.py and paste the following Kivy code. This generates a clean, highly visible white-themed interface for practical hardware telemetry or testing.
```python
# main.py
from kivy.app import App
from kivy.uix.label import Label
from kivy.core.window import Window
from kivy.utils import get_color_from_hex

class WatariLegacyApp(App):
    def build(self):
        # Clean, high-contrast white interface 
        Window.clearcolor = get_color_from_hex("#FFFFFF")
        
        return Label(
            text="[b]WATARI LEGACY ENGINE[/b]\n\nSystem Online.\nARM64 Compiler Active.",
            markup=True,
            color=get_color_from_hex("#000000"), # Black text for high visibility
            font_size='22sp',
            halign="center"
        )

if __name__ == '__main__':
    WatariLegacyApp().run()

```
### Step 3: Configure the Build
Ensure your project is configured to use Kivy. Run this quick command to verify the requirements in your buildozer.spec:
```bash
sed -i 's/^requirements = .*/requirements = python3,kivy/' buildozer.spec

```
### Step 4: Forge the APK
Command the engine to compile your Python bytecode into an Android Dalvik executable:
```bash
yes | watari-build

```
> ### ⚠️ **CRITICAL NOTIFICATION: FIRST BUILD DURATION**
> The **very first time** you run watari-build, the compilation process will take **30 to 45+ minutes**.
> Buildozer must unpack the massive Android NDK, compile the core Python headers in C++, and build the machine code for the Android APK from scratch. **Do not close your terminal.** Once this initial baseline is cached, all subsequent builds will complete in just a few minutes.
> 
### Step 5: Locate the Executable
Once the terminal displays # Android packaging done!, your finished application will be located in the ~/watari_project/bin/ directory. Transfer the generated .apk to your file manager and install it on your device.

# 🚀[2]Watari Studio (Native ARM64 Android Forge)

**Watari** is a self-contained, pure Java compilation environment designed to forge Android applications natively on ARM64 processors (Termux, Linux PRoot environments, Raspberry Pi, Mac M-Series). It bypasses the need for an Intel/AMD x86 PC or Android Studio IDE.

---

## ⚠️ The v2.0.0 Paradigm Shift
Watari has evolved. The legacy `v1.0.0` utilized a massive Python/Buildozer wrapper, which resulted in 20-minute compile times, bloated APKs, and frequent C-compiler crashes on mobile Linux environments.

**Watari v2.0.0 is a complete architectural rewrite.** We have built a **Pure Native Engine**. It executes raw Java and interfaces directly with Google's Android SDK command-line tools.
* **Speed:** Compiles full Android applications in **under 5 seconds**.
* **Size:** Generates highly optimized, native-sized APKs.
* **Architecture:** Injects custom-compiled ARM64 `aapt2` and `zipalign` binaries directly into the pipeline to bypass Google's x86 restrictions.

---

## ✨ Cutting-Edge Features

* **Android 15 & OxygenOS 16 Ready:** Watari strictly targets `API 34`. It enforces **Page Alignment (`-p`)** and **V2 Cryptographic Signatures**, guaranteeing that modern Android systems will not flag your app as an "Incompatible Device" installation.
* **Universal Linux Deployment:** The installer dynamically detects your environment and package manager (`pacman`, `apt`, `dnf`, `zypper`, `apk`, `pkg`) and installs the exact JDK dependencies required.
* **Smart Shortcuts:** No more navigating through massive `src/main/java/com/...` directories. Watari generates a `watari.java` file and a `watari-manifest.xml` right in your root folder. The compiler automatically maps, routes, and injects them into the backend during the build phase.
* **Vector Logo Forging:** Automatically generates sleek XML Vector Graphics for app icons natively.

---

## 📦 1-Step Installation

Do not extract the tarball manually. Simply run the universal installer script in your Linux environment:

```bash
wget https://raw.githubusercontent.com/mikey-7x/Watari-ARM64-Studio/refs/heads/main/watari.sh
chmod +x watari.sh
./watari.sh
```
*Restart your terminal or run source ~/.bashrc after installation.*
## 🛠️ The Watari Command Suite
Once installed, Watari operates entirely as global terminal commands:
| Command | Description |
|---|---|
| watari | Displays the help menu and command suite list. |
| watari-init <Name> | Scaffolds a complete, clean Android project structure. |
| watari-build | Compiles the active folder into a signed, aligned APK. |
| watari-export | Copies the forged APK directly to /storage/emulated/0/Documents/. |
| watari-clean current | Wipes the active build cache (solves ghost bugs). |
| watari-clean <Name> | Factory resets and permanently eradicates an old project. |
## ⚡ Quick Start: Forging an App
 1. **Initialize the Project:**
   ```bash
   watari-init MyFirstApp
   cd MyFirstApp
   
   ```
 2. **Write your Logic:**
   Open the watari.java file. Delete the placeholder and drop in your raw Android Java code. (The package headers are handled automatically by the Forge).
 3. **Declare Hardware Permissions:**
   Open watari-manifest.xml to add any specific hardware permissions (BLUETOOTH_CONNECT, CAMERA, etc.).
 4. **Compile and Export:**
   ```bash
   watari-build
   watari-export
   
   ```
   *Your newly forged APK is now waiting in your phone's Documents folder!*
## ⚙️ Under The Hood (The Compilation Pipeline)
When you trigger watari-build, the script seamlessly executes the Google Android pipeline natively on your ARM64 silicon:
 1. **aapt2 (Resource Compiler):** Links XML permissions and layout overlays.
 2. **javac (Java Compiler):** Compiles your raw Java against android.jar.
 3. **d8 (Dalvik Executable):** Desugars and translates Java bytecode into heavily optimized classes.dex machine code.
 4. **zipalign:** Modifies byte offsets to exactly 4-byte boundaries (and Page Aligns) for instant RAM reads on mobile.
 5. **apksigner:** Cryptographically seals the package with an RSA Keystore.

---
# ⚡[3]Watari ARM64 Studio (Pro v3.0)

Watari Pro is the ultimate command-line Android compilation engine designed specifically for Linux ARM64 environments (like Termux and Ubuntu PRoot). It strips away the heavy GUI overhead of Android Studio while retaining the full power of the official Android Gradle Plugin (AGP) and Kotlin.

Build complex, industry-level Android applications entirely from the terminal. 

## Features
* **Zero IDE Overhead:** Compile heavy Kotlin apps on mobile devices and SBCs without needing a desktop environment.
* **Full Kotlin & AndroidX Support:** Natively scaffolds modern Android project architectures out-of-the-box.
* **Auto-Configuration:** Handles `local.properties` SDK routing, JVM target alignments, and Android SDK licensing automatically.
* **Strict Offline Mode:** Once dependencies are cached, you can compile applications entirely offline without an internet connection.

## Installation 

To install the Watari Pro engine and the official Android Command-Line Tools, run the master installer in your Ubuntu/Debian terminal:

```bash
wget https://raw.githubusercontent.com/mikey-7x/Watari-ARM64-Studio/refs/heads/main/watari_pro_v3.sh
chmod +x watari_pro_v3.sh
./watari_pro_v3.ah
source ~/.bashrc
```

CLI Commands

​Watari integrates directly into your bash path, providing three core commands:

​watari

​Displays the master menu and command reference.

​watari-init <ProjectName>

​Scaffolds a completely blank, correctly configured modern Kotlin/Gradle project in the current directory.

```
watari-init SmartHomeApp
cd SmartHomeApp
```
watari-build

​Engages the Gradle daemon to compile your project. The first run requires an internet connection to download and cache external dependencies (like AndroidX or Firebase libraries).
```
watari-build
```
Compiled APKs are automatically routed to build/app-debug.apk.


watari-build --offline

​Forces the Gradle daemon to execute without pinging remote repositories, using only your locally cached toolchains and dependencies.

# Architecture Notes

​Watari Pro v3.0 establishes the environment in 
~/.watari_forge/.

​SDK Path: ~/.watari_forge/android_sdk

​Binaries: ~/.watari_forge/bin

---

## 🚀 Quick Start Example: Building Your First App

Here is a complete start-to-finish example of how to forge an interactive Android app using Watari Pro, right from your terminal.

Step 1: Scaffold the Project

Create a new project workspace. Watari will automatically generate the Gradle configuration, Manifest, and Kotlin architecture.

```bash
watari-init HelloWatari
cd HelloWatari

```
Step 2: Edit the UI Layout

Open the layout file using your preferred terminal editor (like nano or vim).
```bash
nano app/src/main/res/layout/activity_main.xml

```
Paste in a simple layout with a TextView and a Button:
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="[http://schemas.android.com/apk/res/android](http://schemas.android.com/apk/res/android)"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center"
    android:background="#121212">

    <TextView
        android:id="@+id/tvGreeting"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="System Standby"
        android:textColor="#00E5FF"
        android:textSize="24sp"
        android:textStyle="bold"
        android:layout_marginBottom="24dp"/>

    <Button
        android:id="@+id/btnEngage"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Engage Watari"
        android:backgroundTint="#00E5FF"
        android:textColor="#000000"/>
</LinearLayout>

```
*(Save and exit)*

Step 3: Add the Kotlin Logic

Next, open the main Kotlin file to add interactive logic to the button.
```bash
nano app/src/main/java/com/watari/hellowatari/MainActivity.kt

```
Paste this Kotlin code:
```kotlin
package com.watari.hellowatari

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val tvGreeting = findViewById<TextView>(R.id.tvGreeting)
        val btnEngage = findViewById<Button>(R.id.btnEngage)

        btnEngage.setOnClickListener {
            tvGreeting.text = "Watari Engine Online! ⚡"
        }
    }
}

```
*(Save and exit)*

Step 4: Forge the APK!

Trigger the compilation engine. If this is your first build, Gradle will download the required AndroidX libraries.
```bash
watari-build
```
or
```
~/.<name_of_project>/bin/watari-build
```

Step 5: Install

Once the terminal outputs [✔] APP FORGED!, your compiled application is ready. You can move it to your device's main storage to install it:
```bash
cp build/app-debug.apk /storage/emulated/0/Download/HelloWatari.apk
```
Navigate to your Downloads folder, tap the APK, and test your new app!

---

## 👨‍💻 Author & Authority

**Watari-ARM64-Studio** is independently designed, developed, and maintained by **Mikey** ([@mikey-7x](https://github.com/mikey-7x)). 

All core scripts, build architectures, and custom CLI compilation engines within this repository are the intellectual property of the author. 

## ⚖️ License & Usage Terms

This project is protected under a strict **Source-Available / Non-Commercial License**. 

By accessing, downloading, or modifying this repository, you legally agree to the following conditions:

* **✅ Permitted (Personal & Educational Use):** You are free to download, modify, and use this engine for personal development, educational learning, and internal non-profit projects.

* **✅ Required (Attribution):** Any public showcase, fork, or non-commercial redistribution of this tool (or modified versions of it) must clearly credit **Mikey (mikey-7x)** and link back to this original repository.
* **❌ Strictly Prohibited (No Commercial Use):** You may **NOT** use this software, its source code, or its compiled binaries for any commercial purpose, monetary gain, or profit-generating activity. This includes, but is not limited to: selling the software, integrating it into a commercial product, or offering its capabilities as a paid service.

### 💼 Commercial Permissions

If you are a business, enterprise, or individual wishing to utilize Watari-ARM64-Studio for profit-generating or commercial purposes, you are legally required to obtain explicit, written permission and a separate commercial license from the author prior to any use.

To negotiate a commercial license, please reach out directly to **@mikey-7x** by opening a dedicated issue or discussion thread in this repository.

---
