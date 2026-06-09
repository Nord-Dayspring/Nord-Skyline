#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/interact.sh"

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

  if [[ "${shell}" == "zsh" ]]; then
    shell_config_path="$HOME/.zprofile"
    shellenv_command="eval \"$(/opt/homebrew/bin/brew shellenv)\""
  elif [[ "${shell}" == "fish" ]]; then
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
  if ! confirm_install "fonts" "https://github.com/Nord-Dayspring/Nord-Skyline"; then
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

  echo "${COLOR_SUCCESS}All recommended fonts has been installed.${COLOR_RESET}"
}

install_fish() {
  if check_install "fish"; then
    echo "${COLOR_SUCCESS}Fish has already been installed.${COLOR_RESET}"
    return 0
  fi

  if !confirm_install "Fish Shell" "https://fishshell.com/"; then
    echo "Skipped Fish installation."
    return 1
  fi

  brew install fish
  echo "${COLOR_SUCCESS}Successfully installed Fish.${COLOR_RESET}"

  echo "$(which fish)" | sudo tee -a /etc/shells
  chsh -s "$(which fish)"
}

install_starship() {
  if check_install "starship"; then
    echo "${COLOR_SUCCESS}Starship has already been installed.${COLOR_RESET}"
    return 0
  fi

  if ! confirm_install "Starship" "https://starship.rs/"; then
    echo "${COLOR_WARNING}Skipped Starship installation.${COLOR_RESET}"
    return 1
  fi

  brew install starship
  echo "${COLOR_SUCCESS}Successfully installed Starship.${COLOR_RESET}"

  if [[ "$shell" == "zsh" ]]; then
    local shell_config_path="$HOME/.zshrc"
    local initialize_command='eval "$(starship init zsh)"'
  elif [[ "$shell" == "fish" ]]; then
    mkdir -p "$HOME/.config/fish"
    local shell_config_path="$HOME/.config/fish/config.fish"
    local initialize_command='starship init fish | source'
  fi

  echo "${initialize_command}" >>"${shell_config_path}"
  echo "${COLOR_SUCCESS}Successfully append Starship to ${shell} config.${COLOR_RESET}"
}

install_ghostty() {
  if check_install "ghostty"; then
    echo "${COLOR_SUCCESS}Ghostty has already been installed.${COLOR_RESET}"
    return 0
  elif ! confirm_install "Ghostty" "https://ghostty.org/"; then
    echo "Skipped ghostty installation."
    return 1
  fi

  brew install --cask ghostty
  echo "${COLOR_SUCCESS}Successfully installed Ghostty.${COLOR_RESET}"

  echo "Please make ghostty the default terminal with the following steps: "
  echo "1. Click 'Ghostty' in the menu bar when ghostty is on the focus."
  echo "2. Click '􀋃 Make Ghostty the Default Terminal' in pop-up menu."

  open -a "ghostty"
  read -r -p "${COLOR_WARNING}Press [Enter] if you finish the manual setup.${COLOR_RESET}"

  local script_path="$(cd "$(dirname "$0")" && pwd)"
  local config_path="${script_path}/../Ghostty Config/config.ghostty"
  local target_path="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"

  if [[ ! -f "$config_path" ]]; then
    echo "${COLOR_ERROR}Source config not found. Please check the integrity of the repo.${COLOR_RESET}"
    echo "${COLOR_WARNING}Skipped config deployment.${COLOR_RESET}"
    return 1
  else
    cp "${config_path}" "${target_path}"
  fi

  if [[ "$shell" == "fish" ]]; then
    echo "command=$(which fish)" >>"${target_path}"
  fi

  echo "${COLOR_SUCCESS}Successfully setup Ghostty config. Press 􀆝􀆔, to reload config.${COLOR_RESET}"
}
