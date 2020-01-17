#!/bin/bash

set -e

USER_EMAIL="${1:-divorce+ccd@gmail.com}"
ENV="${2:-local}"
FORENAME="${3:-Case}"
SURNAME="${4:-Worker}"
PASSWORD=Password12
USER_GROUP="caseworker"
USER_ROLES='[{"code":"caseworker-divorce"}]'

binFolder=$(dirname "$0")

${binFolder}/create-user.sh "${USER_EMAIL}" "${ENV}" "${FORENAME}" "${SURNAME}" "${USER_GROUP}" "${USER_ROLES}"
