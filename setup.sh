#!/bin/bash
if grep -q -i "Red Hat" /etc/*-release
then
  echo "running RHEL "
  RED_HAT=true
else 
  echo "running not RHEL"
  RED_HAT=false
fi

echo -e "\e[32mWelcome to the DEV VM Installer\e[0m\n"
echo "We will now clone a Git Repository into your current working directory."
echo -n "Continue? [y/N] "

read start
if [ "$start" != "y" ] 
then
    echo -e "\e[31mAborting...\e[0m\n"
    exit 0
fi 


echo
echo "First we need to install Git. We'll need your admin password for that..."
if $RED_HAT
then
	sudo yum -yq install git-core
else
	sudo apt-get -yq install git-core
fi	

echo
echo "Cloning the repository."
echo -e "\e[31mNote that your username and password are the ones from GitLab!\e[0m"
echo "Login to GitLab, check your profile and set a password if you have not already done so.\n"
if $RED_HAT
then
	echo -n "Enter your username:"
	read git_username
	git clone https://$git_username@source.ctp-consulting.com/java/vm_setup_scripts.git
else
	git clone https://source.ctp-consulting.com/java/vm_setup_scripts.git
fi

if [ $? -ne 0 ]
then
    echo -e "\e[31mClone failed - wrong credentials?\e[0m Exiting..."
    exit 1
fi

echo -e "\e[32mGit Repository successfully cloned.\e[0m Starting the setup."

cd vm_setup_scripts
./install.sh

if [ $? -eq 0 ]
then
    echo -e "\e[32mDEV VM successfully initialized! Start installing by running the .sh installers in the vm_setup_scripts directory.\e[0m"
fi

