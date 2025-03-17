# /etc/bashrc

# System wide functions and aliases
# Environment stuff goes in /etc/profile

# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

# are we an interactive shell?
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*|vte*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      elif [ "${VTE_VERSION:-0}" -ge 3405 ]; then
          PROMPT_COMMAND="__vte_prompt_command"
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    screen*)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
      ;;
    esac
  fi
  # Turn on parallel history
  shopt -s histappend
  history -a
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi

if ! shopt -q login_shell ; then # We're not a login shell
    # Need to redefine pathmunge, it get's undefined at the end of /etc/profile
    pathmunge () {
        case ":${PATH}:" in
            *:"$1":*)
                ;;
            *)
                if [ "$2" = "after" ] ; then
                    PATH=$PATH:$1
                else
                    PATH=$1:$PATH
                fi
        esac
    }

    # By default, we want umask to get set. This sets it for non-login shell.
    # Current threshold for system reserved uid/gids is 200
    # You could check uidgid reservation validity in
    # /usr/share/doc/setup-*/uidgid file
    if [ $UID -gt 199 ] && [ "`/usr/bin/id -gn`" = "`/usr/bin/id -un`" ]; then
       umask 077
    else
       umask 077
    fi

    SHELL=/bin/bash
    # Only display echos from profile.d scripts if we are no login shell
    # and interactive - otherwise just process them to set envvars
    for i in /etc/profile.d/*.sh; do
        if [ -r "$i" ]; then
            if [ "$PS1" ]; then
                . "$i"
            else
                . "$i" >/dev/null
            fi
        fi
    done

    unset i
    unset -f pathmunge
fi
# vim:ts=4:sw=4
export TMOUT=600
export TMOUT=600

unalias export 2>/dev/null

if [[ "$USER" != "root" && "$USER" != "devops" ]]; then
   alias export='echo "export command is not allowed."'
   alias scp='echo "scp command is not allowed."'
   alias rsync='echo "rsync command is not allowed."'
   alias aws='echo "aws command is not allowed."'
   alias whereis='echo "whereis command is not allowed."'
   alias which='echo "which command is not allowed."'
   alias printenv='echo "printenv command is not allowed."'
   alias env='echo "env command is not allowed."'
   alias set='echo "set command is not allowed."'
   export PATH=/usr/local/src:$PATH

   alias find='function _find() {
      if [[ "$@" =~ "git" ]] || [[ "$@" =~ "docker" ]]; then
        echo "You are not allowed to search the files.";
      else
        /usr/bin/find "$@";
      fi;
   }; _find'

   alias locate='function _locate() {
      if [[ "$@" =~ "git" ]] || [[ "$@" =~ "docker" ]]; then
        echo "You are not allowed to search the files.";
      else
        /usr/bin/locate "$@";
      fi;
   }; _locate'

fi

# Block git push command
function git() {
    if [[ "$1" == "push" ]]; then
        echo "git push is disabled in this shell session."
        return 1
    else
        command git "$@"
    fi
}

#Block Docker push command
#function docker() {
#    if [[ "$1" == "push" ]]; then
#        echo "docker push is disabled in this shell session."
#        return 1
#    else
#        command docker "$@"
#    fi
#}


if [[ $EUID -ne 0 ]]; then
  function echo() {
    if [[ "$1" == "$PATH" ]]; then
      /usr/bin/echo "Access to PATH variable is restricted."
    else
      /usr/bin/echo "$@"
    fi
  }
fi



#mv /usr/local/src/docker /usr/bin/docker
#source /etc/bashrc