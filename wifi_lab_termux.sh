#!/data/data/com.termux/files/usr/bin/bash
# Real Termux WiFi Lab - For YOUR OWN network only

clear
echo "╔══════════════════════════════════════╗"
echo "║      TERMUX WIFI SECURITY LAB       ║"
echo "║     For Educational Purposes Only   ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Check if using own network
echo "[!] WARNING: Only use on YOUR OWN WiFi!"
echo "[!] Illegal access is a crime (UU ITE Pasal 30)"
echo ""

# Enable Termux WiFi API
echo "[1] Setting up Termux WiFi API..."
termux-wifi-enable true
sleep 2

# Scan networks
echo "[2] Scanning WiFi networks..."
SCAN_RESULT=$(termux-wifi-scaninfo)
echo "$SCAN_RESULT" > /sdcard/wifi_scan.txt
echo "[+] Scan saved to /sdcard/wifi_scan.txt"

# Show current connection
echo "[3] Current connection info:"
CONN_INFO=$(termux-wifi-connectioninfo)
echo "$CONN_INFO"

# Ask for user's own WiFi details
echo ""
echo "[4] Enter YOUR OWN WiFi details for testing:"
read -p "Your WiFi SSID: " MY_SSID
read -sp "Your WiFi Password: " MY_PASS
echo ""

# Create test wordlist with user's password
echo "[5] Creating test wordlist..."
cat > /sdcard/test_wordlist.txt << EOF
# Common passwords first
12345678
password
admin
123456789
qwerty
123456
password123
admin123

# Your actual password (for testing)
$MY_PASS

# More common passwords
letmein
welcome
monkey
dragon
sunshine
football
iloveyou
EOF

echo "[+] Wordlist created: /sdcard/test_wordlist.txt"

# Password strength test
echo "[6] Testing password strength..."
PASS_LEN=${#MY_PASS}
SCORE=0

[[ $PASS_LEN -ge 8 ]] && SCORE=$((SCORE+1))
[[ $PASS_LEN -ge 12 ]] && SCORE=$((SCORE+2))
[[ $MY_PASS =~ [A-Z] ]] && SCORE=$((SCORE+1))
[[ $MY_PASS =~ [a-z] ]] && SCORE=$((SCORE+1))
[[ $MY_PASS =~ [0-9] ]] && SCORE=$((SCORE+1))
[[ $MY_PASS =~ [^A-Za-z0-9] ]] && SCORE=$((SCORE+2))

echo "    Password: ${MY_PASS//?/*}"
echo "    Length: $PASS_LEN characters"
echo "    Security Score: $SCORE/8"

if [[ $SCORE -le 3 ]]; then
    echo "    ⚠️  WEAK - Crackable in minutes!"
elif [[ $SCORE -le 5 ]]; then
    echo "    ⚠️  MEDIUM - Crackable in hours"
elif [[ $SCORE -le 7 ]]; then
    echo "    ✅ GOOD - Hard to crack"
else
    echo "    💪 EXCELLENT - Very secure"
fi

# Simulate dictionary attack
echo ""
echo "[7] Simulating dictionary attack..."
echo "    This is a SIMULATION only!"
echo "    Real cracking requires root access."

sleep 2
echo -n "    Testing passwords: "
for i in {1..10}; do
    echo -n "."
    sleep 0.3
done
echo ""

# Check if password is in common list
if grep -q "^$MY_PASS$" /sdcard/test_wordlist.txt; then
    echo "    🚨 ALERT: Your password is in common password list!"
    echo "    Time to crack: 1-5 minutes (estimated)"
else
    echo "    ✅ Good: Password not in common list"
    echo "    Time to crack: Hours to years (estimated)"
fi

# Generate strong password suggestion
echo ""
echo "[8] Strong password suggestion:"
STRONG_PASS=$(cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*' | fold -w 16 | head -n 1)
echo "    $STRONG_PASS"
echo "    Save this password and change your WiFi password!"

# Create security report
echo ""
echo "[9] Generating security report..."
cat > /sdcard/wifi_security_report.txt << EOF
============================================
       WIFI SECURITY REPORT
       Generated: $(date)
============================================

YOUR WIFI INFORMATION:
- SSID: $MY_SSID
- Password: ${MY_PASS//?/*} (length: $PASS_LEN)
- Security Score: $SCORE/8

STRENGTH ANALYSIS:
$([[ $SCORE -le 3 ]] && echo "❌ WEAK - Immediate risk!")
$([[ $SCORE -le 5 ]] && echo "⚠️  MEDIUM - Needs improvement")
$([[ $SCORE -le 7 ]] && echo "✅ GOOD - Acceptable security")
$([[ $SCORE -eq 8 ]] && echo "💪 EXCELLENT - Strong security")

RECOMMENDATIONS:
1. Change password if score < 6
2. Use suggested strong password
3. Disable WPS on router
4. Enable MAC filtering
5. Update router firmware

SUGGESTED STRONG PASSWORD:
$STRONG_PASS

LEGAL DISCLAIMER:
This report is for educational purposes only.
Only test on networks you own or have permission to test.
EOF

echo "[+] Report saved: /sdcard/wifi_security_report.txt"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║           TEST COMPLETE!            ║"
echo "║    Check /sdcard/ for results       ║"
echo "╚══════════════════════════════════════╝"