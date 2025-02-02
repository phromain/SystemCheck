# Fonction pour récupérer les informations de sécurité
function Show-SecurityInfo {
    # Obtenir l'état du pare-feu
    $firewall = Get-NetFirewallProfile -PolicyStore ActiveStore
    $firewallState = $firewall | ForEach-Object {
        @{
            Name = $_.Name
            Enabled = if ($_.Enabled) { "Oui" } else { "Non" }
        }
    }

    # Obtenir l'antivirus installé et son état
    $antivirus = Get-WmiObject -Namespace "Root\SecurityCenter2" -Class AntiVirusProduct
    $antivirusInfo = @()
    foreach ($av in $antivirus) {
        $productState = [System.Convert]::ToString($av.productState, 16)
        # Assurez-vous d'interpréter l'état correctement en vérifiant les bits significatifs
        $state = if ($productState -eq "41000" -or $productState.StartsWith("1")) { "Actif" } elseif ($productState.StartsWith("2")) { "Désactivé" } else { "Inconnu" }
        $antivirusInfo += @{
            "Nom" = $av.displayName
            "État" = $state
        }
    }

    # Formater les informations en chaîne de caractères
    $result = "=== Informations de sécurité ===`n"
    foreach ($fw in $firewallState) {
        $result += "Pare-feu $($fw.Name) activé : $($fw.Enabled)`n"
    }

    foreach ($av in $antivirusInfo) {
        $result += "Antivirus : $($av.Nom)`n"
        $result += "État de l'antivirus : $($av.État)`n"
    }

    return $result
}

# Exécuter la fonction
Show-SecurityInfo
