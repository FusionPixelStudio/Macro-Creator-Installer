#!binbash

# Check if the script is running with administrative privileges
if [ $EUID -ne 0 ]; then
    echo Please run this script as Administrator (using sudo) to have the necessary privileges.
    exit 1
fi

echo Script executed with administrative privileges. Proceeding with installation.

# Define paths
toolsFolder="Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Tool"
baseFolder="Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp/Fusion Pixel Studios"
nmcFolder="$baseFolder/The New Macro Creator"
filesFolder="$nmcFolder/files"
scriptsFolder="$filesFolder/scripts"
luaModules="Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Modules/Lua"

# Define file download details 
fileDetails=(
    "1K15w41DMZVRDXFA9hKRS88jMIRn7bQnS$nmcFolder Macro Creator.lua"
    "1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B$nmcFolder Change Macro Type.lua"
    "1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B$toolsFolder Change Macro Type.lua"
    "1d8GPLxKMYwSZy_dnKXZi7KZUwf6sJ02E$scriptsFolder QMap QuickEdit.lua"
    "1iLDGt7MQUxJR6G11RNXvQr-6YMMmWjXm$luaModules devmode.lua"
    "1BARwV3JTfsXvHZ942My1K6UPzMZbyhkN$luaModules HTTP.lua"
)

# Function to ensure a folder exists
ensure_folder() {
    local folderPath=$1
    if [ ! -d $folderPath ]; then
        echo Creating folder $folderPath
        mkdir -p $folderPath
    fi
}

# Ensure all required folders exist
ensure_folder $baseFolder
ensure_folder $nmcFolder
ensure_folder $filesFolder
ensure_folder $scriptsFolder
ensure_folder $luaModules
ensure_folder $toolsFolder

# Download files
echo Downloading files...

for fileDetail in ${fileDetails[@]}; do
    fileId=$(echo $fileDetail  cut -d'' -f1)
    filePath=$(echo $fileDetail  cut -d'' -f2)
    url=httpsdrive.google.comucexport=download&id=$fileId

    echo Downloading file from $url
    echo Saving to $filePath
    
    # Perform download
    curl -L $url -o $filePath
    echo Download completed $filePath
done

echo Installation completed.
