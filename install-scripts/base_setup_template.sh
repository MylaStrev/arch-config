#!/bin/bash

#=========================
PACKAGES=(
  "vlc"
#  "blender"
#  "obs-studio"
  "spotify-launcher"
  "discord"
#  "orca-slicer"
#  "protonup-qt"
#  "protonplus"
  "libreoffice-fresh"
  "btop"
  "github-desktop"
  "starship"
  "visual-studio-code-bin"
)
FLATPAK_PACKAGES=(
  "io.edcd.EDMarketConnector"
  "md.obsidian.Obsidian"
)
#=========================
# Track failures
FAILED_PACKAGES=()
FAILED_FLATPAKS=()
#=========================
# Color codes for output
RED='\e[0;31m' # for error
GREEN='\e[0;32m' # for success
NC='\e[0m' # No Color
#=========================
# command calls
YAY_INT='sudo yay -Sq --needed --noconfirm'
FP_INT='sudo flatpak install flathub -y --noninteractive'
#=========================
echo "## INSTALLING FLATPAK AND YAY..."
sudo pacman -S --noconfirm yay flatpak
sudo pacman -v yay &> /dev/null
sudo pacman -v flatpak &> /dev/null
echo "## RUNNING UPDATE AND UPGRADE..."
sudo yay -Syu
sudo flatpak update
#=========================
echo "## INSTALLING YAY PACKAGES"
for pkg in "${PACKAGES[@]}"; do
    if yay -Qi "$pkg" &> /dev/null; then
        echo "## $pkg is already installed, skipping..."
    else
        echo "## installing $pkg..."
        "${YAY_INT}" "${PACKAGES[@]}";
    fi
done

for pkg in "${FLATPAK_PACKAGES[@]}"; do
    if flatpak install "$pkg" >/dev/null 2>&1; then
        echo "## $pkg is already installed, skipping..."
    else
        echo "## installing $pkg..."
      "${FP_INT}" "${FLATPAK_PACKAGES[@]}";
    fi
done
#=========================
# yay package verification
echo "#============================"
echo "## VERIFYING PACMAN/YAY PACKAGES"
for pkg in "${PACKAGES[@]}"; do
  if yay -Qi "$pkg" &> /dev/null; then
    echo -e "${GREEN} + $pkg ${NC}"
  else
    echo -e "${RED} - $pkg FAILED ${NC}"
    FAILED_PACKAGES+=("$pkg")
  fi
done
echo "#============================"
# flatpak package verficiation
echo "## VERIFYING FLATPAK PACKAGES"
for pkg in "${FLATPAK_PACKAGES[@]}"; do
  if flatpak info "$pkg" >/dev/null 2>&1; then
    echo -e "${GREEN} + $pkg ${NC}"
  else
    echo -e "${RED} - $pkg FAILED ${NC}"
    FAILED_PACKAGES+=("$pkg")
  fi
done
echo "#============================"
#=========================
echo "## FINISHED"
