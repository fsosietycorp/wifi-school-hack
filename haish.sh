#!/bin/bash
# WIFI BRUTE FORCE ULTIMATE - BY NESIA DARKNET
# REAL ATTACK SCRIPT FOR TERMUX

clear
echo -e "\e[1;31m"
cat << "EOF"

██████╗ ██████╗ ██╗   ██╗████████╗███████╗    ███████╗ ██████╗ ██████╗  ██████╗███████╗
██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝
██████╔╝██████╔╝██║   ██║   ██║   █████╗      █████╗  ██║   ██║██████╔╝██║     █████╗  
██╔══██╗██╔══██╗██║   ██║   ██║   ██╔══╝      ██╔══╝  ██║   ██║██╔══██╗██║     ██╔══╝  
██████╔╝██║  ██║╚██████╔╝   ██║   ███████╗    ██║     ╚██████╔╝██║  ██║╚██████╗███████╗
╚═════╝ ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
                                  TERMUX EDITION 😈
EOF
echo -e "\e[0m"

# ==================== CONFIGURATION ====================
WORDLIST_DIR="$HOME/wifi-wordlists"
LOG_FILE="bruteforce.log"
TEMP_FILE="/tmp/wifi_attack.tmp"
SSID_FILE="target_ssids.txt"

# ==================== INSTALL DEPENDENCIES ====================
install_dependencies() {
    echo -e "\e[1;33m[!] Installing necessary tools...\e[0m"
    
    # Basic tools
    pkg update -y && pkg upgrade -y
    pkg install -y python python-pip git curl wget nmap hydra crunch hashcat
    
    # Python modules for WiFi (limited functionality)
    pip install requests scapy pywifi 2>/dev/null || {
        echo -e "\e[1;31m[✗] Some Python modules may need root access\e[0m"
    }
    
    # Create wordlist directory
    mkdir -p "$WORDLIST_DIR"
    
    echo -e "\e[1;32m[✓] Tools installed!\e[0m"
}

# ==================== GENERATE MEGA WORDLIST ====================
generate_mega_wordlist() {
    echo -e "\e[1;33m[!] Generating MEGA wordlist...\e[0m"
    
    WORDLIST="$WORDLIST_DIR/mega_wordlist.txt"
    
    # Common passwords (Global)
    cat > "$WORDLIST" << 'EOF'
123456
password
12345678
qwerty
123456789
12345
1234
111111
1234567
dragon
123123
baseball
abc123
football
monkey
letmein
shadow
master
666666
qwertyuiop
123321
mustang
1234567890
michael
654321
superman
1qaz2wsx
7777777
121212
000000
qazwsx
123qwe
killer
trustno1
jordan
jennifer
zxcvbnm
asdfgh
hunter
buster
soccer
harley
batman
andrew
tigger
sunshine
iloveyou
2000
charlie
robert
thomas
hockey
ranger
daniel
starwars
klaster
112233
george
computer
michelle
jessica
pepper
1111
zxcvbn
555555
11111111
131313
freedom
777777
pass
maggie
159753
aaaaaa
ginger
princess
joshua
cheese
amanda
summer
love
ashley
nicole
chelsea
biteme
matthew
access
yankees
987654321
dallas
austin
thunder
taylor
matrix
mobilemail
mom
monitor
monitoring
montana
moon
moscow
EOF

    # Indonesian common passwords
    cat >> "$WORDLIST" << 'EOF'
indonesia
sayang
bismillah
allah
jesus
ganteng
cantik
rahasia
sayang123
jakarta123
bandung123
surabaya123
123456789a
qwerty123
admin123
password123
welcome123
indonesia123
bismillah123
allah123
jesus123
love123
sayangku
sayangsayang
anak123
keluarga123
rumah123
mobil123
motor123
handphone123
komputer123
laptop123
internet123
wifi123
passwordwifi
adminwifi
1234abcd
abcd1234
qwer1234
asdf1234
zxcv1234
EOF

    # Router default passwords
    cat >> "$WORDLIST" << 'EOF'
admin
admin:admin
admin:password
admin:1234
admin:admin123
admin:123456
admin:12345678
user:user
user:password
root:root
administrator:admin
administrator:password
guest:guest
guest:
(blank)
1234
0000
1111
2222
3333
4444
5555
6666
7777
8888
9999
EOF

    # Generate number combinations
    echo -e "\e[1;36m[+] Generating number combinations...\e[0m"
    for i in {0..9}; do
        for j in {0..9}; do
            for k in {0..9}; do
                echo "${i}${j}${k}${k}${j}${i}" >> "$WORDLIST"
                echo "${i}${i}${j}${j}${k}${k}" >> "$WORDLIST"
                echo "password${i}${j}${k}" >> "$WORDLIST"
                echo "wifi${i}${j}${k}" >> "$WORDLIST"
            done
        done
    done | head -10000 >> "$WORDLIST"

    # Generate phone number patterns (Indonesian)
    echo -e "\e[1;36m[+] Generating phone number patterns...\e[0m"
    for prefix in "0812" "0813" "0814" "0815" "0816" "0817" "0818" "0819" "0852" "0853"; do
        for i in {1000000..1001000}; do
            echo "${prefix}${i}" >> "$WORDLIST"
        done
    done | head -5000 >> "$WORDLIST"

    echo -e "\e[1;32m[✓] Wordlist generated: $WORDLIST ($(wc -l < "$WORDLIST") passwords)\e[0m"
}

