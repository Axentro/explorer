#!/bin/sh -uex

# Build Axentro explorer

MY_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
for dir in $MY_DIR/bin $MY_DIR/lib
do
    if [ -d $dir ]
    then
        rm -rf $dir
    fi
done

if [ -x $MY_DIR/build_mintapp.sh ]
then
    $MY_DIR/build_mintapp.sh
fi

if [ -d $HOME/opt/crystal-0.35.0-1/bin ]
then
    PREFIX=$HOME/opt/crystal-0.35.0-1/bin
fi

if [ -e $MY_DIR/shard.lock ]
then
    $PREFIX/shards update --production
else
    $PREFIX/shards install --production
fi

$PREFIX/shards build --no-debug --release --production

cd "$OLDPWD"

exit 0
