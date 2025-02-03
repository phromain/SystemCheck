function Get-ProcessorInfo {
    $processor = Get-WmiObject -Class Win32_Processor | Select-Object -Property Name, LoadPercentage
    $processorUsage = $processor.LoadPercentage
    return [PSCustomObject]@{
        UtilisationProcesseur = $processorUsage
    }
}

function Get-GPUUsagePercent {
    $gpuUsageOutput = & nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits
    $gpuUsagePercent = [math]::round([double]$gpuUsageOutput, 2)
    return [PSCustomObject]@{
        UtilisationGPU = $gpuUsagePercent
    }
}

function Get-MemoryUsagePercent {
    $TotalMemory = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
    $FreeMemory = (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory * 1KB
    $UsedMemory = $TotalMemory - $FreeMemory
    $MemoryUsagePercent = ($UsedMemory / $TotalMemory) * 100
    return [math]::round($MemoryUsagePercent, 2)
}

function Get-DiskUsagePercent {
    $disks = Get-WmiObject Win32_DiskDrive
    $result = @()

    foreach ($disk in $disks) {
        $partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"
        $usedSpace = 0

        foreach ($partition in $partitions) {
            $logicalDisks = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
            foreach ($logicalDisk in $logicalDisks) {
                $usedSpace += $logicalDisk.Size - $logicalDisk.FreeSpace
            }
        }

        $usagePercent = ($usedSpace / $disk.Size) * 100

        $result += [PSCustomObject]@{
            Disques = $disk.Model
            Utilisation = [math]::round($usagePercent, 2)
        }
    }
    return $result
}

function Show-PerformanceInfo {
    $processorInfo = Get-ProcessorInfo
    $gpuUsage = Get-GPUUsagePercent
    $memoryUsage = Get-MemoryUsagePercent
    $diskUsage = Get-DiskUsagePercent

    $result = "=== Informations de performances ===`n"
    $result += "`nUtilisation du Processeur : $($processorInfo.UtilisationProcesseur)%`n"
    $result += "Utilisation du GPU : $($gpuUsage.UtilisationGPU)%`n"
    $result += "Utilisation de la Mémoire : $memoryUsage%`n"
    $result += "`n=== Utilisation des disques ===`n$($diskUsage | Format-Table -AutoSize | Out-String)`n"

    return $result
}

# Exécuter la fonction et afficher les informations de performance
Show-PerformanceInfo
