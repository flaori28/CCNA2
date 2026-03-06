
### 1. Refer to the exhibit. What will router R1 do with a packet that has a destination IPv6 address of 2001:db8:cafe:5::1?

forward the packet out GigabitEthernet0/0
drop the packet
forward the packet out GigabitEthernet0/1
forward the packet out Serial0/0/0*

### 2. Refer to the exhibit. Currently router R1 uses an EIGRP route learned from Branch2 to reach the 10.10.0.0/16 network. Which floating static route would create a backup route to the 10.10.0.0/16 network in the event that the link between R1 and Branch2 goes down?

ip route 10.10.0.0 255.255.0.0 Serial 0/0/0 100
ip route 10.10.0.0 255.255.0.0 209.165.200.226 100
ip route 10.10.0.0 255.255.0.0 209.165.200.225 100*
ip route 10.10.0.0 255.255.0.0 209.165.200.225 50

### 3. Refer to the exhibit. R1 was configured with the static route command ip route 209.165.200.224 255.255.255.224 S0/0/0 and consequently users on network 172.16.0.0/16 are unable to reach resources on the Internet. How should this static route be changed to allow user traffic from the LAN to reach the Internet?

Add an administrative distance of 254.
Change the destination network and mask to 0.0.0.0 0.0.0.0*
Change the exit interface to S0/0/1.
Add the next-hop neighbor address of 209.165.200.226.

### 4. Which option shows a correctly configured IPv4 default static route?

ip route 0.0.0.0 255.255.255.0 S0/0/0
ip route 0.0.0.0 0.0.0.0 S0/0/0*
ip route 0.0.0.0 255.255.255.255 S0/0/0
ip route 0.0.0.0 255.0.0.0 S0/0/0

### 5. Refer to the exhibit. Which static route command can be entered on R1 to forward traffic to the LAN connected to R2?

ipv6 route 2001:db8:12:10::/64 S0/0/0
ipv6 route 2001:db8:12:10::/64 S0/0/1 fe80::2*
ipv6 route 2001:db8:12:10::/64 S0/0/0 fe80::2
ipv6 route 2001:db8:12:10::/64 S0/0/1 2001:db8:12:10::1

### 6. What is a method to launch a VLAN hopping attack?

introducing a rogue switch and enabling trunking*
sending spoofed native VLAN information
sending spoofed IP addresses from the attacking host
flooding the switch with MAC addresses

### 7. A cybersecurity analyst is using the macof tool to evaluate configurations of switches deployed in the backbone network of an organization. Which type of LAN attack is the analyst targeting during this evaluation?

VLAN hopping
DHCP spoofing
MAC address table overflow*
VLAN double-tagging

### 8. Refer to the exhibit. A network administrator is configuring a router as a DHCPv6 server. The administrator issues a show ipv6 dhcp pool command to verify the configuration. Which statement explains the reason that the number of active clients is 0?

The default gateway address is not provided in the pool.
No clients have communicated with the DHCPv6 server yet.
The IPv6 DHCP pool configuration has no IPv6 address range specified.
The state is not maintained by the DHCPv6 server under stateless DHCPv6 operation.*

### 9. Refer to the exhibit. A network administrator configured routers R1 and R2 as part of HSRP group 1. After the routers have been reloaded, a user on Host1 complained of lack of connectivity to the Internet The network administrator issued the show standby brief command on both routers to verify the HSRP operations. In addition, the administrator observed the ARP table on Host1. Which entry should be seen in the ARP table on Host1 in order to gain connectivity to the Internet?

the virtual IP address and the virtual MAC address for the HSRP group 1*
the virtual IP address of the HSRP group 1 and the MAC address of R1
the virtual IP address of the HSRP group 1 and the MAC address of R2

### 11. Which statement is correct about how a Layer 2 switch determines how to forward frames?

Frame forwarding decisions are based on MAC address and port mappings in the CAM table.*
Only frames with a broadcast destination address are forwarded out all active switch ports.
Cut-through frame forwarding ensures that invalid frames are always dropped.

