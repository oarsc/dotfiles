# Hotspot + UFW

This guide configures UFW so a NetworkManager Wi-Fi hotspot can provide DHCP, DNS, and Internet access while keeping the firewall enabled.
Please use this guide only if the NetworkManager hotspot is already configured but clients cannot connect or access the Internet while UFW is enabled.

## Create new Hotspot connection

```bash
sudo nmcli device wifi hotspot \
    ifname wlan0 \
    con-name Hotspot \
    ssid <hotspot-public-ssid> \
    password '<hotspot-password>' \
    band bg \
    channel 6

sudo nmcli connection modify "Hotspot" \
    802-11-wireless-security.pmf 1
```

## Check ufw configuration

Check if ufw is active
```bash
sudo ufw status numbered
```

If UFW is active and there are no rules for the Wi-Fi interface, the steps in this guide may be needed. Output example:
```
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 67/udp on wlan0            ALLOW IN    Anywhere                   # Hotspot DHCP
[ 2] 53/udp on wlan0            ALLOW IN    Anywhere                   # Hotspot DNS
[ 3] 53/tcp on wlan0            ALLOW IN    Anywhere                   # Hotspot DNS TCP
[ 4] Anywhere on enp4s0         ALLOW FWD   10.42.0.0/24 on wlan0      # Hotspot Internet
[ 5] 67/udp (v6) on wlan0       ALLOW IN    Anywhere (v6)              # Hotspot DHCP
[ 6] 53/udp (v6) on wlan0       ALLOW IN    Anywhere (v6)              # Hotspot DNS
[ 7] 53/tcp (v6) on wlan0       ALLOW IN    Anywhere (v6)              # Hotspot DNS TCP
```

## Configuration variables

The three values below can be different depending on each PC:

```bash
HOTSPOT_IF="wlan0"
INTERNET_IF="enp4s0"
HOTSPOT_SUBNET="10.42.0.0/24"
```

### Find `HOTSPOT_IF`

List network interfaces and their state:
```bash
nmcli device status
```

Look for the Wi-Fi device (`TYPE` = `wifi`). For example:
```text
DEVICE   TYPE      STATE                   CONNECTION
wlan0    wifi      connected               Hotspot-1
```

You can also list wireless interfaces with:
```bash
iw dev
```

Look for an interface whose type is `AP` while the hotspot is active:
```text
Interface wlan0
    type AP
```

> Do not assume the name is always `wlan0`. It may be something such as `wlp2s0` on another machine.

---

### Find `INTERNET_IF`

The most reliable way is to ask the routing table which interface is used for an external destination:
```bash
ip route get 1.1.1.1
```

Example:
```text
1.1.1.1 via 192.168.1.1 dev enp4s0 src 192.168.1.137
```

The value after `dev` is the Internet interface:
```bash
INTERNET_IF="enp4s0"
```

This can also be checked with:
```bash
nmcli device status
```

Look for the interface connected to the network that provides Internet access.

> If the PC gets Internet through another Wi-Fi adapter, USB Ethernet adapter, VPN, etc., `INTERNET_IF` may be different.

---

### Find `HOTSPOT_SUBNET`

Enable the hostpot with:
```bash
nmcli connection show # list all connection profiles
nmcli connection up <hotspot name>
```

With the hotspot active, inspect the IPv4 address of the hotspot interface:
```bash
ip -4 addr show dev "$HOTSPOT_IF"
```

Example:
```text
inet 10.42.0.1/24 brd 10.42.0.255 scope global wlan0
```

The interface address is `10.42.0.1/24`, so the network is:
```bash
HOTSPOT_SUBNET="10.42.0.0/24"
```

You can also get the address directly from the NetworkManager connection profile:
```bash
nmcli connection show "Hotspot-1" | grep '^ipv4.addresses'
```

Example:
```text
ipv4.addresses:                         10.42.0.1/24
```

NetworkManager commonly uses `10.42.0.0/24` for its shared connections, but **do not hard-code that assumption**; check the actual address on the target PC.

---

## Set UFW rules

```bash
HOTSPOT_IF="wlan0"
INTERNET_IF="enp4s0"
HOTSPOT_SUBNET="10.42.0.0/24"

# Allow DHCP requests on the hotspot interface
sudo ufw allow in on "$HOTSPOT_IF" to any port 67 proto udp comment 'Hotspot DHCP'

# Allow DNS queries on the hotspot interface
sudo ufw allow in on "$HOTSPOT_IF" to any port 53 proto udp comment 'Hotspot DNS'
sudo ufw allow in on "$HOTSPOT_IF" to any port 53 proto tcp comment 'Hotspot DNS TCP'

# Allow hotspot clients to access the Internet through the Internet interface
sudo ufw route allow in on "$HOTSPOT_IF" out on "$INTERNET_IF" from "$HOTSPOT_SUBNET" comment 'Hotspot Internet'
```
