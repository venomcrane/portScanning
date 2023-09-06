#!/bin/bash

# Extract nmap information
function extractPorts(){
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
    echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
    echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
    echo $ports | tr -d '\n' | xclip -sel clip
    echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
    cat extractPorts.tmp; rm extractPorts.tmp

    echo -e "\n[+] Performing Network Scanning...\n"

    sudo nmap -sCV -vvv -p$ports $ip_address -oN netScan 
}

# Funcion portScan
function portScan(){
    read -p "> IP Address: " ip
    echo -e "\n[+] Selected IP Address: $ip\n"
    echo -e "\n[+] Scanning...\n"
    sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn $ip -oG initScan

    extractPorts initScan
}

# Call the function portScan
portScan
