![watari poster](watari.png)

# 🛠️ Watari ARM64 Studio
**The Ultimate Mobile Development Forge | Native ARM64 Cross-Compilation Studio**
*Developed and Maintained by [Mikey (@mikey-7x)](https://github.com/mikey-7x)*

Watari is a suite of highly advanced, self-contained compilation environments designed to forge Android and Desktop applications natively on ARM64 processors (Termux, Linux PRoot, Raspberry Pi, Mac M-Series). It completely bypasses the need for an Intel/AMD x86 PC or heavy IDEs like Android Studio.

---

## 🚀 [1] Watari Native Forge (Pure Java Engine)

**Watari Native Forge** executes raw Java and interfaces directly with Google's Android SDK command-line tools natively on ARM64 silicon.

* **Speed:** Compiles full Android applications in **under 5 seconds**.
* **Size:** Generates highly optimized, native-sized APKs.
* **Play Store Ready:** Automatically generates cryptographic Release Keystores.
* **Universal Linux Deployment:** Dynamically detects your environment (`pacman`, `apt`, `dnf`, `zypper`, `apk`, `pkg`) and installs exact dependencies.

📦 1-Step Installation
```bash
wget https://raw.githubusercontent.com/mikey-7x/Watari-ARM64-Studio/refs/heads/main/watari.sh
chmod +x watari.sh
./watari.sh
source ~/.bashrc
```
--- 

##⚡ [2] Watari PRO Engine (Kotlin/Gradle Multiplatform)

Watari PRO is the ultimate command-line compilation engine. It strips away the
heavy GUI overhead of Android Studio while retaining the full power of the
official Android Gradle Plugin (AGP) and Kotlin.

  - Zero IDE Overhead: Compile heavy Kotlin apps on mobile devices and SBCs.
  - Multi-Distro Standalone Gradle: Embeds a portable Gradle 8.7 engine,
    guaranteeing it works on Arch Linux, Termux, Fedora, and Ubuntu without
    repository conflicts.
  - Cross-Platform Ready: Scaffolds projects capable of compiling Android APKs
    and Universal Desktop Apps (Windows/macOS/Linux) via Kotlin JVM.
  - Official Licensing: Automatically generates 2048-bit RSA Keystores for
    official Google Play Store distribution.

📦 1-Step Installation
```
wget https://raw.githubusercontent.com/mikey-7x/Watari-ARM64-Studio/refs/heads/main/watari_pro.sh
chmod +x watari_pro.sh
./watari_pro.sh
source ~/.bashrc
```

🛠️ The Watari PRO Command Suite

| Command                  | Description                                             |
| ------------------------ | ------------------------------------------------------- |
| `watari`                 | Displays the master menu and command reference.         |
| `watari-init <Name>`     | Scaffolds a modern Kotlin project with Play Store Keys. |
| `watari-build`           | Compiles a Debug APK.                                   |
| `watari-build --release` | Compiles and cryptographically signs a Release APK.     |
| `watari-build --desktop` | Compiles a cross-platform Desktop application.          |

---

⚖️ WATARI PROPRIETARY NON-COMMERCIAL LICENSE

Copyright © 2024 Mikey (@mikey-7x). All Rights Reserved.

This software, including all scripts, build architectures, and custom CLI
compilation engines within this repository, is the proprietary intellectual
property of mikey-7x.

By accessing, downloading, or using this software, you legally agree to the
following strict terms:

  - ✅ Permitted (Personal & Educational Use): You may use this engine for
    personal development, educational learning, and internal non-profit
    projects.
  - ✅ Required (Attribution): Any public showcase or non-commercial
    redistribution must clearly credit mikey-7x and link back to this
    repository.
  - ❌ STRICTLY PROHIBITED (NO COMMERCIAL USE): You may NOT use this software,
    its source code, or its compiled binaries for any commercial purpose,
    monetary gain, or profit-generating activity. You may not sell the software,
    integrate it into a commercial product, or offer its capabilities as a paid
    service.
---

💼 Commercial Licensing & Permissions

If you wish to utilize Watari-ARM64-Studio for profit-generating or commercial
purposes, you are legally required to obtain explicit, written permission and a
separate commercial license from the author.

Contact for Commercial Licensing: chauhanyogesh9512@gmail.com


---

🧪 4. Arch Linux (Termux PRoot) Testing Instructions

To test these scripts on your Android phone running Arch Linux via Termux PRoot:

1. Open your Arch Linux PRoot environment.
Ensure you are logged in as `root` or a user with `sudo` privileges.

2. Test Watari PRO Engine
```bash
# 1. Download and run the installer
wget https://raw.githubusercontent.com/mikey-7x/Watari-ARM64-Studio/refs/heads/main/watari_pro.sh
chmod +x watari_pro.sh
./watari_pro.sh
```
3. Reload environment
```
source ~/.bashrc
```
4. Scaffold a test project
```
watari-init ArchTestApp
cd ArchTestApp
```
5. Build a Play Store Ready Release APK
```
watari-build --release
```
6. Verify the output
```
ls -l build/
```
You should see your signed release APK ready for the Play Store!

