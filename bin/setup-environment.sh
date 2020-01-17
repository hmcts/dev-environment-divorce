#!/bin/sh
## initialize common variable

COMPOSE_FILES_GLOBAL_DEFINITION="-f docker-compose.override.yaml"
COMPOSE_FILES_LOCAL_OVERRIDE="-f docker-compose-local.yaml"

COMPOSE_FILES="${COMPOSE_FILES_GLOBAL_DEFINITION} ${COMPOSE_FILES_LOCAL_OVERRIDE} "