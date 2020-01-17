#!/bin/bash

source $(dirname "${BASH_SOURCE[0]}")/login.sh

source $(dirname "${BASH_SOURCE[0]}")/setup-environment.sh

if [ ${#} -gt 0 ]
then
  docker-compose ${COMPOSE_FILES} pull ${@}
else
  docker-compose ${COMPOSE_FILES} pull
fi