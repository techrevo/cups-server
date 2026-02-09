FROM debian:bullseye-slim

LABEL org.opencontainers.image.title="Universal CUPS AirPrint Server" \
      org.opencontainers.image.description="Dockerized CUPS server for AirPrint/Mopria with HPLIP and multi-arch support." \
      org.opencontainers.image.authors="Carlo Aquino <carlo.aquino111@gmail.com>" \
      org.opencontainers.image.url="https://github.com/techrevo/cups-server" \
      org.opencontainers.image.source="https://github.com/techrevo/cups-server.git" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.licenses="Apache-2.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    sudo \
    cups \
    cups-bsd \
    cups-filters \
    build-essential \
    libcups2-dev \
    libdbus-1-dev \
    python3-dev \
    libssl-dev \
    libsnmp-dev \
    python3 \
    python3-dbus \
    python3-gi \
    python3-pip \
    python3-reportlab \
    wget \
    curl \
    gnupg \
    netcat-openbsd \
    avahi-daemon \
    libnss-mdns \
    printer-driver-all \
    printer-driver-gutenprint \
    hp-ppd \
    hplip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --home /home/admin --shell /bin/bash --gecos "admin" --disabled-password admin \
    && adduser admin sudo \
    && adduser admin lp \
    && adduser admin lpadmin \
    && echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

RUN /usr/sbin/cupsd \
    && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
    && cupsctl --remote-admin --remote-any --share-printers \
    && kill $(cat /var/run/cups/cupsd.pid) \
    && echo "ServerAlias *" >> /etc/cups/cupsd.conf \
    && sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

RUN cp -rp /etc/cups /etc/cups-skel

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["cupsd", "-f"]

EXPOSE 631