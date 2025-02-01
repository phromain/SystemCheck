
# Fonction pour récupérer les informations réseau
function Show-NetworkInfo {
    # Obtenir les adresses IP
    $ipAddresses = Get-NetIPAddress | Select-Object -First 1
    $ipInfo = @{
        "Adresse IPv4" = $ipAddresses.IPv4Address
        "Adresse IPv6" = $ipAddresses.IPv6Address
    }

    # Obtenir les serveurs DNS
    $dnsServers = Get-DnsClientServerAddress
    $dnsInfo = @{
        "Serveurs DNS" = ($dnsServers | ForEach-Object { $_.ServerAddresses }) -join ", "
    }

    # Obtenir les connexions actives
    $activeConnections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }
    $connectionInfo = @()
    foreach ($connection in $activeConnections) {
        $connectionInfo += @{
            "Local Address" = $connection.LocalAddress
            "Remote Address" = $connection.RemoteAddress
            "State" = $connection.State
        }
    }

    # Obtenir le SSID du Wi-Fi
    $wifiSsid = (Get-NetAdapter | Where-Object {$_.Status -eq 'Up' -and $_.Name -match 'Wi-Fi'}).SSID

    # Obtenir les adresses MAC
    $macAddresses = Get-NetAdapter | Select-Object -ExpandProperty MacAddress

    # Formater les informations en chaîne de caractères
    $result = "=== Informations réseau ===`n"
    foreach ($key in $ipInfo.Keys) {
        $result += "$key : $($ipInfo[$key])`n"
    }

    foreach ($key in $dnsInfo.Keys) {
        $result += "$key : $($dnsInfo[$key])`n"
    }

    $result += "=== Connexions actives ===`n"
    foreach ($connection in $connectionInfo) {
        foreach ($key in $connection.Keys) {
            $result += "$key : $($connection[$key])`n"
        }
        $result += "`n"
    }

    $result += "=== Wi-Fi ===`nSSID : $wifiSsid`n"
    $result += "=== Adresses MAC ===`n"
    $result += ($macAddresses -join "`n") + "`n"
    return $result
}