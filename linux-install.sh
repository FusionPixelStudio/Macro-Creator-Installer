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
baseFolder="$scriptsFolder/Scripts/Comp/Fusion Pixel Studios"
nmcFolder="$baseFolder/The New Macro Creator"
filesFolder="$nmcFolder/files"
filesScriptsFolder="$nmcFolder/files/scripts"
luaModules="$scriptsFolder/Modules/Lua"

# Define file download details
fileDetails=(
    "1K15w41DMZVRDXFA9hKRS88jMIRn7bQnS:$nmcFolder/Macro Creator.lua"
    "1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B:$nmcFolder/Change Macro Type.lua"
    "1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B:$toolsFolder/Change Macro Type.lua"
    "1d8GPLxKMYwSZy_dnKXZi7KZUwf6sJ02E:$filesScriptsFolder/QMap QuickEdit.lua"
    "1iLDGt7MQUxJR6G11RNXvQr-6YMMmWjXm:$luaModules/devmode.lua",
    "1BARwV3JTfsXvHZ942My1K6UPzMZbyhkN:$luaModules/HTTP.lua"
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
ensure_folder "$scriptsFolder"
ensure_folder "$luaModules"
ensure_folder "$toolsFolder"
ensure_folder "$filesScriptsFolder"

# Download files
echo "Downloading files..."

for fileDetail in "${fileDetails[@]}"; do
    fileId=$(echo "$fileDetail" | cut -d':' -f1)
    filePath=$(echo "$fileDetail" | cut -d':' -f2)
    url="https://drive.google.com/uc?export=download&id=$fileId"

    echo "Downloading file"
    echo "Saving to: $filePath"
    
    # Perform download
    curl -L "$url" -o "$filePath"
    echo "Download completed: $filePath"
done

echo "Installation completed."
