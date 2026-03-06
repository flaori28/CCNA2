const quizData = {
     1: [
        {
            question: "Refer to the exhibit. What will router R1 do with a packet that has a destination IPv6 address of 2001:db8:cafe:5::1?",
            options: { a: "forward the packet out GigabitEthernet0/0", b: "drop the packet", c: "forward the packet out GigabitEthernet0/1", d: "forward the packet out Serial0/0/0" },
            correct: "d"
        },
        {
            question: "Refer to the exhibit. Currently router R1 uses an EIGRP route learned from Branch2 to reach the 10.10.0.0/16 network. Which floating static route would create a backup route to the 10.10.0.0/16 network in the event that the link between R1 and Branch2 goes down?",
            options: { a: "ip route 10.10.0.0 255.255.0.0 Serial 0/0/0 100", b: "ip route 10.10.0.0 255.255.0.0 209.165.200.226 100", c: "ip route 10.10.0.0 255.255.0.0 209.165.200.225 100", d: "ip route 10.10.0.0 255.255.0.0 209.165.200.225 50" },
            correct: "c"
        },
        {
            question: "Refer to the exhibit. R1 was configured with the static route command ip route 209.165.200.224 255.255.255.224 S0/0/0 and consequently users on network 172.16.0.0/16 are unable to reach resources on the Internet. How should this static route be changed to allow user traffic from the LAN to reach the Internet?",
            options: { a: "Add an administrative distance of 254.", b: "Change the destination network and mask to 0.0.0.0 0.0.0.0", c: "Change the exit interface to S0/0/1.", d: "Add the next-hop neighbor address of 209.165.200.226." },
            correct: "b"
        },
        {
            question: "Which option shows a correctly configured IPv4 default static route?",
            options: { a: "ip route 0.0.0.0 255.255.255.0 S0/0/0", b: "ip route 0.0.0.0 0.0.0.0 S0/0/0", c: "ip route 0.0.0.0 255.255.255.255 S0/0/0", d: "ip route 0.0.0.0 255.0.0.0 S0/0/0" },
            correct: "b"
        },
        {
            question: "Refer to the exhibit. Which static route command can be entered on R1 to forward traffic to the LAN connected to R2?",
            options: { a: "ipv6 route 2001:db8:12:10::/64 S0/0/0", b: "ipv6 route 2001:db8:12:10::/64 S0/0/1 fe80::2", c: "ipv6 route 2001:db8:12:10::/64 S0/0/0 fe80::2", d: "ipv6 route 2001:db8:12:10::/64 S0/0/1 2001:db8:12:10::1" },
            correct: "b"
        },
        {
            question: "What is a method to launch a VLAN hopping attack?",
            options: { a: "introducing a rogue switch and enabling trunking", b: "sending spoofed native VLAN information", c: "sending spoofed IP addresses from the attacking host", d: "flooding the switch with MAC addresses" },
            correct: "a"
        },
        {
            question: "A cybersecurity analyst is using the macof tool to evaluate configurations of switches deployed in the backbone network of an organization. Which type of LAN attack is the analyst targeting during this evaluation?",
            options: { a: "VLAN hopping", b: "DHCP spoofing", c: "MAC address table overflow", d: "VLAN double-tagging" },
            correct: "c"
        },
        {
            question: "Refer to the exhibit. A network administrator is configuring a router as a DHCPv6 server. The administrator issues a show ipv6 dhcp pool command to verify the configuration. Which statement explains the reason that the number of active clients is 0?",
            options: { a: "The default gateway address is not provided in the pool.", b: "No clients have communicated with the DHCPv6 server yet.", c: "The IPv6 DHCP pool configuration has no IPv6 address range specified.", d: "The state is not maintained by the DHCPv6 server under stateless DHCPv6 operation." },
            correct: "d"
        },
        {
            question: "Refer to the exhibit. A network administrator configured routers R1 and R2 as part of HSRP group 1. After the routers have been reloaded, a user on Host1 complained of lack of connectivity to the Internet The network administrator issued the show standby brief command on both routers to verify the HSRP operations. In addition, the administrator observed the ARP table on Host1. Which entry should be seen in the ARP table on Host1 in order to gain connectivity to the Internet?",
            options: { a: "the virtual IP address and the virtual MAC address for the HSRP group 1", b: "the virtual IP address of the HSRP group 1 and the MAC address of R1", c: "the virtual IP address of the HSRP group 1 and the MAC address of R2" },
            correct: "a"
        },
        {
            question: "Which statement is correct about how a Layer 2 switch determines how to forward frames?",
            options: { a: "Frame forwarding decisions are based on MAC address and port mappings in the CAM table.", b: "Only frames with a broadcast destination address are forwarded out all active switch ports.", c: "Cut-through frame forwarding ensures that invalid frames are always dropped." },
            correct: "a"
        }
    ],
     2: [
        {
            question: "Which statement describes a result after multiple Cisco LAN switches are interconnected?",
            options: { a: "The broadcast domain expands to all switches.", b: "One collision domain exists per switch.", c: "There is one broadcast domain and one collision domain per switch.", d: "Frame collisions increase on the segments connecting the switches.", e: "Unicast frames are always forwarded regardless of the destination MAC address." },
            correct: "a"
        },
        {
            question: "Refer to the exhibit. How is a frame sent from PCA forwarded to PCC if the MAC address table on switch SW1 is empty?",
            options: { a: "SW1 forwards the frame directly to SW2. SW2 floods the frame to all ports connected to SW2, excluding the port through which the frame entered the switch.", b: "SW1 floods the frame on all ports on the switch, excluding the interconnected port to switch SW2 and the port through which the frame entered the switch.", c: "SW1 floods the frame on all ports on SW1, excluding the port through which the frame entered the switch.", d: "SW1 drops the frame because it does not know the destination MAC address." },
            correct: "c"
        },
        {
            question: "An administrator is trying to remove configurations from a switch. After using the command erase startup-config and reloading the switch, the administrator finds that VLANs 10 and 100 still exist on the switch. Why were these VLANs not removed?",
            options: { a: "Because these VLANs are stored in a file that is called vlan.dat that is located in flash memory, this file must be manually deleted.", b: "These VLANs cannot be deleted unless the switch is in VTP client mode.", c: "These VLANs are default VLANs that cannot be removed.", d: "These VLANs can only be removed from the switch by using the no vlan 10 and no vlan 100 commands." },
            correct: "a"
        },
        {
            question: "Refer to the exhibit. A network administrator has connected two switches together using EtherChannel technology. If STP is running, what will be the end result?",
            options: { a: "STP will block one of the redundant links.", b: "The switches will load balance and utilize both EtherChannels to forward packets.", c: "The resulting loop will create a broadcast storm.", d: "Both port channels will shutdown." },
            correct: "a"
        },
        {
            question: "What is a secure configuration option for remote access to a network device?",
            options: { a: "Configure an ACL and apply it to the VTY lines.", b: "Configure 802.1x.", c: "Configure SSH.", d: "Configure Telnet." },
            correct: "c"
        },
        {
            question: "Which wireless encryption method is the most secure?",
            options: { a: "WPA2 with AES", b: "WPA2 with TKIP", c: "WEP", d: "WPA" },
            correct: "a"
        },
        {
            question: "After attaching four PCs to the switch ports, configuring the SSID and setting authentication properties for a small office network, a technician successfully tests the connectivity of all PCs that are connected to the switch and WLAN. A firewall is then configured on the device prior to connecting it to the Internet. What type of network device includes all of the described features?",
            options: { a: "firewall appliance", b: "wireless router", c: "switch", d: "standalone wireless access point" },
            correct: "b"
        },
        {
            question: "Refer to the exhibit. Host A has sent a packet to host B. What will be the source MAC and IP addresses on the packet when it arrives at host B?",
            options: { a: "Source MAC: 00E0.FE91.7799 Source IP: 10.1.1.10", b: "Source MAC: 00E0.FE10.17A3 Source IP: 10.1.1.10", c: "Source MAC: 00E0.FE10.17A3 Source IP: 192.168.1.1", d: "Source MAC: 00E0.FE91.7799 Source IP: 10.1.1.1", e: "Source MAC: 00E0.FE91.7799 Source IP: 192.168.1.1" },
            correct: "d"
        },
        {
            question: "Refer to the exhibit. Which static route would an IT technician enter to create a backup route to the 172.16.1.0 network that is only used if the primary RIP learned route fails?",
            options: { a: "ip route 172.16.1.0 255.255.255.0 s0/0/0", b: "ip route 172.16.1.0 255.255.255.0 s0/0/0 91", c: "ip route 172.16.1.0 255.255.255.0 s0/0/0 121", d: "ip route 172.16.1.0 255.255.255.0 s0/0/0 111" },
            correct: "c"
        },
        {
            question: "Refer to the exhibit. In addition to static routes directing traffic to networks 10.10.0.0/16 and 10.20.0.0/16, Router HQ is also configured with the following command: ip route 0.0.0.0 0.0.0.0 serial 0/1/1. What is the purpose of this command?",
            options: { a: "Packets that are received from the Internet will be forwarded to one of the LANs connected to R1 or R2.", b: "Packets with a destination network that is not 10.10.0.0/16 or is not 10.20.0.0/16 or is not a directly connected network will be forwarded to the Internet.", c: "Packets from the 10.10.0.0/16 network will be forwarded to network 10.20.0.0/16, and packets from the 10.20.0.0/16 network will be forwarded to network 10.10.0.0/16.", d: "Packets that are destined for networks that are not in the routing table of HQ will be dropped." },
            correct: "b"
        }
    ],
     3: [
        {
            question: "What protocol or technology disables redundant paths to eliminate Layer 2 loops?",
            options: { a: "VTP", b: "STP", c: "EtherChannel", d: "DTP" },
            correct: "b"
        },
        {
            question: "Refer to the exhibit. Based on the exhibited configuration and output, why is VLAN 99 missing?",
            options: { a: "because VLAN 99 is not a valid management VLAN", b: "because there is a cabling problem on VLAN 99", c: "because VLAN 1 is up and there can only be one management VLAN on the switch", d: "because VLAN 99 has not yet been created" },
            correct: "d"
        },
        {
            question: "Which two VTP modes allow for the creation, modification, and deletion of VLANs on the local switch? (Choose two.)",
            options: { a: "client", b: "master", c: "distribution", d: "slave", e: "server", f: "transparent" },
            correct: "e"
        },
        {
            question: "Which three steps should be taken before moving a Cisco switch to a new VTP management domain? (Choose three.)",
            options: { a: "Configure the switch with the name of the new management domain.", b: "Reset the VTP counters to allow the switch to synchronize with the other switches in the domain.", c: "Configure the VTP server in the domain to recognize the BID of the new switch.", d: "Download the VTP database from the VTP server in the new domain.", e: "Select the correct VTP mode and version.", f: "Reboot the switch." },
            correct: "a"
        },
        {
            question: "A network administrator is preparing the implementation of Rapid PVST+ on a production network. How are the Rapid PVST+ link types determined on the switch interfaces?",
            options: { a: "Link types can only be configured on access ports configured with a single VLAN.", b: "Link types can only be determined if PortFast has been configured.", c: "Link types are determined automatically.", d: "Link types must be configured with specific port configuration commands." },
            correct: "c"
        },
        {
            question: "Refer to the exhibit. All the displayed switches are Cisco 2960 switches with the same default priority and operating at the same bandwidth. Which three ports will be STP designated ports? (Choose three.)",
            options: { a: "fa0/9", b: "fa0/13", c: "fa0/10", d: "fa0/20", e: "fa0/21", f: "fa0/11" },
            correct: "b"
        },
        {
            question: "How will a router handle static routing differently if Cisco Express Forwarding is disabled?",
            options: { a: "It will not perform recursive lookups.", b: "Ethernet multiaccess interfaces will require fully specified static routes to avoid routing inconsistencies.", c: "Static routes that use an exit interface will be unnecessary.", d: "Serial point-to-point interfaces will require fully specified static routes to avoid routing inconsistencies." },
            correct: "b"
        },
        {
            question: "Compared with dynamic routes, what are two advantages of using static routes on a router? (Choose two.)",
            options: { a: "They improve netw​ork security.", b: "They take less time to converge when the network topology changes.", c: "They improve the efficiency of discovering neighboring networks.", d: "They use fewer router resources." },
            correct: "a"
        },
        {
            question: "Refer to the exhibit. Which route was configured as a static route to a specific network using the next-hop address?",
            options: { a: "S 10.17.2.0/24 [1/0] via 10.16.2.2", b: "S 0.0.0.0/0 [1/0] via 10.16.2.2", c: "S 10.17.2.0/24 is directly connected, Serial 0/0/0", d: "C 10.16.2.0/24 is directly connected, Serial0/0/0" },
            correct: "a"
        },
        {
            question: "What is the effect of entering the spanning-tree portfast configuration command on a switch?",
            options: { a: "It disables an unused port.", b: "It disables all trunk ports.", c: "It enables portfast on a specific switch interface.", d: "It checks the source L2 address in the Ethernet header against the sender L2 address in the ARP body." },
            correct: "c"
        }
    ],
     4: [
        {
            question: "What is the IPv6 prefix that is used for link-local addresses?",
            options: { a: "FF01::/8", b: "2001::/3", c: "FC00::/7", d: "FE80::/10" },
            correct: "d"
        },
        {
            question: "Which two statements are characteristics of routed ports on a multilayer switch? (Choose two.)​",
            options: { a: "In a switched network, they are mostly configured between switches at the core and distribution layers.", b: "The interface vlan command has to be entered to create a VLAN on routed ports.", c: "They support subinterfaces, like interfaces on the Cisco IOS routers.", d: "They are used for point-to-multipoint links.", e: "They are not associated with a particular VLAN." },
            correct: "a"
        },
        {
            question: "Successful inter-VLAN routing has been operating on a network with multiple VLANs across multiple switches for some time. When an inter-switch trunk link fails and Spanning Tree Protocol brings up a backup trunk link, it is reported that hosts on two VLANs can access some, but not all the network resources that could be accessed previously. Hosts on all other VLANS do not have this problem. What is the most likely cause of this problem?",
            options: { a: "The protected edge port function on the backup trunk interfaces has been disabled.", b: "The allowed VLANs on the backup link were not configured correctly.", c: "Dynamic Trunking Protocol on the link has failed.", d: "Inter-VLAN routing also failed when the trunk link failed." },
            correct: "a"
        },
        {
            question: "Which command will start the process to bundle two physical interfaces to create an EtherChannel group via LACP?",
            options: { a: "interface port-channel 2", b: "channel-group 1 mode desirable", c: "interface range GigabitEthernet 0/4 – 5", d: "channel-group 2 mode auto" },
            correct: "c"
        },
        {
            question: "What action takes place when a frame entering a switch has a multicast destination MAC address?",
            options: { a: "The switch will forward the frame out all ports except the incoming port.", b: "The switch forwards the frame out of the specified port.", c: "The switch adds a MAC address table entry mapping for the destination MAC address and the ingress port.", d: "The switch replaces the old entry and uses the more current port." },
            correct: "c"
        },
        {
            question: "A junior technician was adding a route to a LAN router. A traceroute to a device on the new network revealed a wrong path and unreachable status. What should be done or checked?",
            options: { a: "Verify that there is not a default route in any of the edge router routing tables.", b: "Check the configuration on the floating static route and adjust the AD.", c: "Create a floating static route to that network.", d: "Check the configuration of the exit interface on the new static route." },
            correct: "d"
        },
        {
            question: "Select the three PAgP channel establishment modes. (Choose three.)",
            options: { a: "Auto", b: "default", c: "passive", d: "desirable", e: "extended", f: "on" },
            correct: "a"
        },
        {
            question: "A static route has been configured on a router. However, the destination network no longer exists. What should an administrator do to remove the static route from the routing table?",
            options: { a: "Remove the route using the no ip route command.", b: "Change the administrative distance for that route.", c: "Change the routing metric for that route.", d: "Nothing. The static route will go away on its own." },
            correct: "a"
        },
        {
            question: "Refer to the exhibit. What can be concluded about the configuration shown on R1?",
            options: { a: "R1 is configured as a DHCPv4 relay agent.", b: "R1 is operating as a DHCPv4 server.", c: "R1 will broadcast DHCPv4 requests on behalf of local DHCPv4 clients.", d: "R1 will send a message to a local DHCPv4 client to contact a DHCPv4 server at 10.10.10.8." },
            correct: "a"
        },
        {
            question: "Refer to the exhibit. A network administrator has added a new subnet to the network and needs hosts on that subnet to receive IPv4 addresses from the DHCPv4 server. What two commands will allow hosts on the new subnet to receive addresses from the DHCP4 server? (Choose two.)",
            options: { a: "R1(config-if)# ip helper-address 10.1.0.254", b: "R1(config)# interface G0/0", c: "R1(config-if)# ip helper-address 10.2.0.250", d: "R1(config)# interface G0/1", e: "R2(config-if)# ip helper-address 10.2.0.250", f: "R2(config)# interface G0/0" },
            correct: "b"
        }
    ],
     5: [
        {
            question: "Refer to the exhibit. R1 has been configured as shown. However, PC1 is not able to receive an IPv4 address. What is the problem?​",
            options: { a: "The ip helper-address command was applied on the wrong interface.", b: "R1 is not configured as a DHCPv4 server.​", c: "A DHCP server must be installed on the same LAN as the host that is receiving the IP address.", d: "The ip address dhcp command was not issued on the interface Gi0/1." },
            correct: "a"
        },
        {
            question: "What two default wireless router settings can affect network security? (Choose two.)",
            options: { a: "The SSID is broadcast.", b: "MAC address filtering is enabled", c: "WEP encryption is enabled.", d: "The wireless channel is automatically selected.", e: "A well-known administrator password is set." },
            correct: "a"
        },
        {
            question: "What is the common term given to SNMP log messages that are generated by network devices and sent to the SNMP server?",
            options: { a: "Traps", b: "acknowledgments", c: "auditing", d: "warnings" },
            correct: "a"
        },
        {
            question: "A network administrator is adding a new WLAN on a Cisco 3500 series WLC. Which tab should the administrator use to create a new VLAN interface to be used for the new WLAN?",
            options: { a: "WIRELESS", b: "MANAGEMENT", c: "CONTROLLER", d: "WLANs" },
            correct: "c"
        },
        {
            question: "A network administrator is configuring a WLAN. Why would the administrator change the default DHCP IPv4 addresses on an AP?",
            options: { a: "to restrict access to the WLAN by authorized, authenticated users only", b: "to monitor the operation of the wireless network", c: "to reduce outsiders intercepting data or accessing the wireless network by using a well-known address range", d: "to reduce the risk of interference by external devices such as microwave ovens" },
            correct: "a"
        },
        {
            question: "Which two functions are performed by a WLC when using split media access control (MAC)? (Choose two.)",
            options: { a: "packet acknowledgments and retransmissions", b: "frame queuing and packet prioritization", c: "beacons and probe responses", d: "frame translation to other protocols", e: "association and re-association of roaming clients" },
            correct: "d"
        },
        {
            question: "On what switch ports should BPDU guard be enabled to enhance STP stability?",
            options: { a: "all PortFast-enabled ports", b: "only ports that are elected as designated ports", c: "only ports that attach to a neighboring switch", d: "all trunk ports that are not root ports" },
            correct: "a"
        },
        {
            question: "Which network attack is mitigated by enabling BPDU guard?",
            options: { a: "rogue switches on a network", b: "CAM table overflow attacks", c: "MAC address spoofing", d: "rogue DHCP servers on a network" },
            correct: "a"
        },
        {
            question: "Why is DHCP snooping required when using the Dynamic ARP Inspection feature?",
            options: { a: "It relies on the settings of trusted and untrusted ports set by DHCP snooping.", b: "It uses the MAC address table to verify the default gateway IP address.", c: "It redirects ARP requests to the DHCP server for verification.", d: "It uses the MAC-address-to-IP-address binding database to validate an ARP packet." },
            correct: "d"
        },
        {
            question: "Refer to the exhibit. Router R1 has an OSPF neighbor relationship with the ISP router over the 192.168.0.32 network. The 192.168.0.36 network link should serve as a backup when the OSPF link goes down. The floating static route command ip route 0.0.0.0 0.0.0.0 S0/0/1 100 was issued on R1 and now traffic is using the backup link even when the OSPF link is up and functioning. Which change should be made to the static route command so that traffic will only use the OSPF link when it is up?​",
            options: { a: "Change the administrative distance to 120.", b: "Add the next hop neighbor address of 192.168.0.36.", c: "Change the destination network to 192.168.0.34.", d: "Change the administrative distance to 1." },
            correct: "a"
        }
    ],
     6: [
        {
            question: "Refer to the exhibit. What is the metric to forward a data packet with the IPv6 destination address 2001:DB8:ACAD:E:240:BFF:FED4:9DD2?",
            options: { a: "90", b: "128", c: "2170112", d: "2681856", e: "2682112", f: "3193856" },
            correct: "e"
        },
        {
            question: "A network administrator is configuring a new Cisco switch for remote management access. Which three items must be configured on the switch for the task? (Choose three.)",
            options: { a: "IP address", b: "VTP domain", c: "vty lines", d: "default VLAN", e: "default Gateway", f: "loopback address" },
            correct: "a"
        },
        {
            question: "Refer to the exhibit. Which statement shown in the output allows router R1 to respond to stateless DHCPv6 requests?",
            options: { a: "ipv6 nd other-config-flag", b: "​prefix-delegation 2001:DB8:8::/48 00030001000E84244E70​", c: "ipv6 dhcp server LAN1​", d: "ipv6 unicast-routing", e: "dns-server 2001:DB8:8::8​" },
            correct: "a"
        },
        {
            question: "Refer to the exhibit. A Layer 3 switch routes for three VLANs and connects to a router for Internet connectivity. Which two configurations would be applied to the switch? (Choose two.)",
            options: { a: "(config)# interface gigabitethernet1/1
(config-if)# switchport mode trunk", b: "(config)# interface gigabitethernet 1/1
(config-if)# no switchport
(config-if)# ip address 192.168.1.2 255.255.255.252**", c: "(config)# interface vlan 1
(config-if)# ip address 192.168.1.2 255.255.255.0
(config-if)# no shutdown", d: "(config)# interface fastethernet0/4
(config-if)# switchport mode trunk", e: "(config)# ip routing" },
            correct: "e"
        },
        {
            question: "A technician is troubleshooting a slow WLAN and decides to use the split-the-traffic approach. Which two parameters would have to be configured to do this? (Choose two.)",
            options: { a: "Configure the 5 GHz band for streaming multimedia and time sensitive traffic.", b: "Configure the security mode to WPA Personal TKIP/AES for one network and WPA2 Personal AES for the other network", c: "Configure the 2.4 GHz band for basic internet traffic that is not time sensitive.", d: "Configure the security mode to WPA Personal TKIP/AES for both networks.", e: "Configure a common SSID for both split networks." },
            correct: "a"
        },
        {
            question: "A company has just switched to a new ISP. The ISP has completed and checked the connection from its site to the company. However, employees at the company are not able to access the internet. What should be done or checked?",
            options: { a: "Verify that the static route to the server is present in the routing table.", b: "Check the configuration on the floating static route and adjust the AD.", c: "Ensure that the old default route has been removed from the company edge routers.", d: "Create a floating static route to that network." },
            correct: "c"
        },
        {
            question: "Which information does a switch use to populate the MAC address table?",
            options: { a: "the destination MAC address and the incoming port", b: "the destination MAC address and the outgoing port", c: "the source and destination MAC addresses and the incoming port", d: "the source and destination MAC addresses and the outgoing port", e: "the source MAC address and the incoming port", f: "the source MAC address and the outgoing port" },
            correct: "e"
        }
    ]
};

let currentSeries = 1;

// Fonctions principales
function startQuiz(seriesId) {
    currentSeries = seriesId;
    
    // UI Update
    document.getElementById('menu-container').classList.add('hidden');
    document.getElementById('quiz-form').classList.remove('hidden');
    document.getElementById('quiz-title').textContent = `Série d'entraînement N°${seriesId}`;
    
    // Reset previous results
    document.getElementById('result-area').classList.add('hidden');
    document.getElementById('result-msg').textContent = '';

    renderQuestions(seriesId);
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function showMenu() {
    document.getElementById('quiz-form').classList.add('hidden');
    document.getElementById('result-area').classList.add('hidden');
    document.getElementById('menu-container').classList.remove('hidden');
    
    // Clean up
    document.getElementById('questions-container').innerHTML = '';
}

function renderQuestions(seriesId) {
    const container = document.getElementById('questions-container');
    container.innerHTML = '';
    
    const questions = quizData[seriesId];
    
    if (!questions) {
        container.innerHTML = '<p>Série non disponible.</p>';
        return;
    }
    
    questions.forEach((q, index) => {
        const qNum = index + 1;
        const nameAttr = `q-${seriesId}-${index}`;

        const card = document.createElement('div');
        card.className = 'question-card';
        card.setAttribute('data-correct', q.correct);
        
        let optionsHtml = '';
        for (const [key, value] of Object.entries(q.options)) {
            optionsHtml += `
                <label class="option">
                    <input type="radio" name="${nameAttr}" value="${key}">
                    <span class="checkmark"></span>
                    ${value}
                </label>
            `;
        }

        card.innerHTML = `
            <div class="question-header">
                <span class="q-number">Q${qNum}.</span>
                <h3>${q.question}</h3>
            </div>
            <div class="options">
                ${optionsHtml}
            </div>
        `;
        container.appendChild(card);
    });
}

// Validation Logic
document.getElementById('submit-btn').addEventListener('click', function() {
    let score = 0;
    const questions = document.querySelectorAll('.question-card');
    const total = questions.length;

    questions.forEach(card => {
        const correctValue = card.getAttribute('data-correct');
        const options = card.querySelectorAll('.option');
        let answered = false;
        let isCorrect = false;

        // Reset styles first
        options.forEach(opt => opt.classList.remove('correct', 'incorrect'));

        options.forEach(option => {
            const input = option.querySelector('input');
            if (input.checked) {
                answered = true;
                if (input.value === correctValue) {
                    option.classList.add('correct');
                    isCorrect = true; 
                } else {
                    option.classList.add('incorrect');
                }
            }
        });
        
        // Show correct answer anyway
        options.forEach(option => {
             const input = option.querySelector('input');
             if (input.value === correctValue) {
                 option.classList.add('correct');
             }
        });

        if (isCorrect) score++;
    });

    // Display results
    const resultArea = document.getElementById('result-area');
    const scoreVal = document.getElementById('score-val');
    const totalVal = document.getElementById('total-val');
    const msg = document.getElementById('result-msg');

    scoreVal.textContent = score;
    totalVal.textContent = total;
    
    // Feedback message
    if (score === total) {
        msg.textContent = "Excellent ! Vous maîtrisez ce chapitre.";
        msg.style.color = "green";
    } else if (score >= total / 2) {
        msg.textContent = "Pas mal ! Encore quelques révisions.";
        msg.style.color = "orange";
    } else {
        msg.textContent = "Continuez vos efforts, relisez le cours.";
        msg.style.color = "red";
    }

    resultArea.classList.remove('hidden');
    
    // Scroll to result
    setTimeout(() => {
        resultArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }, 100);
});
