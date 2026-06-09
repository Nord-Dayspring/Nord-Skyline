#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"

# Provide the name of software and website links for detail information access.
confirm_install() {
  local software_name="$1"
  local detail_link="$2"

  echo "Get ready to install $software_name."
  echo "Visit $detail_link for detail information."
  echo "${COLOR_WARNING}Install $software_name? [y/N]${COLOR_RESET}" && read -r choice

  case "$choice" in
  [nN] | [nN][oO]) return 1 ;;
  [yY] | *) return 0 ;;
  esac
}

# Provide the name of application in shell to check whether the app has been installed.
check_install() {
  local software_name="$1"
  local software_path=$(command -v "$software_name" 2>/dev/null)
  local HOMEBREW_PREFIX="$(brew --prefix)"

  sleep "${SLEEP_SECONDS_BEFORE_CLEAR}" && echo ""
  if brew list "$software_name" &>/dev/null; then
    echo "${COLOR_SUCCESS}$software_name has already been installed.${COLOR_RESET}"
    return 0
  elif [[ -n "$software_path" ]] && [[ "$software_path" == "${HOMEBREW_PREFIX}"* ]]; then
    echo "${COLOR_SUCCESS}$software_name has already been installed.${COLOR_RESET}"
    return 0
  elif [[ -n "$software_path" ]] || ls /Applications 2>/dev/null | grep -iq "$software_name"; then
    echo "${COLOR_WARNING}$software_name is installed, but not via Homebrew.${COLOR_RESET}"
    return 0
  fi

  return 1
}
