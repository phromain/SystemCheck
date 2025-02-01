# Fonction pour récupérer les informations de performances
function Show-PerformanceInfo {
    $cpuUsage = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
    $ram = Get-WmiObject -Class Win32_OperatingSystem
    $totalRam = $ram.TotalVisibleMemorySize * 1KB
    $freeRam = $ram.FreePhysicalMemory * 1KB
    $usedRam = $totalRam - $freeRam

    $processes = Get-Process | Select-Object -Property Name, CPU, WorkingSet
    $services = Get-Service | Where-Object { $_.Status -eq 'Running' }

    # Formater les informations en chaîne de caractères
    $result = "=== Informations de performances ===`n"
    $result += "Utilisation CPU : $([math]::round($cpuUsage, 2))%`n"
    $result += "Utilisation RAM : $([math]::round(($usedRam / $totalRam * 100), 2))%`n"
    $result += "=== Processus ===`n"
    foreach ($process in $processes) {
        $result += "Nom : $($process.Name), Utilisation CPU : $([math]::round($process.CPU, 2)), Utilisation RAM : $([math]::round($process.WorkingSet / 1MB, 2)) MB`n"
    }
    $result += "=== Services ===`n"
    foreach ($service in $services) {
        $result += "Nom : $($service.DisplayName), État : $($service.Status)`n"
    }
    return $result
}
