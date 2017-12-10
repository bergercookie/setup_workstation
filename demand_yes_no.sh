#!/usr/bin/env bash

if [ -z log ]; then
    log=echo
fi

# Demand a YES/NO answer from the user. Useful in shell interactive sessions
# return 0 if answer is "YES", 1 if answer is "NO
function __demand_yes_no()
{
    answer=
    while [[ "`echo ${answer} | awk '{ print toupper($0) }'`" != "YES" ]] && \
          [[ "`echo ${answer} | awk '{ print toupper($0) }'`" != "NO" ]];
    do
        ${log} warning "Specify [yes/no]"
        read answer
    done

    ret=
    if [[ "`echo ${answer} | awk '{ print toupper($0) }'`" = "YES" ]]; then
        ret=0
    else
        ret=1
    fi
    return ${ret}
} # end of __demand_yes_no

__demand_yes_no
exit $?
