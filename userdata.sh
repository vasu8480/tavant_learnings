#!/bin/bash

yum update -y
yum install git -y
yum install docker -y
systemctl enable docker
systemctl start docker

#moving the binaries to other location
mv /usr/bin/git /usr/local/src
mv /usr/bin/docker /usr/local/src

#Restrict users to run git push using binary
cat << 'EOF' > /usr/bin/git
#!/bin/bash

if [[ "$1" == "push" ]]; then
  echo "You are not allowed to run 'git push'."
  exit 1
else
  /usr/local/src/git "$@"
fi
EOF

#Restrict users to run docker push using binary
cat << 'EOF' > /usr/bin/docker
#!/bin/bash

if [[ "$1" == "push" ]]; then
  echo "You are not allowed to run 'docker push'."
  exit 1
else
  /usr/local/src/docker "$@"
fi
EOF

#Add execute permission for new binaries
chmod 755 /usr/bin/git
chmod 755 /usr/bin/docker

#Restrict permission for other users
chmod 700 /usr/bin/printenv
chmod 700 /usr/bin/env
chmod 700 /usr/bin/scp
chmod 700 /usr/bin/rsync
chmod 700 /usr/bin/aws

#Restrict normal users to run the commands like export, scp, rsync, aws, whereis, which, printenv, env, set, find git, locate git, git push, docker push, echo PATH.
cat << 'EOF' >> /etc/bashrc

unalias export 2>/dev/null

if [[ $EUID -ge 1000 ]]; then
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
      if [[ "$@" =~ "git" ]]; then
        echo "You are not allowed to search for 'git' files.";
      else
        /usr/bin/find "$@";
      fi;
   }; _find'

   alias locate='function _locate() {
      if [[ "$@" =~ "git" ]]; then
        echo "You are not allowed to search for 'git' files using locate.";
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
if [[ $EUID -ne 0 ]]; then
function docker() {
    if [[ "$1" == "push" ]]; then
        echo "docker push is disabled in this shell session."
        return 1
    else
        command docker "$@"
    fi
}
fi

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

#To reflect the bashrc file
source /etc/bashrc
# echo "root:root@2025" | chpasswd  
# passwd -l root

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
systemctl restart sshd

useradd -m -c "DevOps user" devops
echo "devops:DevOps@2025" | chpasswd  
echo "devops ALL=(ALL:ALL) ALL" >>  /etc/sudoers


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
