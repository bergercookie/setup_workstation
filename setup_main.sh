#!/usr/bin/env bash

export OS_NAME=`uname`
export DISTRO_NAME=`head -n 1 /etc/os-release | cut -d '"' -f2`
export LOG_TO_FILE=false
export DOTFILES_LOCAL=${HOME}/dotfiles

log=
if [[ "${LOG_TO_FILE}" = true ]]; then
    # initialize the logger
    log=`dirname ${BASH_SOURCE[0]}`/third-party/lumberjack/lj
else
    log=`dirname ${BASH_SOURCE[0]}`/stdout_logger
fi
export log

${log} info "Initializing..."
${log} info "Operating System:  ${OS_NAME}"
${log} info "Distribution: ${DISTRO_NAME}"

${log} info "Specify the categories you want to install packages from: "

function root_install_package_category()
{
    sudo -E bash -c "./install_category_packages.sh $1"
}

category="ESSENTIAL"
${log} warning "Installing packages from category: ${category}"
# verify...
answer=
while [[ "`echo ${answer} | awk '{ print toupper($0) }'`" != "YES" ]] && \
      [[ "`echo ${answer} | awk '{ print toupper($0) }'`" != "NO" ]];
do
    ${log} warning "Continue? [yes/no]"
    read answer
done
root_install_package_category ${category}

GIT=`which git`
SSH_KEYGEN=`which ssh-keygen`
XCLIP=`which xclip`

${log} info "Setting up the computer ssh-key..."
ssh-keygen -t 'rsa'

${log} warning "Public key copied! Add it to your Github profile..."
GITHUB_SSH_KEYS_PAGE="https://github.com/settings/keys"
if [[ `./check_if_debian_based_distro.sh` = 0 ]]; then
    `xdg-open firefox ${GITHUB_SSH_KEYS_PAGE}`
fi

${log} info "Don't worry, I'll wait here 'till you're done... :-)"
read

${log} info "Downloading dotfiles repository..."
${GIT} clone ssh://git@github.com/bergercookie/dotfiles-reborn dotfiles
${log} info "Done!"

${log} info "Running post-download actions..."

${log} info "Compiling YCM"
curdir=`pwd`
cd ${DOTFILES}/vim/.vim/bundle/YouCompleteMe
./install.py --all
cd ${curdir}


${log} info "Building indicated projects from source..."

${log} info "Creating the necessary symlinks..."

${log} info "Installing the fonts..."

# CATEGORY_NAMES="GENERIC_SOURCE MULTIMEDIA CRYPTO ESSENTIAL COMPILING BUILD
# PYTHON ROBOTICS_SOURCE SCIENCE"
# for category in `echo ${CATEGORY_NAMES}`
# do
#     name=SOFTWARE_${category}
#     echo ${name}
# done

log warning "Kalimera!"

