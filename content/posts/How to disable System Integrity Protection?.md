---
tags:
  - Mac
title: How to disable System Integrity Protection?
date: 2023-05-23
categories: 
zkcode: "202504281659"
---



1. Turn off your device
2. **Intel [(apple docs)](https://support.apple.com/en-gb/guide/mac-help/mchl338cf9a8/12.0/mac/12.0):**  
    Hold down command ⌘R while booting your device.
    
    **Apple Silicon [(apple docs)](https://support.apple.com/en-gb/guide/mac-help/mchl82829c17/12.0/mac/12.0):**  
    Press and hold the power button on your Mac until “Loading startup options” appears.  
    Click Options, then click Continue.
3. In the menu bar, choose `Utilities`, then `Terminal`
4. If you're on Apple Silicon macOS 13.x.x. Requires Filesystem Protections, Debugging Restrictions and NVRAM Protection to be disabled (printed warning can be safely ignored)

```bash
csrutil enable --without fs --without debug --without nvram
```

5. Reboot
6. For Apple Silicon; enable non-Apple-signed arm64e binaries

```bash
# Open a terminal and run the below command, then reboot
sudo nvram boot-args=-arm64e_preview_abi
```

7.  You can verify that System Integrity Protection is turned off by running `csrutil status`, which returns `System Integrity Protection status: disabled.` if it is turned off (it may show `unknown` for newer versions of macOS when disabling SIP partially).

If you ever want to re–enable System Integrity Protection after uninstalling yabai; repeat the steps above, but run `csrutil enable` instead at step 4.

Please note that System Integrity Protection will be re–enabled during device repairs or analysis at any Apple Retail Store or Apple Authorized Service Provider. You will have to repeat this step after getting your device back.

---
## Reference
[https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
