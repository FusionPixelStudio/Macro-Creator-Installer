# Check if the current user has administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please open PowerShell as Administrator to run this script - requires administrative privileges." -ForegroundColor Red
    exit
}

Write-Host "Script executed with administrative privileges. Proceeding with installation."

# Define paths
$toolsFolder = "$env:ProgramData\Blackmagic Design\DaVinci Resolve\Fusion\Scripts\Tool\"
$baseFolder = "$env:ProgramData\Blackmagic Design\DaVinci Resolve\Fusion\Scripts\Comp\Fusion Pixel Studios"
$nmcFolder = "$baseFolder\The New Macro Creator"
$filesFolder = "$nmcFolder\files"
$scriptsFolder = "$filesFolder\scripts"
$luaModules = "$env:ProgramData\Blackmagic Design\DaVinci Resolve\Fusion\Modules\Lua"

# Define file download details
$fileDetails = @(
    @{ID = "1K15w41DMZVRDXFA9hKRS88jMIRn7bQnS"; Path = "$nmcFolder\Macro Creator.lua"},
    @{ID = "1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B"; Path = "$nmcFolder\Change Macro Type.lua"},
    @{ID = "1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B"; Path = "$toolsFolder\Change Macro Type.lua"},
    @{ID = "1d8GPLxKMYwSZy_dnKXZi7KZUwf6sJ02E"; Path = "$scriptsFolder\QMap QuickEdit.lua"},
    @{ID = "1iLDGt7MQUxJR6G11RNXvQr-6YMMmWjXm"; Path = "$luaModules\devmode.lua"},
    @{ID = "1BARwV3JTfsXvHZ942My1K6UPzMZbyhkN"; Path = "$luaModules\HTTP.lua"}
)

# Function to ensure a folder exists
function Ensure-Folder {
    param (
        [string]$folderPath
    )
    if (-not (Test-Path $folderPath)) {
        Write-Output "Creating folder: $folderPath"
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
    }
}

# Ensure all required folders exist
Ensure-Folder -folderPath $baseFolder
Ensure-Folder -folderPath $nmcFolder
Ensure-Folder -folderPath $filesFolder
Ensure-Folder -folderPath $scriptsFolder
Ensure-Folder -folderPath $luaModules

# Download files
foreach ($file in $fileDetails) {
    $fileId = $file.ID
    $filePath = $file.Path
    $url = "https://drive.google.com/uc?export=download&id=$fileId"
    
    Write-Output "Downloading file"
    Write-Output "Saving to: $filePath"
    
    # Perform download
    Invoke-WebRequest -Uri $url -OutFile $filePath
    Write-Output "Download completed: $filePath"
}
