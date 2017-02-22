## Kiosk install instructions for Raspbian Jessie

This script will get the Slideshow up and running from scratch

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
#### Install lightweight GUI

1. Display Server (Xorg Display Server)
2. Desktop Environment & Window Manager (XFCE & XFWM Window Manager)
3. Login Manager (LightDM Login Manager)

```
sudo apt-get install -y --no-install-recommends xserver-xorg && \
sudo apt-get install -y xfce4 xfce4-terminal && \
sudo apt-get install -y lightdm
```

#### Automatically login LightDM

Backup `/etc/lightdm/lightdm.conf`

```
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf."$(date +%Y%m%d)".bak && \
```

Replace contents of `/etc/lightdm/lightdm.conf` with the following:

```
[SeatDefaults]
autologin-user=kiosk
autologin-user-timeout=0
```

#### apt-get install all we need

- vim (texteditor)
- libreoffice (office suite)
- VNC (Virtual network client)
- wget (download manager)
- git-core (software version control)
- usbmount (automount usb on plugin)
- lsof (list file connections and open files)

```
sudo apt-get -y update && sudo apt-get -y install \
  vim \
  libreoffice libreoffice-base \
  realvnc-vnc-server \
  wget \
  git-core \
  usbmount \
  lsof
```

#### Update and reboot

```
sudo apt-get -y update && sudo apt-get -y dist-upgrade && sudo reboot
```

#### Create mountpoint and mount read-only

```
sudo mkdir -p /media/kiosk && sudo chown kiosk:kiosk /media/kiosk
```

Change mountpoint, edit : `/etc/usbmount/usbmount.conf`

```
# add the /media/kiosk as the first mountpoint in the list
MOUNTPOINTS="/media/kiosk /media/usb0 /media/usb1 /media/usb2 /media/usb3
             /media/usb4 /media/usb5 /media/usb6 /media/usb7"

MOUNTOPTIONS="ro,noexec,nodev,noatime,nodiratime"
```

#### Run script when USB is mounted

Due to the way FAT disks work (no file permissions etc) you can not run a script directly of the disk, you need to invoke it from somewere else.

```
sudo mkdir -p ~/bin && \
sudo touch ~/bin/kiosk.sh && \
sudo chmod 755 ~/bin/kiosk.sh
```

Edit: `~/bin/kiosk.sh`

```
#!/bin/bash
# b.nelissen

logger "Start kiosk"

# Kill all previous instances of open office
killall soffice

# Open open office
while true; do
  logger "Start slideshow"
  export DISPLAY=:0.0
  soffice --impress --nologo --norestore --show /media/kiosk/wachtkamer.odp

  # we landed here because the line above did exit...
  logger "Slideshow exit, restart"
  sleep 6
done
```

Start the kiosk deamon script at login:

1. Settings
2. Session and startup
3. Application Autostart
4. Add: /home/kiosk/kiosk.sh

#### Enable VNC

Enable VNC login (Option '5' -> 'P3')

```
sudo raspi-config
```

Login on the remote machine using VNC Viewer

- VNC Server `kiosk`, name `Kiosk`
- Connect. Username: `kiosk`. Password: `kiosk`

#### Disable long boot time due to `dhcpcd`

```
sudo systemctl disable dhcpcd.service
```
--- 

**Extra's**

#### Service that runs on USB insertion (obsolete)

Create `/etc/systemd/system/kiosk.service`

```
sudo touch /etc/systemd/system/kiosk.service && sudo chmod 644 /etc/systemd/system/kiosk.service
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
ExecStart=/home/kiosk/bin/kiosk.sh

[Install]
WantedBy=media-kiosk.mount
```

Start the service

```
sudo systemctl start kiosk.service && sudo systemctl enable kiosk.service
```

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
gzip --decompress --stdout ${IMGGZ} | pv -s 16G | sudo dd of=/dev/rdisk${DISK} bs=100M && \
diskutil unmountDisk /dev/disk${DISK}
```