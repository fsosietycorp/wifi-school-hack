#!/data/data/com.termux/files/usr/bin/bash

# ============================================
# 🚀 WIFI SCHOOL TOOL - ULTIMATE FIXED VERSION
# 🎯 BY NESIA DARKNET
# 💀 TOR CONFLICT FIXED + SIMPLE MENU
# ============================================

# Warna
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
BLUE='\033[1;94m'
PURPLE='\033[1;95m'
CYAN='\033[1;96m'
NC='\033[0m'

clear_screen() {
    clear
}

show_header() {
    clear_screen
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   WIFI SCHOOL HACKER - FINAL EDITION   ║"
    echo "║         WORKING 100% 😈                ║"
    echo "╚════════════════════════════════════════╝${NC}"
    echo ""
}

# ============================================
# 🛠️ FUNGSI UTAMA
# ============================================

kill_existing_tor() {
    echo -e "${YELLOW}[+] Checking for existing TOR processes...${NC}"
    
    # Kill semua proses TOR
    pkill -9 tor 2>/dev/null
    pkill -9 -f "tor" 2>/dev/null
    
    # Kill proses yang menggunakan port 9050
    if command -v fuser &>/dev/null; then
        fuser -k 9050/tcp 2>/dev/null
    fi
    
    # Force kill dengan lsof jika ada
    if command -v lsof &>/dev/null; then
        lsof -ti:9050 | xargs kill -9 2>/dev/null
    fi
    
    sleep 2
    echo -e "${GREEN}[✓] Cleaned existing TOR processes${NC}"
}

setup_vpn_simple() {
    echo -e "${YELLOW}[+] VPN Setup...${NC}"
    
    # Install TOR jika belum ada
    if ! command -v tor &>/dev/null; then
        echo -e "${RED}[!] TOR not installed${NC}"
        echo -e "${GREEN}[+] Installing TOR...${NC}"
        pkg install tor -y
    fi
    
    # Kill existing TOR dulu
    kill_existing_tor
    
    # Start TOR sederhana
    echo -e "${YELLOW}[+] Starting TOR...${NC}"
    tor &
    TOR_PID=$!
    
    # Tunggu 10 detik
    echo -ne "${CYAN}[+] Waiting"
    for i in {1..10}; do
        sleep 1
        echo -ne "."
    done
    echo ""
    
    # Cek apakah TOR berjalan
    if ps -p $TOR_PID >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] TOR is running${NC}"
        return 0
    else
        echo -e "${RED}[✗] TOR failed to start${NC}"
        return 1
    fi
}

install_tools() {
    echo -e "${YELLOW}[+] Installing tools...${NC}"
    
    # Update packages
    pkg update -y
    
    # Install basic tools
    pkg install -y curl wget git python
    
    # Install hacking tools (opsional)
    echo -e "${CYAN}[+] Optional hacking tools:${NC}"
    echo "1. Install all tools"
    echo "2. Skip tools installation"
    read -p "Choice [1-2]: " tool_choice
    
    if [ "$tool_choice" = "1" ]; then
        echo -e "${GREEN}[+] Installing hacking tools...${NC}"
        pkg install -y aircrack-ng macchanger
        pip install scapy
    fi
    
    echo -e "${GREEN}[✓] Tools setup complete${NC}"
}

create_password_list() {
    echo -e "${YELLOW}[+] Creating password list...${NC}"
    
    cat > school_passwords.txt << 'EOF'
# Common School WiFi Passwords
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
EOF
    
    echo -e "${GREEN}[✓] Password list created: school_passwords.txt${NC}"
}

scan_wifi() {
    echo -e "${YELLOW}[+] Scanning WiFi networks...${NC}"
    
    if command -v termux-wifi-scaninfo &>/dev/null; then
        termux-wifi-scaninfo
    else
        echo -e "${RED}[!] termux-wifi-scaninfo not available${NC}"
        echo -e "${YELLOW}[+] Try:${NC}"
        echo "  pkg install termux-api"
        echo "  termux-wifi-enable"
    fi
}

