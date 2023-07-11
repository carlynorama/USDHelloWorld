#!/bin/sh

#PATH_TO_USDCAT="somepath"
REMOVE_TMP_FLAG=false
TMP_FILE_NAME="smash_tmp.usda"
OUTPUT_NAME="smash_output.usdc"


usdcat --flattenLayerStack $@ > $TMP_FILE_NAME
usdcat -o $OUTPUT_NAME $TMP_FILE_NAME
if $REMOVE_TMP_FLAG; then
    rm $TMP_FILE_NAME
fi