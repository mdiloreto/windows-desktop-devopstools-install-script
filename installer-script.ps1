# PowerShell script to install various tools using Chocolatey and PowerShell 7 using Winget

# Ensure the script is run as an Administrator
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    Exit
}

# Install Chocolatey if not already installed
If (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# List of software to install with Chocolatey
$chocoSoftwareList = @(
    "docker-desktop",
    "azure-cli",
    "gcloud",
    "visualstudiocode",
    "terraform",
    "python",
    "mremoteng",
    "postman",
    "anydesk",
    "snagit",
    "bitwarden"
)

# Install software with Chocolatey
foreach ($software in $chocoSoftwareList) {
    Write-Host "Checking and installing $software with Chocolatey..."
    choco install $software -y
}

# PowerShell script segment to install PowerShell 7 (stable or preview) using Winget

Write-Host "Searching for the latest version of PowerShell using Winget..."
$ps7SearchOutput = winget search Microsoft.PowerShell
$ps7StableInstalled = $ps7SearchOutput -match "Microsoft.PowerShell"
$ps7PreviewInstalled = $ps7SearchOutput -match "Microsoft.PowerShell.Preview"

# Install stable PowerShell if not installed
if (-not $ps7StableInstalled) {
    Write-Host "Installing the latest stable version of PowerShell..."
    winget install --id Microsoft.PowerShell --source winget
} else {
    Write-Host "The latest stable version of PowerShell is already installed."
}

# Optionally, install PowerShell Preview if not installed
if (-not $ps7PreviewInstalled) {
    Write-Host "Installing the latest preview version of PowerShell..."
    winget install --id Microsoft.PowerShell.Preview --source winget
} else {
    Write-Host "The latest preview version of PowerShell is already installed."
}


# Enable WSL and Install Ubuntu (optional based on previous request)
 $wslInstalled = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online
 if ($wslInstalled.State -ne "Enabled") {
     Write-Host "Enabling WSL..."
     Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart
     # Install Ubuntu
     winget install --id Canonical.Ubuntu --source winget
 } else {
     Write-Host "WSL is already enabled."
 }

 
# Install required PowerShell modules
$psModules = @(
    "Az",
    "AzureAD", # For Azure Active Directory
    "MSOnline", # For Microsoft 365
    "ExchangeOnlineManagement"

)

foreach ($module in $psModules) {
    Write-Host "Installing PowerShell module: $module"
    Install-Module -Name $module -AllowClobber -Force -SkipPublisherCheck
}

foreach ($module in $psModules) {
    Write-Host "Installing PowerShell module: $module"
    Update-Module -Name $module -Force 
}

# Note: For AzureAD, you might use 'AzureAD.Standard.Preview' for the newer version
# For MSOnline, consider 'ExchangeOnlineManagement' for Exchange specific tasks

Write-Host "Installation and checks are complete. Please restart your system for all changes to take effect." -ForegroundColor Green
