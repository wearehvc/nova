#!/usr/bin/env bash

# Set target domain
sudo apt-get install figlet
figlet -s NOVA
echo "simple Automation script to  enum subdomains and find xss in them and thanks Chat gpt made by @Ashw4 Team: @HVC "
echo "please make sure install nabbu ,httpx,nuclei,dirsearch,subfinder"
echo "Please Enter Your Target Domain "
read target_domain

# Use Subfinder to find subdomains
subfinder -d $target_domain -o subdomains.txt

# Use HTTPX to gather information about HTTP servers on found subdomains
cat subdomains.txt | while read subdomain; do
    httpx -title -status-code -silent -content-length $subdomain >> httpx-output.txt
done

# Use Dirsearch to scan for directories on found subdomains
cat subdomains.txt | while read subdomain; do
    dirsearch -u $subdomain -e * -x 400,401,402,403,405 -w /usr/share/dirb/wordlists/common.txt
done

# Use Naabu to scan for open ports on found subdomains
cat subdomains.txt | while read subdomain; do
    naabu -hL subdomains.txt -ports full -o naabu-output.txt
done

# Use Nuclei to scan for XSS vulnerabilities on found subdomains
cat subdomains.txt | while read subdomain; do
    nuclei -t templates/xss.yaml -l $subdomain -o nuclei-output.txt
done

