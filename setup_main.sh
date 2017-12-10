#!/usr/bin/env bash

export OS_NAME=`uname`
export DISTRO_NAME=`head -n 1 /etc/os-release | cut -d '"' -f2`
export LOG_TO_FILE=false

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

sudo -E bash -c "./install_category_packages.sh ESSENTIAL"

${log} info "Setting up the computer ssh-key..."

${log} info "Downloading dotfiles repository..."

${log} info "Running post-download actions..."

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

