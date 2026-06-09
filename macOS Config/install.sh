#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/interact.sh"

install_homebrew() {
  sleep "${SLEEP_SECONDS_BEFORE_CLEAR}" && clear
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
  sleep "${SLEEP_SECONDS_BEFORE_CLEAR}" && clear
  check_install "mas" && return 0

  brew install mas
  echo "${COLOR_SUCCESS}Successfully installed mas.${COLOR_RESET}"

  echo "${COLOR_WARNING}Please log in Mac App Store with your Apple ID.${COLOR_RESET}"
  open -a "App Store" && echo "Please press [Enter] if you finished logging in." && read -r

  echo "${COLOR_SUCCESS}Successfully connect mas with Mac App Store.${COLOR_RESET}"
}

install_fonts() {
  if ! confirm_install "Recommended Fonts" "https://github.com/Nord-Dayspring/Nord-Skyline"; then
    echo "${COLOR_WARNING}Skipped all font installation. You may face the lack of fonts later.${COLOR_RESET}"
    return 1
  fi

  local fonts=(
    "font-jetbrains-mono"
    "font-lxgw-wenkai"
    "font-maple-mono"
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
  check_install "fish" && return 0

  if ! confirm_install "Fish Shell" "https://fishshell.com/"; then
    echo "Skipped Fish installation."
    return 1
  fi

  brew install fish
  echo "${COLOR_SUCCESS}Successfully installed Fish.${COLOR_RESET}"

  echo "$(which fish)" | sudo tee -a /etc/shells
  chsh -s "$(which fish)"
}

install_aerospace() {
  check_install "aerospace" && return 0

  if ! confirm_install "Aerospace" "https://github.com/nikitabobko/AeroSpace"; then
    echo "${COLOR_WARNING}Skipped Aerospace installation.${COLOR_RESET}"
    return 1
  fi

  brew install --cask nikitabobko/tap/aerospace
  echo "${COLOR_SUCCESS}Successfully installed Aerospace.${COLOR_RESET}"

  local AEROSPACE_DIR="$HOME/.config/aerospace"
  mkdir -p "${AEROSPACE_DIR}"

  local source_config_path="${SCRIPTS_PATH}/../Aerospace Config/aerospace.toml"
  local target_config_path="${AEROSPACE_DIR}/aerospace.toml"

  cp "${source_config_path}" "${target_config_path}"
  echo "${COLOR_SUCCESS}Successfully setup Aerospace settings.${COLOR_RESET}"
}

install_starship() {
  check_install "starship" && return 0

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
  check_install "ghostty" && return 0

  if ! confirm_install "Ghostty" "https://ghostty.org/"; then
    echo "Skipped ghostty installation."
    return 1
  fi

  brew install --cask ghostty
  echo "${COLOR_SUCCESS}Successfully installed Ghostty.${COLOR_RESET}"

  echo "Please make ghostty the default terminal with the following steps: "
  echo "1. Click 'Ghostty' in the menu bar when ghostty is on the focus."
  echo "2. Click '􀋃 Make Ghostty the Default Terminal' in pop-up menu."

  open -a "ghostty" && echo "Please press [Enter] if you steps above." && read -rr

  local source_config_path="${SCRIPTS_PATH}/../Ghostty Config/config.ghostty"
  local target_config_path="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"

  cp "${source_config_path}" "${target_config_path}"

  if [[ "$shell" == "fish" ]]; then
    echo "command=$(which fish)" >>"${target_config_path}"
  fi

  echo "${COLOR_SUCCESS}Successfully setup Ghostty config.${COLOR_RESET}"
}

install_zed() {
  check_install "zed" && return 0

  if ! confirm_install "Zed" "https://zed.dev/"; then
    echo "${COLOR_WARNING}Skipped Zed installation.${COLOR_RESET}"
    return 1
  fi

  brew install --cask zed
  echo "${COLOR_SUCCESS}Successfully installed Zed.${COLOR_RESET}"

  local ZED_DIR="$HOME/.config/zed"
  mkdir -p "${ZED_DIR}"

  local source_config_path="${SCRIPTS_PATH}/../Zed Config/settings.yaml"
  local target_config_path="${ZED_DIR}/settings.json"

  cp "${source_config_path}" "${target_config_path}"
  echo "${COLOR_SUCCESS}Successfully setup Zed settings.${COLOR_RESET}"
}

install_squirrel() {
  check_install "squirrel" && return 0

  if ! confirm_install "Squirrel 鼠须管" "https://rime.im/"; then
    echo "${COLOR_WARNING}Skipped Squirrel installation.${COLOR_RESET}"
    return 1
  fi

  brew install --cask squirrel-app
  echo "${COLOR_SUCCESS}Successfully installed Squirrel.${COLOR_RESET}"

  local RIME_DIR="$HOME/Library/Rime"
  mkdir -p "${RIME_DIR}" && cd "${RIME_DIR}"

  git clone https://github.com/rime/plum.git plum
  bash plum/rime-install iDvel/rime-ice:others/recipes/full
  echo "${COLOR_SUCCESS}Successfully installed rime-ice 雾凇拼音.${COLOR_RESET}"
  cd "${SCRIPTS_PATH}"

  local source_config_path="${SCRIPTS_PATH}/../Squirrel Config/squirrel.yaml"
  local target_config_path="${RIME_DIR}/squirrel.yaml"

  echo "" >>"$target_config_path"
  sed 's/^/  /' "${source_config_path}" >>"${target_config_path}"

  echo "The main config files are opened. Modify them if needed."
  open -a TextEdit "${target_config_path}"
  open -a TextEdit "${RIME_DIR}/default.yaml"
  echo "${COLOR_SUCCESS}Successfully complete Squirrel setup.${COLOR_RESET}"
}

install_recommend_apps() {
  if ! confirm_install "Recommended Apps" "https://github.com/Nord-Dayspring/Nord-Skyline"; then
    echo "${COLOR_WARNING}Skipped recommended apps installation.${COLOR_RESET}"
    return 1
  fi

  local homebrew_apps=(
    "stats"
    "raycast"
    "clion"
    "pycharm"
    "intellij-idea"
    "arc"
    "firefox"
    "zen"
  )

  for app in "${homebrew_apps[@]}"; do
    check_install "${app}" && continue
    brew install "${app}"
    echo "${COLOR_SUCCESS}Successfully installed ${app}.${COLOR_RESET}"
  done

  declare -A mas_apps=(
    ["WeChat"]="451108668"
    ["QQ"]="836500024"
    ["Pages"]="361309726"
    ["Keynotes"]="361285480"
    ["Numbers"]="361304891"
    ["Wuthering Waves"]="6450693428"
  )

  for app_name in "${(@k)mas_apps}"; do
    local app_id="${mas_apps[$app_name]}"
    local app_link="https://apps.apple.com/app/id$app_id"

    if confirm_install "$app_name" "$app_link"; then
      mas install "$app_id"
      echo "${COLOR_SUCCESS}Successfully installed $app_name.${COLOR_RESET}"
    else
      echo "${COLOR_WARNING}Skipped $app_name.${COLOR_RESET}"
    fi
  done

  echo "${COLOR_SUCCESS}All other essential apps installation completed.${COLOR_RESET}"
}
