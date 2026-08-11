#!/bin/bash

# Function to extract server_name from HTTPS server blocks in config file
extract_server_name() {
    local config_file=$1
    awk '/^\s*server\s*\{/,/^\s*server_name\s+/{flag=1} /^\s*listen\s+.*ssl/ && flag {flag2=1} /^\s*server_name\s+/ && flag && flag2 {for(i=2;i<=NF;i++) print $i; flag=0; flag2=0}' "$config_file" | tr -d ';' | tr ' ' '\n' | sort -u | grep -v '^\s*$'
}

# Main script
if [ $# -eq 0 ]; then
    echo "Usage: $0 <config_file>..."
    exit 1
fi

for config_file in "$@"; do
    if [ -f "$config_file" ]; then
        extract_server_name "$config_file"
    else
        echo "Error: File $config_file not found" >&2
    fi
done
