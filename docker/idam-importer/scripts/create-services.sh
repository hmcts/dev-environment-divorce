#!/bin/sh

set -e

/scripts/create-service.sh "Citizen" "true" "divorce" "12345678" "[\"https://localhost:3000\"]" "[\"citizen\"]"
/scripts/create-service.sh "Caseworker" "false" "divorce" "12345678" "[\"https://localhost:3000\"]" "[\"caseworker-divorce\"]"
# # CCD
/scripts/create-service.sh "CCDGateway" "false" "ccd_gateway" "12345678" "[\"http://localhost:3451/oauth2redirect\"]" "[\"caseworker\",\"caseworker-divorce\"]"