change_mac() {
    echo -e "${YELLOW}[+] Changing MAC Address...${NC}"
    
    if command -v macchanger &>/dev/null; then
        ip link set wlan0 down 2>/dev/null
        macchanger -r wlan0
        ip link set wlan0 up 2>/dev/null
        echo -e "${GREEN}[✓] MAC Address changed${NC}"
    else
        echo -e "${RED}[!] macchanger not installed${NC}"
        echo -e "${YELLOW}[+] Install: pkg install macchanger${NC}"
    fi
}

check_vpn_status() {
    echo -e "${YELLOW}[+] VPN Status Check${NC}"
    
    # Cek proses TOR
    if ps aux | grep -v grep | grep -q tor; then
        echo -e "${GREEN}[✓] TOR process: RUNNING${NC}"
    else
        echo -e "${RED}[✗] TOR process: NOT RUNNING${NC}"
    fi
    
    # Cek port 9050
    if netstat -tuln 2>/dev/null | grep -q ":9050"; then
        echo -e "${GREEN}[✓] Port 9050: LISTENING${NC}"
    else
        echo -e "${RED}[✗] Port 9050: NOT LISTENING${NC}"
    fi
    
    # Tes koneksi
    echo -e "${CYAN}[+] Testing connection...${NC}"
    if curl --socks5-hostname 127.0.0.1:9050 --max-time 5 -s https://api.ipify.org; then
        echo -e "\n${GREEN}[✓] VPN connection: WORKING${NC}"
    else
        echo -e "\n${RED}[✗] VPN connection: FAILED${NC}"
    fi
}

show_commands() {
    echo -e "${YELLOW}[+] Useful Commands:${NC}"
    echo ""
    echo -e "${CYAN}WiFi Scanning:${NC}"
    echo "  termux-wifi-scaninfo"
    echo "  iwlist wlan0 scan"
    echo "  iw dev wlan0 scan"
    echo ""
    echo -e "${CYAN}Network Info:${NC}"
    echo "  ifconfig wlan0"
    echo "  iwconfig wlan0"
    echo "  ip addr show wlan0"
    echo ""
    echo -e "${CYAN}Hacking Tools:${NC}"
    echo "  aircrack-ng - WiFi security auditing"
    echo "  macchanger - Change MAC address"
    echo "  nmap - Network discovery"
    echo ""
    echo -e "${CYAN}Password Cracking:${NC}"
    echo "  aircrack-ng -w school_passwords.txt capture.cap"
}

clean_exit() {
    echo -e "${YELLOW}[+] Cleaning up...${NC}"
    
    # Kill TOR
    pkill tor 2>/dev/null
    
    # Hapus file log jika ada
    rm -f *.log *.tmp 2>/dev/null
    
    echo -e "${GREEN}[✓] Cleanup complete${NC}"
    echo -e "${PURPLE}[+] Goodbye! 😈${NC}"
    exit 0
}

# ============================================
# 🚀 MAIN MENU
# ============================================

main_menu() {
    while true; do
        show_header
        
        echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║             MAIN MENU                  ║${NC}"
        echo -e "${BLUE}╠════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║ 1. 📡 Scan WiFi Networks              ║${NC}"
        echo -e "${BLUE}║ 2. 🔄 Change MAC Address              ║${NC}"
        echo -e "${BLUE}║ 3. 🔐 Setup VPN Protection            ║${NC}"
        echo -e "${BLUE}║ 4. 🛠️ Install Tools                   ║${NC}"
        echo -e "${BLUE}║ 5. 📝 Create Password List            ║${NC}"
        echo -e "${BLUE}║ 6. 📊 Check VPN Status                ║${NC}"
        echo -e "${BLUE}║ 7. 💻 Show Useful Commands            ║${NC}"
        echo -e "${BLUE}║ 8. 🧹 Clean Exit                      ║${NC}"
        echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
        echo ""
        
        read -p "Select option [1-8]: " choice
        
        case $choice in
            1) scan_wifi ;;
            2) change_mac ;;
            3) setup_vpn_simple ;;
            4) install_tools ;;
            5) create_password_list ;;
            6) check_vpn_status ;;
            7) show_commands ;;
            8) clean_exit ;;
            *) echo -e "${RED}[!] Invalid option${NC}" ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# ============================================
# 🎯 START PROGRAM
# ============================================

# Initial setup
show_header
echo -e "${YELLOW}[+] Initializing system...${NC}"

# Jalankan menu utama
main_menu
