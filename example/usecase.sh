#!/usr/bin/env bash


curl -X POST --user {client_id}:{client_secret} 'https://carplates-api-auth-development.auth.eu-central-1.amazoncognito.com/oauth2/token' -H 'Content-Type: application/x-www-form-urlencoded' -d 'grant_type=client_credentials&scope=ApiGateway/api.read'  | json | pygmentize -l json



curl https://15ovzyw9na.execute-api.eu-central-1.amazonaws.com/development/plate/PO1234 -H 'Authorization:{ACCESS_TOKEN}'  | json | pygmentize -l json


