#!/usr/bin/env bash
############################################################################
#  replace env variables from CIRCLE CI project ENV ( Magento Env + AWS Env)
############################################################################
# Const
RED="\e[31m"
DEFAULTCOLOR="\e[39m"
GREEN="\e[32m"
YELLOW="\e[33m"
## default
project_home=/var/www/project
comment_pattern="^\#.*"
replacevars_script=$project_home/.circleci/scripts/replacevars.sh

pimpmylog(){
# print a message in a nice insert
# $1 is the string to print
# $2 is the color code
    string_to_print=$1
    if [[ ! -z $2 ]];then
        color_of_output=$2
    else
        color_of_output="\e[39m"
    fi
    seize_of_string=${#string_to_print}
    line=''
    i=1
    while [ $i -le $seize_of_string ];do
        line="${line}-"
        i=$((i+1))
    done
    echo -e "$color_of_output$line\n$color_of_output$string_to_print\n$color_of_output$line\e[39m"
}

## init vars##
## Project  specific
dtc_env=$project_home/.circleci/.env_dtc/${CIRCLE_BRANCH}.env
vuejs_env=$project_home/.circleci/.env_vuejs/${CIRCLE_BRANCH}.env
npm_env=$project_home/.circleci/.env_npm/${CIRCLE_BRANCH}.env
capistrano_configfile=$project_home/.circleci/scripts/capistrano/deploy.rb

## Continuous integration scripts ##
# VUEJS config
pimpmylog "-- VUEJS .env config --" $YELLOW
$replacevars_script $vuejs_env $project_home/.env

pimpmylog " $project_home/.env file content : " $GREEN
cat $project_home/.env && echo ""

# NPMRC config
pimpmylog "-- NPMRC .env config --" $YELLOW
$replacevars_script $npm_env $HOME/.npmrc
pimpmylog " $HOME/.npmrc file content : " $GREEN
cat $HOME/.npmrc && echo ""

# DEPLOY CONFIG
pimpmylog "-- DTC data replacement --" $YELLOW
$replacevars_script $dtc_env

# Read the file line per line and ignore the comments
# Then export the var in the $BASH_ENV to make it reusable for next bash instances
while IFS= read -r line || [[ -n $line ]]
    do
        if ! [[ $line =~ $comment_pattern ]]; then echo "$line" >> $BASH_ENV; fi
    done < $dtc_env
    . $BASH_ENV

# Replace values in task definition config file
pimpmylog "--Capistrano Config --" $YELLOW
$replacevars_script $capistrano_configfile
