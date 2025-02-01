

# Fonction pour récupérer le SSID des connexions Wi-Fi
function Get-WiFiSSID {
    $wifiSsid = netsh wlan show interfaces | Select-String -Pattern '^\s*SSID\s*:\s*(.+)' | ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() }
    return $wifiSsid
}
# Fonction pour récupérer les informations réseau
function Show-NetworkInfo {
    # Obtenir les connexions réseau actives
    $activeAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

    # Initialiser la chaîne de résultat
    $result = "=== Informations réseau ===`n"

    foreach ($adapter in $activeAdapters) {
        # Obtenir les adresses IPv4 de la connexion active
        $ipAddress = Get-NetIPAddress -InterfaceIndex $adapter.IfIndex -AddressFamily IPv4 | Select-Object -ExpandProperty IPAddress -First 1

        # Obtenir les serveurs DNS de la connexion active (en s'assurant qu'il n'y a pas de chiffres supplémentaires)
        $dnsServers = Get-DnsClientServerAddress -InterfaceAlias $adapter.Name | Select-Object -ExpandProperty ServerAddresses | Where-Object { $_ -match '^\d+\.\d+\.\d+\.\d+$' }

        # Obtenir la passerelle par défaut de la connexion active
        $defaultGateway = Get-NetRoute -InterfaceIndex $adapter.IfIndex | Where-Object { $_.DestinationPrefix -eq '0.0.0.0/0' } | Select-Object -ExpandProperty NextHop -First 1

        # Ajouter les informations de la connexion au résultat
        $result += "=== Connexion $($adapter.Name) ===`n"
        if ($adapter.Name -like '*Wi-Fi*') {
            $ssid = Get-WiFiSSID
            $result += "SSID : $ssid`n"
        }
        $result += "Adresse IPv4 : $ipAddress`n"
        $result += "Serveurs DNS : $($dnsServers -join ', ')`n"
        $result += "Passerelle par défaut : $defaultGateway`n"
        $result += "Adresse MAC : $($adapter.MacAddress)`n`n"
    }

    return $result
}