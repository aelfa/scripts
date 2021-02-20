#!/bin/bash

function badinput() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
}

function rclone_update_stable() {
curl https://rclone.org/install.sh | sudo bash
}

function rclone_update_beta() {
curl https://rclone.org/install.sh | sudo bash -s beta
}

function mergerupdate() {
mgversion="$(curl -s https://api.github.com/repos/trapexit/mergerfs/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')"
wget https://github.com/trapexit/mergerfs/releases/download/${mgversion}/mergerfs_${mgversion}.ubuntu-bionic_amd64.deb -O /tmp/mergerfs.deb
dpkg -i /tmp/mergerfs.deb
rm -rf /tmp/mergerfs.deb 
}

function sudocheck() {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  fi
}

function updateall() {
package_list="update upgrade dist-upgrade autoremove autoclean "
for i in ${package_list}; do
    sudo apt $i -yqq 1>/dev/null 2>&1
    echo "$i is running , please wait"
    sleep 1
done
apt-get install fuse libc6 -yqq
}

function mergerfsupdate() {
mgversion="$(curl -s https://api.github.com/repos/trapexit/mergerfs/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')"
mgstored="$(mergerfs -v | grep 'mergerfs version:' | awk '{print $3}')"

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 mergerfs Update Panel  --local version $mgstored
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

mergerfs installed version = 		$mgstored

mergerfs latest version    = 		$mgversion

[Y] UPDATE to lateste version

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type .... and press [ENTER]: ' typed </dev/tty

  case $typed in

  Y) mergerupdate ;;
  y) mergerupdate ;;
  z) clear && exit ;;
  Z) clear && exit ;;
  *) badinput ;;
  esac

}

function rcloneupdate() {
rcversion="$(curl -s https://api.github.com/repos/rclone/rclone/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')"
rcstored="$(rclone --version | awk '{print $2}' | tail -n 3 | head -n 1)"
      tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 rClone Update Panel  			$rcstored
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

rclone installed version = 		$rcstored

rclone latest version 	 = 		$rcversion

Update to STABLE = [ S / s ]
Update to BETA   = [ B / b ]

[ Z / z ] = Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type .... and press [ENTER]: ' typed </dev/tty

  case $typed in
  S) rclone_update_stable ;;
  s) rclone_update_stable ;;
  B) rclone_update_beta ;;
  b) rclone_update_beta ;;
  z) clear && exit ;;
  Z) clear && exit ;;
  *) badinput ;;
  esac
}

function update() {

sudocheck 
updateall

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  >>> ---- Update INTERFACE ---- <<<<
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


 rclone update panel     = [ R / r ]
 mergerfs update panel   = [ M / m ]

 EXIT the interface      = [ Z / z ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type .... and  press [ENTER]: ' typed </dev/tty

  case $typed in

  R) rcloneupdate ;;
  r) rcloneupdate ;;
  M) mergerfsupdate ;;
  m) mergerfsupdate ;;
  z) clear && exit ;;
  Z) clear && exit ;;
  *) badinput ;;
  esac
}

update