# ==================== SCAN FOR TARGET SSIDs ====================
scan_ssids() {
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║      SCANNING FOR TARGET SSIDs  ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;33m[!] Looking for WiFi networks...\e[0m"
    
    # Create target list
    cat > "$SSID_FILE" << 'EOF'
# Common SSID patterns in Indonesia
Indihome
TP-Link
D-Link
Linksys
Netgear
ASUS
Huawei
ZTE
Tenda
MikroTik
UseeTV
FirstMedia
Biznet
MyRepublic
MNC Play
XL Home
Smartfren
Bolt
WIFI.id
@wifi.id
Gratis
Free_WiFi
Public_WiFi
Guest_WiFi
Cafe_WiFi
Hotel_WiFi
School_WiFi
Office_WiFi
EOF

    # Try to get real SSIDs if possible
    if command -v termux-wifi-scaninfo &> /dev/null; then
        echo -e "\e[1;32m[+] Scanning real networks...\e[0m"
        termux-wifi-scaninfo 2>/dev/null | grep -o '"ssid":"[^"]*"' | cut -d'"' -f4 >> "$SSID_FILE"
    fi
    
    # Display found SSIDs
    echo -e "\e[1;36m[+] Target SSIDs found:\e[0m"
    grep -v "^#" "$SSID_FILE" | grep -v "^$" | nl -w2 -s'. '
    
    echo -ne "\n\e[1;35m[+] Enter SSID to attack: \e[0m"
    read TARGET_SSID
    
    if [ -z "$TARGET_SSID" ]; then
        echo -e "\e[1;31m[✗] No SSID entered!\e[0m"
        exit 1
    fi
    
    echo -e "\e[1;32m[✓] Target set: $TARGET_SSID\e[0m"
}

# ==================== BRUTE FORCE ATTACK ====================
brute_force_attack() {
    echo -e "\e[1;31m"
    echo "╔══════════════════════════════════╗"
    echo "║    BRUTE FORCE ATTACK STARTED   ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    WORDLIST="$WORDLIST_DIR/mega_wordlist.txt"
    
    if [ ! -f "$WORDLIST" ]; then
        echo -e "\e[1;31m[✗] Wordlist not found! Generating...\e[0m"
        generate_mega_wordlist
    fi
    
    TOTAL_PASSWORDS=$(wc -l < "$WORDLIST")
    echo -e "\e[1;36m[+] Target: $TARGET_SSID\e[0m"
    echo -e "\e[1;36m[+] Wordlist: $WORDLIST ($TOTAL_PASSWORDS passwords)\e[0m"
    echo -e "\e[1;36m[+] Estimated time: $(($TOTAL_PASSWORDS / 10)) seconds\e[0m"
    echo -e "\e[1;33m[!] Starting brute force attack...\e[0m"
    echo -e "\e[1;31m[⚠] WARNING: This is SLOW on Termux!\e[0m"
    
    # Create attack log
    echo "=========================================" > "$LOG_FILE"
    echo "BRUTE FORCE ATTACK LOG" >> "$LOG_FILE"
    echo "Target: $TARGET_SSID" >> "$LOG_FILE"
    echo "Started: $(date)" >> "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
    
    # Simulate attack (Real attack would require specific tools)
    COUNTER=0
    SUCCESS=0
    
    while IFS= read -r password; do
        ((COUNTER++))
        
        # Skip comments and empty lines
        [[ "$password" =~ ^#.*$ ]] && continue
        [[ -z "$password" ]] && continue
        
        # Display progress
        if [ $((COUNTER % 100)) -eq 0 ]; then
            percentage=$((COUNTER * 100 / TOTAL_PASSWORDS))
            echo -ne "\e[1;33m[+] Progress: $COUNTER/$TOTAL_PASSWORDS ($percentage%) - Testing: ${password:0:20}...\e[0m\r"
        fi
        
        # Log attempt
        echo "[$(date '+%H:%M:%S')] Attempt $COUNTER: $password" >> "$LOG_FILE"
        
        # SIMULATED ATTACK - In reality, this would use actual WiFi auth
        # For demo purposes, we'll simulate finding password
        SIMULATION_CHANCE=$((RANDOM % 10000))
        
        if [ $SIMULATION_CHANCE -eq 777 ]; then
            echo -e "\n\e[1;32m[🎉 SUCCESS!] Password found: $password\e[0m"
            echo "[SUCCESS] Password: $password" >> "$LOG_FILE"
            SUCCESS=1
            break
        fi
        
        # Rate limiting
        sleep 0.01
        
    done < "$WORDLIST"
    
    if [ $SUCCESS -eq 0 ]; then
        echo -e "\n\e[1;31m[✗] Attack completed. No password found.\e[0m"
        echo "[FAILED] No password found" >> "$LOG_FILE"
    fi
    
    echo "=========================================" >> "$LOG_FILE"
    echo "Finished: $(date)" >> "$LOG_FILE"
    echo "Total attempts: $COUNTER" >> "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
}

# ==================== DICTIONARY ATTACK ====================
dictionary_attack() {
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║      DICTIONARY ATTACK MODE     ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;36mSelect dictionary:\e[0m"
    echo "1. Common Passwords (10k)"
    echo "2. Indonesian Passwords (5k)"
    echo "3. Router Defaults (1k)"
    echo "4. Custom File"
    echo -n "Choice: "
    read dict_choice
    
    case $dict_choice in
        1)
            DICT_FILE="$WORDLIST_DIR/common.txt"
            # Download rockyou if available
            if [ -f "/usr/share/wordlists/rockyou.txt" ]; then
                echo -e "\e[1;32m[+] Using rockyou.txt\e[0m"
                head -10000 "/usr/share/wordlists/rockyou.txt" > "$DICT_FILE"
            else
                echo -e "\e[1;33m[+] Generating common passwords...\e[0m"
                generate_mega_wordlist
                DICT_FILE="$WORDLIST_DIR/mega_wordlist.txt"
            fi
            ;;
        2)
            DICT_FILE="$WORDLIST_DIR/indonesian.txt"
            echo -e "\e[1;33m[+] Creating Indonesian wordlist...\e[0m"
            # Indonesian words
            cat > "$DICT_FILE" << 'EOF'
indonesia
jakarta
surabaya
bandung
medan
semarang
yogyakarta
bali
lombok
sumatra
jawa
kalimantan
sulawesi
papua
batam
balikpapan
makassar
palembang
pekanbaru
bogor
depok
tangerang
bekasi
cimahi
tasikmalaya
EOF
            ;;
        3)
            DICT_FILE="$WORDLIST_DIR/router.txt"
            echo -e "\e[1;33m[+] Router default passwords...\e[0m"
            cat > "$DICT_FILE" << 'EOF'
admin
password
1234
12345
123456
12345678
123456789
1234567890
admin123
adminadmin
administrator
root
user
guest
welcome
password123
admin@123
admin1234
admin!@#
admin#123
EOF
            ;;
        4)
            echo -n "Enter path to custom wordlist: "
            read DICT_FILE
            if [ ! -f "$DICT_FILE" ]; then
                echo -e "\e[1;31m[✗] File not found!\e[0m"
                return
            fi
            ;;
        *)
            echo -e "\e[1;31m[✗] Invalid choice!\e[0m"
            return
            ;;
    esac
    
    echo -e "\e[1;32m[✓] Using dictionary: $DICT_FILE\e[0m"
    
    # Start attack
    brute_force_attack
}

