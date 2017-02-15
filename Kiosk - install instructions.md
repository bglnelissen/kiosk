## Kiosk install instructions for Raspbian Jessie

This script will get the Slideshow up and running from scratch

#### Steps to take

**Done**

- Put Jessie on the sd-card and enable `ssh`
- User setup
    - create 'normal' user
    - create 'server' user
    - change 'sudo' password
    - delete 'pi' user
- Setup `hostname`
- Enable `ssh` login via keys
- Use `apt-get` to update system
- apt-get installs
- mount USB drives at boot
- transmission
- openvpn
- sickrage/sickbeard

**ToDo**

- Fix: `perl: warning: Setting locale failed.`

#### Put Jessie on the sd-card and enable ssh

Get your SD-card inserted in your Mac. Download Raspbian Jessie image and write it to disk. Then add the `ssh` file in the `/boot` directory to enable `ssh` at boot.

```
# download Raspbian image
curl -O -J -L https://downloads.raspberrypi.org/raspbian_lite_latest

# extract the image (ZIP)
unzip 2017-01-11-raspbian-jessie-lite.zip

# create img variablename (IMG)
IMG=2017-01-11-raspbian-jessie-lite.img

# write the image (IMG) to disk and enable ssh
sudo date && diskutil list && echo "Enter the disk NUMBER and press [ENTER]" && read -p "(everything will be lost): " DISK && diskutil unmountDisk /dev/disk${DISK} && pv "${IMG}" | sudo dd of=/dev/rdisk${DISK} bs=100M && sleep 5 && touch /Volumes/boot/ssh && diskutil unmountDisk /dev/disk${DISK} && echo "Succes, you can remove the disk." || echo "Fail. - Re-insert disk and retry."
```

#### Ssh login

Boot the pi and login

```
# from your mac:
ssh pi@10.0.0.100 # password: raspberry
```

#### User setup

Create an account for user `kiosk`.

```
# create user `kiosk`
sudo adduser kiosk
# add this user to the sudo group
sudo usermod -aG sudo kiosk
# list my current groups
groups kiosk
```

Change sudo password.

```
sudo passwd root
```

Delete user `pi` (you need to login by another account obviously).

```
sudo deluser pi
```

#### Install softwere we need for the setup

```
sudo apt-get -y update && sudo apt-get -y install vim
```

#### Hostname setup

```
# change raspberrypi into kiosk
sudo vim /etc/hosts
# change raspberrypi into kiosk
sudo vim /etc/hostname
# activate changes and reboot
sudo /etc/init.d/hostname.sh && hostname && sudo reboot
```

#### Enable login via ssh keys

ssh keys let you login without a password. Copy our local public key to the remote machine.

```
# from your mac:
ssh kiosk@kiosk mkdir -p "~/.ssh" && cat ~/.ssh/id_rsa.pub | (ssh kiosk@kiosk "cat >> ~/.ssh/authorized_keys")
```

#### Update system, install essentials and reboot

Install updates and upgrades, also add packes for software you use a lot.

```
sudo apt-get -y update && sudo apt-get -y dist-upgrade && sudo reboot
```


#### apt-get install all we need

- X with lightdm (Desktop enviroment)
- vim (texteditor)
- libreoffice (office suite)
- VNC (Virtual network client)
- wget (download manager)
- git-core (software version control)
- usbmount (automount usb on plugin)
- lsof (list file connections and open files)

```
sudo apt-get -y update && sudo apt-get -y install \
  lxde \
  lightdm \
  xinit \
  vim \
  libreoffice \
  realvnc-vnc-server \
  wget \
  git-core \
  usbmount \
  lsof
```

#### Run script when USB is mounted

Due to the way FAT disks work (no file permissions etc) you can not run a script directly of the disk, you need to invoke it from somewere else.

```
mkdir -p /home/kiosk/bin
sudo mkdir -p /usr/local/bin
sudo touch /usr/local/bin/kioskMount.sh
sudo chmod 755 /usr/local/bin/kioskMount.sh
ln -s /usr/local/bin/kioskMount.sh /home/kiosk/bin/
```

Add the following in: `/usr/local/bin/kioskMount.sh`

```
#!/bin/bash
# b.nelissen

logger "Kiosk drive mounted"

# add future stuff here
```

Create accesible mountpoint

```
sudo mkdir -p /media/kiosk && sudo chmod 777 /media/kiosk
```

Change mountpoint, edit : `/etc/usbmount/usbmount.conf`

```
# add the /media/kiosk as the first mountpoint in the list
MOUNTPOINTS="/media/kiosk /media/usb0 /media/usb1 /media/usb2 /media/usb3
             /media/usb4 /media/usb5 /media/usb6 /media/usb7"
```

Create `/etc/systemd/system/kiosk.service`

```
sudo touch /etc/systemd/system/kiosk.service
sudo chmod 644 /etc/systemd/system/kiosk.service
```

The service required the mountpoint and runs script when mountpoint is found.
```
# Kiosk
# note: in 'service' files, dashed '-' are used instead of slashes '/'

[Unit]
Description=Start Kiosk after mounting /media/kiosk
Requires=media-kiosk.mount
After=media-kiosk.mount

[Service]
ExecStart=/usr/local/bin/kioskMount.sh

[Install]
WantedBy=media-kiosk.mount
```

Start the service

```
sudo systemctl start kiosk.service
sudo systemctl enable kiosk.service
```













--- 


```
# Get drive info (UUID and /dev/location)
lsusb
sudo blkid
ls -l /dev/disk/by-uuid/

# Check the disk 
sudo fsck -f /dev/sda1

# create a mount location
sudo mkdir -p /media/KoekoekPi && sudo chown server:server /media/KoekoekPi && chmod 777 /media/KoekoekPi

# mount the drive manualy
sudo mount -o "umask=0,uid=nobody,gid=nobody" /dev/sda1 /media/KoekoekPi

# list mounted drives
df -Th
```

Add a line for the mount in **/etc/fstab**

```
#  # <device>                                <dir>             <type>  <options>     <dump> <fsck>
#  UUID=2446eac8-2de0-4872-8e4b-f3d782fe1550 /media/KoekoekPi  ext4    defaults,user 0      2
sudo vim /etc/fstab
```

Test the current **/etc/fstab** configuration, and when correct, run use it.

```
# Mount all
sudo mount --all --verbose
```

#### Start presentation

Aantekeningen:
- -nologo -headless -nofirststartwizard

**Extra's**

#### Resource usage

```
sudo iotop --only
```

#### Create backup image of the current system

ToDo: clean trash and logs befor backup

Shutdown the pi gracefully

```
sudo shutdown -t now
```
## Backup workflow

Run this routine on your mac with the SD inserted.

#### Create backup from SD

```
sudo date && diskutil list && \
read -p "Enter the disk NUMBER you want to backup and press [ENTER]: " DISK && \
diskutil unmountDisk /dev/disk${DISK} && \
sudo pv /dev/rdisk${DISK} | pigz -9 > kiosk."$(date +%Y%m%d)".backup.img.gz
```

#### Restore backup to SD

```
IMGGZ="kiosk.20170213.backup.img.gz";
sudo date && diskutil list && \
read -p "Enter the disk NUMBER you want to backup and press [ENTER]: " DISK && \
diskutil unmountDisk /dev/disk${DISK} && \
gzip --decompress --stdout ${IMGGZ} | pv -s 16G | sudo dd of=/dev/rdisk${DISK} bs=100M
```