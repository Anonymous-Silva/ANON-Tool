# Anonymous-Silva Recon Tool (Windows Edition)
# GitHub: https://github.com/Anonymous-Silva
# A network reconnaissance and information gathering tool for Windows

# Color definitions
$Green = "`e[1;32m"
$Yellow = "`e[1;33m"
$Red = "`e[1;31m"
$Blue = "`e[1;34m"
$Cyan = "`e[1;36m"
$Reset = "`e[0m"

# Function to display the banner
function Show-Banner {
    Write-Host "$Cyan"
    Write-Host "  ╔════════════════════════════════════════════════════╗"
    Write-Host "  ║                                                    ║"
    Write-Host "  ║       █████╗ ███╗   ██╗██████╗ ███╗   ██╗          ║"
    Write-Host "  ║      ██╔══██╗████╗  ██║██╔══██╗████╗  ██║          ║"
    Write-Host "  ║     ███████║██╔██╗ ██║██║  ██║██╔██╗ ██║          ║"
    Write-Host "  ║     ██╔══██║██║╚██╗██║██║  ██║██║╚██╗██║          ║"
    Write-Host "  ║     ██║  ██║██║ ╚████║██████╔╝██║ ╚████║          ║"
    Write-Host "  ║     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═══╝          ║"
    Write-Host "  ║                                                    ║"
    Write-Host "  ║       Recon Tool by Anonymous-Silva                ║"
    Write-Host "  ║       GitHub: https://github.com/Anonymous-Silva   ║"
    Write-Host "  ╚════════════════════════════════════════════════════╝"
    Write-Host "$Reset"
    Write-Host ""
}

# Function to gather website information
function Get-WebInfo {
    if (Test-Path "webdata") { Remove-Item "webdata" -Force }
    Write-Host "$Green[+] Enter target URL:$Reset" -NoNewline
    $targetUrl = Read-Host

    $response = Invoke-WebRequest -Uri "https://myip.ms/$targetUrl" -UseBasicParsing
    Set-Content -Path "webdata" -Value $response.Content

    $ipLoc = Select-String -Path "webdata" -Pattern "IP Location:" | ForEach-Object { $_ -match "'cflag .*?'" | Out-Null; $Matches[0] -replace "'cflag |'", "" -split " " | Select-Object -Last 1 }
    if ($ipLoc) { Write-Host "$Yellow[*] IP Location:$Reset $ipLoc" }

    $ipRange = Select-String -Path "webdata" -Pattern "IP Range .*" | Select-Object -First 1 | ForEach-Object { $_ -replace ".*<td>(.*?)</td>.*", '$1' }
    if ($ipRange) { Write-Host "$Yellow[*] IP Range:$Reset $ipRange" }

    $ipRdns = Select-String -Path "webdata" -Pattern "IP Reverse DNS" | Select-Object -First 1 | ForEach-Object { $_ -match "sval.*>(.*?)<" | Out-Null; $Matches[1] }
    if ($ipRdns) { Write-Host "$Yellow[*] Reverse DNS:$Reset $ipRdns" }

    $ipv6 = Select-String -Path "webdata" -Pattern "whois6" | ForEach-Object { $_ -match "/([^/']+)'_started" | Out-Null; $Matches[1] } | Select-Object -First 1
    if ($ipv6) { Write-Host "$Yellow[*] IPv6:$Reset $ipv6" }

    $hostCo = Select-String -Path "webdata" -Pattern "Hosting Company .*-.*\." | Select-Object -First 1 | ForEach-Object { $_ -replace ".*-(.*?)\..*", '$1' }
    if ($hostCo) { Write-Host "$Yellow[*] Hosting Company:$Reset $hostCo" }

    $ownerAddr = Select-String -Path "webdata" -Pattern "Owner Address: .*" | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' }
    if ($ownerAddr) { Write-Host "$Yellow[*] Owner Address:$Reset $ownerAddr" }

    $hostCountry = Select-String -Path "webdata" -Pattern "Hosting Country:" | ForEach-Object { $_ -match "'cflag .*?'" | Out-Null; $Matches[0] -replace "'cflag |'", "" -split " " | Select-Object -Last 1 }
    if ($hostCountry) { Write-Host "$Yellow[*] Hosting Country:$Reset $hostCountry" }

    $hostPhone = Select-String -Path "webdata" -Pattern "Hosting Phone: .*" | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' }
    if ($hostPhone) { Write-Host "$Yellow[*] Hosting Phone:$Reset $hostPhone" }

    $hostWeb = Select-String -Path "webdata" -Pattern "Hosting Website: .*" | ForEach-Object { $_ -match "href=.*?>(.*?)<" | Out-Null; $Matches[1] }
    if ($hostWeb) { Write-Host "$Yellow[*] Hosting Website:$Reset $hostWeb" }

    $dnsNs = (Invoke-WebRequest -Uri "https://dns-api.org/NS/$targetUrl" -UseBasicParsing).Content | ConvertFrom-Json | ForEach-Object { $_.value }
    if ($dnsNs) { Write-Host "$Yellow[*] Nameservers:$Reset $dnsNs" }

    $mxRec = (Invoke-WebRequest -Uri "https://dns-api.org/MX/$targetUrl" -UseBasicParsing).Content | ConvertFrom-Json | ForEach-Object { $_.value }
    if ($mxRec) { Write-Host "$Yellow[*] MX Records:$Reset $mxRec" }

    if (Test-Path "webdata") { Remove-Item "webdata" -Force }
}

