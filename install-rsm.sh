#!/usr/bin/env bash
# Installs the latest RedM Server Manager on the system. Works for linux (deb) and darwin x64.

# Directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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
TARGET=/opt
if [[ "$1" == "windows" ]]; then
  SNIPPET="-win32-x64.tar.gz"
  TARGET="$SCRIPT_DIR" # Install locally on windows
elif [[ "$OSTYPE" == "darwin"* ]]; then
  SNIPPET="-darwin-x64.tar.gz"
else
  SNIPPET="-linux-x64.tar.gz"
fi

# Get the latest release download URL
URL=$($(which curl) --silent https://api.github.com/repos/Timeless-Outlaws/RedM-Server-Manager/releases | jq -r "sort_by(.tag_name) | [ .[] | select(.draft | not) | select(.prerelease | not) ] | .[-1].assets[].browser_download_url | select(test(\".*${SNIPPET}.*\"))")
if [ -z "$URL" ]; then
  echo "There currently is no latest build for rsm, cancelling..."
  exit 1
fi

# Create a temporary directory to download the latest build to
TMP=$(mktemp -d)

# Download latest build to the TMP folder
wget -c $URL -O $TMP/rsm.tar.gz

# Remove the old build since we have a new one
rm -f -R "$TARGET/rsm"
mkdir "$TARGET/rsm"

# Extract the release to the installation directory
tar -xz -f $TMP/rsm.tar.gz -C $TARGET
sudo chown -R $(id -u):$(id -g) $TARGET/rsm

# Remove TMP
rm -f -R $TMP

# Link only on linux/darwin
if ! [[ "$1" == "windows" ]]; then
  createSymlink
fi

if [[ "$1" == "windows" ]]; then
  echo "Successfully installed rsm! Use it by running $TARGET/rsm/bin/rsm.cmd"
else
  echo "Successfully installed rsm! Use it by typing rsm (if you linked /usr/bin/rsm) or $TARGET/rsm/bin/rsm"
fi

