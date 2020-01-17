# Local Dev Environment - Incomplete

Aim is to create a local dev environment that does not rely on AAT.  
Based on CMC-Integration-Test.

## Getting Started

### Prerequisites
* [Docker](https://www.docker.com/)
* You might need to increase the allocated memory for docker ( up to 6G to 8G ) 
* azure cli: `brew install azure-cli`
* jq: `brew install jq`
* Minimum 8Gb memory assigned to Docker. The default is 2Gb so you will need to change.

### Pulling Images or Building Locally
Clone this repo into the same directory as all the services.

```
hmcts
  |__div-petitioner-frontend
  |__dev-environnent-divorce
  |__...

```
Default assumes all services are built locally and the docker file for each is in the root directory.

#### Using Azure Repository Images
Can be changed to use Azure image by going into `setup-environment.sh` and 
changing `COMPOSE_FILES_GLOBAL_DEFINITION` to equal `docker-compose.yaml.


`az login` - will open a browser where you can login with your HMCTS email. This will add long lived token locally. You only need to do this once really. 

If you get authentication errors with hmctspublic run `./bin/login.sh` after adding your subscription key (which is shown after the above).

`./bin/pull-latest.sh` - a helper script that includes the command for logging into ACR.

If you get any authentication errors pulling public Docker-hub images try logging out of any repositories in Docker (`docker logout` or click icon, navigate to account and click sign out).

---

## Local Dev Environment
Still a work in progress. Missing environment variables and broken services.
Known issues will be listed later on.

### Starting
To use the compose files run
```bash
./bin/start-local-environment.sh
``` 

This will:
- Start all services including all frontend, backend and external services.
- Expose ports to the host so all APIs and Databases will be accessible. 

To stop the environment run
```bash
./bin/stop-local-environment.sh
```

---

## IDAM

IDAM is pre-populated using a local IDAM importer helper service. A list of what is 
added can be found in `docker/idam-importer/scripts/`.

### Checking components

We have several components that need to work for full IDAM functionality to work. To check IDAM is up and functioning do all of the following:

#### IDAM API
http://localhost:5000/swagger-ui.html#!/users45controller/loginUserUsingPOST - login with IDAM admin user

*success*: if you get a 200 response with token (Token can used to test endpoints - Auth token is "Bearer INSERT_TOKEN")

#### IDAM Web Admin
http://localhost:8082/login - login with IDAM admin user (detail can be found [here](https://tools.hmcts.net/confluence/display/SISM/Local+Docker+Setup))

*success*: click manage services - you should see Divorce services (currently 2 incl 1 CCD)

#### ForgeRock AM
http://localhost:8080/openam/XUI/#login/ - login with IDAM admin user

*success*: click HMCTS realm, subjects - you should see a list of configured users plus any you have added

#### ForgeRock IDM
http://localhost:18080/#login/ - login with default credentials: `openidm-admin & openidm-admin`

*success*: click profile icon, admin view, configure, mappings - you should see a list of configured users plus any you have added

---

## CCD

### Start CCD Management Web UI
If docker's local environments are already running, then execute following

  ```bash
  $ ./bin/start-local-ccd-web.sh
  ```
  else
  
  ```bash
  $ ./bin/start-local-environment.sh
  
  $ ./bin/start-local-ccd-web.sh
  ```

Open http://localhost:3451 and login with caseworker user pre-initialised in IDAM - see docker/idam-importer.

### Managing CCD definition's

Definitions are managed in: https://github.com/hmcts/div-ccd-definitions/

---

## Current Issues - TODO

1. IDAM web public authentication is not working
2. Draft-Store API is missing roles in db
3. Some services are not registering on "/health" of some services
4. Environment variables may need to change to accommodate local services.

## Known Issues + fixes
1. Citizen login not working but...you can login via swagger with admin user and see your user in GET /users(getUserByEmail) call so the user does exist.

   *Solution*: components have fallen out of sync. Open ForgeRock IDM UI click profile icon, admin view, configure, mappings. Hit Reconcile on all the mappings. This might take a minute or two to take effect.
    (Not working for current issue)
    
2. When you login to IDAM Web Admin you see a `Sorry, there's a problem with this service`.

   *Solution*: open IDAM db (shared-db docker-compose service) in Postico: `localhost:5429` with default credentials: `openidm & openidm`. Open `fridm` DB and empty `service` table. Re-run `idam-importer` docker-compose service with: `./bin/update-idam-importer`. Re-try IDAM Web Admin login. E.g. from the command line:
    ```
    docker-compose exec shared-db psql openidm openidm
    SET search_path TO fridam;
    truncate service;
    \q
    bin/update-idam-importer.sh
    ```
3. CCD Data Store application fails with error `cannot acquire liquibase changelog lock`
    *Meaning*: Postgresql database locking mechanism was quick during locking and is now in a deadlock.
    *Solution*: 
    - Access the terminal of `shared-database` using `docker exec -it <CONTAINER_NAME> bash`
    - Login into the db `psql -u <DATABASE_NAME>` (can be found in a .env file)
    - Unlock db with `UPDATE DATABASECHANGELOGLOCK SET LOCKED=FALSE, LOCKGRANTED=null, LOCKEDBY=null where ID=1;`
    
---

## What is left to do:
- [ ] Add option to build all services but the service they are working on
- [ ] Mounting volumes on some services to retain data
- [ ] Add ability to run all integration tests
- [ ] Add option to run STUB IDAM when having issues with IDAM docker images

---

## Notes
- All div services have a /health endpoint which shows
only if the services it relies are on up. A service's health is only based on the overall health of the services it relies on.

- Ports can be changed in the `docker-compose-local.yaml` file.
Current ports are listed below. 

    - Div-pfe: https://localhost:3000
    - Div-rfe: https://localhost:8084
    - Div-dafe: https://localhost:8085
    - Div-dnfe: https://localhost:8086
    - Div-cos: http://localhost:4012/swagger-ui.html
    - Div-cms: http://localhost:4010/swagger-ui.html
    - IDAM-api: http://localhost:5000/swagger-ui.html
    - IDAM-web-public: http://localhost:9002/login
    - IDAM-web-admin: http://localhost:8082/login
    - IDAM-fr-am: http://localhost:8080/openam/XUI/#login
    - IDAM-fr-idm: http://localhost:18080/#login
    - Div-fees-and-payments: http://localhost:4009/health
    - Div-evidence-management: http://localhost:4006/health
    - Div-payments-api: http://localhost:4421/health
    - Div-case-data-formatter: http://localhost:4011/health
    - service-auth-provider-api: http://localhost:4552/health
    - draft-store-api: http://localhost:8800/health
    - ccd-case-management-web: http://localhost:3451














