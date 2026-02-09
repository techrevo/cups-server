# Universal CUPS Print Server

A robust, Docker-based print server designed to bring modern network printing capabilities to any printer. This image transforms legacy and modern printers into network-accessible devices compatible with **AirPrint (iOS)**, **Mopria (Android)**, and **Windows/macOS/Linux**.

Built on a solid base with all necessary dependencies to handle complex drivers and proprietary binary plugins that often fail in minimal container environments.

---

## 🚀 Key Features

*   **Universal Compatibility:** Pre-installed with a wide range of open-source drivers (Gutenprint, PCL, etc.).
*   **Driver & Plugin Ready:** Includes all compilation headers and libraries required to install proprietary binary plugins.
*   **Auto-Discovery:** Full mDNS/Bonjour support for seamless AirPrint discovery across your network.
*   **Security by Default:** Automatically generates a secure 8-character random password if none is provided.
*   **Multi-Arch Support:** Optimized to run on both standard X86 servers and ARM-based devices

---

## 📦 Option 1: Quick Start (Pre-built Image)

If you want to get up and running immediately using the hosted image:

1. **Create a `docker-compose.yml` file:**

```yaml
services:
  cups:
    container_name: cups-server
    image: ghcr.io/techrevo/cups-server:latest
    hostname: cups-server
    restart: unless-stopped
    network_mode: host
    privileged: true
    environment:
      - ADMIN_PASSWORD=your_secure_password
      - TZ=Europe/Rome
    volumes:
      - ./cups_config:/etc/cups
      - ./cups_cache:/var/cache/cups
      - /var/run/dbus:/var/run/dbus
```

2. **Launch the server:**

```bash
docker-compose up -d
```

3. **Retrieve credentials:**

```bash
docker logs cups-server
```

## 🛠️ Option 2: Clone and Build Locally

Use this method if you want to customize the Dockerfile or the entrypoint script.

1. **Clone the repository:**

```bash
git clone https://github.com/techrevo/cups-server.git
cd cups-server
```

2. **Build and run:*
```bash
docker-compose up -d --build
```

## 🔧 Post-Installation & Drivers

### Access the Web Interface

Open your browser and go to http://<your-server-ip>:631. Use the username admin and the password found in the logs.

### Installing Proprietary Plugins

If your printer requires additional binary components, you can install them directly via the terminal:

```bash
docker exec -it cups-server hp-plugin -i
```

### Persistence

The following volumes ensure your configuration survives container updates:

- ```/etc/cups```: Printer definitions and PPD files.
- ```/var/run/dbus```: Required for broadcasting the printer service to mobile devices.

## 🌐 Network Considerations

- **Host Mode**: This container uses network_mode: host to allow mDNS/Bonjour packets to reach your network for discovery.
- **Firewall**: Ensure ports 631 (IPP) and 5353 (mDNS) are open on your host firewall.
- **Subnets**: For discovery across different subnets, ensure you have an mDNS reflector/proxy active in your network infrastructure.

## 📄 License

This project is open-source and available under the Apache Licence 2.0.