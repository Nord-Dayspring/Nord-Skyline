#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"

_select_shell() {
  local default_shell=$(basename "$SHELL")
  read -r -p "Please select your terminal to export Homebrew PATH: [Zsh/Fish] (default: $default_shell)" choice

  local shell
  case "$choice" in
  [fF] | [fF]ish) shell="fish" ;;
  [zZ] | [zZ]sh) shell="zsh" ;;
  *) shell="$default_shell" ;;
  esac

  echo "$shell"
}

install_homebrew() {
  echo "${COLOR_WARNING}Starting install Homebrew (may take a while)...${COLOR_RESET}"

  # Check if Homebrew has already been installed.
  if brew --version &>/dev/null; then
    echo "${COLOR_SUCCESS}Homebrew has already been installed.${COLOR_RESET}"
    return 0
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "${COLOR_SUCCESS}Successfully installed Homebrew.${COLOR_RESET}"

  local target_shell=$(_select_shell)
  if [[ "$target_shell" == "zsh" ]]; then
    shell_config_path="$HOME/.zprofile"
    shellenv_command="eval \"$(/opt/homebrew/bin/brew shellenv)\""
  elif [[ "$target_shell" == "fish" ]]; then
    shell_config_path="$HOME/.config/fish/config.fish"
    mkdir -p "$HOME/.config/fish"
    shellenv_command="eval (/opt/homebrew/bin/brew shellenv)"
  fi
  echo "$shellenv_command" >>"$shell_config_path"

  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "${COLOR_SUCCESS}Successfully export Homebrew PATH to ${shell} config. (${shell_config_path})${COLOR_RESET}"
}
