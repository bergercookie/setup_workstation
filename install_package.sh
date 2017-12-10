#!/usr/bin/env bash

DISTRO_NAME=`head -n 1 /etc/os-release | cut -d '"' -f2`

function __find_char_occurances_in_str()
{
    char=$1
    text=$2
    GREP=`which grep`

    export char_positions_in_str=`echo ${text} | GREP -aob ${char} | cut -d':' -f1`

} # end of __find_char_occurances_in_str

# Parse the given package string
# That may contain:
# - target distro
# - package name alternatives
function parse_package_str()
{
    TAG_DISTRO="@"
    TAG_PPA="*"
    TAG_ALTERNATIVES="|"

    raw_name=$1

    __find_char_occurances_in_str ${TAG_DISTRO} ${raw_name}
    echo ${char_positions_in_str}

    # split the given string into subparts based on the tags found
}

# Wrapper function for installing a package - Delegates tasks to the
# corresponding install_package_* methods
function install_package()
{
    if [[ ! -z "${REQUIRE_LOGGING_MODULE}" ]] && [[ -z "${log}" ]]; then
        echo "No logging module found. Exiting..."
        exit 1
    else
        log=`which echo`
    fi
    if ! [[ "`id -u`" = 0 ]]; then
        echo "Function ${FUNCNAME[0]} executed without superuser rights. Exiting..."
        exit 1
    fi

    ${log} info "Installing package $1..."

    if [[ "${DISTRO_NAME}" = "Debian" ]] || [[ "${DISTRO_NAME}" = "Ubuntu" ]]; then
        install_package_debian ${@:1}
    else
        install_package_arch ${@:1}
    fi
} # end of install package

function install_package_debian()
{

    if ! [[ -z "${UPDATE_PKG_CACHE}" ]]; then
        sudo apt-get update
    fi

    require_yes_str="-y"
    if  [[ ! -z ${REQUIRE_YES} ]]; then
        require_yes_str=
    fi
    apt-get install ${require_yes_str} $1
} # end of install_package_debian

function install_package_arch()
{
    TODO-UNIMPLEMENTED-METHOD-${FUNCNAME[0]}
    exit 1

    pacman -S $1
} # end of install_package_arch

# install_package ${@:1}
