# Fonction pour récupérer les informations du matériel
function Show-HardwareInfo {
    # Obtenir les informations CPU
    $cpu = Get-WmiObject Win32_Processor | Select-Object -First 1
    $cpuInfo = @{
        "Modèle" = $cpu.Name
        "Nombre de cœurs" = $cpu.NumberOfCores
        "Vitesse" = "$($cpu.MaxClockSpeed) MHz"
    }

    # Obtenir les informations RAM
    $ram = Get-WmiObject Win32_ComputerSystem
    $ramInfo = @{
        "Capacité totale" = "$([math]::round($ram.TotalPhysicalMemory / 1GB, 2)) GB"
        "Mémoire utilisée" = "$([math]::round((($ram.TotalPhysicalMemory - $ram.FreePhysicalMemory) / 1GB), 2)) GB"
        "Mémoire disponible" = "$([math]::round($ram.FreePhysicalMemory / 1GB, 2)) GB"
    }

    # Obtenir les informations GPU
    $gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
    $gpuInfo = @{
        "Modèle" = $gpu.Name
        "Mémoire dédiée" = "$($gpu.AdapterRAM / 1MB) MB"
        "Version du pilote" = $gpu.DriverVersion
    }

    # Obtenir les informations des disques
    $disks = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
    $diskInfo = @()
    foreach ($disk in $disks) {
        $diskInfo += @{
            "Nom" = $disk.DeviceID
            "Capacité totale" = "$([math]::round($disk.Size / 1GB, 2)) GB"
            "Espace libre" = "$([math]::round($disk.FreeSpace / 1GB, 2)) GB"
            "Type" = if ($disk.Description -like "*SSD*") { "SSD" } else { "HDD" }
            "État de santé" = $disk.Status
        }
    }

    # Formater les informations en chaîne de caractères
    $result = "=== Informations matériel ===`n"
    $result += "=== CPU ===`n"
    foreach ($key in $cpuInfo.Keys) {
        $result += "$key : $($cpuInfo[$key])`n"
    }

    $result += "=== RAM ===`n"
    foreach ($key in $ramInfo.Keys) {
        $result += "$key : $($ramInfo[$key])`n"
    }

    $result += "=== GPU ===`n"
    foreach ($key in $gpuInfo.Keys) {
        $result += "$key : $($gpuInfo[$key])`n"
    }

    $result += "=== Disques ===`n"
    foreach ($disk in $diskInfo) {
        foreach ($key in $disk.Keys) {
            $result += "$key : $($disk[$key])`n"
        }
        $result += "`n"
    }
    return $result
}