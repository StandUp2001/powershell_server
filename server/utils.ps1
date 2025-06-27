
function Invoke-Command {
    [CmdletBinding()]
    param ([ScriptBlock] $command)

    Write-Color "Executing command:"
    Write-Color "$($command.ToString())"
    Write-SeparatorLine
    try {
        & $command
    } catch {
        Write-ErrorColor "Error executing command: $_"
    }

    Write-SeparatorLine

}



function Write-SeparatorLine {
    [CmdletBinding()]
    param ([ConsoleColor]$color = [ConsoleColor]::Yellow)
    Write-Host ("=" * 100) -ForegroundColor $color
}

function Write-Color {
    [CmdletBinding()]
    param (
        [string]$text,
        [ConsoleColor]$foregroundColor = [ConsoleColor]::Magenta # Default foreground color
    )
    Write-Host $text -ForegroundColor $foregroundColor
}

function Write-WarningColor {
    [CmdletBinding()]
    param ([string]$text)
    Write-Color $text -ForegroundColor Yellow
}

function Write-ErrorColor {
    [CmdletBinding()]
    param ([string]$text)
    Write-Color $text -ForegroundColor Red
}


function Show-Colors {
    $colors = [enum]::GetValues([System.ConsoleColor])
    Foreach ($bgcolor in $colors){
        Foreach ($fgcolor in $colors) { Write-Host "$fgcolor|"  -ForegroundColor $fgcolor -BackgroundColor $bgcolor -NoNewLine }
        Write-Host " on $bgcolor"
    }
}

# I have a number that I want to check if it is a real number and if it is between two other numbers
function Test-RealNumber {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object]$value,  # Accept any input to validate

        [Parameter(Mandatory = $true)]
        [int]$min,

        [Parameter(Mandatory = $true)]
        [int]$max
    )

    $parsedValue = 0

    # Try to convert the input to int
    if (-not [int]::TryParse($value.ToString(), [ref]$parsedValue)) {
        return $false
    }

    # Check if within range
    return $parsedValue -ge $min -and $parsedValue -le $max
}


function Convert-MatrixFlatten {
    [CmdletBinding()]
    param ([array]$matrix)

    return ($matrix | ForEach-Object { $_ } | ForEach-Object { $_ }) -join ','
}

function Test-Machine {
    [CmdletBinding()]
    param (
        [bool]$debug_me = $false,
        [string]$expectedVersion = "5.1.x",
        [string]$expectedPlatform = "Win32NT"
    )

    if ($debug_me) {
        Write-Host "Debug mode is ON"
    } elseif ($debug_me || ($PSVersionTable.PSVersion -like "$expectedVersion.*" && $PSVersionTable.Platform -eq $expectedPlatform)) {
        Write-Host "This is the expected version $expectedVersion on $expectedPlatform"
        Write-Host "Current version: v$($PSVersionTable.PSVersion) on $($PSVersionTable.Platform)"
    } else {
        Write-ErrorColor "This is NOT the expected version or platform."
        Write-WarningColor "Expected: v$expectedVersion on $expectedPlatform"
        Write-WarningColor "Current: v$($PSVersionTable.PSVersion) on $($PSVersionTable.Platform)"
        Write-ErrorColor "Please check your PowerShell version and platform."
        Write-SeparatorLine
        Write-ErrorColor "Exiting script due to version/platform mismatch."
        exit 1
    }
}