#mac
if [ `uname` = "Darwin" ]; then
    export PATH=/usr/local/bin:$PATH
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi
