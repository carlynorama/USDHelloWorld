#!/bin/sh

#usage, give the script the name of the root file and the root file only, not the full list. 
# can be replaced with `usdcat -o $OUTPUT_NAME --flatten $INPUT_ROOT_FILE``

#PATH_TO_USDCAT="somepath"
REMOVE_TMP_FLAG=false
TMP_FILE_NAME="smash_tmp.usda"
OUTPUT_NAME="smash_output.usdc"

# using $@ (all args) is iffy here since really
# should be passing _one_ file name after all.
usdcat --flatten $@ > $TMP_FILE_NAME
usdcat -o $OUTPUT_NAME $TMP_FILE_NAME
if $REMOVE_TMP_FLAG; then
    rm $TMP_FILE_NAME
fi