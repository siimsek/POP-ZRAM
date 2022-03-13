# POP-ZRAM ~ Magisk Module
Enable ZRAM with 4GB in your device!
### -What is ZRAM on android?

>ZRAM swap can increase the amount of memory available in the system by compressing memory pages and putting them in dynamically allocated swap area of memory.
[ZRAM - Wiki](https://en.wikipedia.org/wiki/Zram)
### -How to check ZRAM?
>Download [RAM Truth](https://play.google.com/store/apps/details?id=sa.ramtruth) . 
>Open app then check  "Swap (Total):".
>![  ](RAM.png)
### -Does ZRAM drain battery?
>Using ZRAM will give u more Free RAM for better multitasking. But it can drain ur battery faster (Not a big difference).

#### Setup Steps:
1. Download POP-ZRAM module. [Github](https://github.com/siimsek/POP-ZRAM/releases/) / [Mirror](https://mirror.orkunergun.workers.dev/POP-ZRAM%28Magisk%29.zip) 
2. Flash module in Magisk.
3. Reboot.
#### Troubleshooting (BootLoop):
1. Open your recovery.
1. Go File Manager and Navigate to "/data/adb/modules".
3. Then delete POP-ZRAM.
