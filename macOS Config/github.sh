source "$(dirname "$0")/config.sh"

setup_github() {
  sleep ${SLEEP_SECONDS_BEFORE_CLEAR} && echo ""
  echo "Do you want to create SSH key for GitHub? [y/N]" && read -r choice
  case "$choice" in
  [nN] | [nN][oO]) return 1 ;;
  [yY] | *) ;;
  esac

  echo "Please enter your Git username: " && read -r username
  echo "Please enter your Git email: " && read -r usermail

  git config --global user.name "${username}"
  git config --global user.email "${usermail}"
  echo "${COLOR_SUCCESS}Git global config updated.${COLOR_RESET}"

  ssh-keygen -t ed25519 -C "${usermail}" -f "$HOME/.ssh/github_ssh"
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain "$HOME/.ssh/github_ssh"
  echo "${COLOR_SUCCESS}SSH key created and added to keychain.${COLOR_RESET}"

  pbcopy <"$HOME/.ssh/github_ssh.pub"
  echo "${COLOR_WARNING}Public key copied to clipboard.${COLOR_RESET}"
  open "https://github.com/settings/ssh/new"

  echo "Press [Enter] after you successfully added the SSH key on GitHub." && read -r
  echo "${COLOR_WARNING}Testing SSH connection to GitHub.${COLOR_RESET}"
  ssh -T git@github.com
  echo "${COLOR_SUCCESS}Successfully setup GitHub SSH access.${COLOR_RESET}"
}
