#!/bin/bash

# some command to be used from keycloak Admin CLI
# download keycloak binaries
export KC_VERSION=24.0.4
cd $HOME
mkdir keycloak
cd keycloak
curl -LO  https://github.com/keycloak/keycloak/releases/download/"${KC_VERSION}"/keycloak-"${KC_VERSION}".zip

# unzip keycloak
unzip keycloak-"${KC_VERSION}".zip

# set kcadm CLI shell command
export PATH=$PATH:$HOME/keycloak/keycloak-"${KC_VERSION}"/bin

# list kcadmin CLI help
kcadm.sh --help

# login into keycloak server using Admin CLI
kcadm.sh config credentials --server http://localhost:8089 --user admin --password password --realm master

export KCADM=kcadm.sh
export REALM_NAME=poc
export ORIGINAL_CLIENT_ID=originalclient

export INTERNAL_CLIENT_ID=internalclient

$KCADM get serverinfo

# get unique identifier for the internal client from poc realm
INTERNAL_ID=$($KCADM get clients -r $REALM_NAME --fields id,clientId | jq '.[] | select(.clientId==("'$INTERNAL_CLIENT_ID'")) | .id')

# get users from poc realm
$KCADM get users -r poc

# get user permissions from poc realm
$KCADM get users-management-permissions -r poc
{
  "enabled" : false
}

# activate user permissions from poc realm (only works if enable admin-fine-grained-authz)
$KCADM update users-management-permissions -r poc -s enabled=true
For more on this error consult the server log at the debug level. [unknown_error]

# get user permissions from poc realm (only where activate admin-fine-grained-authz)
$KCADM get users-management-permissions -r poc
{
  "enabled" : true,
  "resource" : "23ebb2aa-bf52-4222-aca9-561ba5bef086",
  "scopePermissions" : {
    "view" : "f743fef2-4cd0-4753-a94d-f70f53889e5b",
    "manage" : "6239e0f3-1c3b-4ede-ac12-10561da27639",
    "map-roles" : "e9e18515-c339-4947-bcf8-d4b776a2e57e",
    "manage-group-membership" : "fb1908b8-98ca-4ca7-ba86-f9694b6dcd9a",
    "impersonate" : "f718960b-aa57-46b8-b58b-5ae57ca3d83f",
    "user-impersonated" : "8a32fb6b-c1dc-41d3-8236-12e197305617"
  }
}
