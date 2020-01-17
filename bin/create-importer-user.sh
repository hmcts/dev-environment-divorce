#!/bin/bash

set -e

USER_EMAIL="${1:-ccd-importer@server.net}"
ENV="${2:-local}"
FORENAME=CCD
SURNAME=Importer
PASSWORD=Password12
USER_GROUP="ccd-import"
USER_ROLES='[{"code":"ccd-import"}]'

binFolder=$(dirname "$0")

${binFolder}/create-user.sh "${USER_EMAIL}" "${ENV}" "${FORENAME}" "${SURNAME}" "${USER_GROUP}" "${USER_ROLES}"
