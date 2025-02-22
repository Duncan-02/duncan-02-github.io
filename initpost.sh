#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Program: initpost.sh
# Author:  Vitor Britto (Modified for optional parameters)
# Description: Script to create an initial structure for blog posts.
#
# Usage: ./initpost.sh -c "Title" ["Image URL"] ["Category"]
#
# ------------------------------------------------------------------------------

# CORE VARIABLES
TITLE="$2"         # Post title (required)
IMAGE="${3:-}"     # Image URL (optional)
CATEGORY="${4:-}"  # Category (optional)

# Generate a clean filename from the title only
POST_NAME="$(echo "${TITLE}" | sed -e 's/ /-/g' | sed 's/[^a-zA-Z0-9_-]//g' | tr '[:upper:]' '[:lower:]')"
CURRENT_DATE="$(date -u +'%Y-%m-%d')"
TIME="$(date -u +"%T")"
FILE_NAME="${CURRENT_DATE}-${POST_NAME}.md"

# Destination folder
BINPATH=$(cd "$(dirname "$0")"; pwd)
POSTPATH="${BINPATH}/_posts"
DIST_FOLDER="$POSTPATH"

# Ensure directory exists
mkdir -p "$DIST_FOLDER"

# UTILS
e_header() { printf "$(tput setaf 38)→ %s$(tput sgr0)\n" "$@"; }
e_success() { printf "$(tput setaf 76)✔ %s$(tput sgr0)\n" "$@"; }
e_error() { printf "$(tput setaf 1)✖ %s$(tput sgr0)\n" "$@"; }
e_warning() { printf "$(tput setaf 3)! %s$(tput sgr0)\n" "$@"; }

# Help Function
initpost_help() {
cat <<EOT
Usage: ./initpost.sh -c "Title" ["Image URL"] ["Category"]
Examples:
  ./initpost.sh -c "My New Post" "image.jpg" "Technology"
  ./initpost.sh -c "Post Without Image" "" "Science"
  ./initpost.sh -c "Post Without Image and Category"
EOT
}

# Post Content Template
initpost_content() {
cat <<EOT
---
date: ${CURRENT_DATE} ${TIME}
layout: post
title: "${TITLE}"
subtitle: ""
description: ""
EOT

if [ -n "$IMAGE" ]; then
    echo "image: \"$IMAGE\""
    echo "optimized_image: \"$IMAGE\""
fi

if [ -n "$CATEGORY" ]; then
    echo "category: \"$CATEGORY\""
fi

cat <<EOT
tags: []
author: ""
paginate: false
---
EOT
}

# Create File
initpost_file() {
    FULL_PATH="${DIST_FOLDER}/${FILE_NAME}"
    if [ ! -f "$FULL_PATH" ]; then
        e_header "Creating template..."
        initpost_content > "$FULL_PATH"
        e_success "Post successfully created: ${FULL_PATH}"
    else
        e_warning "File already exists: ${FULL_PATH}"
        exit 1
    fi
}

# Main Function
main() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        initpost_help
        exit
    fi

    if [[ "$1" == "-c" || "$1" == "--create" ]]; then
        if [ -z "$TITLE" ]; then
            e_error "Error: No title provided!"
            exit 1
        fi
        initpost_file
        exit
    fi
}

# Run
main "$@"
