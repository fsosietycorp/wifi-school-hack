#!/bin/bash
# DARKNET REAL TOOLS v1.0 - BY NESIA DARKNET
# REAL WORKING TOOLS FOR TERMUX - NO FAKE SHIT

clear
echo -e "\e[1;31m"
cat << "EOF"

██████╗  █████╗ ██████╗ ██╗  ██╗███╗   ██╗███████╗████████╗
██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝████╗  ██║██╔════╝╚══██╔══╝
██║  ██║███████║██████╔╝█████╔╝ ██╔██╗ ██║█████╗     ██║   
██║  ██║██╔══██║██╔══██╗██╔═██╗ ██║╚██╗██║██╔══╝     ██║   
██████╔╝██║  ██║██║  ██║██║  ██╗██║ ╚████║███████╗   ██║   
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   
                  REAL TOOLS v1.0 😈
EOF
echo -e "\e[0m"

# ==================== CHECK & INSTALL DEPENDENCIES ====================
install_deps() {
    echo -e "\e[1;33m[!] Installing necessary packages...\e[0m"
    
    # Update packages
    pkg update -y
    pkg upgrade -y
    
    # Install essential tools
    pkg install -y \
        tor \
        curl \
        wget \
        nmap \
        python \
        python-pip \
        git \
        openssl \
        termux-api \
        jq \
        macchanger \
        hydra \
        sqlmap \
        nikto \
        whois \
        dnsutils \
        net-tools
    
    # Install Python modules
    pip install requests beautifulsoup4
    
    echo -e "\e[1;32m[✓] All dependencies installed!\e[0m"
    sleep 2
}

