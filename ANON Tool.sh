#!/bin/bash

# Anonymous-Silva Recon Tool
# GitHub: https://github.com/Anonymous-Silva
# A network reconnaissance and information gathering tool

# ANSI color codes
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
RESET='\e[0m'

# New ASCII art
function display_banner() {
    echo -e "${CYAN}"
    echo "  ╔════════════════════════════════════════════════════╗"
    echo "  ║                                                    ║"
    echo "  ║       █████╗ ███╗   ██╗██████╗ ███╗   ██╗          ║"
    echo "  ║      ██╔══██╗████╗  ██║██╔══██╗████╗  ██║          ║"
    echo "  ║     ███████║██╔██╗ ██║██║  ██║██╔██╗ ██║          ║"
    echo "  ║     ██╔══██║██║╚██╗██║██║  ██║██║╚██╗██║          ║"
    echo "  ║     ██║  ██║██║ ╚████║██████╔╝██║ ╚████║          ║"
    echo "  ║     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═══╝          ║"
    echo "  ║                                                    ║"
    echo "  ║       Recon Tool by Anonymous-Silva                ║"
    echo "  ║       GitHub: https://github.com/Anonymous-Silva   ║"
    echo "  ╚════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
}

# Function to gather website information
function web_info() {
    [[ -f webdata ]] && rm -rf webdata
    echo -e "${GREEN}[+] Enter target URL:${RESET}"
    read -r target_url

    curl -s -L "myip.ms/$target_url" > webdata

    ip_loc=$(grep 'IP Location:' webdata | grep -o "'cflag .*\'" | cut -d "I" -f1 | cut -d '>' -f1 | tr -d "\'" | cut -d " " -f2)
    [[ -n "$ip_loc" ]] && echo -e "${YELLOW}[*] IP Location:${RESET} $ip_loc"

    ip_rng=$(grep -o 'IP Range .*' webdata | head -n1 | cut -d "<" -f2 | cut -d ">" -f2)
    [[ -n "$ip_rng" ]] && echo -e "${YELLOW}[*] IP Range:${RESET} $ip_rng"

    ip_rdns=$(grep 'IP Reverse DNS' webdata | grep 'sval' | head -n1 | cut -d ">" -f6 | cut -d "<" -f1)
    [[ -n "$ip_rdns" ]] && echo -e "${YELLOW}[*] Reverse DNS:${RESET} $ip_rdns"

    ipv6_addr=$(grep 'whois6' webdata | cut -d "/" -f4 | cut -d "'" -f1 | head -n1)
    [[ -n "$ipv6_addr" ]] && echo -e "${YELLOW}[*] IPv6:${RESET} $ipv6_addr"

    host_co=$(grep -o 'Hosting Company .*-.*.' webdata | head -n1 | cut -d "-" -f2 | cut -d "." -f1)
    [[ -n "$host_co" ]] && echo -e "${YELLOW}[*] Hosting Company:${RESET} $host_co"

    owner_addr=$(grep -o 'Owner Address: .*' webdata | cut -d ">" -f3 | cut -d "<" -f1)
    [[ -n "$owner_addr" ]] && echo -e "${YELLOW}[*] Owner Address:${RESET} $owner_addr"

    host_country=$(grep 'Hosting Country:' webdata | grep -o "'cflag .*\'" | cut -d "I" -f1 | cut -d '>' -f1 | tr -d "\'" | cut -d " " -f2)
    [[ -n "$host_country" ]] && echo -e "${YELLOW}[*] Hosting Country:${RESET} $host_country"

    host_phone=$(grep -o 'Hosting Phone: .*' webdata | cut -d "<" -f3 | cut -d ">" -f2)
    [[ -n "$host_phone" ]] && echo -e "${YELLOW}[*] Hosting Phone:${RESET} $host_phone"

    host_web=$(grep -o 'Hosting Website: .*' webdata | grep -o "href=.*" | cut -d "<" -f1 | cut -d ">" -f2)
    [[ -n "$host_web" ]] && echo -e "${YELLOW}[*] Hosting Website:${RESET} $host_web"

    dns_ns=$(curl -s "https://dns-api.org/NS/$target_url" | grep -o 'value\":.*\"' | cut -d " " -f2 | tr -d '\"')
    [[ -n "$dns_ns" ]] && echo -e "${YELLOW}[*] Nameservers:${RESET} $dns_ns"

    mx_rec=$(curl -s "https://dns-api.org/MX/$target_url" | grep -o 'value\":.*\"' | cut -d " " -f2 | tr -d '\"')
    [[ -n "$mx_rec" ]] && echo -e "${YELLOW}[*] MX Records:${RESET} $mx_rec"

    [[ -f webdata ]] && rm -rf webdata
}

