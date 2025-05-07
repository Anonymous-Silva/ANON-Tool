# Anonymous-Silva Recon Tool (Windows Edition)
<!-- Replace with actual banner image if available -->

A powerful network reconnaissance and information-gathering tool for Windows, designed for security researchers, penetration testers, and network enthusiasts. Built in PowerShell, this tool provides a suite of utilities to gather information about websites, IP addresses, phone numbers, emails, and more, with a sleek interface and robust functionality.

**Author:** Anonymous-Silva  
**GitHub:** https://github.com/Anonymous-Silva  
**License:** MIT License  

## Table of Contents
- Features
- Prerequisites
- Installation
- Usage
- Available Tools
- Limitations
- Contributing
- License
- Disclaimer

## Features
- **Website Information Gathering:** Retrieve details such as IP location, hosting company, reverse DNS, and DNS records for a given URL.
- **Phone Number Lookup:** Validate phone numbers and obtain country, carrier, location, and line type information.
- **Email Validation:** Check the validity of email addresses using an external API.
- **IP Information:** Display your public IP address and remote host details.
- **Site Status Check:** Determine if a website is up or down based on HTTP response codes.
- **IP Tracking:** Gather geolocation and ISP information for a specified IP address.
- **DNS Leak Test:** Identify potential DNS leaks by querying external DNS servers.
- **Internet Speed Test:** Provides instructions for running a speed test using the official Speedtest CLI.
- **Cloudflare Bypass:** Attempt to find the real IP address behind Cloudflare-protected sites.
- **Subdomain Scanner:** Discover subdomains for a given domain.
- **CMS Detection:** Identify the Content Management System (CMS) used by a website.
- **Port Scanner:** Scan single ports or a range of ports to check for open services.
- **User-Friendly Interface:** Sleek ASCII art, color-coded output, and an intuitive menu system.
- **Windows Compatibility:** Fully adapted for Windows using PowerShell, with no reliance on Linux-specific tools.

## Prerequisites
- **Operating System:** Windows 10 or later (Windows Server 2016+ also supported).
- **PowerShell:** PowerShell 5.1 (included) or PowerShell 7 (recommended). Install via:
```powershell
winget install Microsoft.PowerShell
```
- **nslookup:** Included by default in Windows.
- **Internet Connection:** Required for API calls.
- **Speedtest CLI (Optional):** Download from https://www.speedtest.net/apps/cli.
- **API Keys:** Replace hardcoded keys if expired or rate-limited.

## Installation
**Download the Script:**  
Clone or copy the script:
```bash
git clone https://github.com/Anonymous-Silva/ANON Tool.git
```
Or copy into `recon-tool.ps1`.

**Set Execution Policy:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
Confirm with `Y` when prompted.

**Optional: Install Speedtest CLI:**  
Download and follow instructions from https://www.speedtest.net/apps/cli.

## Usage
**Open PowerShell:**  
Run `powershell` or `pwsh`.

**Navigate to Script Directory:**
```powershell
cd path\to\script
```

**Run the Script:**
```powershell
.\recon-tool.ps1
```

**Interact with the Menu:**  
Choose tools by entering a number (e.g., 1 or 01). Use 99 to exit.

## Available Tools
| Option | Tool                | Description |
|--------|---------------------|-------------|
| 1      | Website Information | Gather details like IP location, hosting company, and DNS records |
| 2      | Phone Number Lookup | Validate phone numbers and retrieve country, carrier, location |
| 3      | Email Validator     | Check if an email address is valid using an API |
| 4      | My IP Information   | Display your public IP address and remote host |
| 5      | Site Status Check   | Check if a website is up or down |
| 6      | IP Tracker          | Retrieve geolocation and ISP info for an IP address |
| 7      | DNS Leak Test       | Identify potential DNS leaks |
| 8      | Internet Speed Test | Instructions for running Speedtest CLI |
| 9      | Cloudflare Bypass   | Attempt to find the real IP behind Cloudflare |
| 10     | Subdomain Scanner   | Discover subdomains |
| 11     | CMS Detector        | Identify the CMS (e.g., WordPress) |
| 12     | Port Scanner        | Scan ports to check for open services |
| 99     | Exit                | Exit the tool |

## Limitations
- **Speed Test:** Requires manual CLI install.
- **Port Scanning Performance:** Consider `nmap` or `nc` for faster scanning.
- **API Dependence:** Rate limits or endpoint changes may affect tools.
- **Text Parsing:** HTML scraping with regex may break.
- **Windows-Specific:** Designed for Windows only.

## Contributing
- Fork, branch, commit, push, and submit a Pull Request.
- Follow project style and include documentation.

## License
This project is licensed under the MIT License.

## Disclaimer
This tool is for **educational and ethical use only**. Do not use it without permission. The author is not responsible for misuse. Use responsibly and legally.

**Stay Anonymous!**  
Anonymous-Silva  
https://github.com/Anonymous-Silva
