param(
    [Parameter(Mandatory=$false)]
    [string]$NewComputerName = "Worker-DC"
)

# Get the current computer name
$CurrentComputerName = $env:COMPUTERNAME

Write-Host "Current computer name: $CurrentComputerName" -ForegroundColor Yellow

# Check if the name is already set
if ($CurrentComputerName -eq $NewComputerName) {
    Write-Host "Computer name is already set to $NewComputerName" -ForegroundColor Green
    exit 0
}

# Rename the computer
try {
    Write-Host "Renaming computer to: $NewComputerName" -ForegroundColor Cyan
    Rename-Computer -NewName $NewComputerName -Force -ErrorAction Stop
    Write-Host "Computer renamed successfully to $NewComputerName" -ForegroundColor Green
    Write-Host "A restart is required for the changes to take effect." -ForegroundColor Yellow
    
    # Optionally restart the computer
    $restart = Read-Host "Do you want to restart now? (Y/N)"
    if ($restart -eq "Y" -or $restart -eq "y") {
        Write-Host "Restarting computer..." -ForegroundColor Red
        Restart-Computer -Force
    }
} catch {
    Write-Host "Error renaming computer: $_" -ForegroundColor Red
    exit 1
}