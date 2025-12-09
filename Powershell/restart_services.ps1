function Manage-Service {
    param(
        [ValidateSet("nginx", "iis", "trueapp")]
        [string]$Service,
        [ValidateSet("start", "stop", "restart")]
        [string]$Action
    )

    switch ($Service) {
        "nginx" {
            if ($Action -eq "start") { Start-Service nginx }
            elseif ($Action -eq "stop") { Stop-Service nginx }
            elseif ($Action -eq "restart") { Restart-Service nginx }
        }
        "iis" {
            if ($Action -eq "start") { iisreset /start }
            elseif ($Action -eq "stop") { iisreset /stop }
            elseif ($Action -eq "restart") { iisreset /restart }
        }
        "trueapp" {
            $appService = "TRUE Data Intelligence Service"
            if ($Action -eq "start") { Start-Service $appService }
            elseif ($Action -eq "stop") { Stop-Service $appService }
            elseif ($Action -eq "restart") { Restart-Service $appService }
        }
    }
}

# Example usage:
Manage-Service -Service "iis" -Action "stop"