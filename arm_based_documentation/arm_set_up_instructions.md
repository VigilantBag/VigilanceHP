# Arm64 (rpi) Pimox and OpenPlc Installation instructions
## [Pimox Github](https://github.com/pimox/pimox7)

**THIS METHOD WORKS AS OF MARCH 7, 2023**

**YOU MUST USE A PI WITH 4GB OR MORE OF RAM** 

1. Install Pimox using [Raspberry Pi OS Lite (64-bit)](https://downloads.raspberrypi.org/raspios_oldstable_lite_armhf/images/raspios_oldstable_lite_armhf-2023-02-22/2023-02-21-raspios-buster-armhf-lite.img.xz). **This will _ONLY_ work with the 64-bit lite version** 
2. Using the raspberry pi imager software: 
    - enable ssh
    - set the username and password
    - configure LAN (if you're using wifi)
    - set the timezone/keyboard
3. In the raspberry pi lite installation you just created, run:
    - `# sudo su` <-- logins in as root
    - `# apt-get update && apt-get upgrade -y` <-- update the system
    - `# curl https://raw.githubusercontent.com/pimox/pimox7/master/RPiOS64-IA-Install.sh > RPi_Install.sh` <-- downloads the pi
    - `# chmod +x RPi_Install.sh` <-- make the installation script executable
    - `# ./RPi_Install.sh` <-- run the installation script
    - at this point simply follow the prompts in the script
4. Once the system has been restarted run
    - `# sudo apt upgrade -y` <--upgrades the system one final time finishing the installation
5. Then you should be able to access Pimox at `http://the-ip-you-assigned:8006`
6. The default login is:
    - username: *root*
    - password: *you set this during installation*
7. In the Proxmox web server:
    - Open the shell
    ![](./images/open_shell.png)
8. Allow Proxmox to utilize more RAM:
    - `$ vim /etc/dphys-swapfile` <-- "console-based" editor will work (vim, nano, etc.)
    - change the value of CONF_SWAPSIZE  **(line 16)** from 100 to either 1024 or 2048 depending on which model pi you're using
9. Download the Ubuntu 22.04.2 server for arm64 iso in Proxmox:
    ![](./images/upload_iso.png)
    - [Ubuntu Server for Arm64](https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.2-live-server-arm64.iso)
10. Create the VM:
    1. ![](./images/create_vm.png)
    2. Name the VM
    3. ![](./images/no_media.png) 
    4. ![](./images/bios.png) 
    5. ![](./images/disks.png) 
    6. ![](./images/cpu.png) 
    7. Give the VM 2 Gb of RAM
    8. Leave the network settings exactly how they are by default
    9. Confirm your choices
    10. ![](./images/remove_disk.png)
    11. ![](./images/add_disk.png)  
    12. ![](./images/disk_properties.png)
    13. ![](./images/boot_order.png)
    14. ![](./images/correct_boot_order.png)
    15. ![](./images/start.png)

11. Ubuntu Server Installation Options:
    ![](./images/console.png)
    - Language
    - Keyboard Layout
    - *Ubuntu Server*
    - Auto Configured Network Connection
    - No Proxy
    - Default Storage Configuration Options
    - Name
    - Server Name
    - Username & Password
    - Skip pro
    - *Install openssh server*
    - No server snaps

12. Once the VM reboots, to get OpenPLC running:
    - `$ sudo apt-get update && sudo apt-get upgrade -y` <-- update and upgrade the VM
    - `$ sudo apt-get install git` <-- make sure git is installed
    - `$ curl clone https://github.com/thiagoralves/OpenPLC_v3.git` <-- download the OpenPLC repo
    - `$ cd OpenPLC_v3` <-- go to the folder you just downloaded
    - `$ ./install.sh rpi` <-- run the install script
    - `$ ip -a` <-- write down the ip address for this VM
    - `$ ./start_openplc.sh` <-- start openplc

13. Open http://ip-from-step-12:8080
    - default login:
        - username: openplc
        - password: openplc

