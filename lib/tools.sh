#!/bin/bash
# By Pytel

# adtac/climate
# extract <file> [path]
function extract () {
    if [[ -f $1 ]] ; then
        if [[ $2 == "" ]]; then
            case $1 in
                *.rar)                             rar x   $1       ${1%.rar}/     ;;
                *.tar.bz2)  mkdir -p ${1%.tar.bz2} && tar xjf $1 -C ${1%.tar.bz2}/ ;;
                *.tar.gz)   mkdir -p ${1%.tar.gz}  && tar xzf $1 -C ${1%.tar.gz}/  ;;
                *.tar.xz)   mkdir -p ${1%.tar.xz}  && tar xf  $1 -C ${1%.tar.xz}/  ;;
                *.tar)      mkdir -p ${1%.tar}     && tar xf  $1 -C ${1%.tar}/     ;;
                *.tbz2)     mkdir -p ${1%.tbz2}    && tar xjf $1 -C ${1%.tbz2}/    ;;
                *.tgz)      mkdir -p ${1%.tgz}     && tar xzf $1 -C ${1%.tgz}/     ;;
                *.zip)                             unzip   $1 -d ${1%.zip}/        ;;
                *.7z)                              7za e   $1 -o${1%.7z}/          ;;
                *)          printf "${Red}'$1' cannot be extracted.\n"             ;;
            esac
        else
            case $1 in
                *.rar)                     rar x   $1    $2 ;;
                *.tar.bz2)  mkdir -p $2 && tar xjf $1 -C $2 ;;
                *.tar.gz)   mkdir -p $2 && tar xzf $1 -C $2 ;;
                *.tar.xz)   mkdir -p $2 && tar xf  $1 -C $2 ;;
                *.tar)      mkdir -p $2 && tar xf  $1 -C $2 ;;
                *.tbz2)     mkdir -p $2 && tar xjf $1 -C $2 ;;
                *.tgz)      mkdir -p $2 && tar xzf $1 -C $2 ;;
                *.zip)                     unzip   $1 -d $2 ;;
                *.7z)                      7z  e   $1 -o$2/ ;;
                *)          printf "${Red}'$1' cannot be extracted.\n"             ;;
            esac
        fi
    else
        printf "${Red}'$1' does not exist.\n"
    fi
    printf "${NC}"
}

#END
