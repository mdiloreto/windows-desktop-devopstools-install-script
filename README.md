# DevOps Software Tools Installer Script

## Overview

The `DevOps-software-tools-installer.ps1` script automates the setup of a comprehensive DevOps environment on Windows. It streamlines the installation and configuration of a wide range of software tools essential for development and operations, including package managers, development environments, cloud CLI tools, and more. Designed with simplicity and efficiency in mind, this script ensures a seamless setup process, allowing DevOps professionals to focus on their core tasks without worrying about manual setup complexities.

## Features

- **Automated Installation**: Quickly installs and configures a suite of essential DevOps tools with minimal user intervention.
- **Comprehensive Toolset**: Includes popular tools such as Git, Docker Desktop, Azure CLI, AWS CLI, Visual Studio Code, Terraform, Kubernetes CLI, and many others.
- **PowerShell 7 Support**: Facilitates the installation or update of PowerShell 7 alongside essential PowerShell modules for enhanced scripting capabilities.
- **Windows Subsystem for Linux (WSL) Setup**: Automates the enabling of WSL and installation of preferred Linux distributions, enhancing the Windows development environment.
- **Manual Installation Workarounds**: Provides solutions for installing tools like Google Cloud SDK manually, ensuring users have access to the latest versions.

## Prerequisites

- Operating System: Windows 10 or later.
- Permissions: Local administrative privileges are required.
- Network: An active internet connection for downloading software packages.

## Usage Instructions

1. **Open PowerShell with Administrative Privileges**: Right-click the Start button, select "Windows PowerShell (Admin)" to launch PowerShell with the necessary permissions.

2. **Set Execution Policy** (if required): Allow the execution of PowerShell scripts by setting the execution policy:

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

3. **Execute the Installer Script**: Navigate to the folder containing `DevOps-software-tools-installer.ps1` and run the script:

    ```powershell
    .\DevOps-software-tools-installer.ps1
    ```

## Software Installed

This script installs a variety of tools essential for DevOps workflows:

- Development Tools: `git`, `docker-desktop`, `visualstudiocode`, `terraform`, `kubernetes-cli`
- Cloud CLI Tools: `azure-cli`, `awscli`
- Database Tools: `mysql.workbench`
- Remote Access Tools: `anydesk`, `mremoteng`
- API Testing Tools: `postman`
- Miscellaneous: `bitwarden`, `firefox`, `snagit`

## Customization

Users can customize the script to add or remove software according to their needs. Modify the `$chocoSoftwareList` and `$psModules` variables to adjust the software installation list. Ensure compatibility and availability through Chocolatey and the PowerShell Gallery for new additions.

## Troubleshooting

- **Execution Policy Error**: Ensure the execution policy allows script execution. Use the `Set-ExecutionPolicy` command as shown above.
- **Installation Failures**: Verify internet connectivity and administrative rights. For specific software installation issues, consult the error messages and the official documentation for troubleshooting steps.

## Contributing

Contributions are welcome. Enhancements, new tool integrations, and bug reports can significantly improve the script. Please submit pull requests or issues via the GitHub repository.

## Support

For questions, support, or feedback regarding the script, please open an issue in the GitHub repository where the script is hosted.