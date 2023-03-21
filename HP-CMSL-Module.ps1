# Install latest NuGet package provider
try {
    Write-Output "Attempting to install latest NuGet package provider"
    $PackageProvider = Install-PackageProvider -Name "NuGet" -Force -ErrorAction Stop -Verbose:$false
    }
    catch [System.Exception] {
        Write-output "Unable to install latest NuGet package provider. Error message: $($_.Exception.Message)"; exit 1
    }   
    
# Install the latest PowershellGet Module 
if ($PackageProvider.Version -ge "2.8.5"){
    $PowerShellGetInstalledModule = Get-InstalledModule -Name "PowerShellGet" -ErrorAction SilentlyContinue -Verbose:$false
    if ($PowerShellGetInstalledModule -ne $null) {
        try {
            # Attempt to locate the latest available version of the PowerShellGet module from repository
            Write-Output "Attempting to request the latest PowerShellGet module version from repository" 
            $PowerShellGetLatestModule = Find-Module -Name "PowerShellGet" -ErrorAction Stop -Verbose:$false
            if ($PowerShellGetLatestModule -ne $null) {
                if ($PowerShellGetInstalledModule.Version -lt $PowerShellGetLatestModule.Version) {
                    try {
                        # Newer module detected, attempt to update
                        Write-Output "Newer version detected, attempting to update the PowerShellGet module from repository" 
                        Update-Module -Name "PowerShellGet" -Scope "AllUsers" -Force -ErrorAction Stop -Confirm:$false -Verbose:$false
                    }
                    catch [System.Exception] {
                        Write-Output "Failed to update the PowerShellGet module. Error message: $($_.Exception.Message)"; exit 1
                    }
                }
            }
            else {
                Write-Output "Location request for the latest available version of the PowerShellGet module failed, can't continue"; exit 1
            }
        }
        catch [System.Exception] {
            Write-Output "Failed to retrieve the latest available version of the PowerShellGet module, can't continue. Error message: $($_.Exception.Message)" ; exit 1
        }
    } else {
        try {
            # PowerShellGet module was not found, attempt to install from repository
            Write-Output "PowerShellGet module was not found, attempting to install it including dependencies from repository" 
            Write-Output "Attempting to install PackageManagement module from repository" 
            Install-Module -Name "PackageManagement" -Force -Scope AllUsers -AllowClobber -ErrorAction Stop -Verbose:$false
            Write-Output "Attempting to install PowerShellGet module from repository" 
            Install-Module -Name "PowerShellGet" -Force -Scope AllUsers -AllowClobber -ErrorAction Stop -Verbose:$false
        }
        catch [System.Exception] {
            Write-Output "Unable to install PowerShellGet module from repository. Error message: $($_.Exception.Message)"; exit 1
        }
    }
    
    #Install the latest HPCMSL Module
    $HPInstalledModule = Get-InstalledModule | Where-Object {$_.Name -match "HPCMSL"} -ErrorAction SilentlyContinue -Verbose:$false
    if ($HPInstalledModule -ne $null) {
        $HPGetLatestModule = Find-Module -Name "HPCMSL" -ErrorAction Stop -Verbose:$false
        if ($HPInstalledModule.Version -lt $HPGetLatestModule.Version) {
            Write-Output "Newer HPCMSL version detected, updating from repository"
            try {
                # Install HP Client Management Script Library
                Write-Output -Value "Attempting to install HPCMSL module from repository" 
                Update-Module -Name "HPCMSL" -AcceptLicense -Force -ErrorAction Stop -Verbose:$false
            } 
            catch [System.Exception] {
                Write-OutPut -Value "Unable to install HPCMSL module from repository. Error message: $($_.Exception.Message)"; exit 1
            }
        } else {
            Write-Output "HPCMSL Module is up to date"; exit 0
        }
    } else {
        Write-Output "HPCMSL Module is missing, try to install from repository"
        try {
            # Install HP Client Management Script Library
            Write-Output -Value "Attempting to install HPCMSL module from repository" 
            Install-Module -Name "HPCMSL" -AcceptLicense -Force -ErrorAction Stop -Verbose:$false
        } 
        catch [System.Exception] {
            Write-OutPut -Value "Unable to install HPCMSL module from repository. Error message: $($_.Exception.Message)"; exit 1
        }
    }
}
