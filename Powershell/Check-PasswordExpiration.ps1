# Check Windows Password Expiration Script
# This script checks password expiration for local users and domain users

param(
    [string]$Username = $null,
    [switch]$AllUsers = $false,
    [switch]$CurrentUser = $false,
    [switch]$LocalUsers = $false,
    [switch]$DomainUsers = $false,
    [int]$WarningDays = 30
)

# Function to get password expiration info for local users
function Get-LocalUserPasswordInfo {
    param([string]$UserName = $null)
    
    Write-Host "=== Local Users Password Expiration Info ===" -ForegroundColor Green
    
    try {
        if ($UserName) {
            $users = Get-LocalUser -Name $UserName -ErrorAction Stop
        } else {
            $users = Get-LocalUser | Where-Object { $_.Enabled -eq $true }
        }
        
        foreach ($user in $users) {
            $passwordLastSet = $user.PasswordLastSet
            $passwordNeverExpires = $user.PasswordNeverExpires
            
            Write-Host "`nUser: $($user.Name)" -ForegroundColor Yellow
            Write-Host "Enabled: $($user.Enabled)"
            Write-Host "Password Never Expires: $passwordNeverExpires"
            Write-Host "Password Last Set: $passwordLastSet"
            
            if ($passwordNeverExpires) {
                Write-Host "Status: Password Never Expires" -ForegroundColor Green
            } elseif ($passwordLastSet) {
                # Get local password policy
                $maxPasswordAge = (Get-LocalSecurityPolicy).MaximumPasswordAge
                if ($maxPasswordAge -gt 0) {
                    $expirationDate = $passwordLastSet.AddDays($maxPasswordAge)
                    $daysUntilExpiration = ($expirationDate - (Get-Date)).Days
                    
                    Write-Host "Password Expires: $expirationDate"
                    Write-Host "Days Until Expiration: $daysUntilExpiration"
                    
                    if ($daysUntilExpiration -le 0) {
                        Write-Host "Status: PASSWORD EXPIRED" -ForegroundColor Red
                    } elseif ($daysUntilExpiration -le $WarningDays) {
                        Write-Host "Status: PASSWORD EXPIRING SOON" -ForegroundColor Yellow
                    } else {
                        Write-Host "Status: Password OK" -ForegroundColor Green
                    }
                } else {
                    Write-Host "Status: Password Never Expires (Policy)" -ForegroundColor Green
                }
            } else {
                Write-Host "Status: Password Last Set date not available" -ForegroundColor Gray
            }
        }
    } catch {
        Write-Host "Error checking local users: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to get password expiration info for domain users
function Get-DomainUserPasswordInfo {
    param([string]$UserName = $null)
    
    Write-Host "`n=== Domain Users Password Expiration Info ===" -ForegroundColor Green
    
    try {
        # Check if running in domain environment
        if (-not (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain) {
            Write-Host "This computer is not part of a domain." -ForegroundColor Yellow
            return
        }
        
        Import-Module ActiveDirectory -ErrorAction Stop
        
        if ($UserName) {
            $users = @(Get-ADUser -Identity $UserName -Properties PasswordLastSet, PasswordNeverExpires, PasswordExpired -ErrorAction Stop)
        } else {
            $users = Get-ADUser -Filter {Enabled -eq $true} -Properties PasswordLastSet, PasswordNeverExpires, PasswordExpired
        }
        
        foreach ($user in $users) {
            $passwordLastSet = $user.PasswordLastSet
            $passwordNeverExpires = $user.PasswordNeverExpires
            $passwordExpired = $user.PasswordExpired
            
            Write-Host "`nUser: $($user.SamAccountName) ($($user.Name))" -ForegroundColor Yellow
            Write-Host "Enabled: $($user.Enabled)"
            Write-Host "Password Never Expires: $passwordNeverExpires"
            Write-Host "Password Last Set: $passwordLastSet"
            Write-Host "Password Expired: $passwordExpired"
            
            if ($passwordNeverExpires) {
                Write-Host "Status: Password Never Expires" -ForegroundColor Green
            } elseif ($passwordExpired) {
                Write-Host "Status: PASSWORD EXPIRED" -ForegroundColor Red
            } elseif ($passwordLastSet) {
                # Get domain password policy
                $domainPolicy = Get-ADDefaultDomainPasswordPolicy
                $maxPasswordAge = $domainPolicy.MaxPasswordAge.Days
                
                if ($maxPasswordAge -gt 0) {
                    $expirationDate = $passwordLastSet.AddDays($maxPasswordAge)
                    $daysUntilExpiration = ($expirationDate - (Get-Date)).Days
                    
                    Write-Host "Password Expires: $expirationDate"
                    Write-Host "Days Until Expiration: $daysUntilExpiration"
                    
                    if ($daysUntilExpiration -le 0) {
                        Write-Host "Status: PASSWORD EXPIRED" -ForegroundColor Red
                    } elseif ($daysUntilExpiration -le $WarningDays) {
                        Write-Host "Status: PASSWORD EXPIRING SOON" -ForegroundColor Yellow
                    } else {
                        Write-Host "Status: Password OK" -ForegroundColor Green
                    }
                } else {
                    Write-Host "Status: Password Never Expires (Policy)" -ForegroundColor Green
                }
            } else {
                Write-Host "Status: Password Last Set date not available" -ForegroundColor Gray
            }
        }
    } catch {
        if ($_.Exception.Message -like "*ActiveDirectory*") {
            Write-Host "Active Directory module not available. Install RSAT tools for domain user checking." -ForegroundColor Yellow
        } else {
            Write-Host "Error checking domain users: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Function to get current user password info
function Get-CurrentUserPasswordInfo {
    Write-Host "=== Current User Password Expiration Info ===" -ForegroundColor Green
    
    try {
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        Write-Host "Current User: $currentUser" -ForegroundColor Yellow
        
        # Try to get info using net user command
        $netUserOutput = net user $env:USERNAME 2>$null
        if ($LASTEXITCODE -eq 0) {
            $passwordLastSet = $netUserOutput | Select-String "Password last set" | ForEach-Object { $_.Line.Split()[-2..-1] -join " " }
            $passwordExpires = $netUserOutput | Select-String "Password expires" | ForEach-Object { $_.Line.Split()[-2..-1] -join " " }
            
            Write-Host "Password Last Set: $passwordLastSet"
            Write-Host "Password Expires: $passwordExpires"
            
            if ($passwordExpires -like "*Never*") {
                Write-Host "Status: Password Never Expires" -ForegroundColor Green
            } else {
                try {
                    $expireDate = [DateTime]::Parse($passwordExpires)
                    $daysUntilExpiration = ($expireDate - (Get-Date)).Days
                    
                    Write-Host "Days Until Expiration: $daysUntilExpiration"
                    
                    if ($daysUntilExpiration -le 0) {
                        Write-Host "Status: PASSWORD EXPIRED" -ForegroundColor Red
                    } elseif ($daysUntilExpiration -le $WarningDays) {
                        Write-Host "Status: PASSWORD EXPIRING SOON" -ForegroundColor Yellow
                    } else {
                        Write-Host "Status: Password OK" -ForegroundColor Green
                    }
                } catch {
                    Write-Host "Could not parse expiration date: $passwordExpires" -ForegroundColor Gray
                }
            }
        }
        
        # Also check if it's a domain user
        if ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain) {
            Get-DomainUserPasswordInfo -UserName $env:USERNAME
        }
        
    } catch {
        Write-Host "Error checking current user: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to get local security policy (simplified)
function Get-LocalSecurityPolicy {
    # Default values if unable to retrieve policy
    return @{
        MaximumPasswordAge = 42  # Default Windows value
    }
}

# Main script logic
Write-Host "Windows Password Expiration Checker" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

if ($CurrentUser) {
    Get-CurrentUserPasswordInfo
} elseif ($LocalUsers) {
    Get-LocalUserPasswordInfo
} elseif ($DomainUsers) {
    Get-DomainUserPasswordInfo
} elseif ($Username) {
    # Check specific user in both local and domain
    Get-LocalUserPasswordInfo -UserName $Username
    Get-DomainUserPasswordInfo -UserName $Username
} elseif ($AllUsers) {
    # Check all users
    Get-LocalUserPasswordInfo
    Get-DomainUserPasswordInfo
} else {
    # Default: Check current user
    Get-CurrentUserPasswordInfo
}

Write-Host "`n=== Script Completed ===" -ForegroundColor Cyan