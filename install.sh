#!/bin/bash
# provisioning script to run on server; assumes Debian-based distro
# copy contents of the paramazon repo to the server and run this script

set -o errexit

BASEPATH=${1:-"/usr/local/openresty"}

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y libpcre3-dev build-essential libssl-dev sudo libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make luarocks lua-socket lua-expat vim

luarocks install luacrypto
luarocks install lua-cjson

wget http://openresty.org/download/ngx_openresty-1.4.2.9.tar.gz
tar xzvf ngx*.tar.gz
cd ngx_*
./configure --prefix=$BASEPATH --with-luajit
make
sudo make install

mkdir -p /app/{conf,html,logs}
PATH=$BASEPATH/nginx/sbin:$PATH

cp app.lua affiliate_request.lua base64.lua private.lua /app
cp nginx.conf $BASEPATH/nginx/conf/mime.types /app/conf
cp index.html /app/html

echo
echo to start the server run: nginx -c /app/conf/nginx.conf
