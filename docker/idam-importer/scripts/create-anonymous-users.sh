#!/bin/sh

set -e

PASSWORD="Password12"
ROLES='[{"code":"caseworker-divorce"},{"code":"citizen"}]'
/scripts/create-user.sh "divorce_as_caseworker_beta@mailinator.com" "Divorce" "AnonUser" "${PASSWORD}" "caseworker" "${ROLES}"
