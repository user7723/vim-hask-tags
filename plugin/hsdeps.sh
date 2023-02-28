#! /bin/env bash

# produces
#   .deps - dir with deps source code
#   .tags.deps - ctags file for all downloaded deps

# complete dependency graph
depth=""
# only direct dependencies
#depth="--depth 1"

if [ $# -ne 2 ] ; then
  echo 'please, provide `deps_dir` and `outfile` file paths as paramters'
  exit 1
fi

deps_dir="$1"
outfile="$2"

# list of package dependencies
pkgs=$(stack ls dependencies --test "$depth" --separator "-" 2>/dev/null)
if [ $? -ne 0 ] ; then
  echo "No stack project was found, perhabs you should run \`stack init\`"
  exit 1
fi

# the project package itself should be skipped
zero=$(stack ls dependencies --depth 0 --separator "-")

msg="Trying to download the source code for the following dependencies"
if [ -z "$depth" ] ; then
  echo "$msg (complete list of deps):"
else
  echo "$msg (only direct deps):"
fi

echo "$pkgs"

exis='    [exist]: '
fail='    [error]: '
unpa='    [done]:  '
skip='    [skip]:  '

for pkg in $pkgs; do
  echo "$pkg"
  # skip target package, for which we download the deps code
  [ "$pkg" == "$zero" ] && echo "$skip$pkg" && continue
  if [ -d "$deps_dir/$pkg" ] ; then
    # the code for package already was downloaded
    echo "$exis$pkg"
  else
    stack --silent unpack $pkg --to $deps_dir
    # otherwise download the source code for the dependency package
    if [ $? -eq 0 ] ; then
      echo "$unpa$pkg"
    else
      echo "$fail$pkg"
    fi
  fi
done

echo "Generating ctags file:"
echo "$outfile"
# generate ctags file for all the dependencies source code
fast-tags -R "$deps_dir" -o"$outfile"
