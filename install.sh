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
        -sk|--SESSIONKEY)
            SESSIONKEY="$2"
            shift
            ;;
    esac
    shift
done


# catch the variables
# if [[ -z $DATABASE && -z $USERNAME ]]; then
#     error
# fi

if [ -z $DATABASE ]; then
    DATABASE='sqlite:\/\/\/%(here)s\/Kotti.db'
fi

if [[ -z $USERNAME ]]; then
    dir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
    OIFS=$IFS
    IFS='/'
    paths=($dir)
    IFS=$OIFS
    USERNAME=${paths[4]}
fi

SESSIONKEY="$USERNAME-kotti"
SESSIONSECRET="$USERNAME-SECRET-0815"
MAILDEFAULTSENDER="admin@something.tld"
MAILUSERNAME="mustermann@something.tld"
MAILPASSWORD=""
KOTTISITETITLE="Kotti"
KOTTISECRET="qwerty"


echo "Prepare the buildout file"
cp ./config/buildout.cfg.in ./buildout.cfg
sed -i "s/%databasestring%/$DATABASE/g" ./buildout.cfg
sed -i "s/%username%/$USERNAME/g" ./buildout.cfg
sed -i "s/%session_key%/$SESSIONKEY/g" ./buildout.cfg
sed -i "s/%session_secret%/$SESSIONSECRET/g" ./buildout.cfg
sed -i "s/%mail_default_sender%/$MAILDEFAULTSENDER/g" ./buildout.cfg
sed -i "s/%mail_username%/$MAILUSERNAME/g" ./buildout.cfg
sed -i "s/%mail_password%/$MAILPASSWORD/g" ./buildout.cfg
sed -i "s/%kotti_site_title%/$KOTTISITETITLE/g" ./buildout.cfg
sed -i "s/%kotti_secret%/$KOTTISECRET/g" ./buildout.cfg


# create virtualenv, activate it and run buildout
if [ ! -f ./bin/python2.7 ]; then
    echo "Installing virtualenv."
    virtualenv-2.7 --distribute .
fi

echo "Running the buildout."
./bin/python2.7 bootstrap.py
./bin/buildout

exit 0;
