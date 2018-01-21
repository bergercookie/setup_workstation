#!/usr/bin/env bash

export OS_NAME=`uname`
export DISTRO_NAME=`head -n 1 /etc/os-release | cut -d '"' -f2`
export LOG_TO_FILE=false
export DOTFILES_LOCAL=${HOME}/dotfiles

log=
if [[ "${LOG_TO_FILE}" = true ]]; then
    # initialize the logger
    log=`dirname ${BASH_SOURCE[0]}`/third-party/lumberjack/lj # Doesn't work in bash
else
    log=`dirname ${BASH_SOURCE[0]}`/stdout_logger
fi
export log

demand_yes_no="`dirname ${BASH_SOURCE[0]}`/demand_yes_no.sh"

${log} info "Initializing..."
${log} info "Operating System:  ${OS_NAME}"
${log} info "Distribution: ${DISTRO_NAME}"

${log} info "Specify the categories you want to install packages from: "

function __root_install_package_category()
{
    ${log} warning "Installing packages from category: ${category}"
    # verify...
    ${demand_yes_no}
    [[ "$?" -eq 0 ]] && sudo -E bash -c "./install_category_packages.sh $1"

} # end of __root_install_package_category

##############################################################################
# Install packages
# Get these from the Python npyscreens GUI
# TODO
${log} warning "Install binary packages now?"
${demand_yes_no}
if [[ "$?" -eq 0 ]]; then
    indicated_categories=""
    indicated_categories+="BUILD COMPILING CRYPTO ESSENTIAL MULTIMEDIA"
    indicated_categories+="PYTHON HASKELL ROBOTICS_SOURCE SCIENCE"
    indicated_categories+="TMUX FANCY PRODUCTIVITY "
    indicated_src_categories+="GENERIC_SOURCE ROBOTICS_SOURCE"

    for category in `echo ${indicated_categories}`
    do
        __root_install_package_category ${category}
    done
fi

GIT=`which git`
SSH_KEYGEN=`which ssh-keygen`
XCLIP=`which xclip`
BROWSER=`which firefox`
ID_RSA_PUBFILE=${HOME}/.ssh/id_rsa.pub

${log} info "Setting up the computer ssh-key..."
[[ -f ${ID_RSA_PUBFILE} ]] || ssh-keygen -t 'rsa'

cat ${ID_RSA_PUBFILE} | ${XCLIP} -sel clip
${log} warning "Public key copied! Add it to your Github profile..."
GITHUB_SSH_KEYS_PAGE="https://github.com/settings/ssh/new"
${BROWSER} ${GITHUB_SSH_KEYS_PAGE}&

${log} info "Don't worry, I'll wait here 'till you're done... :-)"
${log} info "Press [ENTER] to continue..."
read

${log} info "Downloading dotfiles repository..."
rm -rI "${DOTFILES_LOCAL}" # clean up previous contents
${GIT} clone --recursive ssh://git@github.com/bergercookie/dotfiles-reborn ${DOTFILES_LOCAL}
${log} info "Done!"

##############################################################################
# Post-Download
${log} info "Running post-download actions..."

# ${log} info "Compiling YCM"
# curdir=`pwd`
# cd "${DOTFILES_LOCAL}/vim/.vim/bundle/YouCompleteMe"
# ./install.py --all
# cd "${curdir}"

${log} info "Compiling vimproc.vim"
curdir=`pwd`
cd "${DOTFILES_LOCAL}/vim/.vim/bundle/vimproc.vim"
make
cd ${curdir}

##############################################################################

${log} info "Building indicated projects from source..."

# TODO

##############################################################################
# SYMLINKS

function __make_symlink()
{
    curdir=`pwd`
    cd ${HOME}
    ln -sf "${DOTFILES_LOCAL}/$1"
    cd ${curdir}
} # end of __make_symlink

function __make_bash_links()
{
    __make_symlink "bash/.bashrc"
    __make_symlink "bash/.bashrc.linux"
    __make_symlink "bash/.bashrc.local"
} # end of __make_symlinks_bash
function __make_vim_links()
{
    __make_symlink "vim/.vim"
    __make_symlink "vim/.vimrc"
    # __make_symlink "vim/.ycm_extra_conf.py"
    __make_symlink "vim/.vintrc.yaml"
} # end of __make_vim_links
function __make_tmux_links()
{
    __make_symlink "tmux/.tmux"
    __make_symlink "tmux/.tmux.conf"
    __make_symlink "tmux/.tmux.conf.linux"
} # end of __make_tmux_links
function __make_git_links()
{
    __make_symlink "git/.gitconfig"
    __make_symlink "git/.gitignore_template"
} # end of __make_python_links
function __make_python_links()
{
    __make_symlink "python/.pdbrc"
} # end of __make_python_links
function __make_gdb_links()
{
    __make_symlink "gdb/.gdbinit"
} # end of __make_gdb_links
function __make_firefox_links()
{
    __make_symlink "firefox/vimperator/.vimperator"
    __make_symlink "firefox/vimperator/.vimperatorrc"
} # end of __make_firefox_links
function __make_ctags_links()
{
    __make_symlink "ctags/.ctags"
} # end of __make_ctags_links
function __make_terminator_links()
{
    curdir=`pwd`
    dir_to_go="${HOME}/.config/terminator"
    mkdir -p ${dir_to_go}; cd $!
    ln -s "${DOTFILES_LOCAL}/terminator/config" .
    cd ${curdir}
} # end of __make_terminator_links

${log} info "Creating the necessary symlinks..."
curdir=`pwd`
cd ${HOME}

__make_bash_links
__make_vim_links
__make_tmux_links
__make_git_links
__make_python_links
__make_gdb_links
__make_firefox_links
__make_ctags_links
__make_terminator_links

cd ${curdir}

##############################################################################
# Fonts

curdir=`pwd`
${log} info "Installing the fonts..."
${log} info "Installing Powerline fonts..."
cd $DOTFILES_LOCAL/fonts/powerline-fonts
./install.sh
${log} info "Installing awesome-terminal-fonts..."
cd $DOTFILES_LOCAL/fonts/awesome-terminal-fonts
./install.sh
${log} info "Installing Apple SanFransisco fonts..."
cd $DOTFILES_LOCAL/fonts/SanFranciscoFont
cd ${curdir}
${log} info "Done!"

##############################################################################
${log} warn "Installing Franz"
setup_franz_script="`dirname ${BASH_SOURCE[0]}`/scripts/setup.franz.ubuntu.sh/setup-franz-ubuntu.sh"
${setup_franz_script}

${log} warn "Franz is set up. Move your configuration files if you have them backed up"
read

