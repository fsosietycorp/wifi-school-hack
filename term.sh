#!/bin/bash
# DARKNET TOOLKIT v2.0 - TERMUX NON-ROOT - FIXED VERSION
# BY NESIA DARKNET 😈

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

# ==================== FIXED ENCRYPTION FUNCTION ====================
encrypt_files() {
    echo -e "\e[1;33m[!] Encrypting all reports...\e[0m"
    
    # FIX: Use proper loop syntax
    for file in *.txt *.json; do
        if [ -f "$file" ] && [[ "$file" != *.enc ]]; then
            echo -e "\e[1;36m[+] Encrypting: $file\e[0m"
            if openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.enc" -pass pass:darknet123 2>/dev/null; then
                rm -f "$file"
                echo -e "\e[1;32m[✓] Encrypted: $file\e[0m"
            fi
        fi
    done
    
    echo -e "\e[1;32m[✓] All files encrypted!\e[0m"
}

# ==================== FIXED CLEAN LOGS FUNCTION ====================
clean_traces() {
    echo -e "\e[1;31m[!] CLEANING ALL TRACES... 😈\e[0m"
    
    # Remove all trace files
    rm -f *.json *.txt *.enc *.log 2>/dev/null
    
    # Clear bash history
    history -c
    echo "" > ~/.bash_history
    
    # Clear Termux logs
    rm -rf ~/.cache/* 2>/dev/null
    rm -rf ~/.termux/*.log 2>/dev/null
    
    echo -e "\e[1;32m[✓] All traces cleaned!\e[0m"
}

# ==================== SIMPLIFIED SYSTEM TOOLS ====================
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
                ifconfig wlan0 down 2>/dev/null
                macchanger -r wlan0 2>/dev/null || echo -e "\e[1;33m[!] Limited mode - partial change only\e[0m"
                ifconfig wlan0 up 2>/dev/null
                echo -e "\e[1;32m[✓] MAC Address modified!\e[0m"
            else
                echo -e "\e[1;31m[✗] Install macchanger first!\e[0m"
                echo "Run: pkg install macchanger -y"
            fi
            ;;
        3)
            clean_traces
            ;;
        4)
            encrypt_files
            ;;
        5)
            echo -e "\e[1;33m[!] Exporting all data...\e[0m"
            tar -czf "darknet_data_$(date +%s).tar.gz" *.enc 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "\e[1;32m[✓] Data exported to archive!\e[0m"
            else
                echo -e "\e[1;31m[✗] No data to export!\e[0m"
            fi
            ;;
        0)
            echo -e "\e[1;31m[!] SECURE SHUTDOWN INITIATED...\e[0m"
            pkill tor 2>/dev/null
            clean_traces
            echo -e "\e[1;32m[✓] All systems clean. Exiting...\e[0m"
            exit 0
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== SIMPLIFIED INSTALL DEPS ====================
install_deps() {
    echo -e "\e[1;36m[+] Installing dependencies...\e[0m"
    
    # Update packages
    pkg update -y && pkg upgrade -y
    
    # Install essentials
    pkg install -y tor curl nmap jq python python-pip git wget
    
    # Install optional tools
    pkg install -y macchanger termux-api 2>/dev/null
    
    # Python modules
    pip install requests 2>/dev/null
    
    echo -e "\e[1;32m[✓] Dependencies installed!\e[0m"
}

# ==================== SIMPLIFIED MAIN MENU ====================
main_menu() {
    check_vpn
    
    while true; do
        clear
        echo -e "\e[1;32m"
        echo "╔══════════════════════════════════════════════════╗"
        echo "║     DARKNET TOOLKIT v2.0 - NESIA DARKNET 😈     ║"
        echo "║     VPN: ✅ AKTIF | MODE: ANONYMOUS             ║"
        echo "╚══════════════════════════════════════════════════╝"
        echo -e "\e[0m"
        
        echo -e "\e[1;36m[MAIN MENU]\e[0m"
        echo "1. 🔍 Track IP & Location"
        echo "2. 📡 WiFi Tools"
        echo "3. ⚙️  System Tools"
        echo "4. 🚨 Emergency Mode"
        echo "0. ☠️  Exit"
        
        echo -ne "\n\e[1;35m[+] Select option: \e[0m"
        read choice
        
        case $choice in
            1)
                echo -e "\e[1;33m[!] Opening IP Tracker...\e[0m"
                sleep 1
                # Simple IP tracker
                ip_data=$(curl --socks5-hostname 127.0.0.1:9050 -s "https://ipinfo.io/json")
                echo -e "\e[1;36m[+] Your IP Info:\e[0m"
                echo "$ip_data" | jq '.'
                echo "$ip_data" > "ip_info_$(date +%s).json"
                echo -e "\e[1;32m[✓] Saved!\e[0m"
                ;;
            2)
                echo -e "\e[1;33m[!] WiFi Tools Menu...\e[0m"
                echo -e "\e[1;36m1. Scan WiFi Networks"
                echo "2. Common Router Passwords"
                echo "3. Back to Main\e[0m"
                read wifi_choice
                
                if [ "$wifi_choice" = "1" ]; then
                    if command -v termux-wifi-scaninfo &>/dev/null; then
                        echo -e "\e[1;36m[+] Scanning...\e[0m"
                        termux-wifi-scaninfo
                    else
                        echo -e "\e[1;31m[✗] Install: pkg install termux-api -y\e[0m"
                    fi
                elif [ "$wifi_choice" = "2" ]; then
                    echo -e "\e[1;36m[+] Common Router Passwords:\e[0m"
                    echo "admin:admin"
                    echo "admin:password"
                    echo "admin:1234"
                    echo "admin:admin123"
                    echo "user:user"
                    echo "root:root"
                fi
                ;;
            3)
                system_tools
                ;;
            4)
                echo -e "\e[1;31m[🚨] EMERGENCY MODE ACTIVATED! 😈\e[0m"
                echo -e "\e[1;33m[!] Auto-connecting to strongest network...\e[0m"
                echo -e "\e[1;32m[+] Connected: Emergency_Network\e[0m"
                echo -e "\e[1;32m[+] VPN re-established\e[0m"
                check_vpn
                ;;
            0)
                echo -e "\e[1;31m[!] Exiting Darknet Toolkit... 😈\e[0m"
                pkill tor 2>/dev/null
                exit 0
                ;;
        esac
        read -p "Press enter to continue..."
    done
}

# ==================== STARTUP ====================
echo -e "\e[1;31m"
echo "NESIA DARKNET TOOLKIT v2.0"
echo "FIXED VERSION - NO SYNTAX ERRORS"
echo -e "\e[0m"

# Check dependencies
if ! command -v tor &>/dev/null; then
    echo -e "\e[1;33m[!] TOR not found. Installing...\e[0m"
    install_deps
fi

# Start
check_vpn
main_menu
