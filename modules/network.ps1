# Fonction pour récupérer les informations réseau

function Get-WiFiSSID {
    $wifiSsid = netsh wlan show interfaces | Select-String -Pattern '^\s*SSID\s*:\s*(.+)' | ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() }
    return $wifiSsid
}

function Get-IPv4Address {
    param ([int]$IfIndex)
    $ipAddress = Get-NetIPAddress -InterfaceIndex $IfIndex -AddressFamily IPv4 | Select-Object -ExpandProperty IPAddress -First 1
    return $ipAddress
}

function Get-DNSServers {
    param ([string]$InterfaceAlias)
    $dnsServers = Get-DnsClientServerAddress -InterfaceAlias $InterfaceAlias | Select-Object -ExpandProperty ServerAddresses | Where-Object { $_ -match '^\d+\.\d+\.\d+\.\d+$' }
    return $dnsServers -join ', '
}

function Get-DefaultGateway {
    param ([int]$IfIndex)
    $defaultGateway = Get-NetRoute -InterfaceIndex $IfIndex | Where-Object { $_.DestinationPrefix -eq '0.0.0.0/0' } | Select-Object -ExpandProperty NextHop -First 1
    return $defaultGateway
}

function Show-NetworkInfo {
    # Obtenir les connexions réseau actives
    $activeAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

    # Initialiser la chaîne de résultat
    $result = "=== Informations réseau ===`n"

    foreach ($adapter in $activeAdapters) {
        $ipAddress = Get-IPv4Address -IfIndex $adapter.IfIndex
        $dnsServers = Get-DNSServers -InterfaceAlias $adapter.Name
        $defaultGateway = Get-DefaultGateway -IfIndex $adapter.IfIndex

        # Ajouter les informations de la connexion au résultat
        $result += "=== Connexion $($adapter.Name) ===`n"
        if ($adapter.Name -like '*Wi-Fi*') {
            $ssid = Get-WiFiSSID
            $result += "SSID : $ssid`n"
        }
        $result += "Adresse IPv4 : $ipAddress`n"
        $result += "Serveurs DNS : $dnsServers`n"
        $result += "Passerelle par défaut : $defaultGateway`n"
        $result += "Adresse MAC : $($adapter.MacAddress)`n`n"
    }

    return $result
}

# Exécuter la fonction et afficher les informations réseau
Show-NetworkInfo
