#!/bin/sh

apk update
apk add git
git clone https://github.com/baokong/kong-plugin-gql-dealership.git

apk add httpie
http post :8001/services/ name=gql-server url=http://host.docker.internal:4000
http post :8001/services/gql-server/routes hosts:='["dealership.com"]'

cd /kong-plugin-gql-dealership
luarocks make
cd /

export KONG_PLUGINS=bundled,gql-dealership
kong reload

http post :8001/services/gql-server/plugins/ name=gql-dealership
kong prepare
kong reload