### 12. Which statement describes a result after multiple Cisco LAN switches are interconnected?

The broadcast domain expands to all switches.*
One collision domain exists per switch.
There is one broadcast domain and one collision domain per switch.
Frame collisions increase on the segments connecting the switches.
Unicast frames are always forwarded regardless of the destination MAC address.

### 14. Refer to the exhibit. How is a frame sent from PCA forwarded to PCC if the MAC address table on switch SW1 is empty?

SW1 forwards the frame directly to SW2. SW2 floods the frame to all ports connected to SW2, excluding the port through which the frame entered the switch.
SW1 floods the frame on all ports on the switch, excluding the interconnected port to switch SW2 and the port through which the frame entered the switch.
SW1 floods the frame on all ports on SW1, excluding the port through which the frame entered the switch.*
SW1 drops the frame because it does not know the destination MAC address.

### 15. An administrator is trying to remove configurations from a switch. After using the command erase startup-config and reloading the switch, the administrator finds that VLANs 10 and 100 still exist on the switch. Why were these VLANs not removed?

Because these VLANs are stored in a file that is called vlan.dat that is located in flash memory, this file must be manually deleted.*
These VLANs cannot be deleted unless the switch is in VTP client mode.
These VLANs are default VLANs that cannot be removed.
These VLANs can only be removed from the switch by using the no vlan 10 and no vlan 100 commands.

### 17. Refer to the exhibit. A network administrator has connected two switches together using EtherChannel technology. If STP is running, what will be the end result?

STP will block one of the redundant links.*
The switches will load balance and utilize both EtherChannels to forward packets.
The resulting loop will create a broadcast storm.
Both port channels will shutdown.

### 18. What is a secure configuration option for remote access to a network device?

Configure an ACL and apply it to the VTY lines.
Configure 802.1x.
Configure SSH.*
Configure Telnet.

### 19. Which wireless encryption method is the most secure?

WPA2 with AES*
WPA2 with TKIP
WEP
WPA

### 20. After attaching four PCs to the switch ports, configuring the SSID and setting authentication properties for a small office network, a technician successfully tests the connectivity of all PCs that are connected to the switch and WLAN. A firewall is then configured on the device prior to connecting it to the Internet. What type of network device includes all of the described features?

firewall appliance
wireless router*
switch
standalone wireless access point

### 21. Refer to the exhibit. Host A has sent a packet to host B. What will be the source MAC and IP addresses on the packet when it arrives at host B?

Source MAC: 00E0.FE91.7799 Source IP: 10.1.1.10**
Source MAC: 00E0.FE10.17A3 Source IP: 10.1.1.10
Source MAC: 00E0.FE10.17A3 Source IP: 192.168.1.1
Source MAC: 00E0.FE91.7799 Source IP: 10.1.1.1
Source MAC: 00E0.FE91.7799 Source IP: 192.168.1.1

### 22. Refer to the exhibit. Which static route would an IT technician enter to create a backup route to the 172.16.1.0 network that is only used if the primary RIP learned route fails?

ip route 172.16.1.0 255.255.255.0 s0/0/0
ip route 172.16.1.0 255.255.255.0 s0/0/0 91
ip route 172.16.1.0 255.255.255.0 s0/0/0 121*
ip route 172.16.1.0 255.255.255.0 s0/0/0 111

### 23. Refer to the exhibit. In addition to static routes directing traffic to networks 10.10.0.0/16 and 10.20.0.0/16, Router HQ is also configured with the following command: ip route 0.0.0.0 0.0.0.0 serial 0/1/1. What is the purpose of this command?

Packets that are received from the Internet will be forwarded to one of the LANs connected to R1 or R2.
Packets with a destination network that is not 10.10.0.0/16 or is not 10.20.0.0/16 or is not a directly connected network will be forwarded to the Internet.*
Packets from the 10.10.0.0/16 network will be forwarded to network 10.20.0.0/16, and packets from the 10.20.0.0/16 network will be forwarded to network 10.10.0.0/16.
Packets that are destined for networks that are not in the routing table of HQ will be dropped.

