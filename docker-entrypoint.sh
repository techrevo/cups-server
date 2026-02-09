#!/bin/bash -e

PRIMARY_IP=$(hostname -I | awk '{print $1}')

if [ -z "${ADMIN_PASSWORD}" ]; then
  ADMIN_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)
fi

echo -e "${ADMIN_PASSWORD}\n${ADMIN_PASSWORD}" | passwd admin

if [ ! -f /etc/cups/cupsd.conf ]; then
  echo "Initializing CUPS configuration from skeleton..."
  cp -rpn /etc/cups-skel/* /etc/cups/
fi

chown -R root:lp /etc/cups
chmod -R 755 /etc/cups

echo "                                                                    "
echo "--------------------------------------------------------------------"
echo "                    CUPS Server is almost ready!                    "
echo "--------------------------------------------------------------------"
echo " After successful startup, login at https://${PRIMARY_IP}:631/admin "
echo " with username 'admin' and password '${ADMIN_PASSWORD}'.            " 
echo "--------------------------------------------------------------------"
echo "                                                                    "

exec "$@"
