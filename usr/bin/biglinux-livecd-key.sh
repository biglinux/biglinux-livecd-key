#!/usr/bin/env bash

# Color definitions for status messages
blueDark="\e[1;38;5;33m"     # Bold dark blue
mediumBlue="\e[1;38;5;32m"   # Bold medium blue
lightBlue="\e[1;38;5;39m"    # Bold light blue
cyan="\e[1;38;5;45m"         # Bold cyan
white="\e[1;97m"             # Bold white
reset="\e[0m"                # Reset text formatting

# Additional colors for warnings/errors
red="\e[1;31m"               # Bold red for errors
yellow="\e[1;33m"            # Bold yellow for warnings
green="\e[1;32m"             # Bold green for success

# Print status messages
printMsg() {
    local message="$1"
    echo -e "${blueDark}[${lightBlue}biglinux-livecd-key${blueDark}]${reset} ${cyan}→${reset} ${white}${message}${reset}"
}

# Print success messages
printOk() {
    local message="$1"
    echo -e "${blueDark}[${green}SUCCESS${blueDark}]${reset} ${cyan}→${reset} ${white}${message}${reset}"
}

# Print warning messages
printWarn() {
    local message="$1"
    echo -e "${blueDark}[${yellow}WARNING${blueDark}]${reset} ${cyan}→${reset} ${white}${message}${reset}"
}

# Print error messages
printErr() {
    local message="$1"
    echo -e "${blueDark}[${red}ERROR${blueDark}]${reset} ${cyan}→${reset} ${white}${message}${reset}"
}

# List of files to be copied
files=('pubring.gpg' 'trustdb.gpg')

# Source and destination paths
srcPath='/usr/share/pacman/keyrings'
destPath='/etc/pacman.d/gnupg'

# Check if destination directory exists, if not, create it
if [[ ! -d "$destPath" ]]; then
    printMsg "Creating directory $destPath..."
    mkdir -p "$destPath"
fi

# Iterate through the file list
for file in "${files[@]}"; do
    srcFile="$srcPath/$file"
    destFile="$destPath/$file"

    # Check if source file exists
    if [[ -e "$srcFile" ]]; then
        printMsg "Copying 'Public Keyring' and 'Trust Database' ${srcFile} into ${destFile}..."
        cp -af "$srcFile" "$destFile" >/dev/null 2>&1
    else
        printWarn "Source file $srcFile does not exist"
    fi
done

# Ensure keyring is properly initialized
printMsg "Initializing pacman keyring..."
pacman-key --init >/dev/null 2>&1
printOk "Done!"
