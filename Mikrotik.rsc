# mar/25/2022 22:28:46 by RouterOS 6.48.4
# software id = MI4Q-0ECF
#
# model = RouterBOARD 952Ui-5ac2nD
# serial number = 71B107865131
/interface bridge
add name=bridge1
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no ssid=MikroTik
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa-psk,wpa2-psk eap-methods="" \
    mode=dynamic-keys supplicant-identity=MikroTik wpa-pre-shared-key=\
    fermituttiwpa2-pre-shared-fermitutti
/ip hotspot profile
set [ find default=yes ] html-directory=hotspot
/ip pool
add name=dhcp_pool1 ranges=192.168.55.2-192.168.55.220
/ip dhcp-server
add address-pool=dhcp_pool1 disabled=no interface=bridge1 name=dhcp1
/interface bridge port
add bridge=bridge1 interface=wlan1
add bridge=bridge1 interface=ether3
/ip address
add address=192.168.55.1/24 interface=bridge1 network=192.168.55.0
/ip dhcp-server lease
add address=192.168.55.200 client-id=1:0:d8:61:ab:fa:5f mac-address=\
    00:D8:61:AB:FA:5F server=dhcp1
add address=192.168.55.100 client-id=1:0:d8:61:ab:fa:60 mac-address=\
    00:D8:61:AB:FA:6F server=dhcp1
/ip dhcp-server network
add address=192.168.55.0/24 dns-server=8.8.8.8 gateway=192.168.55.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=dst-nat chain=dstnat dst-port=8086 in-interface=ether1 protocol=tcp \
    to-addresses=192.168.55.200 to-ports=8000
/system clock
set time-zone-name=Europe/Rome