# Function to gather phone information
function Get-PhoneInfo {
    if (Test-Path "phone_data.txt") { Remove-Item "phone_data.txt" -Force }
    Write-Host "$Green[+] Enter phone number (e.g., 14158586273):$Reset" -NoNewline
    $phoneNum = Read-Host

    $response = Invoke-WebRequest -Uri "https://apilayer.net/api/validate?access_key=43fc2577cf1cdb2eb522583eaee6ae8f&number=$phoneNum&country_code=&format=1" -UseBasicParsing
    Set-Content -Path "phone_data.txt" -Value $response.Content

    if ((Get-Content "phone_data.txt") -match '"valid":true') {
        $phoneData = Get-Content "phone_data.txt" | ConvertFrom-Json
        Write-Host "$Yellow[*] Country:$Reset $($phoneData.country_name)"
        Write-Host "$Yellow[*] Location:$Reset $($phoneData.location)"
        Write-Host "$Yellow[*] Carrier:$Reset $($phoneData.carrier)"
        Write-Host "$Yellow[*] Line Type:$Reset $($phoneData.line_type)"
    } else {
        Write-Host "$Red[!] Invalid phone number!$Reset"
    }

    if (Test-Path "phone_data.txt") { Remove-Item "phone_data.txt" -Force }
}

# Function to check email validity
function Test-Email {
    Write-Host "$Green[+] Enter email address:$Reset" -NoNewline
    $email = Read-Host

    $response = Invoke-WebRequest -Uri "https://api.2ip.me/email.txt?email=$email" -UseBasicParsing
    if ($response.Content -match "true") {
        Write-Host "$Green[*] Valid email address!$Reset"
    } else {
        Write-Host "$Red[!] Invalid email address!$Reset"
    }
}

# Function to display user's IP information
function Get-MyIpInfo {
    if (Test-Path "ip_info") { Remove-Item "ip_info" -Force }
    $response = Invoke-WebRequest -Uri "https://ifconfig.me/all" -UseBasicParsing
    Set-Content -Path "ip_info" -Value $response.Content

    $ipAddr = Select-String -Path "ip_info" -Pattern "ip_addr:.*" | ForEach-Object { $_ -replace "ip_addr: (.*)", '$1' }
    $remoteHost = Select-String -Path "ip_info" -Pattern "remote_host:.*" | ForEach-Object { $_ -replace "remote_host: (.*)", '$1' }

    Write-Host "$Yellow[*] My IP:$Reset $ipAddr"
    Write-Host "$Yellow[*] Remote Host:$Reset $remoteHost"

    if (Test-Path "ip_info") { Remove-Item "ip_info" -Force }
}

