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
    -a FILE   path to authors file
    -u URL    url of SVN repository
EOF
}

svn_url=""
authors_file="authors.list"

OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.
while getopts ":ha:u:" opt; do
  case "$opt" in
    h)
        show_help
        exit 0
        ;;
    a)  authors_file=$OPTARG
        ;;
    u)  svn_url=$OPTARG
        ;;
    '?')
        show_help >&2
        exit 1
        ;;
  esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.


echo "Writing authors from SVN-server $svn_url to file $authors_file."
svn log -q $svn_url | \
   awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); \
   print $2" = "$2" <"$2">"}' | sort -u >> $authors_file

echo "$authors_file written, please adjust the author names."

#eof