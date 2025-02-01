# Fonction pour récupérer les informations de l'utilisateur
function Show-UserInfo {
    $currentUser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
    $groups = Get-WmiObject -Class Win32_GroupUser | Where-Object { $_.PartComponent -match $currentUser }
    $lastLogon = (Get-WmiObject -Class Win32_NetworkLoginProfile -Filter "Name='$currentUser'").LastLogon

    # Formater les informations en chaîne de caractères
    $result = "=== Informations utilisateur ===`n"
    $result += "Utilisateur actuel : $currentUser`n"
    $result += "Groupes : $($groups -join ', ')`n"
    $result += "Dernière connexion : $lastLogon`n"
    return $result
}