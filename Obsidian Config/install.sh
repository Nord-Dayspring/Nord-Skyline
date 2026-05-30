#!/usr/bin/env bash

## Predifine the special text style.
ERROR=$(tput setaf 1 2>/dev/null)
WARNING=$(tput setaf 3 2>/dev/null)
SUCCESS=$(tput setaf 2 2>/dev/null)
RESET=$(tput sgr0 2>/dev/null)

## Verify the scripts environment.
# Check whether Obsidian CLI has been installed.
if ! command -v obsidian &>/dev/null; then
  echo "${ERROR}Error: You have not installed Obsidian CLI yet.${RESET}"
  echo "Please toggle 'Command Line Interface' on in Obsidian settings."
fi

# Make sure obsidian is running.
if ! obsidian version &>/dev/null; then
  echo "${ERROR}Error: Obsidian is not running.${RESET}"
  echo "Please open the repository in Obsidian and try again."
fi

## Execute Obsidian CLI commands to install Obsidian themes.
# Execute command to install themes.
echo "Install themes: Baseline, Underwater and Velocity..."
obsidian theme:install name="Baseline" enable
obsidian theme:install name="Underwater"
obsidian theme:install name="Velocity"

## Ask for toggle restricted mode off, then install Obsidian plugins.
# Ask user whether to toggle restricted mode off. Exit if not.
read -r \
  -p "${WARNING}Toggle restricted mode off to enable third party plugins? [y/N]${RESET}" \
  INSTALL_PLUGINS
case "$INSTALL_PLUGINS" in
[yY])
  obsidian plugins:restrict off
  ;;
*)
  echo "${SUCCESS}Finish installing Obsidian themes.${RESET}"
  exit 0
  ;;
esac

# Execute command to install necessary plugins and toggle on.
echo "Install and enable plugins: Hider, Style Settings and Easy Typing..."
obsidian plugin:install id="obsidian-hider" enable
obsidian plugin:install id="obsidian-style-settings" enable
obsidian plugin:install id="easy-typing-obsidian" enable

# Execute command to install suggested plugins.
echo "Install plugins: Animated Cursor, Advanced URI, Latex Suite and CJK Word Splitting..."
obsidian plugin:install id="animated-cursor"
obsidian plugin:install id="cm-chs-patch"
obsidian plugin:install id="obsidian-advanced-uri"
obsidian plugin:install id="obsidian-latex-suite"

# Exit
echo "${SUCCESS}Finish installing Obsidian themes and third-party plugins.${RESET}"
exit 0