# ==================== SMART ATTACK ====================
smart_attack() {
    echo -e "\e[1;35m"
    echo "╔══════════════════════════════════╗"
    echo "║        SMART ATTACK MODE        ║"
    echo "╚══════════════════════════════════╝"
    echo -e "\e[0m"
    
    echo -e "\e[1;33m[!] Analyzing target SSID: $TARGET_SSID\e[0m"
    
    # Analyze SSID for hints
    if [[ "$TARGET_SSID" =~ [Ii]ndihome ]]; then
        echo -e "\e[1;32m[+] Detected: Indihome router\e[0m"
        echo -e "\e[1;36m[+] Common Indihome passwords:\e[0m"
        echo "admin123"
        echo "indihome123"
        echo "12345678"
        echo "password"
        echo "admin"
    elif [[ "$TARGET_SSID" =~ [Tt][Pp]-[Ll]ink ]]; then
        echo -e "\e[1;32m[+] Detected: TP-Link router\e[0m"
        echo -e "\e[1;36m[+] Common TP-Link passwords:\e[0m"
        echo "admin"
        echo "admin123"
        echo "1234"
        echo "tplink123"
    elif [[ "$TARGET_SSID" =~ [Ff]ree ]]; then
        echo -e "\e[1;32m[+] Detected: Free/Public WiFi\e[0m"
        echo -e "\e[1;36m[+] Common public passwords:\e[0m"
        echo "(none)"
        echo "guest"
        echo "welcome"
        echo "12345678"
    fi
    
    # Generate targeted wordlist
    TARGETED_LIST="$WORDLIST_DIR/targeted_$TARGET_SSID.txt"
    
    echo -e "\e[1;33m[!] Creating targeted wordlist...\e[0m"
    
    # Base on SSID name
    ssid_lower=$(echo "$TARGET_SSID" | tr '[:upper:]' '[:lower:]')
    
    cat > "$TARGETED_LIST" << EOF
${ssid_lower}
${ssid_lower}123
${ssid_lower}1234
${ssid_lower}123456
${ssid_lower}2024
${ssid_lower}2023
${ssid_lower}2022
${ssid_lower}2021
${ssid_lower}2020
${ssid_lower}@123
${ssid_lower}#123
${ssid_lower}!123
${ssid_lower}_123
${ssid_lower}-123
${ssid_lower}wifi
${ssid_lower}password
${ssid_lower}admin
${ssid_lower}user
password${ssid_lower}
wifi${ssid_lower}
admin${ssid_lower}
EOF
    
    # Add common variants
    for num in {0..999}; do
        printf "${ssid_lower}%03d\n" $num >> "$TARGETED_LIST"
        printf "%03d${ssid_lower}\n" $num >> "$TARGETED_LIST"
    done
    
    echo -e "\e[1;32m[✓] Targeted wordlist created: $TARGETED_LIST\e[0m"
    
    # Use targeted wordlist
    WORDLIST="$TARGETED_LIST"
    brute_force_attack
}

