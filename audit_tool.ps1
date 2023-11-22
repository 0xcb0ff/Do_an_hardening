#!/bin/bash
echo --% >/dev/null;: ' | out-null
<#'
# bash part
if [ "$(basename "$SHELL")" != "bash" ]; then
    echo "This script requires Bash. Please run it with Bash."
    exit 1
fi
echo "You are running in Bash environment."

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo su' command"
    exit 1
fi

while true; do
    echo "Choose your OS:"
    echo "1. CentOS"
    echo "2. Ubuntu"
    echo "3. Windows Server"
    echo "0. Exit"
    read -p "Enter the number of your choice (1, 2, or 0 to exit): " choice
    if [ "$choice" -eq 1 ]; then
        echo "You selected CentOS."
        chmod +x Script/audit_centos.sh
        ./Script/audit_centos.sh
        break
    elif [ "$choice" -eq 2 ]; then
        echo "You selected Ubuntu."
        chmod +x Script/audit_ubuntu.sh
        ./Script/audit_ubuntu.sh
        break
    elif [ "$choice" -eq 3 ]; then
        clear
        echo "You selected Windows Server."
        echo "This enviroment can't support. please rechoice!"
        echo "-----------------------------------------------"
    elif [ "$choice" -eq 0 ]; then
        echo "You selected exit."
        exit
    else
        clear
        echo "Invalid choice. Please enter 1, 2, or 0 to exit." 2> /dev/null
        echo "-----------------------------------------------"
    fi
done

exit #>
# end bash part

# powershell part

if ($host.Name -eq 'ConsoleHost') {
    Write-Host "You are running in PowerShell environment"
}

function Test-IsAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    return $isAdmin
}

if (-not (Test-IsAdmin)) {
    Write-Host "This script requires administrator privileges. Please run as administrator."
    Exit
}
if (-not $IsAdmin) {
    Write-Host "This script requires administrator privileges. Please run as administrator."
    Exit
}

while ($true) {
    Write-Host "Choose your OS:"
    Write-Host "1. CentOS"
    Write-Host "2. Ubuntu"
    Write-Host "3. Windows Server"
    Write-Host "0. Exit"
    
    $choice = Read-Host "Enter the number of your choice (1, 2, or 0 to exit)"
    
    if ($choice -eq 1) {
        cls
        Write-Host "You selected CentOS."
        Write-Host "This enviroment can't support."
        Write-Host "-----------------------------------------------"
    }
    elseif ($choice -eq 2) {
        cls
        Write-Host "You selected Ubuntu."
        Write-Host "This enviroment can't support. Please rechoice!"
        Write-Host "-----------------------------------------------"
    }
    elseif ($choice -eq 3) {
        Write-Host "You selected Windows Server."
        $currentDirectory = Get-Location
        & "$currentDirectory\Script\windows_harderning.ps1"
        break
    }
    elseif ($choice -eq 0) {
        Write-Host "You selected exit."
        exit
    }
    else {
        cls
        Write-Host "Invalid choice. Please enter 1, 2, or 0 to exit."
        Write-Host "-----------------------------------------------"
    }
}