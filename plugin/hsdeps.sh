#! /bin/env bash

# produces
#   .deps - dir with deps source code
#   .tags.deps - ctags file for all downloaded deps

# complete dependency graph
depth=""
# only direct dependencies
#depth="--depth 1"

deps_dir=.deps
outfile=.tags.deps

# list of package dependencies
pkgs=$(stack ls dependencies --test "$depth" --separator "-")

# the project package itself should be skipped
zero=$(stack ls dependencies --depth 0 --separator "-")

msg="Trying to download the source code for the following dependencies"
if [ -z "$depth" ] ; then
  echo "$msg (complete list of deps):"
else
  echo "$msg (only direct deps):"
fi

echo $pkgs

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
    # otherwise download the source code for the dependency package
    if [ $(stack --silent unpack $pkg --to $deps_dir) ] ; then
      echo "$fail$pkg"
    else
      echo "$unpa$pkg"
    fi
  fi
done

echo "Generating ctags file:"
echo "$outfile"
# generate ctags file for all the dependencies source code
fast-tags -R "$deps_dir" -o"$outfile"
