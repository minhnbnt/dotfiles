#
# ~/.bashrc
#
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything

[[ $- != *i* ]] && return

# Some of my custom command

alias vi="nvim"
alias ls='ls -vA --color --group-directories-first'

#export GTK_IM_MODULE=ibus
#export QT_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
# Dành cho những phần mềm dựa trên qt4
#export QT4_IM_MODULE=ibus
# Dành cho những phần mềm dùng thư viện đồ họa clutter/OpenGL
#export CLUTTER_IM_MODULE=ibus
#export GLFW_IM_MODULE=ibus
#ibus-daemon -drx

# Define some basic colors using tput (8-bit color: 256 colors)

yellow="\[$(tput setaf 11)\]"
bright_red="\[$(tput setaf 9)\]"
pink="\[$(tput setaf 13)\]"
orange="\[$(tput setaf 172)\]"
blue="\[$(tput setaf 12)\]"
cyan="\[$(tput setaf 14)\]"
drk_cyan="\[$(tput setaf 6)\]"
light_blue="\[$(tput setaf 80)\]"
drk_gray="\[$(tput setaf 8)\]"
light_gray="\[$(tput setaf 7)\]"
white="\[$(tput setaf 15)\]"
green="\[$(tput setaf 10)\]"
bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

# Define basic colors to be used in prompt
## The color for username (light_blue, for root user: bright_red)
username_color="${reset}${bold}${green}\$([[ \${EUID} == 0 ]] && echo \"${yellow}\")";
## Color of @ and ✗ symbols (orange)
at_color=$reset$bold$drk_gray
## Color of host/pc-name (blue)
host_color=$reset$bold$blue
## Color of current working directory (light_purple)
directory_color=$reset$pink
## Color for other characters (like the arrow)
etc_color=$reset$drk_cyan
# If last operation did not succeded, add [exit code]- to the prompt
on_error='$(code=${?##0};echo ${code:+$(tput setaf 6)[$(tput bold)$(tput setaf 9)${code}$(tput sgr0)$(tput setaf 6)]})'
# The last symbol in prompt ($, for root user: #)
symbol="${reset}${bold}${cyan}$(if [[ ${EUID} == 0 ]]; then echo '#'; else echo '$'; fi)"
# Color of command number
cmd_num="${white}${bold}"

# Setup the prompt/prefix for linux terminal
PS1="${etc_color}┌─[${cmd_num}\#";
PS1+="${etc_color}]";
PS1+="${on_error}";
PS1+="${etc_color}─[";
if [[ -f /data/data/com.termux/files/usr/bin/termux-info ]]; then
	PS1+="${username_color}minhnbnt";
	PS1+="${at_color}@";
	PS1+="${host_color}A03s"
else
	PS1+="${username_color}\u";        # \u=Username
	PS1+="${at_color}@";
	PS1+="${host_color}\h"             # \h=Host
fi
PS1+="${etc_color}]─[";
PS1+="${directory_color}\w";       # \w=Working directory
PS1+="${etc_color}]\n"             # \n=New Line
PS1+="${etc_color}└╼";
PS1+="${reset} ${symbol}${reset} ";

export PS1
#PS0="\n"
