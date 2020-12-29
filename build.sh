#!/bin/sh -uex

# Build Axentro explorer

MY_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
if [ -d $MY_DIR/[bin|lib] ]
then
    rm -rf $MY_DIR/[dist|lib]
fi

if [ -x $MY_DIR/build_mintapp.sh ]
then
    $MY_DIR/build_mintapp.sh
fi

if [ -d $HOME/opt/crystal-0.35.0-1/bin ]
then
    PREFIX=$HOME/opt/crystal-0.35.0-1/bin
fi

$PREFIX/shards install --production
$PREFIX/shards build --no-debug --release --production

cd "$OLDPWD"

exit 0
