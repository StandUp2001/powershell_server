# Includes scripts
. "$PSScriptRoot\utils.ps1"

Test-Machine $true
$fallThroughFunctions = $true


Write-Color "Couple functions to test:"
Show-Colors
Write-SeparatorLine
Invoke-Command {
    Write-Color "Hello, World!" Cyan
}
Invoke-Command {
    Get-Command -CommandType Cmdlet
}
Invoke-Command {
    Get-Help Write-Host
}
Invoke-Command {
    Get-Member -InputObject 5
}
Invoke-Command {
    "STAN" | Select-Object -Property *
}
Invoke-Command {
    Select-Object -InputObject "STAN" -Property *
}
Invoke-Command {
    5.5.GetType()
}

$matrix = @(
    @(1, 2, 3),
    @(4, 5, 6),
    @(7, 8, 9)
)

Invoke-Command {
    $matrix.GetType()
}

Invoke-Command {
    $matrix | ForEach-Object {
        $_ | ForEach-Object { Write-Host $_ -NoNewLine }
        Write-Host ""
    }
}


Invoke-Command {
    foreach ($row in $matrix) {
        foreach ($item in $row) {
            Write-Host $item -NoNewLine
        }
        Write-Host ""
    }
}

# Display the matrix in a formatted table
Invoke-Command {
    Write-Color "Matrix in table format:"
    $matrix | ForEach-Object {
        $_ -join "`t" | Write-Host
    }
}

Invoke-Command {
    Write-Color "Flattened matrix:"
    $flattened = $matrix | ForEach-Object { $_ } | ForEach-Object { $_ }
    $flattened -join ", " | Write-Host
}

$matrix += ,@(10, 11, 12)#Need a comma to ensure it's treated as a single row

Invoke-Command {
    $flattened = Convert-MatrixFlatten -Matrix $matrix
    Write-Color "Flattened matrix: $flattened" -ForegroundColor Green
}


Invoke-Command {
    Write-Color "Matrix after adding a new row:"
    $matrix | ForEach-Object {
        $_ -join "`t" | Write-Host
    }
}


$HashTable = @{
    Name = "Stan"
    Age = 30
    City = "New York"
}

Invoke-Command {
    Write-Color "HashTable contents:"
    $HashTable.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key): $($_.Value)"
    }
}

$HashTable.Add("Country", "USA")

Invoke-Command {
    Write-Color "HashTable after adding a new key-value pair:"
    $HashTable.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key): $($_.Value)"
    }
}

Invoke-Command {
    Write-Color "HashTable keys:"
    $HashTable.Keys | ForEach-Object { Write-Host $_ }
}

Invoke-Command {
    Write-Color "HashTable values:"
    $HashTable.Values | ForEach-Object { Write-Host $_ }
}

Invoke-Command {
    Write-Color "HashTable as a formatted table:"
    $HashTable.GetEnumerator() | Format-Table -AutoSize
}

Invoke-Command {
    Write-Color "HashTable as a formatted list:"
    $HashTable.GetEnumerator() | Format-List
}

$HashTable.Set_Item("Age", 31)

Invoke-Command {
    Write-Color "HashTable after updating a value:"
    $HashTable.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key): $($_.Value)"
    }
}

$HashTable.Remove("City")

Invoke-Command {
    Write-Color "HashTable after removing a key-value pair:"
    $HashTable.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key): $($_.Value)"
    }
}

Invoke-Command {
    Write-Host "What is your favorite color?"
    $exclude = [System.ConsoleColor]::Black, [System.ConsoleColor]::DarkBlue
    $colors = [enum]::GetValues([System.ConsoleColor]) | Where-Object { $_ -notin $exclude }
    $colors | ForEach-Object { 
        $Index = [array]::IndexOf($colors, $_) + 1
        Write-Host "$Index. $_" -NoNewLine; Write-Host " "
    }
    Write-Host ""

    if (!$fallThroughFunctions){

        $number = Read-Host "Enter the number of your favorite color (1-$($colors.Count))"
        while (!(Test-RealNumber $number 1 $colors.Count)) {
            Write-ErrorColor "Please enter a valid number between 1 and $($colors.Count)."
            $number = Read-Host "Enter the number of your favorite color (1-$($colors.Count))"
        }
    }
    else {
        $number = 1
    }
    
    $favoriteColor = $colors[$number - 1]
    if (!$favoriteColor) {
        Write-ErrorColor "Invalid selection. Please enter a number between 1 and $($colors.Count)."
        return
    }
    Write-Color "You selected: $favoriteColor" -ForegroundColor $favoriteColor
}

$testDirectory = "$PSScriptRoot/test_directory"

Invoke-Command {
    Write-Color "Created testfile.txt in $PSScriptRoot"
    New-Item "$PSScriptRoot/testfile.txt" -type File -value "This is a test file." -Force | Out-Null
    Write-Color "Listing contents of $PSScriptRoot"
    ls
}

Invoke-Command {
    Write-Color "Created test_directory in $PSScriptRoot"
    New-Item $testDirectory -type Directory -Force  | Out-Null
    Write-Color "Listing contents of test_directory"
    ls
}

Invoke-Command {
    Write-Color "Copying testfile.txt to test_directory"
    Copy-Item "$PSScriptRoot/testfile.txt" "$testDirectory/testfile_copy.txt"
    Write-Color "Listing contents of test_directory after copying testfile.txt"
    ls $testDirectory
}

Invoke-Command {
    Write-Color "Moving testfile.txt to test_directory"
    Move-Item "$PSScriptRoot/testfile.txt" "$testDirectory/testfile_moved.txt" -Force
    
    Write-Color "Listing contents of test_directory after moving testfile.txt"
    ls $testDirectory
    
    Write-Color "Listing contents of $PSScriptRoot"
    ls
}

Invoke-Command {
    Write-Color "Renaming testfile_moved.txt to testfile_renamed.txt"
    $target = "$testDirectory/testfile_renamed.txt"
    if (Test-Path $target) {
        Write-WarningColor "File $target already exists. Overwriting it."
        Remove-Item $target -Force
        Rename-Item "$testDirectory/testfile_moved.txt" $target -Force
    }
    else {
        Rename-Item "$testDirectory/testfile_moved.txt" $target
    }

    Write-Color "Listing contents of test_directory after renaming"
    ls $testDirectory
}

Invoke-Command {
    Write-Color "Deleting testfile_copy.txt from test_directory"
    Remove-Item "$testDirectory/testfile_copy.txt" -Force

    Write-Color "Listing contents of test_directory after deletion"
    ls $testDirectory

    Write-Host ""

    Write-Color "Deleting test_directory"
    Remove-Item $testDirectory -Recurse -Force

    Write-Color "Listing contents of $PSScriptRoot after deleting test_directory"
    ls
}

Invoke-Command {
    Write-Color "Testing real number validation:"
    $testNumbers = @(5, 10.5, -3, 0, "abc", 1.2e3, 1.2e-3)
    $testNumbers | ForEach-Object {
        if (Test-RealNumber $_ 0 10) {
            Write-Color "$_ is a valid real number between 0 and 10."
        } else {
            Write-ErrorColor "$_ is NOT a valid real number between 0 and 10."
        }
    }
}