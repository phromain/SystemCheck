# Fonction pour récupérer les informations de sécurité
function Show-SecurityInfo {
    # Obtenir l'état du pare-feu
    $firewall = Get-NetFirewallProfile
    $firewallState = @{
        "Pare-feu activé" = ($firewall | ForEach-Object { $_.Enabled }) -join ", "
    }

    # Obtenir l'antivirus installé et son état
    $antivirus = Get-WmiObject -Namespace "Root\SecurityCenter2" -Query "SELECT * FROM AntiVirusProduct"
    $antivirusInfo = @{
        "Antivirus" = $antivirus.displayName
        "État" = if ($antivirus.productState -band 0x10) { "Actif" } else { "Inactif" }
    }

    # Obtenir la dernière date de mise à jour de Windows
    $lastUpdate = (Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1).InstalledOn

    # Formater les informations en chaîne de caractères
    $result = "=== Informations de sécurité ===`n"
    foreach ($key in $firewallState.Keys) {
        $result += "$key : $($firewallState[$key])`n"
    }

    foreach ($key in $antivirusInfo.Keys) {
        $result += "$key : $($antivirusInfo[$key])`n"
    }

    $result += "Dernière mise à jour de Windows : $lastUpdate`n"
    return $result
}