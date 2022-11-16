#!/bin/bash

DIR=$(dirname "$0")

rm "$DIR/index.yml"
echo -e "# -----------------------" >> "$DIR/index.yml"
echo -e "# DO NOT EDIT !!!" >> "$DIR/index.yml"
echo -e "# THIS FILE HAS BEEN GENERATED AUTOMATICALLY" >> "$DIR/index.yml"
echo -e "# DO YOUR MODIFICATION IN THE 'input_files' DIRECTORY INSTEAD" >> "$DIR/index.yml"
echo -e "# -----------------------" >> "$DIR/index.yml"
readarray -d '' entries < <(printf '%s\0' "$DIR/input_files/"*.yml | sort -zV)
for entry in "${entries[@]}"; do
   echo -e "\n# $entry" >> "$DIR/index.yml"
   echo -e "# -----------------------" >> "$DIR/index.yml"
   cat "$entry" >> "$DIR/index.yml"
done
