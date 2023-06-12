if status is-interactive
    # Commands to run in interactive sessions can go here
    clear
    neofetch --config /home/minhnbnt/.config/neofetch/configfish.conf | sed '/^$/d'
end

set fish_greeting
set -g fish_autosuggestion_enabled 1
set -g cmdcount 1

function preexec --on-event fish_preexec
    set cmdcount (math $cmdcount + 1)
end

function fish_prompt
    # save last command status
    set -l last_status $status

    set_color cyan; printf "┌─[";

    # print number of commands executed
    set_color --bold brwhite;
    printf "%u" $cmdcount;

    # return normal font style
    set_color normal;

    # if last command returns error code, print error code
    if test $last_status -ne 0
        set_color cyan; printf "][";
        set_color --bold brred; printf "%s" $last_status;
    end
    set_color normal; set_color cyan; printf "]─[";

    # print current user
    if fish_is_root_user
        set_color --bold bryellow;
    else # normal user
        set_color --bold brgreen;
    end; printf "%s" $USER;
    set_color brblack; printf "@";

    # print hostname
    set_color brblue; printf "%s" $hostname;
    set_color normal; set_color cyan; printf "]─[";

    # print current directory
    set_color brmagenta;
    printf "%s" (prompt_pwd);

    # print current git branch
    set -l git_prompt (fish_git_prompt "%s")
    if test (string length --visible $git_prompt)
        set_color cyan; printf "][";
        set_color f05033; printf "";
        set_color white; printf " %s" $git_prompt;
    end
    set_color cyan; printf "]\n└╼";
    set_color normal; printf " ";

    # print # if root, $ if normal user
    set_color --bold brcyan;
    if fish_is_root_user
        printf "#";
    else # normal user
        printf '$';
    end
    set_color normal; printf " ";
end