# Function to check if a site is up or down
function Test-SiteStatus {
    Write-Host "$Green[+] Enter site URL:$Reset" -NoNewline
    $siteUrl = Read-Host

    try {
        $response = Invoke-WebRequest -Uri $siteUrl -Method Head -UseBasicParsing -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        if ($response.StatusCode -eq 200) {
            Write-Host "$Green[*] Site is UP!$Reset"
        } else {
            Write-Host "$Red[*] Site is DOWN!$Reset"
        }
    } catch {
        Write-Host "$Red[*] Site is DOWN!$Reset"
    }
}

# Function to track IP information
function Get-IpTracker {
    if (Test-Path "ip_track.log") { Remove-Item "ip_track.log" -Force }
    Write-Host "$Green[+] Enter IP address to track:$Reset" -NoNewline
    $ipAddr = Read-Host

    $response = Invoke-WebRequest -Uri "https://www.ip-tracker.org/locator/ip-lookup.php?ip=$ipAddr" -UseBasicParsing -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    Set-Content -Path "ip_track.log" -Value $response.Content

    $continent = Select-String -Path "ip_track.log" -Pattern "Continent.*" | Select-Object -First 1 | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' }
    if ($continent) { Write-Host "$Yellow[*] Continent:$Reset $continent" }

    $hostname = Select-String -Path "ip_track.log" -Pattern "Hostname:.*" | ForEach-Object { $_ -match "Hostname:.*>(.*?)<" | Out-Null; $Matches[1] }
    if ($hostname) { Write-Host "$Yellow[*] Hostname:$Reset $hostname" }

    $country = Select-String -Path "ip_track.log" -Pattern "Country:.*" | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' -replace "&.*", "" }
    if ($country) { Write-Host "$Yellow[*] Country:$Reset $country" }

    $city = Select-String -Path "ip_track.log" -Pattern "City Location:.*" | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' }
    if ($city) { Write-Host "$Yellow[*] City:$Reset $city" }

    $isp = Select-String -Path "ip_track.log" -Pattern "ISP:.*" | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' }
    if ($isp) { Write-Host "$Yellow[*] ISP:$Reset $isp" }

    if (Test-Path "ip_track.log") { Remove-Item "ip_track.log" -Force }
}

# Function to check DNS leaks
function Test-DnsLeak {
    Write-Host "$Green[+] Running DNS Leak Test...$Reset"
    for ($i = 1; $i -le 3; $i++) {
        Write-Host "$Yellow[*] Test $i/3...$Reset"
        $dnsIp = (nslookup whoami.akamai.net | Select-String -Pattern "Address:" | Select-Object -Skip 1).ToString().Split()[-1]
        $response = Invoke-WebRequest -Uri "https://www.ip-tracker.org/locator/ip-lookup.php?ip=$dnsIp" -UseBasicParsing -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        Set-Content -Path "dns_test" -Value $response.Content

        $city = Select-String -Path "dns_test" -Pattern "City Location:.*" | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' }
        $country = Select-String -Path "dns_test" -Pattern "Country:.*" | ForEach-Object { $_ -replace ".*>(.*?)<.*", '$1' -replace "&.*", "" }

        Write-Host "$Cyan[*] DNS IP: $dnsIp, Country: $country, City: $city$Reset"
        Remove-Item "dns_test" -Force
        Start-Sleep -Seconds 5
    }
    Write-Host "$Red[!] If your city appears, your DNS may be leaking!$Reset"
}

# Function to perform internet speed test
function Test-Speed {
    Write-Host "$Green[+] Running Internet Speed Test...$Reset"
    Write-Host "$Yellow[*] Note: Speed test requires external tools like Speedtest CLI. Please install it manually.$Reset"
    Write-Host "$Yellow[*] Visit https://www.speedtest.net/apps/cli to download.$Reset"
}

