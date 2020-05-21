#!/bin/sh

echo "\nBootstrap:\nconfigpath=/world\nworldpath=/world\nlogpath=/log\n"
echo "Copying plugins..."
cp -Rfv /plugins/* /tshock/ServerPlugins

echo "Moving plugins..."
if [ -f "/tshock/BCrypt.Net.dll"]; then
	mv /tshock/BCrypt.Net.dll /tshock/ServerPlugins/BCrypt.Net.dll
fi
if [ -f "/tshock/HttpServer.dll"]; then
	mv /tshock/HttpServer.dll /tshock/ServerPlugins/HttpServer.dll
fi
if [ -f "/tshock/Mono.Data.Sqlite.dll"]; then
	mv /tshock/Mono.Data.Sqlite.dll /tshock/ServerPlugins/Mono.Data.Sqlite.dll
fi
if [ -f "/tshock/MySql.Data.dll"]; then
	mv /tshock/MySql.Data.dll /tshock/ServerPlugins/MySql.Data.dll
fi

mono --server --gc=sgen -O=all TerrariaServer.exe -configPath "/world" -worldpath "/world" -logpath "/log" -config "/world/serverconfig.txt" "$@" 