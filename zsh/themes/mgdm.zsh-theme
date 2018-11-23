if [ "$(whoami)" = "root" ]
then CARETCOLOR="red"
else CARETCOLOR="white"
fi

host_color=0
local i=1
for val in $(echo $HOST | od -A n -t dC); do
	host_color=$(($host_color + $i * $val))
	i=$((i + 1))
done
host_color=$((1 + $host_color % 7))

GREEN="%{$fg_bold[green]%}"
YELLOW="%{$terminfo[bold]$FG[226]%}"
CYAN="%{$fg_bold[cyan]%}"
RED="%{$fg_bold[red]%}"
RESET="%{$reset_color%}"
MAGENTA="%{$fg_bold[magenta]%}"
WHITE="%{$fg_bold[white]%}"
BLUE="%{$fg_bold[blue]%}"
TIME="%F{green}%D{%L:%M} %F{yellow}%D{%p}%f"

function seperate {
	echo '%{%F{white}%} :: '
}

function battery_charge {
  echo `~/bin/batcharge.py`
}

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}@%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

ZSH_THEME_GIT_PROMPT_PREFIX="%{${fg[yellow]}%}git:%{${fg_bold[cyan]}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{${fg[yellow]}%}%{${reset_color}%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{${fg_no_bold[red]}%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒ "
ZSH_THEME_GIT_PROMPT_CLEAN=" %{${fg_no_bold[green]}%}✔%{${reset_color}%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}✓ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}△ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➜ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%}▲ "

ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[white]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"

ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg[blue]%}svn:%{$fg_bold[cyan]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$fg[blue]%}%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY=" %{$fg_no_bold[red]%}✗%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN=" %{$fg_no_bold[green]%}✔%{$reset_color%}"

ZSH_THEME_STV_APP_PREFIX="%{$fg[blue]%}stv:%{$fg[yellow]%}"
ZSH_THEME_STV_APP_SUFFIX="%{$reset_color%}"

# NVM info
local nvm_info='$(nvm_prompt_info)'
ZSH_THEME_NVM_PROMPT_PREFIX="%{${fg[green]}%}⬢ "
ZSH_THEME_NVM_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[blue]%}ve:‹%{$fg_bold[cyan]%}"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$fg[blue]%}›%{$reset_color%}"

ZSH_THEME_VIRTUAL_ENV_WARNING_PREFIX="%{$fg[blue]%}ve:‹%{$fg_bold[red]%}"
ZSH_THEME_VIRTUAL_ENV_WARNING_SUFFIX="%{$fg[blue]%}›%{$reset_color%}"

cmd_time="%F{green}%D{%L:%M} %F{yellow}%D{%p}%f"
MODE_INDICATOR="%{$fg_bold[magenta]%}<%{$reset_color%}%{$fg[magenta]%}<<%{$reset_color%}"

# TODO use 265 colors
#MODE_INDICATOR="$FX[bold]$FG[020]<$FX[no_bold]%{$fg[blue]%}<<%{$reset_color%}"
# TODO use two lines if git

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
# '%(?..${red}%? ⏎  ) '

PROMPT='$FG[237]------------------------------------------------------------%{$reset_color%}
${cmd_time} \
$(seperate)\
%{$(nvm_prompt_info)%} \
$(seperate)\
%{${fg[white]}%}%1~%{$reset_color%}
$(battery_charge) \
%{$terminfo[bold]$fg[white]%}$%{$reset_color%} '

RPS1='${return_code} $(stv_prompt) $(git_prompt_info)'