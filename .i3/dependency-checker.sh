#!/usr/bin/env bash

# Check that the required binaries are found
if ! command -v gcc &> /dev/null; then
    printf '\e[1;31m%-6s\e[m\n' "GNU Compiler Collection's C compiler ('gcc') is not detected"
    printf '\e[1;31m%-6s\e[m\n' "in PATH, so please install it, or edit"
    printf '\e[1;31m%-6s\e[m\n' "$HOME/GitHub/mine/scripts/common-scripts/.i3/i3status.sh so"
    printf '\e[1;31m%-6s\e[m\n' "that it can detect the binary correctly."
fi

if ! command -v g++ &> /dev/null; then
    printf '\e[1;31m%-6s\e[m\n' "GNU Compiler Collection's C++ compiler ('g++') is not detected"
    printf '\e[1;31m%-6s\e[m\n' "in PATH, so please install it, or edit"
    printf '\e[1;31m%-6s\e[m\n' "$HOME/GitHub/mine/scripts/common-scripts/.i3/i3status.sh so"
    printf '\e[1;31m%-6s\e[m\n' "that it can detect the binary correctly."
fi

# GNU Octave
if ! command -v octave &> /dev/null; then
    printf '\e[1;31m%-6s\e[m\n' "GNU Octave's binary ('octave') is not in PATH, so please"
    printf '\e[1;31m%-6s\e[m\n' "install it, or edit"
    printf '\e[1;31m%-6s\e[m\n' "$HOME/GitHub/mine/scripts/common-scripts/.i3/i3status.sh so"
    printf '\e[1;31m%-6s\e[m\n' "that it can detect the binary correctly."
fi

# GNU Coreutils needed
if ! ( command -v ln &> /dev/null && command -v tail &> /dev/null && command -v cat &> /dev/null && command -v cut &> /dev/null && command -v grep &> /dev/null && command -v date &> /dev/null); then
    printf '\e[1;31m%-6s\e[m\n' "At least one of the GNU coreutils was not found in PATH."
    printf '\e[1;31m%-6s\e[m\n' "i3status.sh will not work without it."
fi

# sed
if ! command -v sed &> /dev/null ; then
    printf '\e[1;31m%-6s\e[m\n' "sed is not found in PATH (${PATH}), please install it, or if it is"
    printf '\e[1;31m%-6s\e[m\n' "installed, please add it to PATH"
fi
# procps-ng
if ( ! command -v uptime &> /dev/null ) || ( ! command -v free &> /dev/null ); then
    printf '\e[1;31m%-6s\e[m\n' "free and uptime are not found in PATH, the package that"
    printf '\e[1;31m%-6s\e[m\n' "provides it is usually called procps-ng on Linux. i3status.sh"
    printf '\e[1;31m%-6s\e[m\n' "will not work without it, I suggest installing it."
fi

# psmisc
if ! command -v killall &> /dev/null ; then
    printf '\e[1;31m%-6s\e[m\n' "The killall command was not found, i3status.sh will not run"
    printf '\e[1;31m%-6s\e[m\n' "properly without it. psmisc is usually the name of the package"
    printf '\e[1;31m%-6s\e[m\n' "that provides it."
fi

# Zsh
if ! command -v zsh &> /dev/null ; then
    printf '\e[1;31m%-6s\e[m\n' "The Zsh shell is not found in your PATH and is required."
fi