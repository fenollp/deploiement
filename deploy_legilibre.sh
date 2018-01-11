#!/bin/sh

# Add red PS1 for root
echo >> /root/.bashrc
echo -E 'export PS1='\''${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[01;37m\] \t \[\033[1;34m\]\w \$\[\033[00m\] '\' >> /root/.bashrc

# Unused directory?
rmdir init.disabled

# Avoid locale warning
echo -e '\nen_US.UTF-8\nfr_FR.UTF-8\n' >> /etc/locale.gen
locale-gen --purge
echo -e 'LANG=C.UTF-8\n' > /etc/default/locale

# Update and install some packages
apt-get update
apt-get install -y libarchive13 python-pip git htop

# If data disk, use it
location=/root
if [ -e /dev/xvdb ]; then
	label=`e2label /dev/xvdb`
	if [ "$?" = 0 ]; then
		# On Debian 9 (on Gandi VMs), data disk are mounted but not activated until requested
		ls /srv/$label >/dev/null 2>/dev/null
		location=/srv/$label
	fi
fi

# Create dedicated directory
mkdir -p $location/legilibre
cd $location/legilibre

# Create directories
mkdir -p code tarballs sqlite

# Copy code
cd code
git clone https://github.com/Legilibre/legi.py.git
cd legi.py
pip install -r requirements.txt

# Install cron
# TBD

# Download tarballs
python -m legi.download ../../tarballs

# Compute database
python -m legi.tar2sqlite ../../sqlite/legi.sqlite ../../tarballs

# Tidy
rm -f /root/deploy_legilibre.sh
