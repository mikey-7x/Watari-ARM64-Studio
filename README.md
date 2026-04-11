# Watari-ARM64-Studio
Watari-ARM64-Studio






# 🚀[2] Watari Studio (Native ARM64 Android Forge)

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
