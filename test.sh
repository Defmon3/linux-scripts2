#!/usr/bin/env bash
core_utils=`echo "xargs find mv sed awk" | tr ' ' '\n'`
selected=`printf "$core_utils" | fzf`
read -p "Query: " query
curl cht.sh/$selected~$query