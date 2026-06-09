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
}

select_shell
echo "${COLOR_SUCCESS}The shell you selected is: ${shell}.${COLOR_RESET}"

sleep "${SLEEP_SECONDS_BEFORE_CLEAR}"
clear
echo "Install basic package manager and fonts..."
install_homebrew
install_mas
install_fonts

sleep "${SLEEP_SECONDS_BEFORE_CLEAR}" && clear
if [[ "$shell" == "fish" ]]; then
  echo "Install fish shell to replace $(basename "$SHELL")"
  install_fish
fi

sleep "${SLEEP_SECONDS_BEFORE_CLEAR}" && clear
echo "Install terminal and prompt..."
install_starship
install_ghostty