# Function to gather phone information
function phone_info() {
    [[ -f phone_data.txt ]] && rm -rf phone_data.txt
    echo -e "${GREEN}[+] Enter phone number (e.g., 14158586273):${RESET}"
    read -r phone_num

    curl -s "apilayer.net/api/validate?access_key=43fc2577cf1cdb2eb522583eaee6ae8f&number=$phone_num&country_code=&format=1" -L > phone_data.txt

    if grep -q 'valid\":true' phone_data.txt; then
        country=$(grep 'country_name\":\"' phone_data.txt | cut -d ":" -f2 | tr -d ',' | tr -d '\"')
        location=$(grep 'location\":\"' phone_data.txt | cut -d ":" -f2 | tr -d ',' | tr -d '\"')
        carrier=$(grep 'carrier\":\"' phone_data.txt | cut -d ":" -f2 | tr -d ',' | tr -d '\"')
        line_type=$(grep 'line_type\":\"' phone_data.txt | cut -d ":" -f2 | tr -d ',' | tr -d '\"')

        echo -e "${YELLOW}[*] Country:${RESET} $country"
        echo -e "${YELLOW}[*] Location:${RESET} $location"
        echo -e "${YELLOW}[*] Carrier:${RESET} $carrier"
        echo -e "${YELLOW}[*] Line Type:${RESET} $line_type"
    else
        echo -e "${RED}[!] Invalid phone number!${RESET}"
    fi

    [[ -f phone_data.txt ]] && rm -rf phone_data.txt
}

# Function to check email validity
function email_check() {
    echo -e "${GREEN}[+] Enter email address:${RESET}"
    read -r email

    result=$(curl -s "https://api.2ip.me/email.txt?email=$email" | grep -o 'true\|false')
    if [[ "$result" == "true" ]]; then
        echo -e "${GREEN}[*] Valid email address!${RESET}"
    else
        echo -e "${RED}[!] Invalid email address!${RESET}"
    fi
}

# Function to display user's IP information
function my_ip_info() {
    [[ -f ip_info ]] && rm -rf ip_info
    curl -s "ifconfig.me/all" > ip_info

    ip_addr=$(grep -o 'ip_addr:.*' ip_info | cut -d " " -f2)
    remote_host=$(grep -o 'remote_host:.*' ip_info | cut -d " " -f2)

    echo -e "${YELLOW}[*] My IP:${RESET} $ip_addr"
    echo -e "${YELLOW}[*] Remote Host:${RESET} $remote_host"

    [[ -f ip_info ]] && rm -rf ip_info
}

