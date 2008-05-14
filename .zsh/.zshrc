#!/bin/zsh
#####################################################################
#
# zshrc
#
#####################################################################

#####################################################################
### Aliases and environment
#####################################################################

## Gentoo
[ -e /etc/profile.env ] && source /etc/profile.env

## Debian
[ -e /etc/profile ] && [[ $HOST != mother* ]] && source /etc/profile

#for f in /etc/profile.d/*.sh ; do
#    [ -x "$f" ] && source "$f"
#done

umask 0027

## Aliases common to all shells
[ -f ~/.aliasrc ] && . ~/.aliasrc

## zsh=specific aliases
alias -g L='|less'
alias -g shh='&> /dev/null '
alias lsd='ls -ld *(-/DN)'
alias histcount='history -i 1 | awk "{a[\$2]++} END {for(date in a) print date, a[date]}" | sort -nk2'
functions -u help-zshglob

[[ -r ~/.envrc ]] && . ~/.envrc
[[ -d ~/.zsh_functions.d ]] && fpath=(~/.zsh_functions.d $fpath)
[[ -d ~/.zsh/functions ]] && for dir in ~/.zsh/functions/*(/); do nfpath+=($dir); done
fpath=($nfpath $fpath)

## Colorize stderr
# http://gentoo-wiki.com/TIP_Advanced_zsh_Completion 
#exec 2>>(while read line; do
#    print '\e[91m'${(q)line}'\e[0m' > /dev/tty; 
#done &)

## Only unique entries
typeset -U path

#####################################################################
### Completion
#####################################################################

zmodload -i zsh/complist
autoload -Uz compinit
compinit -C

### http://zshwiki.org/home/examples/compquickstart
# If you want zsh's completion to pick up new commands in $path automatically
# comment out the next line and un-comment the following 5 lines
zstyle ':completion:::::' completer _complete _approximate
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1 # Because we didn't really complete anything
}
zstyle ':completion:::::' completer _force_rehash _complete _approximate

zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

## Always use menu selection
## select=<N>
zstyle ':completion:*' menu select

zstyle ':completion:*' verbose yes

### $hosts completion
## /usr/share/doc/zsh/examples/ssh_completion.gz
## Including IP addresses
hosts=(${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*})
## Excluding IP addresses
# hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*})
## For every command accepting hosts
zstyle ':completion:*:hosts' hosts $hosts
## Only for SSH
zstyle ':completion:*:complete:ssh:*:hosts' hosts $hosts

### http://ft.bewatermyfriend.org/
## manual pages are sorted into sections
zstyle ':completion:*:manuals'              separate-sections true
zstyle ':completion:*:manuals.(^1*)'        insert-sections   true

## Tolerate errors
zstyle -e ':completion:*:approximate:*'     max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'

## functions starting with '_' are completion functions by convention
## these are not supposed to be called by hand. no completion needed.
zstyle ':completion:*:(functions|parameters|association-keys)' \
                                                            ignored-patterns '_*'
## normally I don't want to complete *.o and *~, so, I'll ignore them
## update: these patterns are not ignored for rm, since i might want to delete those files
zstyle ':completion:*:*:(^rm):*:*files'                 ignored-patterns '*?.o' '*?\~'

## vi(m) can ignore even more files
zstyle ':completion:*:*:(^rm):*:*files'                 ignored-patterns '*?.o' '*?\~'

## vi(m) can ignore even more files
zstyle ':completion::*:(vi|vim):*'                      ignored-patterns '*?.(lo|so|la|o)'

## enable verbose completion; descriptions like: '-a  -- list entries starting with .'
zstyle ':completion:*'                                  verbose yes

## if i have 'rm file0' on the commandline
## i don't need "file0" in possible completions
zstyle ':completion:*:(rm|kill):*'                      ignore-line yes

## $hosts for <tab> completing hostnames
zstyle ':completion:*:(nc|ping|ssh|nmap|*ftp|telnet|finger):*' \
                                                            hosts $hosts

## i like kill <tab>, but i want more processes...
zstyle ':completion:*:processes'                        command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:*:kill:*:processes'               sort false
zstyle ':completion:*:processes-names'                  command 'ps c -u ${USER} -o command | uniq'

### Random stuff
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle :compinstall filename '/home/redondos/.zshrc'

if [[ $HOSTNAME == refinery* ]]; then
    zstyle ':completion:*:urls' local aolivera.com.ar /var/www/aolivera.com.ar/htdocs
    zstyle ':completion:*:urls' local twat.com.ar ~/public_html
fi
## In case AUTO_CD is not enabled
# compctl -/ cd

## Aptitude 4.6 includes many aptitude-* commands that we don't want to be completed.
# zstyle ':completion:*:complete:-command-::commands'       ignored-patterns 'aptitude-*'
# zstyle ':completion:::::'                                 completer _complete _ignored _approximate

## Enable/disable globdots for completion
# _comp_options=(${_comp_options//*globdots/} noglobdots)
# _comp_options=(${_comp_options//*globdots/} globdots)

## Different separator
zstyle ':completion:*' list-separator --\>

## kill
# http://madism.org/~madcoder/dotfiles/zsh/40_completion
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,time,cmd|grep -v "ps -au$USER -o pid,time,cmd"'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'

#####################################################################
### compinstall
#####################################################################
# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
#
# # The function will not be run in future, but you can run
# it yourself as follows:
#   autoload zsh-newuser-install
#     zsh-newuser-install -f
#

#####################################################################
### Zle
#####################################################################

## zkbd helps defining human-friendly keymap names by sourcing a properly named
## file from ~/.zsh/zkbd

## A file is created by calling zkbd if there doesn't exist one for the current
##triple: $TERM-$VENDOR-$OSTYPE

autoload zkbd && [[ ! -f ~/.zsh/zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd
[[ -f ~/.zsh/zkbd/$TERM-$VENDOR-$OSTYPE ]] && source ~/.zsh/zkbd/$TERM-$VENDOR-$OSTYPE || source ~/.zsh/zkbd/xterm-$VENDOR-$OSTYPE

## Emacs mode
bindkey -e

## Old style keybindings, now aliases are used via zkbd
# bindkey '\e[1~' beginning-of-line
# bindkey '\e[2~' overwrite-mode
# bindkey '\e[3~' delete-char
# bindkey '\e[4~' end-of-line
# bindkey '\e[5~' history-search-backward
# bindkey '\e[6~' history-search-forward
# case $TERM in (xterm*)
#     bindkey '\e[H'  beginning-of-line
#     bindkey '\e[F'  end-of-line;;
# esa

## Teh bindings.
[[ -n ${key[Home]}      ]]  &&  bindkey "${key[Home]}"      beginning-of-line
[[ -n ${key[Insert]}    ]]  &&  bindkey "${key[Insert]}"    overwrite-mode
[[ -n ${key[Delete]}    ]]  &&  bindkey "${key[Delete]}"    delete-char
[[ -n ${key[End]}       ]]  &&  bindkey "${key[End]}"       end-of-line
[[ -n ${key[PageUp]}    ]]  &&  bindkey "${key[PageUp]}"    history-search-backward
[[ -n ${key[PageDown]}  ]]  &&  bindkey "${key[PageDown]}"  history-search-forward
[[ -n ${key[Up]}        ]]  &&  bindkey "${key[Up]}"        up-line-or-history
[[ -n ${key[Down]}      ]]  &&  bindkey "${key[Down]}"      down-line-or-history
[[ -n ${key[Left]}      ]]  &&  bindkey "${key[Left]}"      backward-char
[[ -n ${key[Right]}     ]]  &&  bindkey "${key[Right]}"     forward-char

## Kill that line
bindkey '^u'    backward-kill-line

## Kill that word
bindkey '^\\' backward-kill-word

## Turn prediction on/off
if autoload predict-on ; then
    zle -N predict-on
    zle -N predict-off
    bindkey '^X^T^N' predict-on
    bindkey '^X^T^F' predict-off
fi

## ctrl-x, f inserts the latest modified file the the command line
bindkey -s '^xf' '*(.om[1])\t'

## exec_on_xclip, by ft
## http://bewatermyfriend.org/posts/2007/05-17.17-57-48-computer.html
if whence xclip &>/dev/null; then
    if autoload exec_on_xclip; then
        zle -N exec_on_xclip
        bindkey '^xb'   exec_on_xclip
        bindkey '^x^b'  exec_on_xclip
        zstyle ':exec_on_xclip:*'             contexts                      \
                                                  "0:uri_http"  'http://*'  \
                                                  "1:file_gz"   '(/|~)*.gz' \
                                                  "2:file"      '(/|~)*'

        zstyle ':exec_on_xclip:*'             stages '0:nox' '1:x11'
        zstyle ':exec_on_xclip:*'             xclip "xclip"
        zstyle ':exec_on_xclip:*'             options "-o"
        zstyle ':exec_on_xclip:*'             pager "less -Mr"
        zstyle ':exec_on_xclip:x11:*'         operate false
        zstyle ':exec_on_xclip:nox:*'         clearterm true
        if   [[ -x $(which opera) ]] ; then
            zstyle ':exec_on_xclip:x11:uri_http'  app 'opera -remote openURL(_eoxc_)'
        elif [[ -x $(which firefox) ]] ; then
            zstyle ':exec_on_xclip:x11:uri_http'  app 'firefox -new-tab _eoxc_'
        else
            zstyle ':exec_on_xclip:x11:uri_http'  app false
        fi
        zstyle ':exec_on_xclip:*:uri_http'    app "${BROWSER:-w3m} _eoxc_"
        zstyle ':exec_on_xclip:*:file_gz'     app "zless _eoxc_"
        zstyle ':exec_on_xclip:*:file'        app "less _eoxc_"

    fi
fi

## expand-or-complete-with-dots
## Ian Langworth, 13.Jun.07 17:53
## <b6c719b90706131353l3c12764eg893b3ff39294dcde@mail.gmail.com>
# autoload expand-or-complete-with-dots
# zle -N expand-or-complete-with-dots
# bindkey "^I" expand-or-complete-with-dots
# Also show what completer is being tried.
zstyle ":completion:*" show-completer true

## Redo
bindkey '^xr' 'redo'
bindkey '^x^r' 'redo'

## Search in history for lines that are exactly the same from the start up to
## the cursor position.
bindkey '^xp' history-beginning-search-backward
bindkey '^xn' history-beginning-search-forward

## vi-${direction}-word
# bindkey '\eB' vi-backward-word
# bindkey '\eF' vi-forward-word

## Better handling of multi-line commands than push-line, especially in the
## buffer stack
bindkey '\eq' push-line-or-edit

## Function that performs commands similar to the way readline does
## That is, removing some characters from $WORDCHARS
readline-command() {
    typeset WORDCHARS=${WORDCHARS//[\/.:;-@#]}
    zle ${WIDGET#readline-}
}

## readline-kill-word
zle -N readline-kill-word readline-command
bindkey '\ed' readline-kill-word
bindkey '\eD' kill-word

## readline-backward-kill-word
zle -N readline-backward-kill-word readline-command
bindkey '\ew' readline-backward-kill-word
bindkey '^w' readline-backward-kill-word
bindkey '\eW' backward-kill-word

## readline-forward-word
zle -N readline-forward-word readline-command
bindkey '\ef' readline-forward-word
bindkey '\eF' forward-word

## readline-backward-word
zle -N readline-backward-word readline-command
bindkey '\eb' readline-backward-word
bindkey '\eB' backward-word

## Enter directories in menu selection, from zshguide.
bindkey -M menuselect '^o' accept-and-infer-next-history

## Easier to navigate menus
accept-and-execute-line() { zle accept-line ; zle accept-line }
zle -N accept-and-execute-line
# bindkey -M menuselect '^M' accept-and-execute-line

## Completion help
bindkey '^xh' _complete_help

## Manual completion calls
bindkey '^X^R' _read_comp

## delete-word-alnum
delete-word-alnum() { 
    typeset WORDCHARS=
    zle delete-word
}
zle -N delete-word-alnum
# bindkey "\ed" delete-word-alnum

## copy-prev-word
## default is \e^_ (ctrl+alt+shift+-)
bindkey '\e=' copy-prev-word

## zsticky
## Bart Schaefer, <080113000048.ZM15017@torch.brasslantern.com>
autoload -U zsticky

## Fast directory navigation
# http://blog.orebokech.com/2008/03/fast-directory-navigation.html
function up-one-dir { set -E; pushd ..; set +E; zle redisplay; zle -M `pwd` }
function back-one-dir { set -E; popd; set +E; zle redisplay; zle -M `pwd` }
zle -N up-one-dir
zle -N back-one-dir
bindkey "^[-" up-one-dir
bindkey "^[=" back-one-dir

## expand-dot
# http://rusmafia.org/linux/zsh-parent-dir-expand
# it messes up incremental completion
# autoload -U expand-dot
# zle -N expand-dot
# bindkey . expand-dot

## narrow-to-region wrapper
# Mikael Magnusson <mikachu@gmail.com>
# <237967ef0804021119l400b2305sbc9e5391a380e616@mail.gmail.com>

zle -N _narrow_to_region_marked
bindkey "^X^I"    _narrow_to_region_marked
autoload -U narrow-to-region
function _narrow_to_region_marked()
{
  local right
  local left
  if ((MARK == 0)); then
    zle set-mark-command
  fi
  if ((MARK < CURSOR)); then
    left="$LBUFFER[0,$((MARK-CURSOR-1))]"
    right="$RBUFFER"
  else
    left="$LBUFFER"
    right="$BUFFER[$((MARK+1)),-1]"
  fi
  narrow-to-region -p "$left>>|" -P "|<<$right"
}

### some scripts from either of these three (who copied from who?)
# http://wael.nasreddine.com/cgi-bin/viewvc.cgi/wael/trunk/etc/.zsh/zle?revision=628&view=markup&sortby=author
# http://hg.codemac.net/config/
# git://github.com/gigamo/config.git
## bracket_automatcher
bracket_automatcher() {
    zle self-insert
    zle vi-backward-char
    zle vi-match-bracket
    zle -R
    sleep 0.2
    zle vi-match-bracket
    zle forward-char
}
zle -N bracket_automatcher
bindkey ']' bracket_automatcher
bindkey '}' bracket_automatcher
bindkey ')' bracket_automatcher
#
## clear-bottom
clear-screen-bottom () {
    echo -n "\033[2J\033[400H"
    builtin zle .redisplay
}
zle -N clear-screen-bottom
bindkey "^L" clear-screen-bottom

## expand-or-complete-prefix is much cooler
bindkey '^I' expand-or-complete-prefix

## Cycle in reverse with meta-tab
bindkey '\e^I' reverse-menu-complete

## ctrl-o to browse directory hierarchies
bindkey  -M  menuselect  '^o'  accept-and-infer-next-history

## _email_addresses from lbdbq
autoload -U _email-lbdbq
#####################################################################
### Prompt and terminal title
#####################################################################

## This is a modified version of the 'gentoo' prompt
## It also has a right prompt that displays alternating time/date, as
## well as the exit code of the previous command if it wasn't 0 and history
## event numbers every 10 items.

## This is also where the terminal/screen title are set.

autoload -U promptinit
promptinit

# Clear xterm title, not really needed but handy for testing the escape codes
# under different terminals.
# echo -ne '\e]0\a'

###
# PROMPT

# [[ $HOSTNAME = refinery* ]] && prompt gentoo || source ~/.zsh/prompt-$HOSTNAME
source ~/.zsh/functions/Prompts/gentoo

###
# RPROMPT

# Enabled by default
RPROMPT_ENABLED=1
# Alternate between these expressions and append to the end of RPROMPT
RPROMPT_DATETIME=('%D{%T}' ' %D{%b %d} ')
RPROMPT_DATETIME=("$RPROMPT_DATETIME[1]" "$RPROMPT_DATETIME[@]")
# Color codes appended to the array by using ^ (RC_EXPAND_PARAM)
RPROMPT_DATETIME=(\[%{${fg[yellow]}%}${^RPROMPT_DATETIME}%{${fg[default]}%}\])
# Exit code if != 0
RPROMPT_EXITCODE="%(?..%{${fg[red]}%}(%?%)%{${fg[default]}%} )"
# Path
# this is too damn long!
# RPROMPT_PATH="%{${fg[cyan]}%}%/%{${fg[default]}%} "

function title {
    if [[ $TERM == screen* ]]; then
        # Use these two for GNU Screen:
        print -nR $'\ek'$1$'\e'"\\"
        shift
#       print -nR $'\e]0;'$*$'\a'
        print -nR $'\e_screen \005 | '$*$'\e'"\\"
    elif [[ $TERM == "xterm" || $TERM == rxvt* ]]; then
        # Use this one instead for XTerms:
        shift
        print -nR $'\e]0;'$@$'\a'
    fi
}
  
function precmd {
  title zsh "$PWD"
}
  
###
# precmd()

precmd() {
    ###
    # Terminal and screen title
    local termtitle RPROMPT_HISTEVENT GIT_BRANCH

    ## Changing IFS breaks a few things otherwise, especially clear-zle-screen
    IFS=$' \t\n'

    # termtitle=$(print -P "%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y")
    termtitle=$(print -P "%n@%m:%~ | ${COLUMNS}x${LINES} | %y")
    title zsh "$termtitle"
#    print "***********************************************"
 
    ###
    # RPROMPT
    if [[ -n $RPROMPT_ENABLED ]]; then
        # Alternate between these expressions and append to the end of RPROMPT
        for ((i=2; i<= ${#RPROMPT_DATETIME}; i++)); do
            if [[ $RPROMPT_DATETIME[i] == $RPROMPT_DATETIME[1] ]]; then
                if [[ -n $RPROMPT_DATETIME[((i+1))] ]]; then
                    RPROMPT_DATETIME[1]=$RPROMPT_DATETIME[((i+1))]
                else
                    RPROMPT_DATETIME[1]=$RPROMPT_DATETIME[2]
                fi
                break
            fi
        done

        # Display history event number every 10 commands.
        # it got boring after a while../.
        # if (($(print -P ${:-%\!})%10==0)); then
        #     RPROMPT_HISTEVENT="[%{${fg[blue]}%}%!%{${fg[default]}%}] "
        # else
        #     unset RPROMPT_HISTEVENT
        # fi

        if [[ -d .git ]]; then
            GIT_BRANCH="%{${fg[green]}%}{${$(git-symbolic-ref HEAD 2>/dev/null)#refs/heads/}}%{${fg[default]}%} "
        fi

        RPROMPT="${GIT_BRANCH}${RPROMPT_HISTEVENT}${RPROMPT_EXITCODE}${RPROMPT_PATH}${RPROMPT_DATETIME[1]}"
    fi

    ## Show running jobs
    [[ -o interactive && -z $NRJ ]] && jobs -l;
    
}

[ -e ~/.zsh/prompt-madduck ] && . ~/.zsh/prompt-madduck
###
# preexec()

preexec() {
## Deprecated
    local escape_seq
    escape_seq="("$'\a|\b|\e|\f|\n|\r|\t|\v'"|\\a|\\b|\\c|\\e|\\f|\\n|\\r|\\t|\\v)"
    case "$TERM" in
        screen*)
            ## screen title
            local CMD=${1[(wr)^(*=*|sudo|time|fg|nice|-*)]}
            echo -ne "\ek$CMD\e\\"
            ## Terminal title
            # Reminder: the correct escape sequence inside screen is '\e_$string\e\'
            # When using the traditional '\e$string\a', garbage is printed
            # before the prompt.
            print -Pn "\e_screen \005 | %(!.-=*[ROOT]*=- | .)%n@%m: ${1//${~escape_seq}/·} \e\\"
    ;;
        ^(dumb|linux))
            # Escape sequences *must* be removed, otherwise print will interpret them and they
            # will go to the terminal, not to its titlebar.
            print -Pn "\e]0;%(!.-=*[ROOT]*=- | .)%n@%m: ${1//${~escape_seq}/·}\a"
        ;;
    esac
}

function preexec {
## Deprecated
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title $cmd[1]:t "$cmd[2,-1]"
}

preexec() {
    # With bits from http://zshwiki.org/home/examples/hardstatus
    # emulate -L zsh
    local -a cmd; cmd=(${(z)1})           # Re-parse the command line
    local termtitle

    # Prepend this string to the title.
    # termtitle=$(print -P "%(!.-=*[ROOT]*=- | .)%n@%m:")
    termtitle=$(print -P "%n@%m:")

    case $cmd[1] in
        fg)
            if (( $#cmd == 1 )); then
                # No arguments, must find the current job
                # Old approach: cmd=(builtin jobs -l %+)
                #   weakness: shows a load of bs
                title ${jobtexts[${(k)jobstates[(R)*+*]}]%% *} "$termtitle ${jobtexts[${(k)jobstates[(R)*+*]}]}"
            else
                # Replace the command name, ignore extra args.
                # Old approach: cmd=(builtin jobs -l ${(Q)cmd[2]})
                #     weakness: shows all matching jobs on the title, not just one
                title "${jobtexts[${cmd[2]#%}]%% *}" "$termtitle $jobtexts[${cmd[2]#%}]"
            fi
            ;;
        %*) title "${jobtexts[${cmd[1]#%}]% *}" "$termtitle $jobtexts[${cmd[1]#%}]"
            ;;
        exec|sudo) shift cmd
            # If the command is 'exec', drop that, because
            # we'd rather just see the command that is being
            # exec'd. Note the ;& to fall through the next entry.
            ;& 
        *=*) shift cmd;&
        *)  title $cmd[1]:t "$termtitle $cmd[*]"    # Starting a new job.
            ;;
        esac
}

###
# Catch SIGWINCH to re-print COLSxLINES
trap precmd 28

#####################################################################
### Other configuration
#####################################################################

# [ -r ~/bin/lookup ] && . ~/bin/lookup

## Don't let external processes affect the tty. (-u to unfreeze)
ttyctl -f

## zmv
autoload zmv
alias zmv='noglob zmv'
alias mmv='noglob zmv -W'

## nohup-alike function
autoload dehup

## dircolors
# Orange dirs, 2008-04-13, redondos
# Good for xterm
# No good for urxvt, orange not available
# eval $(dircolors =(print "${$(dircolors --print-database)//DIR ?????/DIR 38;5;202}"))

## run-help-sudo
# 2008-14-21, me
# when calling "sudo cmd", run-help will look for a function called run-help-$1
# and use it if available, passing the arguments shifted to the left
run-help-sudo() { man $1; }

#####################################################################
### Parameters
#####################################################################

##---------------------------
## History
##---------------------------

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

##---------------------------
## Other
##---------------------------

## Clear the screen after CLRTMOUT seconds of inactivity
## $fpath/clear-zle-screen
if [[ $ZSH_VERSION == 4.3.<4-> ]]; then
    CLRTMOUT=3600
    autoload clear-zle-screen
    clear-zle-screen
fi

## Bigger stack size
DIRSTACKSIZE=50

## wtmp check interval for WATCH
LOGCHECK=20

## Print $TIMEFMT if command's combined execution time is greater than this value.
REPORTTIME=5

## Report login activity in $WATCHFMT
watch=(notme)

#####################################################################
### Options
#####################################################################

##---------------------------
## Changing Directories
##---------------------------

## Allows typing of directory names to cd into, only when no command matches
setopt AUTO_CD

## Make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

## Expand directory expressions as if they all started with ~
setopt CDABLE_VARS

## Don't push multiple copies of the same  directory
setopt PUSHD_IGNORE_DUPS

##---------------------------
## Completion
##---------------------------

## Switch between possible completions after an additional TAB.
## (default, replaced by MENU_COMPLETE)
# setopt AUTO_MENU

## Append a slash to autocompleted parameters that correspond to directories.
setopt AUTO_PARAM_SLASH

## Remove added space after completing a parameter and then entering a
## character that needs to be inside the parameter, e.g. `:'.
setopt AUTO_PARAM_KEYS

## Remove trailing slashes if they aren't relevant to the command executed.
## (set by default)
unsetopt AUTO_REMOVE_SLASH

## Don't complete aliases using the expanded command.
# setopt COMPLETE_ALIASES

## Complete in middle of a word without considering the full string.
setopt COMPLETE_IN_WORD

## Complete non-ambiguous prefix/suffix first, then display the ambiguities
## after another function call.
setopt LIST_AMBIGUOUS

## Switch between possible completions, immediately.
setopt MENU_COMPLETE
## Don't send SIGHUP to bg jobs when the shell exits
# setopt NO_NOHUP

## Background jobs notify its status immediately
setopt NOTIFY

##---------------------------
## Expansion and Globbing
##---------------------------

## Substitute globs inside variables (like in sh): foo=*; print $foo
# setopt GLOB_SUBST

## `@', `*', `+', `?' and `!' are special in pattern matching
setopt KSH_GLOB

## Non-matching globs as printed as-is
setopt NO_NOMATCH

## Remove non-matching globs from expressions with multiple globs
## This overrides NOMATCH, so I don't like it.
# setopt CSH_NULL_GLOB

## Print blank lines instead of globs/error when no matches are found
# setopt NULL_GLOB

## Allow `#', `~' and `^' to be treated as part of patterns
setopt EXTENDED_GLOB

## Warn when a global variable is created inside a function (override with
## typeset -g)
setopt WARN_CREATE_GLOBAL

##---------------------------
## History
##---------------------------

## Append to history instead of replacing
setopt APPEND_HISTORY

## Append to history in real time
setopt INC_APPEND_HISTORY

## Read from history file in real time
setopt SHARE_HISTORY

## Ignore duplicate history entries
setopt HIST_IGNORE_ALL_DUPS

## Remove useless blanks from history 
setopt HIST_REDUCE_BLANKS

## Add date and duration of each command to history file
setopt EXTENDED_HISTORY

##---------------------------
## Initialisation
##---------------------------

##---------------------------
## Input/Output
##---------------------------

## Don't truncate existing files
setopt NO_CLOBBER

## Correct spelling of commands
setopt CORRECT

## Correct all spelling mistakes
# setopt CORRECT_ALL

## Allow comments even in interactive shells.
setopt INTERACTIVE_COMMENTS

## Allow single quotes inside single quotes: ''
setopt RC_QUOTES

##---------------------------
## Job Control
##---------------------------

## Don't send SIGHUP to bg jobs when the shell exits
# setopt NO_NOHUP

## Background jobs notify its status immediately
setopt NOTIFY

##---------------------------
## Prompting
##---------------------------

## Don't make % special in prompts
# setopt NO_PROMPT_PERCENT

## Expand expressions inside prompts: PS1='${PWD}% '
# setopt PROMPT_SUBST

##---------------------------
## Scripts and Functions
##---------------------------

## All options are local to functions
# setopt LOCAL_OPTIONS

## All traps are local to functions
# setopt LOCAL_TRAPS

##---------------------------
## Shell Emulation
##---------------------------

## CSH-style loops: no "do" is required
# setopt CSH_JUNKIE_LOOPS

## Quotes don't make commands extend on multiple lines. Utterly broken
## behavior.
# setopt CSH_JUNKIE_QUOTES

## Force curly braces in arrays, and start indexing from 0
# setopt KSH_ARRAYS

## Files in $fpath should have function definitions instead of scripts.
## Sometimes this is useful, e.g. when setting variables or performing commands
## that should not be set on each function execution
# setopt KSH_AUTOLOAD

## Expand tilde later in the evaluation, just like ksh/sh do.
## e.g. setopt GLOB_SUBST SH_FILE_EXPANSION
##      foo='~/.zshrc'; print $foo won't expand tilde
# setopt SH_FILE_EXPANSION

## sh/ksh-style short options
# setopt SH_OPTION_LETTERS

## Split words in unquoted vars: foo="foo bar"; command $foo vs. command "$foo"
# setopt SH_WORD_SPLIT

##---------------------------
## Zle
##---------------------------

## Don't beep on errors
setopt NO_BEEP

## Vi/Emacs-style keybindings
# bindkey -v
# setopt VI
# bindkey -e
# setopt EMACS

#####################################################################

# vim:ft=zsh:foldmethod=marker:ts=4:sw=4:expandtab
