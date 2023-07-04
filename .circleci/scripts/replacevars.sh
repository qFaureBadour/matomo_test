
#!/bin/bash
###########################################################################################
# The goal of this script is to replace variables dynamically in config files
###
# if 1 arg is supplied, then the vars that match a pattern (see pattern var) are replaced 
# by loaded env vars
###
# if 2 args are supplied , then the first one is a template , and the second one
# is generated from this template
###########################################################################################
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
    echo -e "$color_of_output$line"
    echo -e "$color_of_output$string_to_print"
    echo -e "$color_of_output$line\e[39m"
}

## Init vars ##
branch_config_file=$1
if [[ -n "$2" ]];then final_file=$2; else final_file=$branch_config_file; fi
pattern_of_values_to_be_replaced="<[A-Za-z1-9_-]*>"
RED="\e[31m"
DEFAULTCOLOR="\e[39m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
##############

### SCRIPT START ###
pimpmylog "-- Config file variable replacing script START -- " $GREEN

if [[ $branch_config_file != $final_file ]]; then 
    cp $branch_config_file $final_file
fi

# extract values that we want to replace from the env file
targets=($(grep -o $pattern_of_values_to_be_replaced $final_file))
length=${#targets[@]}

# Iterate over the previously extracted values
for ((i = 0; i != length; i++)); do

    # delete <> around the value
    value=${targets[i]//[<>]}
    echo -e "$BLUE target $i: '$value' = '${!value}' $DEFAULTCOLOR"

    # replace the value by it's namesake
    # use pipes in sed to avoid escaping in variables
    sline="s|<$value>|${!value}|g"
    sed -i "$sline" $final_file
done
echo ""
pimpmylog "-- Config file variable replacing script END --" $GREEN 
### SCRIPT END ###