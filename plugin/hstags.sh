#! /bin/env bash

# produces
#   .tags - ctags file for the current project
#   .hscope.db - cscope file for the current project

tags_file=".tags"
scope_file=".hscope.db"

# list of .hs files in the current repo
srcs=$(git ls-files -- '*.hs')

# if there is no repository yet, then list all .hs files in the current directory
[ -n "$srcs" ] ||
  # but exclude all hidden directories
  srcs=$(find . \( ! -regex '.*/\..*' \) -type f -name "*.hs")

# make ctags or cscope file for all .hs files of the current project
function generate () {
  toggle="$1"
  out="$2"
  gencmd='ghc-tags -c'
  [ "$toggle" == "ctags" ] || gencmd='hscope -b'

  cmd='echo "$srcs" | xargs '$gencmd' -f '$out

  action="Updating"
  [ -f "$out" ] || action="Generating"

  echo "${action} ${toggle} file (${out}) for project source code..."
  eval "$cmd" && echo "done"
}

generate 'ctags' "$tags_file"
generate 'cscope' "$scope_file"
