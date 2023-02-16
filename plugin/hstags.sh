#! /bin/env bash

# produces
#   .tags - ctags file for the current project
#   .hscope.db - cscope file for the current project
# Err 1 - no ctags gen tool
# Err 2 - no cscope gen tool
# Err 3 - no haskell files
# Err 4 - command execution error
# Err 5 - output file generation failure

ctags_file=".tags"
cscope_file=".hscope.db"

ctags_gen='ghc-tags'
ctags_flags='-c -f '$ctags_file

cscope_gen='hscope'
cscope_flags='-b -f '$cscope_file

# Err 1 - no ctags gen tool
which "$ctags_gen"
if [ $? -ne 0 ] ; then
  printf "Error: $ctags_gen was not found"
  exit 1
fi

# Err 2 - no cscope gen tool
which "$cscope_gen"
if [ $? -ne 0 ] ; then
  printf "Error: $cscope_gen was not found"
  exit 2
fi

# list of .hs files in the current repo
srcs=$(git ls-files -- '*.hs')

# if there is no repository yet, then list all .hs files in the current directory
[ -n "$srcs" ] ||
  # but exclude all hidden directories
  srcs=$(find . \( ! -regex '.*/\..*' \) -type f -name "*.hs")

# Err 3 - no haskell files
if [ -z "$srcs" ] ; then
  printf "Error: No haskell files under $(pwd) directory"
  exit 3
fi

# make ctags or cscope file for all .hs files of the current project
function generate () {
  out="$1"

  if [ "$out" == "$cscope_file" ] ; then
    gencmd="$cscope_gen $cscope_flags"
  else
    gencmd="$ctags_gen $ctags_flags"
  fi

  cmd='echo "$srcs" | xargs '$gencmd

  err="$(eval $cmd 2>&1>/dev/null)"
  if [ -n "$err" ] ; then
    printf "Error: $err" | perl -pe 's/\n//g'
    exit 4
  fi

  # Err 4 - file generation failure
  if [ ! -f "$out" ] ; then
    printf "Error: failed to generate \"$out\" file"
    exit 5
  fi
}

t_action="generated"
[ -f "$ctags_file" ] && t_action="updated"

s_action="generated"
[ -f "$cscope_file" ] && s_action="updated"

generate "$ctags_file"
generate "$cscope_file"
printf "Succes: $t_action $ctags_file file and $s_action $cscope_file file"
