#!/bin/bash
# Check if Docker is installed

if command -v docker >/dev/null 2>&1; then

echo "Docker is installed."
 
docker_bin=$(whereis -b docker | awk '{print $2}')
 
 
# Define destination paths

DEST="/usr/local/src/docker"
 
# Check if the destination file already exists

if [ -f "$DEST" ]; then

    echo "File already exists in $DEST. Skipping copy."

else

     #moving the binaries to other location

     mv $docker_bin /usr/local/src

     echo "File copied to $DEST."

#Restrict users to run docker push using binary

cat << 'EOF' > $docker_bin

#!/bin/bash

if [[ "$1" == "push" ]]; then

  echo "You are not allowed to run 'docker push'."

  exit 1

else

  /usr/local/src/docker "$@"

fi

EOF

#Add execute permission for new binaries

chmod 755 $docker_bin
 
fi
 
fi
 
 
# Check if Git is installed

if command -v git >/dev/null 2>&1; then
 
echo "Git is installed."
 
git_bin=$(whereis -b git | awk '{print $2}')
 
 
# Define destination paths

DEST_GIT="/usr/local/src/git"
 
# Check if the destination file already exists

if [ -f "$DEST_GIT" ]; then

    echo "File already exists in $DEST_GIT. Skipping copy."

else

     #moving the binaries to other location

     mv $git_bin /usr/local/src

     echo "File copied to $DEST_GIT."
 
#Restrict users to run git push using binary

cat << 'EOF' > $git_bin

#!/bin/bash

if [[ "$1" == "push" ]]; then

  echo "You are not allowed to run 'git push'."

  exit 1

else

  /usr/local/src/git "$@"

fi

EOF

#Add execute permission for new binaries

chmod 755 $git_bin
 
fi
 
fi
 
printenv_bin=$(whereis -b printenv | awk '{print $2}')

env_bin=$(whereis -b env | awk '{print $2}')

scp_bin=$(whereis -b scp | awk '{print $2}')

rsync_bin=$(whereis -b rsync | awk '{print $2}')

aws_bin=$(whereis -b aws | awk '{print $2}')
 
#Restrict permission for other users

chmod 700 $printenv_bin

chmod 700 $env_bin

chmod 700 $scp_bin

chmod 700 $rsync_bin

chmod 700 $aws_bin
 
useradd -m -c "DevOps - Admin User" devops

sleep 3

echo "devops:D3709S@z02s" | chpasswd  

echo "devops ALL=(ALL:ALL) ALL" >>  /etc/sudoers
 
#Restrict normal users to run the commands like export, scp, rsync, aws, whereis, which, printenv, env, set, find git, locate git, git push, docker push, echo PATH.
 
 
# Define the line to check

CHECK_LINE="unalias export 2>/dev/null"
 
# Define the target file

BASHRC_FILE="/etc/bashrc"
 
# Check if the line is present in /etc/bashrc

if grep -Fxq "$CHECK_LINE" "$BASHRC_FILE"; then

    echo "Line '$CHECK_LINE' already present. Skipping file copy."

else
 
cat << 'EOF' >> /etc/bashrc

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

function docker() {

    if [[ "$1" == "push" ]]; then

        echo "docker push is disabled in this shell session."

        return 1

    else

        command docker "$@"

    fi

}
 


if [[ $EUID -ne 0 ]]; then

  function echo() {

    if [[ "$1" == "$PATH" ]]; then

      /usr/bin/echo "Access to PATH variable is restricted."

    else

      /usr/bin/echo "$@"

    fi

  }

fi

EOF
 
fi
 
 


#To reflect the bashrc file

source /etc/bashrc

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

echo "PermitRootLogin no" >> /etc/ssh/sshd_config


while ! id "ssm-user" &>/dev/null; do

    echo "Waiting for ssm-user to be created..."

    sleep 5

done

# Reset the password for ssm-user

echo "ssm-user:S5mUs36@2025" | chpasswd

if [ $? -eq 0 ]; then

    echo "Password reset successful for ssm-user."

else

    echo "Failed to reset password for ssm-user."

    exit 1

fi

# Update sudoers for ssm-user
> /etc/sudoers.d/ssm-agent-users

echo "ssm-user ALL=(ALL) ALL" > /etc/sudoers.d/ssm-agent-users

chmod 440 /etc/sudoers.d/ssm-agent-users

# Restart SSM agent

systemctl restart amazon-ssm-agent

systemctl restart sshd
 
 

S5mUs36@2025



