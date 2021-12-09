#!/usr/bin/env bash

# Installs the latest RedM Server Manager on the system. Works for linux (deb) and darwin x64.
#
#

function createSymlink() {
  if [ -f "/usr/bin/rsm" ]; then
    read -p "Cant link /usr/bin/rsm as it does already exist, do you want to overwrite it? " -n 1 -r
    echo    # (optional) move to a new line
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "Skipping linking to /usr/bin/rsm."
      exit 0
    fi
  fi
  
  ln -f -s /opt/rsm/bin/rsm /usr/bin/rsm
}

# Determine the correct build
if [[ "$OSTYPE" == "darwin"* ]]; then
  SNIPPET="-darwin-x64.tar.gz"
else
  SNIPPET="-linux-x64.tar.gz"
fi

# Get the latest release download URL
URL=curl --silent https://api.github.com/repos/Timeless-Outlaws/RedM-Server-Manager/releases | jq -r "sort_by(.tag_name) | [ .[] | select(.draft | not) | select(.prerelease | not) ] | .[-1].assets[].browser_download_url | select(test(\".*${SNIPPET}.*\"))"

# Create a temporary directory to download the latest build to
TMP=mktmp

# Download latest build to the TMP folder
wget -c $URL -C $TMP/rsm.tar.gz

# Remove the old build since we have a new one
rm -R /opt/rsm
mkdir /opt/rsm

# Extract the release to the installation directory
tar -xz $TMP/rsm.tar.gz -C /opt/rsm

# Remove TMP
rm -f -R $TMP

# Link the release
createSymlink

echo "Successfully installed rsm! Use it by typing rsm (if you linked /usr/bin/rsm) or /opt/rsm/bin/rsm"