# Function to find IP behind Cloudflare
function Get-CloudflareBypass {
    Write-Host "$Green[+] Enter Cloudflare-protected site:$Reset" -NoNewline
    $cfSite = Read-Host

    $nsResponse = Invoke-WebRequest -Uri "https://dns-api.org/NS/$cfSite" -UseBasicParsing
    if ($nsResponse.Content -match "cloudflare") {
        $response = Invoke-WebRequest -Uri "http://www.crimeflare.biz:82/cgi-bin/cfsearch.cgi" -Method Post -Body "cfS=$cfSite" -UseBasicParsing -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        Set-Content -Path "cf.log" -Value $response.Content

        if ((Get-Content "cf.log") -match "A direct-connect IP address was found") {
            $realIp = Select-String -Path "cf.log" -Pattern "<font color=#c00000>" | Select-Object -Skip 1 | ForEach-Object { $_ -match ">(.*?)<" | Out-Null; $Matches[1] }
            Write-Host "$Yellow[*] Real IP:$Reset $realIp"
        } else {
            Write-Host "$Red[!] No direct IP found!$Reset"
        }
        Remove-Item "cf.log" -Force
    } else {
        Write-Host "$Red[!] This site is not using Cloudflare!$Reset"
    }
}

# Function to find subdomains
function Get-Subdomains {
    Write-Host "$Green[+] Enter site for subdomain scan:$Reset" -NoNewline
    $subSite = Read-Host

    $response = Invoke-WebRequest -Uri "https://www.pagesinventory.com/search/?s=$subSite" -UseBasicParsing
    Set-Content -Path "sub.log" -Value $response.Content

    $subdomains = Select-String -Path "sub.log" -Pattern "domain/.{0,40}\.$subSite\.html" | ForEach-Object { $_ -replace ".*domain/(.*?)\.$subSite\.html", '$1' }
    if ($subdomains) {
        Write-Host "$Yellow[*] Subdomains found:$Reset"
        $subdomains | ForEach-Object { Write-Host "$Cyan$_$Reset" }
    } else {
        Write-Host "$Red[!] No subdomains found!$Reset"
    }
    Remove-Item "sub.log" -Force
}

# Function to detect CMS
function Get-Cms {
    Write-Host "$Green[+] Enter site URL for CMS detection:$Reset" -NoNewline
    $cmsUrl = Read-Host

    $response = Invoke-WebRequest -Uri "https://whatcms.org/APIEndpoint?key=759cba81d90c6188ec5f7d2e2bf8568501a748d752fd2acdba45ee361181f58d07df7d&url=$cmsUrl" -UseBasicParsing
    Set-Content -Path "cms.log" -Value $response.Content

    if ((Get-Content "cms.log") -match '"Success"') {
        $cmsName = Select-String -Path "cms.log" -Pattern '"name":.*,' | ForEach-Object { $_ -replace '.*"name":"(.*?)",.*', '$1' }
        Write-Host "$Yellow[*] CMS Detected:$Reset $cmsName"
    } elseif ((Get-Content "cms.log") -match "Too Many Requests") {
        Write-Host "$Red[!] Too Many Requests! Try again later.$Reset"
    } else {
        Write-Host "$Red[!] CMS or Host Not Found!$Reset"
    }
    Remove-Item "cms.log" -Force
}

