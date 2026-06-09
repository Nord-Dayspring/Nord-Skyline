#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/install.sh"

SCRIPTS_PATH="${0:a:h}"

select_shell() {
  local default_shell=$(basename "$SHELL")
  echo "Please select the terminal you use: [Zsh/Fish] (default: $default_shell)" && read -r choice

  case "${choice}" in
  [fF] | [fF]ish) shell="fish" ;;
  [zZ] | [zZ]sh) shell="zsh" ;;
  *) shell="${default_shell}" ;;
  esac

  echo "${COLOR_SUCCESS}The shell you selected is: ${shell}.${COLOR_RESET}"
}

select_shell

# Basic Package Manager and Fonts
install_homebrew
install_mas
install_fonts

# Shell
if [[ "$shell" == "fish" ]]; then
  install_fish
fi

# Terminal and Shell Prompt
install_starship
install_ghostty

# Text Editor & Code Editor
install_zed

# Chinese text input
install_squirrel
