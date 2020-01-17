#!/bin/bash

source $(dirname "${BASH_SOURCE[0]}")/setup-environment.sh

docker-compose ${COMPOSE_FILES} up ${@} -d ccd-case-management-web \
                                           ccd-api-gateway
