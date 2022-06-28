# Take Home Test from Equal Experts

Github API
    - Write a script that uses the Github API to query a user’s publicly available gists. 

    - When the script is first run, it should display a listing of all the user’s publicly available gists. 
    
    - On subsequent runs the script should list any gists that have been published since the last run. 
    
    - The script may optionally provide other functionality (possibly via additional command line flags) but the above functionality must be implemented.

 # Solution Execution Pre-requisite

   - Jq Installed on local machine (Tested on jq-1.5-1-a5b5cbe)
   - Bash (Tested on GNU bash, version 4.4.20()

 # Execute Solution

    iacspike > ./get_pub_gist_for_a_user.sh <username>
.


### Sample Run screenshot as attached ### 

<img src="PreviewEE.gif"  width="1000" height="800"> 

 # Troubleshooting
   
  Verify if you have saved your token at write path

  iacspike > jq -r .token secrets/gitapi_token.json

# Future add on functionality for query parameters

  Append input/list_pub_gist_params/parameters.json with 
  iacspike > sh ./get_pub_gist_for_a_user.sh 1

 # References

 https://docs.github.com/en/rest/gists/gists#list-public-gists