# Take Home Test from Equal Experts

Github API
    - Write a script that uses the Github API to query a user’s publicly available gists. 

    - When the script is first run, it should display a listing of all the user’s publicly available gists. 
    
    - On subsequent runs the script should list any gists that have been published since the last run. 
    
    - The script may optionally provide other functionality (possibly via additional command line flags) but the above functionality must be implemented.

 # Solution Execution Pre-requisite

   - Jq Installed on local machine (Tested on jq-1.5-1-a5b5cbe)

   - GithubApi Token
   - Save your token in input/secrets/gitapi_token.json

 # Execute Solution

    iacspike > sh ./get_all_public_gist.sh
.

    Second time it will fetch the since last execution time as saved in output/list-public-gists.lastRun

    iacspike > sh ./get_all_public_gist.sh
.

    For verification of since last run append 
    output/list-public-gists.lastRun to different date & run shell again

    and see diff of output
    
    diff output/list-public-gists.json_2022-06-20T00\:25\:10+0100.json output/list-public-gists.json_2022-06-26T00\:25\:10+0100.json 

### Sample Run screenshot as attached ### 

<img src="PreviewEE.gif"  width="1000" height="600"> 

 # Troubleshooting
   
  Verify if you have saved your token at write path

  iacspike > jq -r .token secrets/gitapi_token.json

# Future add on functionality for query parameters

  Append input/list_pub_gist_params/parameters.json with 
  iacspike > sh ./get_all_public_gist.sh 1

 # References

 https://docs.github.com/en/rest/gists/gists#list-public-gists