### 24. What protocol or technology disables redundant paths to eliminate Layer 2 loops?

VTP
STP*
EtherChannel
DTP

### 25. Refer to the exhibit. Based on the exhibited configuration and output, why is VLAN 99 missing?

because VLAN 99 is not a valid management VLAN
because there is a cabling problem on VLAN 99
because VLAN 1 is up and there can only be one management VLAN on the switch
because VLAN 99 has not yet been created*

### 26. Which two VTP modes allow for the creation, modification, and deletion of VLANs on the local switch? (Choose two.)

client
master
distribution
slave
server*
transparent*

### 27. Which three steps should be taken before moving a Cisco switch to a new VTP management domain? (Choose three.)

Configure the switch with the name of the new management domain.*
Reset the VTP counters to allow the switch to synchronize with the other switches in the domain.
Configure the VTP server in the domain to recognize the BID of the new switch.
Download the VTP database from the VTP server in the new domain.
Select the correct VTP mode and version.*
Reboot the switch.*

### 28. A network administrator is preparing the implementation of Rapid PVST+ on a production network. How are the Rapid PVST+ link types determined on the switch interfaces?

Link types can only be configured on access ports configured with a single VLAN.
Link types can only be determined if PortFast has been configured.
Link types are determined automatically.*
Link types must be configured with specific port configuration commands.

### 29. Refer to the exhibit. All the displayed switches are Cisco 2960 switches with the same default priority and operating at the same bandwidth. Which three ports will be STP designated ports? (Choose three.)

fa0/9
fa0/13*
fa0/10*
fa0/20
fa0/21*
fa0/11

### 30. How will a router handle static routing differently if Cisco Express Forwarding is disabled?

It will not perform recursive lookups.
Ethernet multiaccess interfaces will require fully specified static routes to avoid routing inconsistencies.*
Static routes that use an exit interface will be unnecessary.
Serial point-to-point interfaces will require fully specified static routes to avoid routing inconsistencies.

### 31. Compared with dynamic routes, what are two advantages of using static routes on a router? (Choose two.)

They improve netw​ork security.*
They take less time to converge when the network topology changes.
They improve the efficiency of discovering neighboring networks.
They use fewer router resources.*

### 32. Refer to the exhibit. Which route was configured as a static route to a specific network using the next-hop address?

S 10.17.2.0/24 [1/0] via 10.16.2.2*
S 0.0.0.0/0 [1/0] via 10.16.2.2
S 10.17.2.0/24 is directly connected, Serial 0/0/0
C 10.16.2.0/24 is directly connected, Serial0/0/0

### 33. What is the effect of entering the spanning-tree portfast configuration command on a switch?

It disables an unused port.
It disables all trunk ports.
It enables portfast on a specific switch interface.*
It checks the source L2 address in the Ethernet header against the sender L2 address in the ARP body.

### 34. What is the IPv6 prefix that is used for link-local addresses?

FF01::/8
2001::/3
FC00::/7
FE80::/10*

### 35. Which two statements are characteristics of routed ports on a multilayer switch? (Choose two.)​

In a switched network, they are mostly configured between switches at the core and distribution layers.*
The interface vlan command has to be entered to create a VLAN on routed ports.
They support subinterfaces, like interfaces on the Cisco IOS routers.
They are used for point-to-multipoint links.
They are not associated with a particular VLAN.*

### 36. Successful inter-VLAN routing has been operating on a network with multiple VLANs across multiple switches for some time. When an inter-switch trunk link fails and Spanning Tree Protocol brings up a backup trunk link, it is reported that hosts on two VLANs can access some, but not all the network resources that could be accessed previously. Hosts on all other VLANS do not have this problem. What is the most likely cause of this problem?

