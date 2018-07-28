# Rubygems
if `which ruby > /dev/null 2>&1`; then
    export GEM_VERSION=$(ruby --version | cut -d ' ' -f 2 | sed 's/[a-z][0-9]//g' | sed 's/.[0-9]*$//g' | sed 's/$/.0/g')
    if [[ -d /usr/lib64/ruby/gems/$GEM_VERSION/bin ]]; then
         export GEMPATH=/usr/lib64/ruby/gems/$GEM_VERSION/bin
    fi
    if [[ -d $HOME/.gem/ruby/$GEM_VERSION/bin ]]; then
         if [[ -n $GEMPATH ]]; then
              export GEMPATH=$HOME/.gem/ruby/$GEM_VERSION/bin:$GEMPATH
         else
              export GEMPATH=$HOME/.gem/ruby/$GEM_VERSION/bin
         fi
    fi
    if [[ -d $HOME/bin ]]; then
         if [[ -n $GEMPATH ]]; then
              export GEMPATH=$HOME/bin:$GEMPATH
         else
              export GEMPATH=$HOME/bin
         fi
    fi
fi
