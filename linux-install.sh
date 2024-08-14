#!/bin/bash

# Check if the script is running with administrative privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as Administrator (using sudo) to have the necessary privileges."
    exit 1
fi

echo "Script executed with administrative privileges. Proceeding with installation."

# Define default paths
defaultPath1="/opt/resolve/Fusion"
defaultPath2="/home/resolve/Fusion"

# Determine the correct path
if [ -d "$defaultPath1" ]; then
    scriptsFolder="$defaultPath1"
elif [ -d "$defaultPath2" ]; then
    scriptsFolder="$defaultPath2"
else
    read -p "Neither $defaultPath1 nor $defaultPath2 exists. Please enter the path to your Universal DaVinci Resolve Fusion Folder: " userPath
    scriptsFolder="$userPath"
fi

# Define folders based on the determined path
toolsFolder="$scriptsFolder/Scripts/Tool"
baseFolder="$scriptsFolder/Scripts/Comp/FusionPixelStudio"
nmcFolder="$baseFolder/The New Macro Creator"
filesFolder="$nmcFolder/files"
filesScriptsFolder="$filesFolder/scripts"
luaModules="$scriptsFolder/Modules/Lua"

# Define file download details
fileDetails=(
    "1-JYqs48z9DH18UQ8VkNcT2W_CNeik3Q-:$nmcFolder/Macro Creator.lua"
    "1-KGV-xEIaBTCdrHGmN4eTbEOAuj_fWe6:$nmcFolder/Change Macro Type.lua"
    "1-KGV-xEIaBTCdrHGmN4eTbEOAuj_fWe6:$toolsFolder/Change Macro Type.lua"
    "1-RmJpcD4MZRucvqQ3QCqEB88xIKLDARh:$filesScriptsFolder/QMap QuickEdit.lua"
    "1-NWtxyCgZZUwHSZiuZZWg88lp83IDDBN:$luaModules/devmode.lua"
    "1-N8GS-5YoDJBYfjEa4YlwpUWZsCnIxxp:$luaModules/HTTP.lua"
)

# Function to ensure a folder exists
ensure_folder() {
    local folderPath="$1"
    if [ ! -d "$folderPath" ]; then
        echo "Creating folder: $folderPath"
        mkdir -p "$folderPath"
    fi
}

# Ensure all required folders exist
ensure_folder "$baseFolder"
ensure_folder "$nmcFolder"
ensure_folder "$filesFolder"
ensure_folder "$filesScriptsFolder"
ensure_folder "$scriptsFolder"
ensure_folder "$luaModules"
ensure_folder "$toolsFolder"

# Download files
echo "Downloading files..."

for fileDetail in "${fileDetails[@]}"; do
    filePath=$(echo "$fileDetail" | cut -d':' -f2)
    fileName=$(basename "$filePath")  # Extract file name from the path
    url="https://drive.google.com/uc?export=download&id=$(echo "$fileDetail" | cut -d':' -f1)"

    echo "Downloading file: $fileName"
    
    # Perform download
    curl -L "$url" -o "$filePath"
    echo "Download completed: $fileName"
done

# Output the result with the current time
currentTime=$(date +"%I:%M:%S %p")
echo "Finished at $currentTime"
