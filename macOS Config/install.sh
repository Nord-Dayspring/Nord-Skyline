#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"

_select_shell() {
  local default_shell=$(basename "$SHELL")
  read -r -p "Please select your terminal to export Homebrew PATH: [Zsh/Fish] (default: $default_shell)" choice

  local shell
  case "${choice}" in
  [fF] | [fF]ish) shell="fish" ;;
  [zZ] | [zZ]sh) shell="zsh" ;;
  *) shell="${default_shell}" ;;
  esac

  echo "${shell}"
}

install_homebrew() {
  clear
  echo "${COLOR_WARNING}Starting install Homebrew (may take a while)...${COLOR_RESET}"

  # Check if Homebrew has already been installed.
  if brew --version &>/dev/null; then
    echo "${COLOR_SUCCESS}Homebrew has already been installed.${COLOR_RESET}"
    return 0
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "${COLOR_SUCCESS}Successfully installed Homebrew.${COLOR_RESET}"

  local target_shell=$(_select_shell)
  if [[ "${target_shell}" == "zsh" ]]; then
    shell_config_path="$HOME/.zprofile"
    shellenv_command="eval \"$(/opt/homebrew/bin/brew shellenv)\""
  elif [[ "${target_shell}" == "fish" ]]; then
    mkdir -p "$HOME/.config/fish"
    shell_config_path="$HOME/.config/fish/config.fish"
    shellenv_command="eval (/opt/homebrew/bin/brew shellenv)"
  fi

  echo "${shellenv_command}" >>"${shell_config_path}"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "${COLOR_SUCCESS}Successfully export Homebrew PATH to ${shell} config. (${shell_config_path})${COLOR_RESET}"
}

install_mas() {
  clear

  if check_install "mas"; then
    echo "${COLOR_SUCCESS}mas has already been installed.${COLOR_RESET}"
    return 0
  fi

  brew install mas
  echo "${COLOR_SUCCESS}Successfully installed mas.${COLOR_RESET}"

  echo "${COLOR_WARNING}Please log in Mac App Store with your Apple ID.${COLOR_RESET}"
  open -a "App Store"
  read -r -p "Press [Enter] if you have successfully logged in."
  echo "${COLOR_SUCCESS}Successfully connect mas with Mac App Store.${COLOR_RESET}"
}

install_fonts() {
  if !confirm_install "Recommended Fonts Collection" "https://github.com/Nord-Dayspring/Nord-Skyline"; then
    echo "${COLOR_WARNING}Skipped all font installation. You may face the lack of fonts later.${COLOR_RESET}"
    return 1
  fi

  local fonts=(
    "font-jetbrains-mono"
    "font-lxgw-wenkai"
    "font-maple-mono-nf-cn"
    "font-new-york"
    "font-noto-sans"
    "font-noto-sans-sc"
    "font-noto-serif"
    "font-noto-serif-sc"
    "font-sf-mono"
    "font-sf-pro"
  )

  for font in "${fonts[@]}"; do
    if check_install "$font"; then
      echo "${COLOR_SUCCESS}${font} has already been installed.${COLOR_RESET}"
      continue
    else
      brew install --cask "$font"
      echo "${COLOR_SUCCESS}Successfully installed ${font}.${COLOR_RESET}"
    fi
  done

  echo "${COLOR_SUCCESS}All fonts in Recommended Fonts Collection has been installed.${COLOR_RESET}"
}
