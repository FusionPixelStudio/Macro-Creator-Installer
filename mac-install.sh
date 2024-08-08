#!binbash

# Check if the script is running with administrative privileges
if [ $EUID -ne 0 ]; then
    echo Please run this script as Administrator (using sudo) to have the necessary privileges.
    exit 1
fi

echo Script executed with administrative privileges. Proceeding with installation.

# Define paths
toolsFolder=LibraryApplication SupportBlackmagic DesignDaVinci ResolveFusionScriptsTool
baseFolder=LibraryApplication SupportBlackmagic DesignDaVinci ResolveFusionScriptsCompFusion Pixel Studios
nmcFolder=$baseFolderThe New Macro Creator
filesFolder=$nmcFolderfiles
scriptsFolder=$filesFolderscripts
luaModules=LibraryApplication SupportBlackmagic DesignDaVinci ResolveFusionModulesLua

# Define file download details
fileDetails=(
    1K15w41DMZVRDXFA9hKRS88jMIRn7bQnS$nmcFolderMacro Creator.lua
    1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B$nmcFolderChange Macro Type.lua
    1_Igs1M4N5GAi9QUoy2Fa7cvFfvLSTe5B$toolsFolderChange Macro Type.lua
    1d8GPLxKMYwSZy_dnKXZi7KZUwf6sJ02E$scriptsFolderQMap QuickEdit.lua
    1iLDGt7MQUxJR6G11RNXvQr-6YMMmWjXm$luaModulesdevmode.lua
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