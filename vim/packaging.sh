function vcl {
    vim *.changelog
}

alias vchl=vcl

function vds {
    vim *.dsc
}

alias vdsc=vds
alias vsc=vds

function vrl {
    vim *rules
}

function vsh {
    vim $SHL $HOME/.bashrc $HOME/.zshrc
}

function vsl {
    vim $HOME/SlackBuilds
}

function vsp {
    vim *.spec
}

function vyl {
    vim *.yml .*.yml
}

alias vyml=vyl

function vtyl {
    vim .travis.yml
}
