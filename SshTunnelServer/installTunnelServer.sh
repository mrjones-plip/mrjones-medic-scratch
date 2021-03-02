#!/bin/bash

# todo - put in a single loop?  fewer loops?
# todo - check for Nth run to not create users that already exist etc
# todo - save decent looking HTML instructions in $DOMAIN vhost
# todo - maybe check for ubuntu?

clear
echo ""
echo "This script assumes you're root and assumes you"
echo "want to set a bunch of SSH tunnels to reverse proxy"
echo "HTTPs and HTTP traffic."
echo ""
echo "See https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/SshTunnelServer "
echo "for more info"
echo ""
echo "Press any key to continue or \"ctrl + c\" to exit"
echo ""
read -n1 -s

DOMAIN=$1

USERS_FILE='user.txt'
if [ ! -f "$USERS_FILE" ]; then
  echo "ERROR - $USERS_FILE does not exist."
  echo ""
  echo "Exiting"
  echo ""
  exit
fi

# thanks https://stackoverflow.com/a/18216122
if [ "$EUID" -ne 0 ]; then
  echo "ERROR - You are not as root"
  echo ""
  echo "Exiting"
  echo ""
  exit
fi

echo ""
echo "Installing required software..."
echo ""
apt update&&apt dist-upgrade&&apt install apache2  rpl&&systemctl --now enable apache2
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot

#enable mods restart apache
a2enmod proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html
systemctl reload apache2

# create user ():
# todo validate this works
echo ""
echo "Adding users..."
echo ""
for i in $(cat user.txt); do useradd -m -d /home/$i -s /bin/false $i; done

# create .ssh dir and authorized_keys with right perms and ownership
# todo validate this works
for i in $(cat user.txt); do
  mkdir /home/$i/.ssh
  chown -R $i:$i /home/$i/.ssh
  touch /home/$i/.ssh/authorized_keys
  chmod 700 /home/$i/.ssh
  chmod 600 /home/$i/.ssh/authorized_keys
done

# fetch .ssh keys into authorized keys file
for i in $(cat user.txt); do curl https://github.com/$i.keys -o /home/$i/.ssh/authorized_keys; done

# add mrjones key to all to help testing (optional)
for i in $(cat user.txt); do curl -s https://github.com/mrjones-plip.keys >>/home/$i/.ssh/authorized_keys; done

#  create one file per user vhost
for i in `cat user.txt`; do cp /root/apache.conf /etc/apache2/sites-available/$i.$DOMAIN.conf;rpl --encoding UTF-8  -q SUBDOMAIN $i /etc/apache2/sites-available/$i.$DOMAIN.conf; done
for i in `cat user.txt`; do rpl --encoding UTF-8  -q DOMAIN $DOMAIN /etc/apache2/sites-available/$i.$DOMAIN.conf; done

# create a custom port per file.
for i in `cat user.txt`; do rand=`shuf -i1000-5000 -n1`;rpl --encoding UTF-8  -q PORT $rand /etc/apache2/sites-available/$i.$DOMAIN.conf; done

# enable vhosts
for i in `cat user.txt`; do a2ensite $i.$DOMAIN.conf; done

#enable certbot certs , change email
for i in `cat user.txt`; do sudo certbot   --apache   --non-interactive   --agree-tos   --email mrjones@plip.com   --domains $i.cht-tunnel.plip.com; done

# output mapping
grep ProxyPassReverse /etc/apache2/sites-available/*cht*|cut -d/ -f5,8|cut -d: -f1,3