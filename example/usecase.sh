#!/usr/bin/env bash

# create read client access token
curl -X POST --user {client_id}:{client_secret} 'https://car-plates-api-auth-development.auth.eu-central-1.amazoncognito.com/oauth2/token' -H 'Content-Type: application/x-www-form-urlencoded' -d 'grant_type=client_credentials&scope=ApiGateway/api.read,ApiGateway/api.read'  | json | pygmentize -l json

# read from api
curl https://15ovzyw9na.execute-api.eu-central-1.amazonaws.com/development/plate/PO1234 -H 'Authorization:{ACCESS_TOKEN}'  | json | pygmentize -l json


# create write client access token
curl -X POST --user {client_id}:{client_secret} 'https://car-plates-api-auth-development.auth.eu-central-1.amazoncognito.com/oauth2/token' -H 'Content-Type: application/x-www-form-urlencoded' -d 'grant_type=client_credentials&scope=ApiGateway/api.write'  | json | pygmentize -l json


# write to api
curl -i https://15ovzyw9na.execute-api.eu-central-1.amazonaws.com/development/plate -H 'Authorization:{ACCESS_TOKEN}' -d '{"platenumber":"PO5555"}' | grep HTTP



# create multi scope access token
curl -X POST --user {client_id}:{client_secret} 'https://car-plates-api-auth-development.auth.eu-central-1.amazoncognito.com/oauth2/token' -H 'Content-Type: application/x-www-form-urlencoded' -d 'grant_type=client_credentials&scope=ApiGateway/api.read ApiGateway/api.write'  | json | pygmentize -l json