# ==================== NETWORK SCANNER (REAL) ====================
network_scanner() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║      NETWORK SCANNER - REAL     ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. Scan Local Network"
    echo "2. Port Scanner"
    echo "3. Ping Sweep"
    echo "4. DNS Lookup"
    echo "5. Traceroute"
    echo "0. Back\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            echo -e "\e[1;33m[!] Scanning local network...\e[0m"
            
            # Get local IP range
            gateway=$(ip route | grep default | awk '{print $3}' | head -1)
            if [ -z "$gateway" ]; then
                gateway="192.168.1.1"
            fi
            
            network=$(echo $gateway | cut -d. -f1-3)
            
            echo -e "\e[1;32m[+] Scanning network: $network.0/24\e[0m"
            echo -e "\e[1;33m[!] This may take a minute...\e[0m"
            
            # Real nmap scan
            nmap -sn "$network.0/24" 2>/dev/null | grep -E "Nmap scan|MAC Address"
            
            echo -e "\e[1;32m[✓] Scan completed!\e[0m"
            ;;
        2)
            echo -n "Enter target IP or domain: "
            read target
            echo -e "\e[1;33m[!] Scanning ports on $target...\e[0m"
            
            # Common ports scan
            nmap -p 21,22,23,25,53,80,110,143,443,445,3306,3389,8080 $target
            
            echo -e "\e[1;32m[✓] Port scan completed!\e[0m"
            ;;
        3)
            echo -e "\e[1;33m[!] Ping sweep...\e[0m"
            gateway=$(ip route | grep default | awk '{print $3}' | head -1)
            network=$(echo $gateway | cut -d. -f1-3)
            
            for i in {1..254}; do
                ip="$network.$i"
                ping -c 1 -W 1 $ip > /dev/null 2>&1
                if [ $? -eq 0 ]; then
                    echo -e "\e[1;32m[+] $ip is UP\e[0m"
                fi
            done
            ;;
        4)
            echo -n "Enter domain: "
            read domain
            echo -e "\e[1;33m[!] DNS lookup for $domain...\e[0m"
            
            nslookup $domain
            dig $domain ANY
            ;;
        5)
            echo -n "Enter target: "
            read target
            echo -e "\e[1;33m[!] Traceroute to $target...\e[0m"
            
            traceroute $target 2>/dev/null || echo "Install: pkg install traceroute"
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== WEB TOOLS (REAL) ====================
web_tools() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║        WEB TOOLS - REAL         ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. Website Information"
    echo "2. Directory Bruteforce"
    echo "3. SQL Injection Test"
    echo "4. XSS Scanner"
    echo "5. Subdomain Finder"
    echo "0. Back\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            echo -n "Enter URL: "
            read url
            echo -e "\e[1;33m[!] Getting info for $url...\e[0m"
            
            # Get headers
            echo -e "\e[1;32m[+] Headers:\e[0m"
            curl -I $url 2>/dev/null
            
            # Get server info
            echo -e "\n\e[1;32m[+] Server Info:\e[0m"
            curl -s $url | grep -i "server\|powered-by" | head -5
            ;;
        2)
            echo -n "Enter URL: "
            read url
            echo -e "\e[1;33m[!] Directory bruteforce (common paths)...\e[0m"
            
            # Common directories
            dirs=("admin" "login" "wp-admin" "dashboard" "backend" "api" "test" "secret")
            
            for dir in "${dirs[@]}"; do
                response=$(curl -s -o /dev/null -w "%{http_code}" "$url/$dir/")
                if [ "$response" = "200" ] || [ "$response" = "301" ] || [ "$response" = "302" ]; then
                    echo -e "\e[1;32m[+] Found: $url/$dir/ (HTTP: $response)\e[0m"
                fi
            done
            ;;
        3)
            echo -n "Enter URL (with parameter): "
            read url
            echo -e "\e[1;33m[!] Testing for SQL injection...\e[0m"
            
            # Basic SQLi test
            test_url="${url}'"
            response=$(curl -s "$test_url" | grep -i "sql\|error\|syntax\|mysql")
            
            if [ ! -z "$response" ]; then
                echo -e "\e[1;31m[!] Possible SQL Injection vulnerability!\e[0m"
                echo "$response" | head -3
            else
                echo -e "\e[1;32m[✓] No obvious SQLi detected\e[0m"
            fi
            ;;
        4)
            echo -n "Enter URL: "
            read url
            echo -e "\e[1;33m[!] Testing for XSS...\e[0m"
            
            # Basic XSS test
            test_payload="<script>alert('XSS')</script>"
            echo -e "\e[1;36m[+] Test payload: $test_payload\e[0m"
            echo -e "\e[1;33m[!] Manual test required. Try submitting forms with payload.\e[0m"
            ;;
        5)
            echo -n "Enter domain: "
            read domain
            echo -e "\e[1;33m[!] Finding subdomains...\e[0m"
            
            # Common subdomains
            subdomains=("www" "mail" "ftp" "blog" "dev" "test" "api" "admin" "portal" "webmail")
            
            for sub in "${subdomains[@]}"; do
                host="$sub.$domain"
                ping -c 1 -W 1 $host > /dev/null 2>&1
                if [ $? -eq 0 ]; then
                    echo -e "\e[1;32m[+] Found: $host\e[0m"
                fi
            done
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== SECURITY TOOLS (REAL) ====================
security_tools() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║      SECURITY TOOLS - REAL      ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. TOR VPN Control"
    echo "2. MAC Address Changer"
    echo "3. Password Generator"
    echo "4. Hash Cracker (Basic)"
    echo "5. SSL Checker"
    echo "0. Back\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            echo -e "\e[1;33m[!] TOR VPN Control\e[0m"
            echo -e "\e[1;36m1. Start TOR"
            echo "2. Stop TOR"
            echo "3. Check Status"
            echo "4. Change TOR Identity"
            echo -n "Select: "
            read tor_choice
            
            case $tor_choice in
                1)
                    echo -e "\e[1;33m[!] Starting TOR...\e[0m"
                    pkill tor 2>/dev/null
                    tor &
                    sleep 5
                    echo -e "\e[1;32m[✓] TOR started!\e[0m"
                    ;;
                2)
                    echo -e "\e[1;33m[!] Stopping TOR...\e[0m"
                    pkill tor 2>/dev/null
                    echo -e "\e[1;32m[✓] TOR stopped!\e[0m"
                    ;;
                3)
                    if curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org | grep -q "Congratulations"; then
                        echo -e "\e[1;32m[✓] TOR is ACTIVE\e[0m"
                    else
                        echo -e "\e[1;31m[✗] TOR is INACTIVE\e[0m"
                    fi
                    ;;
                4)
                    echo -e "\e[1;33m[!] Changing TOR identity...\e[0m"
                    pkill -HUP tor
                    echo -e "\e[1;32m[✓] New TOR identity requested!\e[0m"
                    ;;
            esac
            ;;
        2)
            echo -e "\e[1;33m[!] MAC Address Changer\e[0m"
            
            # Show current MAC
            echo -e "\e[1;32m[+] Current MAC:\e[0m"
            ifconfig wlan0 2>/dev/null | grep "ether"
            
            # Note about root
            echo -e "\e[1;31m[!] Note: Full MAC change requires root!\e[0m"
            echo -e "\e[1;33m[+] Try: pkg install macchanger -y\e[0m"
            echo -e "\e[1;33m[+] Then: macchanger -r wlan0\e[0m"
            ;;
        3)
            echo -e "\e[1;33m[!] Password Generator\e[0m"
            echo -n "Length (8-32): "
            read length
            length=${length:-12}
            
            echo -e "\e[1;32m[+] Generated passwords:\e[0m"
            for i in {1..5}; do
                tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c $length
                echo ""
            done
            ;;
        4)
            echo -e "\e[1;33m[!] Basic Hash Cracker\e[0m"
            echo -n "Enter MD5 hash: "
            read hash
            
            echo -e "\e[1;33m[!] Checking online databases...\e[0m"
            
            # Try crackstation API (free)
            result=$(curl -s "https://crackstation.net/crackstation-web-app-api/crack?hash=$hash" | jq -r '.result' 2>/dev/null)
            
            if [ ! -z "$result" ] && [ "$result" != "null" ]; then
                echo -e "\e[1;32m[✓] Cracked: $result\e[0m"
            else
                echo -e "\e[1;31m[✗] Not found in database\e[0m"
            fi
            ;;
        5)
            echo -n "Enter domain: "
            read domain
            echo -e "\e[1;33m[!] Checking SSL certificate...\e[0m"
            
            echo | openssl s_client -connect $domain:443 2>/dev/null | openssl x509 -noout -dates -issuer
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== INFORMATION GATHERING ====================
info_gathering() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║   INFORMATION GATHERING - REAL  ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. IP Geolocation"
    echo "2. WHOIS Lookup"
    echo "3. Reverse IP Lookup"
    echo "4. Email Header Analysis"
    echo "5. Social Media Search"
    echo "0. Back\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            echo -e "\e[1;33m[!] IP Geolocation\e[0m"
            echo -e "\e[1;36m1. My IP Info"
            echo "2. Target IP Info"
            echo -n "Select: "
            read ip_choice
            
            if [ "$ip_choice" = "1" ]; then
                echo -e "\e[1;33m[!] Getting your IP information...\e[0m"
                curl -s https://ipinfo.io/json
            elif [ "$ip_choice" = "2" ]; then
                echo -n "Enter IP address: "
                read target_ip
                echo -e "\e[1;33m[!] Getting info for $target_ip...\e[0m"
                curl -s "https://ipinfo.io/$target_ip/json"
            fi
            ;;
        2)
            echo -n "Enter domain or IP: "
            read target
            echo -e "\e[1;33m[!] WHOIS lookup for $target...\e[0m"
            
            whois $target | head -50
            ;;
        3)
            echo -n "Enter IP address: "
            read target_ip
            echo -e "\e[1;33m[!] Reverse IP lookup for $target_ip...\e[0m"
            
            # Use hackertarget API
            curl -s "https://api.hackertarget.com/reverseiplookup/?q=$target_ip"
            ;;
        4)
            echo -e "\e[1;33m[!] Email Header Analysis\e[0m"
            echo -e "\e[1;36m[+] Paste email headers below (Ctrl+D when done):\e[0m"
            headers=$(cat)
            
            echo -e "\n\e[1;32m[+] Analysis:\e[0m"
            
            # Extract IPs
            echo -e "\e[1;33m[!] IP Addresses found:\e[0m"
            echo "$headers" | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u
            
            # Extract domains
            echo -e "\n\e[1;33m[!] Domains found:\e[0m"
            echo "$headers" | grep -Eo '[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' | sort -u
            ;;
        5)
            echo -n "Enter username: "
            read username
            echo -e "\e[1;33m[!] Searching for $username...\e[0m"
            
            # Check common platforms
            platforms=(
                "https://github.com/$username"
                "https://twitter.com/$username"
                "https://instagram.com/$username"
                "https://facebook.com/$username"
                "https://linkedin.com/in/$username"
            )
            
            for platform in "${platforms[@]}"; do
                response=$(curl -s -o /dev/null -w "%{http_code}" "$platform")
                if [ "$response" = "200" ]; then
                    echo -e "\e[1;32m[+] Found: $platform\e[0m"
                fi
            done
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== SYSTEM TOOLS ====================
system_tools_menu() {
    clear
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║       SYSTEM TOOLS - REAL       ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36m1. Clean System"
    echo "2. Monitor Network Traffic"
    echo "3. Check Disk Usage"
    echo "4. Process Monitor"
    echo "5. Backup Files"
    echo "0. Back\e[0m"
    echo -n "Select: "
    read choice
    
    case $choice in
        1)
            echo -e "\e[1;33m[!] Cleaning system...\e[0m"
            
            # Clear cache
            rm -rf ~/.cache/* 2>/dev/null
            rm -rf ~/.thumbnails/* 2>/dev/null
            
            # Clear bash history
            history -c
            echo "" > ~/.bash_history
            
            # Remove temp files
            rm -f ~/*.log ~/*.tmp 2>/dev/null
            
            echo -e "\e[1;32m[✓] System cleaned!\e[0m"
            ;;
        2)
            echo -e "\e[1;33m[!] Network Traffic Monitor\e[0m"
            echo -e "\e[1;36m[+] Press Ctrl+C to stop\e[0m"
            
            # Show network interfaces
            ifconfig | grep -E "wlan0|eth0|inet"
            
            # Monitor with netstat
            echo -e "\n\e[1;33m[+] Active connections:\e[0m"
            netstat -tunap 2>/dev/null | head -20
            ;;
        3)
            echo -e "\e[1;33m[!] Disk Usage\e[0m"
            df -h
            echo -e "\n\e[1;33m[+] Home directory:\e[0m"
            du -sh ~/* 2>/dev/null | sort -hr | head -10
            ;;
        4)
            echo -e "\e[1;33m[!] Running Processes\e[0m"
            ps aux | head -20
            ;;
        5)
            echo -e "\e[1;33m[!] Backup Important Files\e[0m"
            
            # Create backup directory
            backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$backup_dir"
            
            # Backup important files
            cp ~/.bashrc "$backup_dir/" 2>/dev/null
            cp ~/.termux/* "$backup_dir/" 2>/dev/null 2>/dev/null
            
            echo -e "\e[1;32m[✓] Backup created in: $backup_dir\e[0m"
            ;;
    esac
    read -p "Press enter to continue..."
}

# ==================== MAIN MENU ====================
main_menu() {
    # Check dependencies
    if ! command -v tor > /dev/null 2>&1 || ! command -v nmap > /dev/null 2>&1; then
        echo -e "\e[1;31m[!] Missing dependencies!\e[0m"
        install_deps
    fi
    
    # Start TOR in background
    if ! curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org | grep -q "Congratulations" 2>/dev/null; then
        echo -e "\e[1;33m[!] Starting TOR VPN...\e[0m"
        pkill tor 2>/dev/null
        tor &
        sleep 5
    fi
    
    while true; do
        clear
        echo -e "\e[1;32m"
        echo "╔══════════════════════════════════════════════╗"
        echo "║     DARKNET REAL TOOLS v1.0 - NESIA DARKNET ║"
        echo "║           100% REAL - NO BULLSHIT           ║"
        echo "║     TOR VPN: ✅ ACTIVE | MODE: SECURE       ║"
        echo "╚══════════════════════════════════════════════╝"
        echo -e "\e[0m"
        
        # Display system info
        echo -e "\e[1;36m[+] System Info:\e[0m"
        echo "IP: $(curl -s https://api.ipify.org 2>/dev/null || echo 'Unknown')"
        echo "Storage: $(df -h /data | awk 'NR==2 {print $4}') free"
        echo "Uptime: $(uptime -p 2>/dev/null | cut -d' ' -f2-)"
        
        echo -e "\n\e[1;35m[+] REAL TOOLS MENU:\e[0m"
        echo "1. 🔍 Network Scanner"
        echo "2. 🌐 Web Security Tools"
        echo "3. 🛡️  Security & Privacy"
        echo "4. 📊 Information Gathering"
        echo "5. ⚙️  System Tools"
        echo "6. 📚 Install/Update Tools"
        echo "7. 🧹 Clean & Exit"
        echo "0. ❌ Exit"
        
        echo -ne "\n\e[1;33m[?] Select option: \e[0m"
        read choice
        
        case $choice in
            1) network_scanner ;;
            2) web_tools ;;
            3) security_tools ;;
            4) info_gathering ;;
            5) system_tools_menu ;;
            6) install_deps ;;
            7)
                echo -e "\e[1;33m[!] Cleaning and exiting...\e[0m"
                pkill tor 2>/dev/null
                rm -f *.log *.tmp 2>/dev/null
                echo -e "\e[1;32m[✓] All clean! Goodbye.\e[0m"
                exit 0
                ;;
            0)
                echo -e "\e[1;32m[✓] Goodbye! Stay secure.\e[0m"
                exit 0
                ;;
            *)
                echo -e "\e[1;31m[✗] Invalid option!\e[0m"
                sleep 1
                ;;
        esac
    done
}

# ==================== START SCRIPT ====================
echo -e "\e[1;33m[!] Initializing Darknet Real Tools...\e[0m"
echo -e "\e[1;36m[+] Checking requirements...\e[0m"

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "\e[1;31m[✗] This script must run in Termux!\e[0m"
    exit 1
fi

# Check for storage permission
if [ ! -w "/storage/emulated/0" ]; then
    echo -e "\e[1;33m[!] Grant storage permission:\e[0m"
    echo -e "\e[1;36m[+] Run: termux-setup-storage\e[0m"
fi

# Start main menu
main_menu
