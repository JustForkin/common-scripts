function apmu {
    apm upgrade --no-confirm
}

function apmi {
    apm install "$@"
}

function apmr {
    apm remove "$@"
}

function apms {
    apm search "$@"
}
