# Rubygems
export GEM_VERSION=$(ruby --version | cut -d ' ' -f 2 | sed 's/[a-z][0-9]//g' | sed 's/.[0-9]*$//g' | sed 's/$/.0/g')
export GEMPATH=$HOME/.gem/ruby/$GEM_VERSION/bin

