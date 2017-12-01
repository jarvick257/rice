# ZSH Theme - Preview: http://cl.ly/350F0F0k1M2y3A2i3p1S
function ssh_user {
        if [[ -z $SSH_CLIENT ]]; then
                echo "λ" 
        else 
                echo %n@%m:
        fi
}

#local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
local ret_status="%(?:%{$reset_color%} :%{$fg_bold[red]%} %{$reset_color%})"
PROMPT='
$(ssh_user) %~/ $(git_prompt_info)%{$reset_color%}
${ret_status}: '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "


