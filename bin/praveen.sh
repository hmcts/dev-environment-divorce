source $(dirname "${BASH_SOURCE[0]}")/setup-environment.sh

echo "docker-compose ${COMPOSE_FILES}"
echo "Starting IDAM(ForgeRock-AM)..."
docker-compose ${COMPOSE_FILES} up -d fr-am
./bin/test-service.sh "fr-am" "http://localhost:8080/openam/isAlive.jsp"

echo "Starting IDAM(ForgeRock-IDM)..."
docker-compose ${COMPOSE_FILES} up -d fr-idm
./bin/test-service.sh "fr-idm" -H "X-OpenIDM-Username: anonymous" -H "X-OpenIDM-Password: anonymous" -X GET "http://localhost:18080/openidm/info/ping"

echo "Starting IDAM..."
docker-compose ${COMPOSE_FILES} up idam-api \
                                           idam-web-public \
                                           idam-web-admin \
                                          idam-importer
./bin/test-service.sh "idam-api" "http://localhost:5000/health"
./bin/test-service.sh "idam-web-public" "http://localhost:9002/health"
./bin/test-service.sh "idam-web-admin" "http://localhost:8082/health"

echo "Testing IDAM Authentication..."
token=$(./bin/idam-authenticate.sh http://localhost:5000 idamowner@hmcts.net Ref0rmIsFun)

if [[ "_${token}" = "_" ]]; then
  echo "Something wrong! Check logs for fr-am, fr-idm, idam-api - restart each in this order, then re-run. Failed to authenticate IDAM admin user. Script terminated."
  exit 1
fi
echo "IDAM Authentication is OK!"
