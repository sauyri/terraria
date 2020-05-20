#!/bin/sh

echo "\nBootstrap:\nconfigpath=$CONFIGPATH\nworldpath=$WORLDPATH\nlogpath=$LOGPATH\n"
echo "Copying plugins..."
cp -Rfv /plugins/* ./ServerPlugins

mono --server --gc=sgen -O=all TerrariaServer.exe -configPath "/world" -worldpath "/world" -logpath "/tshock/log" -config "/world/serverconfig.txt" "$@" 