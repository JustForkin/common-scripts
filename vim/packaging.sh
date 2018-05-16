function vcl {
    vim *.changelog
}

alias vchl=vcl

function vds {
    vim *.dsc
}

alias vdsc=vds
alias vsc=vds

function vpk {
    if [[ -f package.json ]]; then
         vim package.json
    else
         vim PKGBUILD
    fi
}

function vrl {
    vim *rules
}

function vsp {
    vim *.spec
}

function vyl {
    vim *.yml
}
