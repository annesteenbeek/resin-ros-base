#!/bin/bash

# receive which version should be build
# which file is the template file
# use SED remove all %%*.!$type.component%% occurences
# Use AWK to get all %%*.components%%  /^[^#]*(?<=%%)(.*)(?=%%)))/mg
# AWK current regex: awk '/(^(%%[^#](.*)))/{print}' file
# Use sed to replace all these with their file equivalent
# fill in variables @

TEMPLATE=$1
TYPE=$2

DNAME=Dockerfile

touch "$DNAME" # create dockerflie if not already exists
cat "$TEMPLATE" > "$DNAME" # put template in Dockerfile

sed -e '/SUBS/' 
