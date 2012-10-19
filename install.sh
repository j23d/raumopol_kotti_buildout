#!/bin/bash

function error {
    echo "usage: $0 {-d database_string | -u username"}
    exit 0
}

# get some input vars
while [ $# -gt 0 ]; do
    case "$1" in
        -d|--DATABASE)
            DATABASE="$2"
            shift
            ;;
        -u|--USERNAME)
            USERNAME="$2"
            shift
            ;;
    esac
    shift
done

# if [[ -z $DATABASE && -z $USERNAME ]]; then
#     error
# fi

# create virtualenv, activate it and run buildout
virtualenv-2.7 .;
source ./bin/activate;
python bootstrap.py
./bin/buildout

#sed 's|.*\/\([^\.]*\)\(\..*\)$|\1|g'