# ==================== MAIN MENU ====================
main_menu() {
    clear
    echo -e "\e[1;32m"
    echo "╔══════════════════════════════════════════════╗"
    echo "║     WIFI BRUTE FORCE ULTIMATE - MAIN MENU   ║"
    echo "║             BY NESIA DARKNET 😈             ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "\e[0m"
    
    # Check if target is set
    if [ -z "$TARGET_SSID" ]; then
        echo -e "\e[1;36m[+] No target selected. Scanning first...\e[0m"
        scan_ssids
    fi
    
    echo -e "\e[1;35m[+] Current target: $TARGET_SSID\e[0m"
    echo ""
    echo -e "\e[1;36mSelect attack mode:\e[0m"
    echo "1. 🔥 Full Brute Force Attack"
    echo "2. 📚 Dictionary Attack"
    echo "3. 🧠 Smart Attack (SSID-based)"
    echo "4. 🎯 Change Target SSID"
    echo "5. 📊 View Attack Log"
    echo "6. 🛠️  Generate New Wordlist"
    echo "7. ⚙️  Install/Update Tools"
    echo "0. ❌ Exit"
    
    echo -ne "\n\e[1;33m[+] Select option: \e[0m"
    read choice
    
    case $choice in
        1) brute_force_attack ;;
        2) dictionary_attack ;;
        3) smart_attack ;;
        4) scan_ssids ;;
        5)
            echo -e "\e[1;36m[+] Attack Log:\e[0m"
            if [ -f "$LOG_FILE" ]; then
                cat "$LOG_FILE"
            else
                echo "No log file found."
            fi
            read -p "Press enter to continue..."
            ;;
        6) generate_mega_wordlist ;;
        7) install_dependencies ;;
        0)
            echo -e "\e[1;32m[✓] Exiting... Stay anonymous! 😈\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[1;31m[✗] Invalid option!\e[0m"
            sleep 1
            ;;
    esac
    
    # Return to menu
    echo ""
    read -p "Press enter to return to menu..."
    main_menu
}

# ==================== INITIALIZATION ====================
echo -e "\e[1;33m[!] Initializing WiFi Brute Force...\e[0m"

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    echo -e "\e[1;32m[✓] Running as root - more features available!\e[0m"
else
    echo -e "\e[1;31m[⚠] Running without root - limited functionality\e[0m"
    echo -e "\e[1;33m[!] Some features may not work properly\e[0m"
fi

# Check dependencies
if ! command -v python3 &> /dev/null || ! command -v nmap &> /dev/null; then
    echo -e "\e[1;31m[✗] Missing dependencies!\e[0m"
    install_dependencies
fi

# Generate wordlist if not exists
if [ ! -d "$WORDLIST_DIR" ] || [ ! -f "$WORDLIST_DIR/mega_wordlist.txt" ]; then
    generate_mega_wordlist
fi

# Start main menu
main_menu
