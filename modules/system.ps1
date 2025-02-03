# Fonction pour récupérer les informations système
function Show-SystemInfo {
    # Obtenir les informations du système d'exploitation
    $OS = Get-WmiObject Win32_OperatingSystem
    # Obtenir la dernière date de mise à jour de Windows
    $lastUpdate = (Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1).InstalledOn.ToString("dd/MM/yyyy")

    $result = "Nom de l'OS : $($OS.Caption)`n"
    $result += "Version : $($OS.Version)`n"
    $result += "Architecture : $($OS.OSArchitecture)`n"
    $result += "Date d'installation : $($OS.ConvertToDateTime($OS.InstallDate).ToString('dd/MM/yyyy'))`n"
    $result += "Langue : $($OS.MUILanguages[0])`n"
    $result += "Dernière mise à jour de Windows : $lastUpdate`n"
    return $result
}
# Exécuter la fonction
Show-SystemInfo