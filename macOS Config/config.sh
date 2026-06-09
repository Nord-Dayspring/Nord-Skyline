#!/usr/bin/env zsh

SLEEP_SECONDS_BEFORE_CLEAR=0.5

# Load the color variables of zsh. Fallback to "tput" if cannot detect.
#
# fg support black, red, green, yellow, blue, magenta, cyan and white.
# tput support above colors by value 0-7, while 8 for not used and 9 for default.
#
# Visit https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
#   and https://www.linuxcommand.org/lc3_adv_tput.php for more information.

if autoload -Uz colors 2>/dev/null && colors; then
  COLOR_ERROR=$fg[red]
  COLOR_WARNING=$fg[yellow]
  COLOR_SUCCESS=$fg[green]
  COLOR_RESET=$reset_color
else
  COLOR_ERROR=$(tput setaf 1 2>/dev/null)
  COLOR_WARNING=$(tput setaf 3 2>/dev/null)
  COLOR_SUCCESS=$(tput setaf 2 2>/dev/null)
  COLOR_RESET=$(tput sgr0 2>/dev/null)
fi
