#

source $(dirname "${BASH_SOURCE[0]}")/setup-environment.sh

# cmc doesn't have it, refer to cmc-integration-test known issues #2
#echo "Starting shared-db"
#docker-compose ${COMPOSE_FILES} up ${@} -d shared-db
#./bin/test-service.sh "shared-db" "http://localhost:5432/health"

echo "docker-compose ${COMPOSE_FILES}"
echo "Starting IDAM(ForgeRock-AM)..."
docker-compose ${COMPOSE_FILES} up -d fr-am
./bin/test-service.sh "fr-am" "http://localhost:8080/openam/isAlive.jsp"

echo "Starting IDAM(ForgeRock-IDM)..."
docker-compose ${COMPOSE_FILES} up -d fr-idm
./bin/test-service.sh "fr-idm" -H "X-OpenIDM-Username: anonymous" -H "X-OpenIDM-Password: anonymous" -X GET "http://localhost:18080/openidm/info/ping"

echo "Starting IDAM..."
docker-compose ${COMPOSE_FILES} up -d idam-api \
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

echo "Starting Serivce Auth Provider and shared-database..."
docker-compose ${COMPOSE_FILES} up -d service-auth-provider-api \
                                      shared-database
./bin/test-service.sh "service-auth-provider-api" "http://localhost:4552/health"

echo "Starting CCD..."
docker-compose ${COMPOSE_FILES} up ${@} -d ccd-data-store-api \
                                           ccd-definition-store-api \
                                           ccd-user-profile-api \
                                           ccd-api-gateway \
                                           dm-store \
                                           ccd-importer \
                                           
./bin/test-service.sh "dm-store" "http://localhost:4460/health"
./bin/test-service.sh "ccd-api-gateway" "http://localhost:3453/health"
./bin/test-service.sh "ccd-data-store-api" "http://localhost:4452/health"
./bin/test-service.sh "ccd-definition-store-api" "http://localhost:4451/health"
./bin/test-service.sh "ccd-user-profile-api" "http://localhost:4453/health"

echo "Starting Backend Services..."
docker-compose ${COMPOSE_FILES} up -d div-cms \
                                      div-cos \
                                      div-fees-and-payments \
                                      div-evidence-management \
                                      div-payments-api \
                                      div-case-data-formatter \
                                      draft-store-api

#./bin/test-service.sh "div-cos" "http://localhost:4012/health"
#./bin/test-service.sh "div-cms" "http://localhost:4010/health"
#./bin/test-service.sh "div-fees-and-payments" "http://localhost:4009/health"
#./bin/test-service.sh "div-evidence-management" "http://localhost:4006/health"
#./bin/test-service.sh "div-payments-api" "http://localhost:4421/health"
#./bin/test-service.sh "div-case-data-formatter" "http://localhost:4011/health"
#./bin/test-service.sh "draft-store-api" "http://localhost:8800/health"

echo "Starting Redis and SMTP..."
docker-compose ${COMPOSE_FILES} up -d redis \
                                      smtp-server

echo "Starting Frontend Services..."
docker-compose ${COMPOSE_FILES} up -d div-pfe \
                                      div-rfe \
                                      div-dnfe \
                                      div-dafe
#./bin/test-service.sh "div-pfe" "https://localhost:3000/health"
#./bin/test-service.sh "div-rfe" "https://localhost:8084/health"
#./bin/test-service.sh "div-dnfe" "https://localhost:8085/health"
#./bin/test-service.sh "div-dafe" "https://localhost:8086/health"

echo "LOCAL ENVIRONMENT SUCCESSFULLY STARTED"

































