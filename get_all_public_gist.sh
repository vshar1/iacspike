#!/bin/bash
set -e

# Constants 
GIT_TOKEN_SECRET='input/secrets/gitapi_token.json'
GITAPI_TOKEN=$(cat $GIT_TOKEN_SECRET | jq -r '.token | select( . != null)')
INIT_PUBLIC_GIST_FILE='output/list-public-gists.json'
LAST_RUN_PUBLIC_GIST_FILE='output/list-public-gists.lastRun'
STRING_PARAM_FILE='input/list_pub_gist_params/parameters.json'
LIST_PUBLIC_GIST_URL='https://api.github.com/gists/public'
HEADER_VALUE='application/vnd.github.v3+json'

# Methods
getPubGistSinceLastRun()
 {
     LAST_RUN=$(cat $LAST_RUN_PUBLIC_GIST_FILE | jq -r '.since | select( . != null)')
     echo -e "\n LAST_RUN was="$LAST_RUN   

     LIST_SINCE_GIST_URL=$LIST_PUBLIC_GIST_URL"?since="$LAST_RUN
     echo "LIST_SINCE_GIST_URL="$LIST_SINCE_GIST_URL

     curl -H "Accept: $HEADER_VALUE" -H "Authorization: token $GITAPI_TOKEN" $LIST_SINCE_GIST_URL > $INIT_PUBLIC_GIST_FILE"_"$LAST_RUN".json"
 }

getInitialPubGist()
 {  
     echo "Getting the Public gist for all users"
     curl -H "Accept: $HEADER_VALUE" -H "Authorization: token $GITAPI_TOKEN" $LIST_PUBLIC_GIST_URL > $INIT_PUBLIC_GIST_FILE
 }

getPubGistQueryParam()
{
    SINCE=$(cat $STRING_PARAM_FILE | jq -r '.since | select( . != null)')
    PER_PAGE=$(cat $STRING_PARAM_FILE | jq -r '.per_page | select( . != null)')
    PAGE=$(cat $STRING_PARAM_FILE | jq -r '.page | select( . != null)')

    echo $SINCE $PER_PAGE $PAGE
    
    if [ -z "$SINCE" ]
    then
        # Since No since value passed so fetching all
        getInitialPubGist
        exit 1
    else
        QUERY_URL=$LIST_PUBLIC_GIST_URL"?since="$SINCE"&per_page="$PER_PAGE"&page="$PAGE
        DATE=$(date +"%Y-%m-%dT%H:%M:%S%z")
        curl -H "Accept: $HEADER_VALUE" -H "Authorization: token $GITAPI_TOKEN" $QUERY_URL > $INIT_PUBLIC_GIST_FILE"_PARAMS_"$DATE".json"
    fi

    # QUERY_GIST_URL=$LIST_PUBLIC_GIST_URL"?since="$LAST_RUN
    
}

# Validation Pre-requisite
if [ -z "$GITAPI_TOKEN" ]
then
    echo "No GITAPI Token found, please revisit ReadMe.md :Prerequisite i.e. /input/secrets/gitapi_token.json"
    exit 1
else
    echo -e "\nUsing github token is GITAPI_TOKEN="${GITAPI_TOKEN::-6}'******'
fi

OPTIONAL_QUERY=$1
if [[ "$OPTIONAL_QUERY" = "1" ]];
then
    echo "OPTIONAL_QUERY found"$OPTIONAL_QUERY
    getPubGistQueryParam
    exit 1
else
    echo "You can pass ./getPubGistSinceLastRun.sh 1 if you wish to query with params instead of default behavour"
    echo "Just append input/list_pub_gist_params/parameters.json with the values you need"
fi

if test -f "$INIT_PUBLIC_GIST_FILE"; then
    echo -e "\nInitialPubGist exists, so going to fetch recent since last run"
    getPubGistSinceLastRun
else 
    getInitialPubGist
    EXECUTION_DATE=($(date +"%Y-%m-%dT%H:%M:%S%z"))
    echo "{\"since\":\"$EXECUTION_DATE\"}" | jq '.' > $LAST_RUN_PUBLIC_GIST_FILE
fi
