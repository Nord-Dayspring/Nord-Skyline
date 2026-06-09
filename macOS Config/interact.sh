#!/usr/bin/env zsh

source "$(dirname "$0")/config.sh"

# Provide the name of software and website links for detail information access.
confirm_install() {
  local software_name="$1"
  local detail_link="$2"

  clear
  echo "Get ready to install $software_name."
  echo "Visit $detail_link for detail information."
  read -r -p "${COLOR_WARNING}Install $software_name? [Y/n]${COLOR_RESET}" choice

  case "$choice" in
  [yY] | [yY][eE][sS]) return 0 ;;
  [nN] | *) return 1 ;;
  esac
}

# Provide the name of application in shell to check whether the app has been installed.
check_install() {
  local software_name="$1"

  if brew list "$software_name" &>/dev/null; then
    echo "${COLOR_SUCCESS}$software_name has already been installed.${COLOR_RESET}"
    return 0
  fi

  if $(command -v "$software_name" 2>/dev/null) || ls /Applications 2>/dev/null | grep -iq "$software_name"; then
    echo "${COLOR_WARNING}$software_name is installed, but not via Homebrew.${COLOR_RESET}"
    return 0
  fi

  return 1
}
