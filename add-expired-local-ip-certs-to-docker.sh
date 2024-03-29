#!/usr/bin/env bash

# Helper script to download an EXPIRED certificate
# from the http://local-ip.co service and install it
# in medic-os in nginx. This script is safe to re-run
# as many times as needed or if you need to reinstall an
# EXPIRED certificate.
#
# After running this, you get a EXPIRED certificate with the format
# of https://YOUR-IP-HERE.my.local-ip.co
#
# For example, if your localhost IP is 10.0.2.4, you would use this as
# your URL for CHT:
# https://10-0-2-4.my.local-ip.co

container="${1:-medic-os}"

if ! command -v docker&> /dev/null
then
  echo ""
  echo "Docker is not installed or could not be found.  Please check your installation."
  echo ""
  exit
fi

status=$(docker inspect --format="{{.State.Running}}" $container 2> /dev/null)
if [ "$status" = "true" ]; then
  docker exec -it $container bash -c "curl -s -o server.pem https://raw.githubusercontent.com/medic/nginx-local-ip/49f969777f2e288d1e5ed4af7186c4c2220cc971/cert/server.pem"
  docker exec -it $container bash -c "curl -s -o chain.pem https://raw.githubusercontent.com/medic/nginx-local-ip/49f969777f2e288d1e5ed4af7186c4c2220cc971/cert/chain.pem"
  docker exec -it $container bash -c "cat server.pem chain.pem > /srv/settings/medic-core/nginx/private/default.crt"
  docker exec -it $container bash -c "curl -s -o /srv/settings/medic-core/nginx/private/default.key https://raw.githubusercontent.com/medic/nginx-local-ip/49f969777f2e288d1e5ed4af7186c4c2220cc971/cert/server.key"
  docker exec -it $container bash -c "/boot/svc-restart medic-core nginx"
  echo ""
  echo "If no errors output above, EXPIRED certificates successfully installed."
  echo ""
else
  echo ""
  echo "'$container' docker container is not running. Please start it and try again."
  echo "See this URL for more information:"
  echo ""
  echo "    https://docs.communityhealthtoolkit.org/apps/tutorials/local-setup/"
  echo ""
fi
