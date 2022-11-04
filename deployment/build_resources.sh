#!/usr/bin/env bash
# exit when any command fails
set -e

TENANT=""
SUBSCRIPTION=""
LOCATION="westeurope"
RESOURCEGROUP="personalwebsite"

do_login()
{
    subscriptionId="$(az account list --query "[?isDefault].id" -o tsv)"
    if [ $subscriptionId != $SUBSCRIPTION ]; then
        az login --tenant $TENANT
        az account set --subscription $SUBSCRIPTION
    fi
}

do_resource_group()
{
    if [ $(az group exists --name $RESOURCEGROUP) = false ]; then
        az group create --name $RESOURCEGROUP --location $LOCATION
    fi
}

do_static_webapp()
{
    az deployment group create \
    --name StaticWebApp \
    --resource-group $RESOURCEGROUP \
    --template-file static_webapp.json \
    --parameters azuredeploy.parameters.json
}

main()
{
    do_login
    do_resource_group
    do_static_webapp
}

main
