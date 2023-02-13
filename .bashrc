#
# ~/.bashrc
#
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything

echo ""

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
# If last operation did not succeded, add [✗]- to the prompt
on_error="\$([[ \$? != 0 ]] && echo \"${etc_color}[${bright_red}${bold}X${etc_color}]─\")"
# The last symbol in prompt ($, for root user: #)
symbol="${reset}${bold}${cyan}$(if [[ ${EUID} == 0 ]]; then echo '#'; else echo '$'; fi)"
# Color of command number
cmd_num="${white}${bold}"


# Setup the prompt/prefix for linux terminal
PS1="${etc_color}┌─[${cmd_num}\#";
PS1+="${etc_color}]─";
PS1+="${on_error}";
PS1+="${etc_color}[";
PS1+="${username_color}\u";        # \u=Username
PS1+="${at_color}@";
PS1+="${host_color}\h"             # \h=Host
PS1+="${etc_color}]─[";
PS1+="${directory_color}\w";       # \w=Working directory
PS1+="${etc_color}]\n"             # \n=New Line
PS1+="${etc_color}└╼";
PS1+="${reset} ${symbol}${reset} ";

export PS1
#PS0="\n"

[[ $- != *i* ]] && return

alias ls='ls -a --color --group-directories-first'

# Some of my custom command
# Syntax for no output: alias [custom command]='f(){([command] "$@" > /dev/null 2>&1 &);  unset -f f; }; f'

alias vi="nvim"

# For LucasChess
#if $XDG_SESSION_TYPE = wayland ; then
#    alias lucaschess='echo "Enter sudo password or switch to xorg session."; sudo sh /mnt/e/LucasChessR/linux/run.sh' ;
#else
#    alias lucaschess='sh /mnt/e/LucasChessR/linux/run.sh' ;
#fi

# Old PS1
#PS1='[\u@\h \W]\$ '
#PS1="\[\033[38;5;0m\]\[\033[48;5;208m\]\l:\[$(tput sgr0)\]\[\033[38;5;226m\]\u\[$(tput sgr0)\]\[\033[38;5;248m\]@\[$(tput sgr0)\]\[\033[38;5;81m\]\H\[$(tput sgr0)\]\[\033[38;5;79m\]\w\[$(tput sgr0)\] \\$\[$(tput sgr0)\]"
##PS1='\[\e[0;38;5;232;48;5;49m\]\#\[\e[0;48;5;17m\]: \[\e[0;38;5;220;48;5;17m\]\u\[\e[0;38;5;239;48;5;17m\]@\[\e[0;38;5;39;48;5;17m\]\h\[\e[0;38;5;51;48;5;17m\]\w\[\e[0m\] \$\[$(tput sgr0)\] '
#PS1='\[\e[0;38;5;232;48;5;49m\]\#\[\e[0;48;5;17m\]: \[\e[0;38;5;220;48;5;17m\]\u\[\e[0;38;5;239;48;5;17m\]@\[\e[0;38;5;39;48;5;17m\]\h\[\e[0;38;5;51;48;5;17m\]\w\[\e[0;97m\] >\[\e[0m\]'
