#!/bin/sh

echo "\nBootstrap:\nconfigpath=/world\nworldpath=/world\nlogpath=/log\n"
echo "Copying plugins..."
cp -Rfv /plugins/* /tshock/ServerPlugins

echo "Moving plugins..."
if [ -f "BCrypt.Net.dll" ]; then
	mv BCrypt.Net.dll ServerPlugins/
fi
if [ -f "HttpServer.dll" ]; then
	mv HttpServer.dll ServerPlugins/
fi
if [ -f "Mono.Data.Sqlite.dll" ]; then
	mv Mono.Data.Sqlite.dll ServerPlugins/
fi
if [ -f "MySql.Data.dll" ]; then
	mv MySql.Data.dll ServerPlugins/
fi
if [ -f "TShockAPI.dll" ]; then
	mv TShockAPI.dll ServerPlugins/
fi

mono --server --gc=sgen -O=all TerrariaServer.exe -configPath "/world" -worldpath "/world" -logpath "/log" -config "/world/serverconfig.txt" "$@" 