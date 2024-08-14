# Check if the current user has administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please open PowerShell as Administrator to run this script - requires administrative privileges." -ForegroundColor Red
    exit
}

Write-Host "Script executed with administrative privileges. Proceeding with installation."

# Define paths
$toolsFolder = "$env:ProgramData\Blackmagic Design\DaVinci Resolve\Fusion\Scripts\Tool"
$baseFolder = "$env:ProgramData\Blackmagic Design\DaVinci Resolve\Fusion\Scripts\Comp\FusionPixelStudio"
$nmcFolder = "$baseFolder\The New Macro Creator"
$filesFolder = "$nmcFolder\files"
$scriptsFolder = "$filesFolder\scripts"
$luaModules = "$env:ProgramData\Blackmagic Design\DaVinci Resolve\Fusion\Modules\Lua"

# Define file download details
$fileDetails = @(
    @{ID = "1-JYqs48z9DH18UQ8VkNcT2W_CNeik3Q-"; Path = "$nmcFolder\"; Name = "Macro Creator.lua"},
    @{ID = "1-KGV-xEIaBTCdrHGmN4eTbEOAuj_fWe6"; Path = "$nmcFolder\"; Name = "Change Macro Type.lua"},
    @{ID = "1-KGV-xEIaBTCdrHGmN4eTbEOAuj_fWe6"; Path = "$toolsFolder\"; Name = "Change Macro Type.lua"},
    @{ID = "1-RmJpcD4MZRucvqQ3QCqEB88xIKLDARh"; Path = "$scriptsFolder\"; Name = "QMap QuickEdit.lua"},
    @{ID = "1-NWtxyCgZZUwHSZiuZZWg88lp83IDDBN"; Path = "$luaModules\"; Name = "devmode.lua"},
    @{ID = "1-N8GS-5YoDJBYfjEa4YlwpUWZsCnIxxp"; Path = "$luaModules\"; Name = "HTTP.lua"}
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
    $filePath = $file.Path + $file.Name
    $fileName = $file.Name
    $url = "https://drive.google.com/uc?export=download&id=$fileId"
    
    Write-Output "Downloading file $fileName" 
    
    # Perform download
    Invoke-WebRequest -Uri $url -OutFile $filePath
    Write-Output "Download completed"
}

# Get only the current time
$currentTime = Get-Date -Format "HH:mm:ss tt"

# Output the result
Write-Output "Finished at $currentTime"
