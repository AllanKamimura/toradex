#!/bin/bash

git_clone() {
  local branch=""

  # Parse options
  while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
    --branch )
      shift; branch=$1
      ;;
  esac; shift; done
  if [[ "$1" == '--' ]]; then shift; fi

  if [ -z "$1" ]; then
    echo "Usage: git_clone_like [--branch <branch_name>] <github-repo-url>"
    return 1
  fi

  repo_url="$1"
  repo_name=$(basename "$repo_url" .git)
  user_name=$(basename $(dirname "$repo_url"))

  # If branch is not provided, get the default branch from GitHub API
  if [ -z "$branch" ]; then
    branch=$(curl -s "https://api.github.com/repos/$user_name/$repo_name" | grep '"default_branch":' | cut -d '"' -f 4)
    if [ -z "$branch" ]; then
      echo "Failed to get the default branch from GitHub API."
      return 1
    fi
    echo "Default branch is $branch."
  fi

  # Construct the URL for the ZIP file
  zip_url="https://github.com/$user_name/$repo_name/archive/refs/heads/$branch.zip"

  # Create a target directory
  mkdir -p "$repo_name"
  cd "$repo_name" || return 1

  echo "Downloading repository from $zip_url..."
  curl -L -o "${repo_name}.zip" "$zip_url"

  echo "Extracting files..."
  unzip "${repo_name}.zip" > /dev/null

  # Move extracted files to the root of the target directory
  mv "${repo_name}-${branch}"/* .
  rm -rf "${repo_name}-${branch}" "${repo_name}.zip"

  echo "Repository cloned into $(pwd)"
}
