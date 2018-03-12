# Nix
if [[ -d $HOME/.nix-profile/share ]]; then
    export XDG_DATA_DIRS=$HOME/.nix-profile/share
fi

# Rubygems
export GEM_VERSION=$(ruby --version | cut -d ' ' -f 2 | sed 's/[a-z][0-9]//g')
export GEMPATH=$HOME/.gem/ruby/$GEM_VERSION/bin

# Go
unset GOROOT
unset GOPATH
if [[ -d /usr/lib/go ]]; then
    export GOROOT=/usr/lib/go

    if [[ -d $HOME/go ]]; then
         export GOPATH=$HOME/go
    fi
fi

# Java
unset JAVA_HOME
unset JVM_HOME
if [[ -d /usr/lib/jvm ]]; then
    export JVM_HOME=/usr/lib/jvm
    if [[ -d $JVM_HOME/java-8-openjdk ]]; then
         export JAVA_HOME=$JVM_HOME/java-8-openjdk
    elif [[ -d $JVM_HOME/java-9-openjdk ]]; then
         export JAVA_HOME=$JVM_HOME/java-9-openjdk
    elif [[ -d $JVM_HOME/java-9-openjdk ]]; then
         export JAVA_HOME=$JVM_HOME/java-7-openjdk
    fi
fi

# Perl
unset PERL_PATH
if [[ -d /usr/bin/site_perl ]]; then
    export PERL_PATH=$PERL_PATH:/usr/bin/site_perl
fi
if [[ -d /usr/bin/vendor_perl ]]; then
    export PERL_PATH=$PERL_PATH:/usr/bin/vendor_perl
fi
if [[ -d /usr/bin/core_perl ]]; then
    export PERL_PATH=$PERL_PATH:/usr/bin/core_perl
fi

# PATH
export PATH=
if [[ -d /usr/lib/hardening-wrapper/bin ]]; then
    export PATH=$PATH:/usr/lib/hardening-wrapper/bin
fi

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$GEMPATH
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
export PATH=$PATH:$PERL_PATH
export PATH=$PATH:$HOME/.nix-profile/bin
export PATH=$PATH:$GEMPATH

if [[ -d $HMOE/.nix-profile/bin ]]; then
    export PATH=$PATH:$HOME/.nix-profile/bin
fi
