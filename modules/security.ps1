# Fonction pour récupérer les informations de sécurité
function Get-FirewallInfo {
    $firewallProfiles = Get-NetFirewallProfile -PolicyStore ActiveStore
    $result = "=== Pare-feu ===`n"
    
    foreach ($profile in $firewallProfiles) {
        $status = if ($profile.Enabled) { "Activé" } else { "Désactivé" }
        $result += "$($profile.Name) : $status`n"
    }
    
    return $result
}

# Fonction pour récupérer les informations sur l'antivirus
function Get-AntivirusInfo {
    $antivirusList = Get-WmiObject -Namespace "Root\SecurityCenter2" -Class AntiVirusProduct
    $result = "=== Antivirus ===`n"
    
    if ($antivirusList.Count -eq 0) {
        return $result + "Aucun antivirus détecté`n"
    }
    
    foreach ($av in $antivirusList) {
        $productState = [System.Convert]::ToString($av.productState, 16)
        $state = if ($productState -eq "41000" -or $productState.StartsWith("1")) { "Actif" } 
                elseif ($productState.StartsWith("2")) { "Désactivé" } 
                else { "Inconnu" }
        $result += "Nom : $($av.displayName)`n"
        $result += "État : $state`n"
    }
    
    return $result
}

# Fonction principale pour afficher les informations de sécurité
function Show-SecurityInfo {
    $result = "=== Informations de sécurité ===`n"
    $result += Get-FirewallInfo
    $result += "`n"
    $result += Get-AntivirusInfo
    return $result
}

# Exécuter la fonction
Show-SecurityInfo
