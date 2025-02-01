# Fonction pour récupérer les informations système
function Show-SystemInfo {
    # Obtenir les informations du système d'exploitation
    $OS = Get-WmiObject Win32_OperatingSystem
    $systeme = @{
        "Nom de l'OS" = $OS.Caption
        "Version" = $OS.Version
        "Architecture" = $OS.OSArchitecture
        "Date d'installation" = $OS.ConvertToDateTime($OS.InstallDate)
        "Langue" = $OS.MUILanguages[0]
    }

    # Formater les informations en chaîne de caractères
    $result = "=== Informations système ===`n"
    foreach ($key in $systeme.Keys) {
        $result += "$key : $($systeme[$key])`n"
    }
    return $result
}