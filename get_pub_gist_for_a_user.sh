#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
    echo -e "\nUsername parameter missing"
    echo -e "\n: usage: ./get_pub_gist_for_a_user.sh <user-name>"
    echo -e "\ne.g. ./get_pub_gist_for_a_user.sh vshar1\n"
    exit 1
fi

USER_NAME=$1
PER_PAGE=$2
PAGE=$3

DEFAULT_PER_PAGE=30
# Constants 
LAST_RUN_PUBLIC_GIST_FILE='output/list-public-gists.lastRun'
BASE_GIST_URL="https://api.github.com/users/$USER_NAME"
USER_GIST_INFO="output/user_gist_info.json"
TMP_GIST_DETAILS_FILE="output/tmp_gist_details.json"

get_pub_gist_for_a_user()
 {  
    echo -e "\n Getting all gist information for a user"
    curl $BASE_GIST_URL > $USER_GIST_INFO
    GIST_COUNT=$(cat $USER_GIST_INFO  | jq .public_gists)
    echo -e "\n User has total count of public_gists=" $GIST_COUNT

    LAST_RUN=$(cat $LAST_RUN_PUBLIC_GIST_FILE | jq -r '.since | select( . != null)')

    if [ -z "$LAST_RUN" ]
    then
        echo -e "\n Fetching gist for first time for the username ="$USER_NAME
    else
        echo -e "\n Fetching gist for the user added since ="$LAST_RUN
        SUFFIX='&since='$LAST_RUN
    fi

    # Gist has default limit of display 30 gists , so need to implement pagination
    PAGE_CEILING=$((($GIST_COUNT+$DEFAULT_PER_PAGE-1)/$DEFAULT_PER_PAGE))
        for (( page=0; page<PAGE_CEILING; page++ ))
        do 
            pageNumber=$(($page + 1)) 
            pageUrl=$BASE_GIST_URL'/gists?page='$pageNumber'&per_page='$DEFAULT_PER_PAGE''$SUFFIX
            echo -e "\n pageUrl="$pageUrl
            curl $pageUrl > $TMP_GIST_DETAILS_FILE
            GIST_SIZE=$(cat output/tmp_gist_details.json | jq -c '. | length')

            if (( 1 > $GIST_SIZE )); then
                echo -e "\n No Gist found "
                exit 0
            fi
            readarray -t gists < <(jq -c '.[]' $TMP_GIST_DETAILS_FILE)

            IFS=$'\n' 
            for gist in ${gists[@]}; 
                do
                    html_url=$(jq -r '.html_url' <<< "${gist}")
                    file_names=$(jq -r '.files[].filename' <<< "${gist}")
                    raw_file_url=$(jq -r '.files[].raw_url' <<< "${gist}")
                    echo -e "\n========================================================================================================" 
                    echo -e "Gist_Url=$html_url \n Has files \n [$file_names] \n raw_file_url=$raw_file_url"
                    curl $raw_file_url
                done
            unset IFS
        done
    
    EXECUTION_DATE=($(date -u +"%Y-%m-%dT%H:%M:%SZ"))
    echo "{\"since\":\"$EXECUTION_DATE\"}" | jq '.' > $LAST_RUN_PUBLIC_GIST_FILE 
 }

get_pub_gist_for_a_user