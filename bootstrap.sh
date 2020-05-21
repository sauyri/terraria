#!/bin/sh

echo "\nBootstrap:\nconfigpath=/world\nworldpath=/world\nlogpath=/log\n"
echo "Copying plugins..."
cp -Rfv /plugins/* ./tshock/ServerPlugins

mono --server --gc=sgen -O=all TerrariaServer.exe -configPath "/world" -worldpath "/world" -logpath "/log" -config "/world/serverconfig.txt" "$@" 