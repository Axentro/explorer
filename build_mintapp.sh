#!/bin/sh -uex

# Build Axentro static binaries for GNU/Linux x86_64 via Docker

MY_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)/src/explorer/web/static
if [ -d $MY_DIR/dist ]
then
    rm -rf $MY_DIR/dist
fi

MINT_BIN=$(which mint)
if [ ! -x $MINT_BIN ]
then
    echo "Mint binary was not found!!!"
    exit 42
fi

cd $MY_DIR

$MINT_BIN format
$MINT_BIN build --skip-service-worker

cd "$OLDPWD"

exit 0
