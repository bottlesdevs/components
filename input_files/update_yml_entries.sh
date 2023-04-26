#!/bin/bash

nameprefix="${1-$NAMEPREFIX}"
namesuffix="${2-$NAMESUFFIX}"
component_name="${3-$NAME}"
category="${4-$CATEGORY}"
subcategory="${5-$SUBCATEGORY}"
channel="${6-$CHANNEL}"
filename="${7-$YAML_FILENAME}"
created_at="${8-$CREATED_AT}"

filename=$(dirname "$0")/$filename
created_at=$(date -d "$created_at" +%s)

GITHUB_ENV=${GITHUB_ENV-/dev/null}

command_wo_sub='{\(\"$component_name\"\): {\"Category\":\"$category\", \"Channel\": \"$channel\", \"Date\": \"$created_at\"}}'
command_w_sub='{\(\"$component_name\"\): {\"Category\":\"$category\", \"Sub-category\": \"$subcategory\", \"Channel\": \"$channel\", \"Date\": \"$created_at\"}}'

empty_file=$(yq "." $filename)
if ! [ -f "$filename" ] || [ -z "$empty_file" ]; then
    touch $filename
    if [ -z "$subcategory" ]; then
        yq -n -i -y "$(eval echo $command_wo_sub)" $filename
    else
        yq -n -i -y "$(eval echo $command_w_sub)" $filename
    fi
    echo "Updated."
    echo "UPDATED=true" >> $GITHUB_ENV
    exit 0
fi

create_entry () {
    if [ -z "$subcategory" ]; then
        yq -i -y "$(eval echo $command_wo_sub) + ." $filename
    else
        yq -i -y "$(eval echo $command_w_sub) + ." $filename
    fi
}

update_entry () {
    yq -i -y "with_entries(if .key == \"$latest\" then .key = \"$component_name\" else . end) | .\"$component_name\".Channel = \"$channel\" | .\"$component_name\".Date = \"$created_at\"" $filename
}

latest=$(yq -r 'path(.[])[0]' $filename | grep -E -m1 "$nameprefix.*[[:digit:]]+$namesuffix")

if [ -z "$latest" ]; then
    create_entry
    echo "Updated."
    echo "UPDATED=true" >> $GITHUB_ENV
    exit 0
fi

latest_channel=$(yq -r ".\"$latest\".Channel" $filename)
latest_date=$(yq -r ".\"$latest\".Date" $filename)

if [ "$latest_date" = "null" ] || [ "$latest_channel" = "null" ]; then
    echo "::error::Cannot find latest commit or channel. Something is wrong with the input file : $filename"
    exit 1
fi

if [ "$channel" = "stable" ] && [ "$latest_channel" = "unstable" ]; then
    # Always superseed an unstable build by a stable one
    newer=1
else
    ((time_diff=$created_at - $latest_date))
    # For unstable builds, update no less than two weeks
    if [ $time_diff -lt 0 ] || ([ "$channel" = "unstable" ] && [ $time_diff -lt $((60 * 60 * 24 * 7 * 2)) ]); then
        newer=0
    else
        newer=1
    fi
fi

already_exists=$(yq -r 'path(.[])[0]' $filename | grep -x -m1 "$component_name")
if [ "$already_exists" != "" ] || ([ "$newer" -eq 0 ] && [ "$channel" = "unstable" ]); then
    echo "Already up to date."
    exit 0
fi

if [ "$newer" -eq 0 ]; then
    echo "::error::Something is wrong : this new entry is older than the previous one."
    exit 1
fi

if [ "$channel" = "unstable" ] && [ "$latest_channel" = "unstable" ]; then
    if [[ $latest =~ .*-([[:digit:]])-[[:alnum:]]{7} ]]; then
        revision="${BASH_REMATCH[1]}"
        commit_sha=${component_name: -7}
        ((revision=$revision+1))
        component_name=${component_name/-1-$commit_sha/-$revision-$commit_sha}
        echo "NAME=$component_name" >> $GITHUB_ENV
    fi
fi

if [ "$latest_channel" = "stable" ]; then
    create_entry
else
    update_entry
fi

echo "Updated."
echo "UPDATED=true" >> $GITHUB_ENV