#!/bin/sh

set -e

USER_EMAIL="divorce+ccd@gmail.com"
FORENAME=DIV
SURNAME=CaseWorker
PASSWORD=Password12
USER_GROUP="caseworker"
USER_ROLES='[{"code":"caseworker-divorce"}]'

/scripts/create-user.sh "${USER_EMAIL}" "${FORENAME}" "${SURNAME}" "${PASSWORD}" "${USER_GROUP}" "${USER_ROLES}"