# Function to check if a site is up or down
function site_status() {
    echo -e "${GREEN}[+] Enter site URL:${RESET}"
    read -r site_url

    status=$(curl -sLi --user-agent 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31' "$site_url" | grep -o 'HTTP/1.1 200 OK\|HTTP/2 200')
    if [[ "$status" == *"200"* ]]; then
        echo -e "${GREEN}[*] Site is UP!${RESET}"
    else
        echo -e "${RED}[*] Site is DOWN!${RESET}"
    fi
}

# Function to track IP information
function ip_tracker() {
    [[ -f ip_track.log ]] && rm -rf ip_track.log
    echo -e "${GREEN}[+] Enter IP address to track:${RESET}"
    read -r ip_addr

    curl -s -L "www.ip-tracker.org/locator/ip-lookup.php?ip=$ip_addr" --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31" > ip_track.log

    continent=$(grep -o 'Continent.*' ip_track.log | head -n1 | cut -d ">" -f3 | cut -d "<" -f1)
    [[ -n "$continent" ]] && echo -e "${YELLOW}[*] Continent:${RESET} $continent"

    hostname=$(grep -o "</td></tr><tr><th>Hostname:.*" ip_track.log | cut -d "<" -f7 | cut -d ">" -f2)
    [[ -n "$hostname" ]] && echo -e "${YELLOW}[*] Hostname:${RESET} $hostname"

    country=$(grep -o 'Country:.*' ip_track.log | cut -d ">" -f3 | cut -d "&" -f1)
    [[ -n "$country" ]] && echo -e "${YELLOW}[*] Country:${RESET} $country"

    city=$(grep -o "City Location:.*" ip_track.log | cut -d "<" -f3 | cut -d ">" -f2)
    [[ -n "$city" ]] && echo -e "${YELLOW}[*] City:${RESET} $city"

    isp=$(grep -o "ISP:.*" ip_track.log | cut -d "<" -f3 | cut -d ">" -f2)
    [[ -n "$isp" ]] && echo -e "${YELLOW}[*] ISP:${RESET} $isp"

    [[ -f ip_track.log ]] && rm -rf ip_track.log
}

# Function to check DNS leaks
function dns_leak_test() {
    echo -e "${GREEN}[+] Running DNS Leak Test...${RESET}"
    for i in {1..3}; do
        echo -e "${YELLOW}[*] Test $i/3...${RESET}"
        dns_ip=$(nslookup whoami.akamai.net | grep -o 'Address:.*' | sed -n '2,2p' | cut -d " " -f2)
        curl -s -L "www.ip-tracker.org/locator/ip-lookup.php?ip=$dns_ip" --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31" > dns_test
        city=$(grep -o "City Location:.*" dns_test | cut -d "<" -f3 | cut -d ">" -f2)
        country=$(grep -o 'Country:.*' dns_test | cut -d ">" -f3 | cut -d "&" -f1)
        echo -e "${CYAN}[*] DNS IP: $dns_ip, Country: $country, City: $city${RESET}"
        rm -rf dns_test
        sleep 5
    done
    echo -e "${RED}[!] If your city appears, your DNS may be leaking!${RESET}"
}

# Function to perform internet speed test
function speed_test() {
    echo -e "${GREEN}[+] Running Internet Speed Test...${RESET}"
    curl -skLO https://git.io/speedtest.sh && chmod +x speedtest.sh
    ./speedtest.sh --simple
    rm -rf speedtest.sh
}

# Function to find IP behind Cloudflare
function cloudflare_bypass() {
    echo -e "${GREEN}[+] Enter Cloudflare-protected site:${RESET}"
    read -r cf_site

    if curl -s -L "https://dns-api.org/NS/$cf_site" | grep -q 'cloudflare'; then
        curl -s --request POST "http://www.crimeflare.biz:82/cgi-bin/cfsearch.cgi" -d "cfS=$cf_site" -L --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31" > cf.log
        if grep -q "A direct-connect IP address was found" cf.log; then
            real_ip=$(grep "<font color=#c00000>" cf.log | sed -n '2,2p' | cut -d "<" -f2 | cut -d ">" -f2)
            echo -e "${YELLOW}[*] Real IP:${RESET} $real_ip"
        else
            echo -e "${RED}[!] No direct IP found!${RESET}"
        fi
        rm -rf cf.log
    else
        echo -e "${RED}[!] This site is not using Cloudflare!${RESET}"
    fi
}

# Function to find subdomains
function subdomain_scan() {
    echo -e "${GREEN}[+] Enter site for subdomain scan:${RESET}"
    read -r sub_site

    curl -s -L "https://www.pagesinventory.com/search/?s=$sub_site" > sub.log
    subdomains=$(grep -o -P "domain/.{0,40}.$sub_site.html" sub.log | cut -d "." -f1 | cut -d "/" -f2)
    if [[ -n "$subdomains" ]]; then
        echo -e "${YELLOW}[*] Subdomains found:${RESET}"
        echo -e "${CYAN}$subdomains${RESET}"
    else
        echo -e "${RED}[!] No subdomains found!${RESET}"
    fi
    rm -rf sub.log
}

# Function to detect CMS
function cms_detect() {
    echo -e "${GREEN}[+] Enter site URL for CMS detection:${RESET}"
    read -r cms_url

    curl -s -L "https://whatcms.org/APIEndpoint?key=759cba81d90c6188ec5f7d2e2bf8568501a748d752fd2acdba45ee361181f58d07df7d&url=$cms_url" > cms.log
    if grep -q 'Success' cms.log; then
        cms_name=$(grep -o '"name":.*,' cms.log | cut -d "," -f1 | cut -d ":" -f2 | tr -d '\"')
        echo -e "${YELLOW}[*] CMS Detected:${RESET} $cms_name"
    elif grep -q 'Too Many Requests' cms.log; then
        echo -e "${RED}[!] Too Many Requests! Try again later.${RESET}"
    else
        echo -e "${RED}[!] CMS or Host Not Found!${RESET}"
    fi
    rm -rf cms.log
}

# Function to scan ports
function port_scanner() {
    echo -e "${GREEN}[+] Enter target host:${RESET}"
    read -r host
    echo -e "${GREEN}[+] Choose scan type: 1) Single Port, 2) Port Range${RESET}"
    read -r scan_type

    if [[ "$scan_type" == "1" ]]; then
        echo -e "${GREEN}[+] Enter port number:${RESET}"
        read -r port
        if nc -z -v -w3 "$host" "$port" 2>&1 >/dev/null | grep -q 'open'; then
            echo -e "${GREEN}[*] Port $port is OPEN!${RESET}"
        else
            echo -e "${RED}[*] Port $port is CLOSED!${RESET}"
        fi
    elif [[ "$scan_type" == "2" ]]; then
        echo -e "${GREEN}[+] Enter port range (e.g., 1 1000):${RESET}"
        read -r start_port end_port
        echo -e "${GREEN}[+] Enter number of threads (default: 10):${RESET}"
        read -r threads
        threads=${threads:-10}

        seq "$start_port" "$end_port" > ports
        total_ports=$(wc -l ports | cut -d " " -f1)
        echo -e "${RED}[!] Press Ctrl+C to stop${RESET}"

        while IFS= read -r port; do
            if nc -z -v -w3 "$host" "$port" 2>&1 >/dev/null | grep -q 'open'; then
                echo -e "${GREEN}[*] Port $port is OPEN!${RESET}"
                echo "$port" >> open_ports
            fi
        done < ports &
        wait

        if [[ -f open_ports ]]; then
            total_open=$(wc -l open_ports | cut -d " " -f1)
            echo -e "${YELLOW}[*] Total Open Ports:${RESET} $total_open"
            cat open_ports
            rm -rf open_ports
        fi
        rm -rf ports
    fi
}

# Main menu
function main_menu() {
    display_banner
    echo -e "${BLUE}=== Recon Tool Menu ===${RESET}"
    echo -e "${GREEN}1)  Website Information${RESET}"
    echo -e "${GREEN}2)  Phone Number Lookup${RESET}"
    echo -e "${GREEN}3)  Email Validator${RESET}"
    echo -e "${GREEN}4)  My IP Information${RESET}"
    echo -e "${GREEN}5)  Site Status Check${RESET}"
    echo -e "${GREEN}6)  IP Tracker${RESET}"
    echo -e "${GREEN}7)  DNS Leak Test${RESET}"
    echo -e "${GREEN}8)  Internet Speed Test${RESET}"
    echo -e "${GREEN}9)  Cloudflare Bypass${RESET}"
    echo -e "${GREEN}10) Subdomain Scanner${RESET}"
    echo -e "${GREEN}11) CMS Detector${RESET}"
    echo -e "${GREEN}12) Port Scanner${RESET}"
    echo -e "${GREEN}99) Exit${RESET}"
    echo -e "${BLUE}======================${RESET}"
    echo -e "${GREEN}[+] Select an option:${RESET}"
    read -r option

    case "$option" in
        1|01) web_info ;;
        2|02) phone_info ;;
        3|03) email_check ;;
        4|04) my_ip_info ;;
        5|05) site_status ;;
        6|06) ip_tracker ;;
        7|07) dns_leak_test ;;
        8|08) speed_test ;;
        9|09) cloudflare_bypass ;;
        10) subdomain_scan ;;
        11) cms_detect ;;
        12) port_scanner ;;
        99) echo -e "${RED}[!] Exiting... Stay Anonymous!${RESET}"; exit 0 ;;
        *) echo -e "${RED}[!] Invalid option!${RESET}"; sleep 1; main_menu ;;
    esac
}

# Start the tool
main_menu