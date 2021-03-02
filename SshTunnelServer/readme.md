
# SSH Tunnel Server Installer
 
## Intro

This is for when you have a lot of GitHub Developers who have added their SSH key to GitHub (e.g. [here's mine](https://github.com/mrjones-plip.keys)) and they also are doing local development of apps that they either need to share with others via the internet or they need valid TLS certificates to test with, or both!

The script will:
1. Create a login on the host
1. Lock this login to only allow SSH tunnels
1. Create an Apache vhost for this login, with the `GH-USERNAME.domain.com`
1. Create an SSL certificate with Let's Encrypt for `GH-USERNAME.domain.com`
1. Put instructions to use the SSH tunnels at `domain.com`

## Requirements

Right now this very narrowly scoped, so requirements are:
* An Ubuntu 20.04 server
* A public IP for the server
* An A record pointing to the public IP (AAAA if ya wanna be IPv6 classy)
* a wildcard CNAME entry pointing to the A record
* SSH server [locked to keys only](https://www.linuxbabe.com/linux-server/setup-passwordless-ssh-login) (optional, but is very good idea)

Development was done locally and then in Digital Ocean.

## Running

1. SSH as root to your Ubuntu server with public IP
1. run `git clone 