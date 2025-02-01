# Fonction pour récupérer les informations système
function Show-SystemInfo {
    # Obtenir les informations du système d'exploitation
    $OS = Get-WmiObject Win32_OperatingSystem
    $result = "Nom de l'OS : $($OS.Caption)`n"
    $result += "Version : $($OS.Version)`n"
    $result += "Architecture : $($OS.OSArchitecture)`n"
    $result += "Date d'installation : $($OS.ConvertToDateTime($OS.InstallDate))`n"
    $result += "Langue : $($OS.MUILanguages[0])`n"
    return $result
}
