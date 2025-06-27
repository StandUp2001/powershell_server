

if ("/home/stan/Programming/Powershell/server" -eq $PSScriptRoot) {
    Write-Host "Running in the server directory."
    $jsonFolder = "$PSScriptRoot/../json"
    $textFolder = "$PSScriptRoot/../text"
    . "$PSScriptRoot/utils.ps1"
    . "$PSScriptRoot/utils-server.ps1"
} else {
    Write-Host "Not running in the server directory."
    $jsonFolder = "$PSScriptRoot/json"
    $textFolder = "$PSScriptRoot/text"
    . "$PSScriptRoot/server/utils-server.ps1"
    . "$PSScriptRoot/server/utils.ps1"
}

function Convert-Files {
    $files_converted = 0
    $textFiles = Get-ChildItem -Path $textFolder -Filter "*.txt"
    $jsonFiles = Get-ChildItem -Path $jsonFolder -Filter "*.json"
    if ($textFiles.Count -eq $jsonFiles.Count) {
        return $files_converted
    }

    foreach ($txtFile in $textFiles) {
        $fileName = $txtFile.Name
        $jsonFilePath = Join-Path -Path $jsonFolder -ChildPath ($fileName -replace '\.txt$', '.json')

        if (Test-Path $jsonFilePath) {
            Write-Host "JSON file already exists for $fileName, skipping conversion."
            continue
        }

        try {
            $content = Get-Content -Path $txtFile.FullName
            Write-Host "Converting $fileName to JSON format..."

            # Skip the header line, process rest
            $dataObjects = @()
            for ($i = 1; $i -lt $content.Count; $i++) {
                $line = $content[$i]
                $parts = $line -split '\s+'
                if ($parts.Count -ne 2) {
                    Write-Error "Invalid line format in ${fileName}: $line"
                    continue
                }
                $data = [NumberTime]::New([int]$parts[0], [int]$parts[1])
                $dataObjects += $data
            }

            # Convert whole array to JSON once
            $jsonArray = $dataObjects | ConvertTo-Json -Depth 5
            $jsonArray | Out-File -FilePath $jsonFilePath -Encoding utf8

            $files_converted++
        }
        catch {
            Write-Error "Failed to convert ${fileName}: $_"
        }
    }

    Write-Host "Converted $files_converted files to JSON format."
    return $files_converted
}

