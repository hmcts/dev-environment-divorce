#!/bin/sh

docker logout hmctspublic.azurecr.io &>/dev/null
az acr login --name hmctsprivate --subscription <SUBSCRIPTION_KEY>