#!/bin/bash

# check-coke.sh
#
# Execute a coke check only on file to be commited.
# Allow a very fast check, especially for project with large amount of files
#
# Install into:
# - .git/hooks/pre-commit
#
# And make sure all are executable.
# 

file=".coke"
files=""
stash=0

function success
{
    echo "[$(tput bold)$(tput setaf 2)SUCCESS$(tput sgr0)] $(tput setaf 6)$1$(tput sgr0)"
    exit 0
}

function fail
{
    echo "[$(tput bold)$(tput setaf 1)FAIL$(tput sgr0)] $(tput setaf 6)$1$(tput sgr0)"
    exit 1
}

function warning
{
    echo "[$(tput bold)$(tput setaf 3)WARNING$(tput sgr0)] $(tput setaf 6)$1$(tput sgr0)"
}

function info
{
    echo "[$(tput bold)$(tput setaf 4)INFO$(tput sgr0)] $(tput setaf 6)$1$(tput sgr0)"
}

# Execution preparation
STATUS_OUTPUT=$(git status --porcelain)

if echo "$STATUS_OUTPUT"|grep '^[MARCDU][MARCDU]' > /dev/null
then
    fail "Some files appears both in your staging area and your unadded files."
elif echo "$STATUS_OUTPUT"|grep '^ [MARCD]' > /dev/null
then
    if git stash save -u -k -q
    then
        stash=1
    else
        fail "Unable to stash changes"
    fi
fi

if [ ! -e $file ]
then
    warning "Can't find \".coke\" file, aborting check"
    exit 0
fi

cokePaths=$( grep "^[^\#][^\=]*$" $file )

for file in $(git status --porcelain | grep '^[MARC]' | colrm 1 3 | cut -f2 -d">")
do
    allowed=0
    
    for ligne in $cokePaths
    do
        if [ "${ligne:0:1}" = '!' ] && [[ "$file" == *"${ligne:1}"* ]]
        then
            continue 2
        elif [[ "$file" == "$ligne"* ]]
        then
            allowed=1
        fi
    done
    
    if [ "$allowed" -eq 1 ]
    then
        files="$files $file"
    fi
done

# Command execution
if [ -n "$files" ]
then
   coke $files
   CS_RESULT=$?
else
   CS_RESULT=0
fi

if [ "$stash" -eq 1 ]
then
    if git stash pop -q
    then
        warning "Unable to revert stash command"
    fi
fi

if [ $CS_RESULT -eq 1 ]
then
    fail "You must fix coding standards before commit"
fi

success  "Coding standards"
