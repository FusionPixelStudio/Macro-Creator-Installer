#!/bin/bash

# Check if the script is running with administrative privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as Administrator (using sudo) to have the necessary privileges."
    exit 1
fi

echo "Script executed with administrative privileges. Proceeding with installation."

# Define paths
toolsFolder="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Tool"
baseFolder="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp/FusionPixelStudio"
nmcFolder="$baseFolder/The New Macro Creator"
filesFolder="$nmcFolder/files"
scriptsFolder="$filesFolder/scripts"
luaModules="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Modules/Lua"

# Define file download details
fileDetails=(
    "1-JYqs48z9DH18UQ8VkNcT2W_CNeik3Q-,$nmcFolder/Macro Creator.lua"
    "1-KGV-xEIaBTCdrHGmN4eTbEOAuj_fWe6,$nmcFolder/Change Macro Type.lua"
    "1-KGV-xEIaBTCdrHGmN4eTbEOAuj_fWe6,$toolsFolder/Change Macro Type.lua"
    "1-RmJpcD4MZRucvqQ3QCqEB88xIKLDARh,$scriptsFolder/QMap QuickEdit.lua"
    "1-NWtxyCgZZUwHSZiuZZWg88lp83IDDBN,$luaModules/devmode.lua"
    "1-N8GS-5YoDJBYfjEa4YlwpUWZsCnIxxp,$luaModules/HTTP.lua"
)

# Function to ensure a folder exists
ensure_folder() {
    local folderPath=$1
    if [ ! -d "$folderPath" ]; then
        echo "Creating folder: $folderPath"
        mkdir -p "$folderPath"
    fi
}

# Ensure all required folders exist
ensure_folder "$baseFolder"
ensure_folder "$nmcFolder"
ensure_folder "$filesFolder"
ensure_folder "$scriptsFolder"
ensure_folder "$luaModules"
ensure_folder "$toolsFolder"

# Download files
echo "Downloading files..."

for fileDetail in "${fileDetails[@]}"; do
    filePath=$(echo "$fileDetail" | cut -d',' -f2)
    fileName=$(basename "$filePath")
    fileId=$(echo "$fileDetail" | cut -d',' -f1)
    url="https://drive.google.com/uc?export=download&id=$fileId"

    echo "Downloading file: $fileName"
    
    # Perform download
    curl -L "$url" -o "$filePath"
    echo "Download completed: $fileName"
done

# Output the result with the current time
currentTime=$(date +"%I:%M:%S %p")
echo "Finished at $currentTime"