# Function to scan ports
function Test-Ports {
    Write-Host "$Green[+] Enter target host:$Reset" -NoNewline
    $targetHost = Read-Host
    Write-Host "$Green[+] Choose scan type: 1) Single Port, 2) Port Range$Reset" -NoNewline
    $scanType = Read-Host

    if ($scanType -eq "1") {
        Write-Host "$Green[+] Enter port number:$Reset" -NoNewline
        $port = Read-Host
        try {
            $result = Test-NetConnection -ComputerName $host -Port $port -WarningAction SilentlyContinue
            if ($result.TcpTestSucceeded) {
                Write-Host "$Green[*] Port $port is OPEN!$Reset"
            } else {
                Write-Host "$Red[*] Port $port is CLOSED!$Reset"
            }
        } catch {
            Write-Host "$Red[*] Port $port is CLOSED!$Reset"
        }
    } elseif ($scanType -eq "2") {
        Write-Host "$Green[+] Enter port range (e.g., 1 1000):$Reset" -NoNewline
        $range = Read-Host
        $startPort, $endPort = $range -split "\s+"
        $targetHostName = $targetHost
        Write-Host "$Green[+] Enter number of threads (default: 10):$Reset" -NoNewline
        $threads = Read-Host
        if (-not $threads) { $threads = 10 }

        Write-Host "$Red[!] Press Ctrl+C to stop$Reset"
        $openPorts = @()
        $jobs = @()

        for ($port = [int]$startPort; $port -le [int]$endPort; $port++) {
            $jobs += Start-Job -ScriptBlock {
                param($h, $p)
                $result = Test-NetConnection -ComputerName $targetHostName -Port $p -WarningAction SilentlyContinue
                if ($result.TcpTestSucceeded) { return $p }
            } -ArgumentList $host, $port

            if ($jobs.Count -ge $threads) {
                $jobs | ForEach-Object { 
                    $job = Wait-Job -Job $_
                    if ($result = Receive-Job -Job $job) { $openPorts += $result }
                    Remove-Job -Job $job
                }
                $jobs = @()
            }
        }

        # Wait for remaining jobs
        $jobs | ForEach-Object { 
            $job = Wait-Job -Job $_
            if ($result = Receive-Job -Job $job) { $openPorts += $result }
            Remove-Job -Job $job
        }

        if ($openPorts) {
            Write-Host "$Yellow[*] Total Open Ports:$Reset $($openPorts.Count)"
            $openPorts | Sort-Object | ForEach-Object { Write-Host "$Cyan$_$Reset" }
        } else {
            Write-Host "$Red[*] No open ports found!$Reset"
        }
    }
}

# Main menu
function Show-Menu {
    Clear-Host
    Show-Banner
    Write-Host "$Blue=== Recon Tool Menu ===$Reset"
    Write-Host "$Green1)  Website Information$Reset"
    Write-Host "$Green2)  Phone Number Lookup$Reset"
    Write-Host "$Green3)  Email Validator$Reset"
    Write-Host "$Green4)  My IP Information$Reset"
    Write-Host "$Green5 IMMEDIATE)  Site Status Check$Reset"
    Write-Host "$Green6)  IP Tracker$Reset"
    Write-Host "$Green7)  DNS Leak Test$Reset"
    Write-Host "$Green8)  Internet Speed Test$Reset"
    Write-Host "$Green9)  Cloudflare Bypass$Reset"
    Write-Host "$Green10) Subdomain Scanner$Reset"
    Write-Host "$Green11) CMS Detector$Reset"
    Write-Host "$Green12) Port Scanner$Reset"
    Write-Host "$Green99) Exit$Reset"
    Write-Host "$Blue======================$Reset"
    Write-Host "$Green[+] Select an option:$Reset" -NoNewline
    $option = Read-Host

    switch ($option) {
        "1" { Get-WebInfo }
        "01" { Get-WebInfo }
        "2" { Get-PhoneInfo }
        "02" { Get-PhoneInfo }
        "3" { Test-Email }
        "03" { Test-Email }
        "4" { Get-MyIpInfo }
        "04" { Get-MyIpInfo }
        "5" { Test-SiteStatus }
        "05" { Test-SiteStatus }
        "6" { Get-IpTracker }
        "06" { Get-IpTracker }
        "7" { Test-DnsLeak }
        "07" { Test-DnsLeak }
        "8" { Test-Speed }
        "08" { Test-Speed }
        "9" { Get-CloudflareBypass }
        "09" { Get-CloudflareBypass }
        "10" { Get-Subdomains }
        "11" { Get-Cms }
        "12" { Test-Ports }
        "99" { Write-Host "$Red[!] Exiting... Stay Anonymous!$Reset"; exit }
        default { Write-Host "$Red[!] Invalid option!$Reset"; Start-Sleep -Seconds 1; Show-Menu }
    }
}

# Start the tool
Show-Menu