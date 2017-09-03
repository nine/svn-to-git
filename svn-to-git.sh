#!/bin/bash
# 
# This file is part of the svn-to-git distribution (https://github.com/nine/svn-to-git).
# Copyright (c) 2017 Erwin Nindl.
# 
# This program is free software: you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as published by  
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

# exit on error 
set -e

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] -c FILE -u URL 
Update owncloud installations

    -h        display this help and exit
    -a FILE   path to authors-file
    -u URL    url of the SVN-server
    -v        verbose mode. Can be used multiple times for increased
              verbosity.
EOF
}

verbose=0
svn_url=""
trunk="trunk"
branches="branches"
tags="tags"
authors_file="authors.list"
local_dir="."


OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.
while getopts ":ha:d:t:b:T:u:v" opt; do
  case "$opt" in
    h)
        show_help
        exit 0
        ;;
    a)  authors_file=$OPTARG
        ;;
    d)  local_dir=$OPTARG
        ;;
    t)  trunk=$OPTARG
        ;;
    b)  branches=$OPTARG
        ;;
    T)  tags=$OPTARG
        ;;
    u)  svn_url=$OPTARG
        ;;
    v)  verbose=$((verbose+1))
        ;;
    '?')
        show_help >&2
        exit 1
        ;;
  esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.


# Validate input data
if [ ! -e "$authors_file" ]; then
  echo "Please provide a existing SVN authors file, given path: $authors_file."
  exit 1
fi
authors_file=`realpath $authors_file`
if [ ! -d "$local_dir" ]; then
  echo "Please provide a existing local directory, given path: $local_dir."
  exit 1
fi

# Get SVN repository name
svn_repo_name=${svn_url:7}
svn_repo_name=${svn_repo_name#*/}

echo "Clone SVN repository $svn_url to $local_dir"
cd "$local_dir"
git svn clone "$svn_url" --trunk="$trunk" --branches="$branches" --tags="$tags" --authors-file="$authors_file"
cd "$svn_repo_name"

echo "Convert ignored files properties and add them to .gitignore"
git svn show-ignore -i origin/trunk > .gitignore
git add .gitignore
git commit -m 'Convert svn:ignore properties to .gitignore.'

exit 0

echo "Convert importet SVN-tags, i.e. single-node SVN-branches, to real GIT-tags"
git for-each-ref --format='%(parent):%(refname:strip=4)' refs/remotes/origin/tags | 
while read ref
do
  tag_name=${ref#*:}
  tag_ref=${ref%%:*}
  git tag -a -m "Converting SVN tags $ref (tag_ref)" $tag_name $tag_ref
  git branch -r -d "origin/tags/$ref"
done

echo "Result"
git tag --list





#eof