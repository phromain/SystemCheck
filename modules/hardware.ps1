# Fonction pour récupérer les informations du matériel

function Get-ComputerInfo {
    $computer = Get-WmiObject Win32_ComputerSystem
    $result = "=== Informations Ordinateur ===`n"
    $result += "Fabricant : $($computer.Manufacturer)`n"
    $result += "Modèle : $($computer.Model)`n"
    return $result
}
function Get-CPUInfo {
    $cpu = Get-WmiObject Win32_Processor | Select-Object -First 1
    $result = "=== CPU ===`n"
    $result += "Modèle : $($cpu.Name)`n"
    $result += "Nombre de cœurs : $($cpu.NumberOfCores)`n"
    $result += "Vitesse : $($cpu.MaxClockSpeed) MHz`n"
    return $result
}

function Get-RAMInfo {
    $ramModules = Get-WmiObject Win32_PhysicalMemory
    $result = "=== RAM ===`n"
    $result += "Nombre de modules : $($ramModules.Count)`n"

    foreach ($module in $ramModules) {
        $type = switch ($module.MemoryType) {
            20 { "DDR" }
            21 { "DDR2" }
            22 { "DDR2 FB-DIMM" }
            24 { "DDR3" }
            26 { "DDR4" }
            default { "Indisponible" }
        }
        
        $result += "Modèle : $($module.Manufacturer)`n"
        $result += "Capacité : $([math]::round($module.Capacity / 1GB, 2)) GB`n"
        $result += "Vitesse : $($module.Speed) MHz`n"
        $result += "Type : $type`n"
    }
    return $result
}


function Get-GPUInfo {
    $gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
    $result = "=== GPU ===`n"
    $result += "Modèle : $($gpu.Name)`n"
    $result += "Mémoire dédiée : $($gpu.AdapterRAM / 1MB) MB`n"
    $result += "Version du pilote : $($gpu.DriverVersion)`n"
    return $result
}

function Get-DiskInfo {
    $disks = Get-WmiObject Win32_DiskDrive
    $result = "=== Disques ===`n"
    $result += "Nombre de disques : $($disks.Count)`n"

    foreach ($disk in $disks) {
        $type = if ($disk.MediaType -like "*SSD*") { "SSD" } else { "HDD" }
        $totalSizeGB = [math]::round($disk.Size / 1GB, 2)

        $result += "Modèle : $($disk.Model)`n"
        $result += "Type : $type`n"
        $result += "Capacité totale : $totalSizeGB GB`n"
        $result += "État de santé : $($disk.Status)`n"
        $result += "`n"
    }
    return $result
}

function Show-HardwareInfo {
    $result = ""
    $result += Get-ComputerInfo
    $result += "`n"
    $result += Get-CPUInfo
    $result += "`n"
    $result += Get-RAMInfo
    $result += "`n"
    $result += Get-GPUInfo
    $result += "`n"
    $result += Get-DiskInfo
    return $result
}

# Exécuter la fonction et afficher les informations matérielles
Show-HardwareInfo