![](assets/20230303_131323_AICSHP-logo.png)

# Install

### Install Proxmox:

For x86-64, install the ISO on the baremetal machine.

[Proxmox Downloads](https://www.proxmox.com/en/downloads)

Then you should be able to access Pimox at `http://the-ip-you-assigned:8006`

6. The default login is:

   - username: *root*
   - password: *you set this during installation*
7. In the Proxmox web server:

   - ![Open the shell](./arm_based_installation/documentation/images/open_shell.png)
8. Download the Ubuntu 22.04.2 server for AMD64 iso in Proxmox:

   - ![Upload the iso](./arm_based_installation/documentation/images/upload_iso.png)
   - [Ubuntu Server for AMD64](https://ubuntu.com/download/server)
9. Create the VM:

   - ![create the vm](./arm_based_installation/documentation/images/create_vm.png)
   - Name the VM
   - ![OS tab](./arm_based_installation/documentation/images/no_media.png)
   - ![System tab](./arm_based_installation/documentation/images/bios.png)
   - ![Disks tab](./arm_based_installation/documentation/images/disks.png)
   - Allow at least 16Gb
   - ![CPU Cores tab](./arm_based_installation/documentation/images/cpu.png)
   - Add as many cores and CPUs as needed
   - Give the VM 4 Gb of RAM
   - Leave the network settings exactly how they are by default
   - Confirm your choices
   - ![Remove the disk](./arm_based_installation/documentation/images/remove_disk.png)
   - ![Add new disk](./arm_based_installation/documentation/images/add_disk.png)
   - ![CD/DVD disk properties](./arm_based_installation/documentation/images/disk_properties.png)
   - Select the ISO for booting
   - ![Change the boot order](./arm_based_installation/documentation/images/boot_order.png)
   - ![Boot order properties](./arm_based_installation/documentation/images/correct_boot_order.png)
   - ![Start the VM](./arm_based_installation/documentation/images/start.png)
10. Ubuntu Server Installation Options:

    - ![Open the console](./arm_based_installation/documentation/images/console.png)
    - Language
    - Keyboard Layout
    - *Ubuntu Server*
    - Auto Configured Network Connection
    - No Proxy
    - Default Storage Configuration Options
    - Name
    - Server Name
    - Username & Password <-- *make sure the username is ***aicshp*** or things will break later*
    - Skip pro
    - *Install openssh server*
    - Choose the Docker snap
11. After installing and reaching the "remove installation medium" message, change the boot order or remove the CD drive.![boot order](./arm_based_installation/documentation/images/change_boot_order3.png)

### Install Dependencies:

`./installdeps.sh`

Add the following to crontab:

`@reboot bash /etc/inotifyfilechange.sh`

`@reboot bash /etc/start_plc.sh`

### OpenPLC Usage

Web GUI available at [127.0.0.1:8080](127.0.0.1:8080)

Default login: openplc:openplc

Restart system or VMs to restart PLC

### Scaling

Refer to the [Proxmox guide](https://pve.proxmox.com/wiki/Cluster_Manager)
