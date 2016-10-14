#!/usr/bin/env bash

##
# Performs additional setup on Dreamhouse org.
#
# This script:
#   - Enables Dreamhouse PermissionSet on configured workspace,
#   - Loads sample data.
#
# Requires Heroku CLI and AppCloud and Force.com CLI
# plugins which are installed by Salesforce Buildpack.
##

# Debug, echo every command
#set -x


SCRATCH_ORG=org@salesforce.com
HEROKU_CLIENT=heroku

runCmd() {
    local cmnd="$*"
    local ret_code

    echo $cmnd
    eval $cmnd
    ret_code=$?
    if [ $ret_code != 0 ]; then
        printf "Error : [%d] when executing command: '$cmnd'" $ret_code
        exit $ret_code
    fi
}

# Set perms on apps and objects
echo "Enabling Dreamhouse PermissionSet for App and SObject visibility..."
runCmd "$HEROKU_CLIENT force:permset:assign --name DreamHouse"


if [ "$LOAD_DATA" != false ]; then
    # Load the Properties, Favorites, & Brokers into the Salesforce org
    echo "Loading Dreamhouse data..."
    runCmd "$HEROKU_CLIENT force:data:import --plan data/sample-data-plan.json"
fi

exit 0
