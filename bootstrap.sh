#!/bin/sh

echo "\nBootstrap:\nconfigpath=$CONFIGPATH\nworldpath=$WORLDPATH\nlogpath=$LOGPATH\n"
echo "Copying plugins..."
cp -Rfv /plugins/* ./tshock/ServerPlugins

mono --server --gc=sgen -O=all /tshock/TerrariaServer.exe -configPath "/world" -worldpath "/world" -logpath "/log" -config "/world/serverconfig.txt" "$@" 