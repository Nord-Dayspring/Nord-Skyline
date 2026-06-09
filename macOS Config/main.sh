#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/install.sh"

select_shell() {
  local default_shell=$(basename "$SHELL")
  read -r -p "Please select the terminal you use: [Zsh/Fish] (default: $default_shell)" choice

  local shell
  case "${choice}" in
  [fF] | [fF]ish) shell="fish" ;;
  [zZ] | [zZ]sh) shell="zsh" ;;
  *) shell="${default_shell}" ;;
  esac

  echo "${shell}"
}

shell=$(select_shell)

clear
echo "Install basic package manager and fonts..."
install_homebrew
install_mas
install_fonts

clear
echo "Install terminal and prompt, or additional shell if selected..."
if [[ "$shell" == "fish" ]]; then
  install_fish
fi

install_starship
install_ghostty