The protected edge port function on the backup trunk interfaces has been disabled.*
The allowed VLANs on the backup link were not configured correctly.
Dynamic Trunking Protocol on the link has failed.
Inter-VLAN routing also failed when the trunk link failed.

### 37. Which command will start the process to bundle two physical interfaces to create an EtherChannel group via LACP?

interface port-channel 2
channel-group 1 mode desirable
interface range GigabitEthernet 0/4 – 5*
channel-group 2 mode auto

### 38. What action takes place when a frame entering a switch has a multicast destination MAC address?

The switch will forward the frame out all ports except the incoming port.
The switch forwards the frame out of the specified port.
The switch adds a MAC address table entry mapping for the destination MAC address and the ingress port.*
The switch replaces the old entry and uses the more current port.

### 39. A junior technician was adding a route to a LAN router. A traceroute to a device on the new network revealed a wrong path and unreachable status. What should be done or checked?

Verify that there is not a default route in any of the edge router routing tables.
Check the configuration on the floating static route and adjust the AD.
Create a floating static route to that network.
Check the configuration of the exit interface on the new static route.*

### 40. Select the three PAgP channel establishment modes. (Choose three.)

Auto*
default
passive
desirable*
extended
on*

### 41. A static route has been configured on a router. However, the destination network no longer exists. What should an administrator do to remove the static route from the routing table?

Remove the route using the no ip route command.*
Change the administrative distance for that route.
Change the routing metric for that route.
Nothing. The static route will go away on its own.

### 42. Refer to the exhibit. What can be concluded about the configuration shown on R1?

R1 is configured as a DHCPv4 relay agent.*
R1 is operating as a DHCPv4 server.
R1 will broadcast DHCPv4 requests on behalf of local DHCPv4 clients.
R1 will send a message to a local DHCPv4 client to contact a DHCPv4 server at 10.10.10.8.

### 43.Refer to the exhibit. A network administrator has added a new subnet to the network and needs hosts on that subnet to receive IPv4 addresses from the DHCPv4 server. What two commands will allow hosts on the new subnet to receive addresses from the DHCP4 server? (Choose two.)

R1(config-if)# ip helper-address 10.1.0.254
R1(config)# interface G0/0*
R1(config-if)# ip helper-address 10.2.0.250*
R1(config)# interface G0/1
R2(config-if)# ip helper-address 10.2.0.250
R2(config)# interface G0/0

### 44. Refer to the exhibit. R1 has been configured as shown. However, PC1 is not able to receive an IPv4 address. What is the problem?​

The ip helper-address command was applied on the wrong interface.*
R1 is not configured as a DHCPv4 server.​
A DHCP server must be installed on the same LAN as the host that is receiving the IP address.
The ip address dhcp command was not issued on the interface Gi0/1.

### 45. What two default wireless router settings can affect network security? (Choose two.)

The SSID is broadcast.*
MAC address filtering is enabled.
WEP encryption is enabled.
The wireless channel is automatically selected.
A well-known administrator password is set.*

### 46. What is the common term given to SNMP log messages that are generated by network devices and sent to the SNMP server?

Traps*
acknowledgments
auditing
warnings

### 47. A network administrator is adding a new WLAN on a Cisco 3500 series WLC. Which tab should the administrator use to create a new VLAN interface to be used for the new WLAN?

WIRELESS
MANAGEMENT
CONTROLLER*
WLANs

### 48. A network administrator is configuring a WLAN. Why would the administrator change the default DHCP IPv4 addresses on an AP?

to restrict access to the WLAN by authorized, authenticated users only*
to monitor the operation of the wireless network
to reduce outsiders intercepting data or accessing the wireless network by using a well-known address range
to reduce the risk of interference by external devices such as microwave ovens

### 49. Which two functions are performed by a WLC when using split media access control (MAC)? (Choose two.)

packet acknowledgments and retransmissions
frame queuing and packet prioritization
beacons and probe responses
frame translation to other protocols*
association and re-association of roaming clients*

