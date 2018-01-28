#!/bin/bash

function mirror_parent_channel() {
    # This is not a general purpose tool. Do not use it as such.
    #
    # mirror_parent_channel http://example-conda.com/some-channel /some/path/to/store/it
    #
    # /some/path/to/store/it will end up looking like so:
    #
    # + it
    # `- linux-64
    # `- osx-64
    # `- win-64
    # `- noarch
    # `- ...
    #

    local url="$1"
    local dest="$2"
    local _retval=

    if [[ -z $url ]]; then
        echo "URL required."
        return 1
    fi

    if [[ -z $dest ]]; then
        echo "Destination directory not defined."
        return 1
    fi

    if [[ ! -d $dest ]]; then
        mkdir -p "$dest"
    fi

    pushd "$dest" &>/dev/null
    wget \
        --no-verbose \
        --timestamping \
        --accept '*.bz2','*.json*' \
        --recursive \
        --no-parent \
        --no-host-directories \
        --cut-dirs=1 \
        --level=2 \
        "$url"
    _retval=$?

    popd &>/dev/null
    return $_retval
}

mirror_parent_channel "$1" "$2"
