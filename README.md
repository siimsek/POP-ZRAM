# POP-ZRAM

[![Module](https://img.shields.io/badge/module-Magisk-00AEEF?logo=magisk&logoColor=white)](https://github.com/topjohnwu/Magisk)
[![Language](https://img.shields.io/badge/language-Shell-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Android](https://img.shields.io/badge/platform-Android-3DDC84?logo=android&logoColor=white)](https://www.android.com/)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)

A Magisk module that reconfigures the device's `zram0` swap area at boot. During installation, choose a **4GB**, **6GB**, or **8GB** ZRAM size with the hardware volume keys.

> [!IMPORTANT]
> ZRAM compresses memory pages in RAM; it does **not** add physical RAM. The benefit and battery impact depend on the device, kernel, Android version, and workload.

## What it does

Android may use ZRAM as compressed swap to keep more background processes resident under memory pressure. POP-ZRAM automates a chosen ZRAM configuration through a Magisk module, rather than requiring manual commands after every reboot.

## Features

- Interactive 4GB, 6GB, or 8GB ZRAM selection during installation.
- Defaults to 4GB if **Volume Down** is selected.
- Reconfigures `zram0` after Android reports boot completion.
- Detects common `zram0` block-device paths before enabling swap.
- Resets the existing ZRAM swap area, applies the selected size, runs `mkswap`, then enables swap.
- Applies the module's included VM tuning values only when the corresponding kernel nodes exist.
- Includes a boot guard that automatically disables the module after an incomplete prior boot attempt.

## Requirements

- An Android device with root access through **Magisk**.
- Magisk **v19.0 or later**. This is the minimum version enforced by the bundled installer.
- A kernel exposing `/sys/block/zram0` and a usable ZRAM block device.
- A recent backup and a tested recovery path.

> [!CAUTION]
> Large ZRAM values are not universally beneficial. Start with 4GB, test normal use and standby drain, then increase only if the device remains stable.

## Installation

1. Download the latest module ZIP from the [Releases page](https://github.com/siimsek/POP-ZRAM/releases), or build a ZIP from this repository.
2. Open the Magisk app and choose **Modules** → **Install from storage**.
3. Select the POP-ZRAM ZIP.
4. Respond to the installer prompts with the hardware volume keys:

| Prompt | Volume Up | Volume Down |
| --- | --- | --- |
| First selection | Open the 6GB / 8GB selection | Select 4GB |
| Second selection | Select 8GB | Select 6GB |

5. Reboot when installation completes.

## Verify ZRAM

After the device has rebooted, run the following in a root-capable terminal:

```sh
su -c cat /proc/swaps
```

A `zram0` entry indicates that the swap device is active. To inspect its configured capacity:

```sh
su -c cat /sys/block/zram0/disksize
```

## Uninstall and recovery

### Normal uninstall

1. Open the Magisk app.
2. Disable or remove **POP-ZRAM** from the module list.
3. Reboot the device.

### If the device fails to boot

The module creates a boot guard before its service starts. If the previous boot did not complete, it creates Magisk's `disable` marker on the next boot attempt.

If recovery is still required, boot into a compatible recovery environment and remove the module directory:

```text
/data/adb/modules/POP-ZRAM
```

Then reboot the device.

## Project structure

```text
POP-ZRAM/
├── META-INF/
│   └── com/google/android/
│       ├── update-binary          # Magisk module installer entry point
│       └── updater-script         # Marks the ZIP as a Magisk module
├── common/
│   └── functions.sh               # Magisk Module Template helper functions
├── install.sh                     # Volume-key size selection and service patching
├── module.prop                    # Module metadata
├── post-fs-data.sh                # Early boot guard / automatic disable logic
├── service.sh                     # Late-start ZRAM setup and VM tuning
├── uninstall.sh                   # Installer template cleanup routine
├── RAM.png                        # Example verification image
├── LICENSE                         # GNU GPL v3.0
└── README.md
```

## How it works

1. `install.sh` asks for a ZRAM size and patches `service.sh` with the selected value.
2. `post-fs-data.sh` places a temporary boot guard.
3. `service.sh` waits for Android to finish booting, locates `zram0`, disables the prior swap, resets it, applies the selected disk size, and enables a new swap area.
4. After the service completes, it removes the boot guard.

## Development

Clone the repository:

```sh
git clone https://github.com/siimsek/POP-ZRAM.git
cd POP-ZRAM
```

To create a flashable module archive from the project root:

```sh
zip -r9 ../POP-ZRAM.zip . -x '.git/*' '.github/*'
```

Install the resulting ZIP through Magisk, then test on a non-critical device first.

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).

## Disclaimer

This module modifies swap and kernel VM settings on rooted Android devices. Use it at your own risk. The maintainers are not responsible for data loss, boot loops, reduced battery life, or device instability.