### 50. On what switch ports should BPDU guard be enabled to enhance STP stability?

all PortFast-enabled ports*
only ports that are elected as designated ports
only ports that attach to a neighboring switch
all trunk ports that are not root ports

### 51. Which network attack is mitigated by enabling BPDU guard?

rogue switches on a network*
CAM table overflow attacks
MAC address spoofing
rogue DHCP servers on a network

### 52. Why is DHCP snooping required when using the Dynamic ARP Inspection feature?

It relies on the settings of trusted and untrusted ports set by DHCP snooping.
It uses the MAC address table to verify the default gateway IP address.
It redirects ARP requests to the DHCP server for verification.
It uses the MAC-address-to-IP-address binding database to validate an ARP packet.*

### 53. Refer to the exhibit. Router R1 has an OSPF neighbor relationship with the ISP router over the 192.168.0.32 network. The 192.168.0.36 network link should serve as a backup when the OSPF link goes down. The floating static route command ip route 0.0.0.0 0.0.0.0 S0/0/1 100 was issued on R1 and now traffic is using the backup link even when the OSPF link is up and functioning. Which change should be made to the static route command so that traffic will only use the OSPF link when it is up?​

Change the administrative distance to 120.*
Add the next hop neighbor address of 192.168.0.36.
Change the destination network to 192.168.0.34.
Change the administrative distance to 1.

### 54. Refer to the exhibit. What is the metric to forward a data packet with the IPv6 destination address 2001:DB8:ACAD:E:240:BFF:FED4:9DD2?

90
128
2170112
2681856
2682112*
3193856

### 55. A network administrator is configuring a new Cisco switch for remote management access. Which three items must be configured on the switch for the task? (Choose three.)

IP address*
VTP domain
vty lines*
default VLAN
default Gateway*
loopback address

### 56. Refer to the exhibit. Which statement shown in the output allows router R1 to respond to stateless DHCPv6 requests?

ipv6 nd other-config-flag*
​prefix-delegation 2001:DB8:8::/48 00030001000E84244E70​
ipv6 dhcp server LAN1​
ipv6 unicast-routing
dns-server 2001:DB8:8::8​

### 57. Refer to the exhibit. A Layer 3 switch routes for three VLANs and connects to a router for Internet connectivity. Which two configurations would be applied to the switch? (Choose two.)

(config)# interface gigabitethernet1/1
(config-if)# switchport mode trunk

(config)# interface gigabitethernet 1/1
(config-if)# no switchport
(config-if)# ip address 192.168.1.2 255.255.255.252***

(config)# interface vlan 1
(config-if)# ip address 192.168.1.2 255.255.255.0
(config-if)# no shutdown

(config)# interface fastethernet0/4
(config-if)# switchport mode trunk

(config)# ip routing*

### 58. A technician is troubleshooting a slow WLAN and decides to use the split-the-traffic approach. Which two parameters would have to be configured to do this? (Choose two.)

Configure the 5 GHz band for streaming multimedia and time sensitive traffic.*
Configure the security mode to WPA Personal TKIP/AES for one network and WPA2 Personal AES for the other network
Configure the 2.4 GHz band for basic internet traffic that is not time sensitive.*
Configure the security mode to WPA Personal TKIP/AES for both networks.
Configure a common SSID for both split networks.

### 59. A company has just switched to a new ISP. The ISP has completed and checked the connection from its site to the company. However, employees at the company are not able to access the internet. What should be done or checked?

Verify that the static route to the server is present in the routing table.
Check the configuration on the floating static route and adjust the AD.
Ensure that the old default route has been removed from the company edge routers.*
Create a floating static route to that network.

### 60. Which information does a switch use to populate the MAC address table?

the destination MAC address and the incoming port
the destination MAC address and the outgoing port
the source and destination MAC addresses and the incoming port
the source and destination MAC addresses and the outgoing port
the source MAC address and the incoming port*
the source MAC address and the outgoing port
