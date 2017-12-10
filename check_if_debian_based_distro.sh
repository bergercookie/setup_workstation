function __check_if_debian_based_distro()
{
    DISTRO_NAME=`head -n 1 /etc/os-release | cut -d '"' -f2`

    ret=
    if [[ "${DISTRO_NAME}" = "Debian" ]] || [[ "${DISTRO_NAME}" = "Ubuntu" ]]; then
        ret=0
    else
        ret=1
    fi

    return ret
} # __end of check_if_debian_based_distro

__check_if_debian_based_distro ${@:1}
