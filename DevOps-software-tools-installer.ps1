function RunAsAdmin {
    try {
        # Ensure the script is run as an Administrator
        If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Warning "Please run this script as an Administrator!"
            Exit
        }
    } catch {
        Write-Error "Failed to validate administrative privileges: $($_.Exception.Message)"
    }
}

function install-choco {
    try {
        If (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Host "Installing Chocolatey..."
            Set-ExecutionPolicy Bypass -Scope Process -Force
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
    } catch {
        Write-Error "Chocolatey installation failed: $($_.Exception.Message)"
    }
}

function install-choco-soft {
    param (
        [string[]]$chocoSoftwareList,
        [bool]$update 
    )
    
    foreach ($software in $chocoSoftwareList) {
        try {
            Write-Host "Checking and installing $software with Chocolatey..."
            choco install $software -y

            if ($update) {
                choco upgrade $software -y
            }
        } catch {
            Write-Error "Failed to install/upgrade $software : $($_.Exception.Message)"
        }
    }

    if ($update) {
        try {
            Write-Host "Upgrading Chocolatey and all its packages..."
            choco upgrade chocolatey -y
            choco upgrade all -y
        } catch {
            Write-Error "Failed to upgrade Chocolatey and all packages: $($_.Exception.Message)"
        }
    }
}

function install-pwsh7 {
    try {
        Write-Host "Searching for the latest version of PowerShell using Winget..."
        winget search Microsoft.PowerShell
        Write-Host "Installing the latest stable version of PowerShell..."
        winget install --id Microsoft.Powershell --source winget --accept-package-agreements --accept-source-agreements
        winget install --id Microsoft.Powershell.Preview --source winget --accept-package-agreements --accept-source-agreements
    } catch {
        Write-Error "Failed to install PowerShell 7: $($_.Exception.Message)"
    }
}

function install-wsl {
    param (
        [string[]]$distribution
    )
    try {
        # Enable WSL and Install distribution
        $wslInstalled = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online

        if ($wslInstalled.State -ne "Enabled") {
            Write-Host "Enabling WSL..."
            Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart
            Write-Host "Enabling $distribution distribution in WSL with no-launch..." -ForegroundColor DarkRed
            wsl --install -d $distribution --no-launch
        } else {
            Write-Host "WSL is already enabled."
        }
    } catch {
        Write-Error "Failed to enable or check WSL: $($_.Exception.Message)"
    }
}

function install-gcloudsdk-manual {
    try {

        Get-Command gcloud 

    } catch {
        Write-Host "Downloading Google Cloud SDK..." -ForegroundColor Yellow
        (New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")
        Write-Host "Installing Google Cloud SDK..." -ForegroundColor Blue
        Write-Host "The installer will pop out in a second..." -ForegroundColor DarkRed
        & $env:Temp\GoogleCloudSDKInstaller.exe

    }
}

function install-pwsh-modules {
    param (
        [string[]]$psModules
    )

    Write-Host "Managing PowerShell Modules..." -ForegroundColor Yellow

    foreach ($module in $psModules) {
        $installedModule = Get-Module -ListAvailable -Name $module

        if ($installedModule) {
            try {
                Write-Host "Updating PowerShell module: $module"
                Update-Module -Name $module -Force -ErrorAction Stop
            } catch {
                Write-Host "Encountered an issue updating $module. Attempting to install..." -ForegroundColor Yellow
                try {
                    Install-Module -Name $module -AllowClobber -Repository PSGallery -Force -SkipPublisherCheck -ErrorAction Stop
                    Write-Host "$module installed successfully." -ForegroundColor Green
                } catch {
                    Write-Error "Failed to install $module. Error: $_"
                }
            }
        }

    }

    Write-Host "PowerShell Modules management successful." -ForegroundColor Green
}

###### SET VARIABLES ########################################

# List of the Pwsh Modules to install
$psModules = @(
    "Az",
    "AzureAD", # For Azure Active Directory
    "MSOnline", # For Microsoft 365
    "ExchangeOnlineManagement"

)

# List of software to install with Chocolatey
$chocoSoftwareList = @(
    "git",
    "gh",    
    "docker-desktop",
    "microsoftazurestorageexplorer"
    "azure-cli",
    #"gcloudsdk", ### Package out of date 20-2-2024
    "awscli",
    "visualstudiocode",
    "terraform",
    "python",
    "kubernetes-cli",
    "mysql.workbench",
    "mremoteng",
    "postman",
    "anydesk",
    "snagit",
    "bitwarden",
    #"googlechrome", ### Package out of date 20-2-2024
    "firefox"
)

$distribution = "Ubuntu"  

################### Main Script Execution Block ####################

try {
    # 1. Step: Force script to run with elevated Administrator rights
    RunAsAdmin

    # 2. Step: Chocolatey Installation
    install-choco

    # 3. Set: Chocolatey-Powered Software Installation and Possible Upgrading
    install-choco-soft -chocoSoftwareList $chocoSoftwareList -update $true
    # 3.b Installing Gcloud SDK "manually" cause the chocolatly module is out of date. 
    install-gcloudsdk-manual

    # 4. Installing or Checking for PowerShell 7 via Winget
    install-pwsh7

    # 5. Bootstrap: This will be determined if WSL installation is based on a name of the specific choice of OS
    install-wsl -distribution $distribution

    # 6. Operate: Manage Windows and PowerShell's Requisite Leading-Edge Commands (Modules)
    install-pwsh-modules -psModules $psModules

} catch {
    Write-Error "An unexpected event fatally halted the code with error: $($_.Exception.Message)"
    exit 1
} finally {
    Write-Host "******* All applicable latest packages, and patterns including Bootstrapping, set up has been completed. Inspect carefully for errors. *******" -ForegroundColor Cyan
}