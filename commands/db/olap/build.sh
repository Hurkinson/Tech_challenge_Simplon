#!/bin/bash

ENV_FILE="./docker/db_sqlite/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Erreur : le fichier .env est introuvable."
    exit 1
fi

VARIABLES=(
    "PROJECT_NAME"
    "SQLITE_CONTPORT"
    "SQLITE_HOSTPORT"
    "SQLITE_VOLUME"
)

for VAR in "${VARIABLES[@]}"; do
    if grep -q "^${VAR}=" "$ENV_FILE"; then
        VALUE=$(grep "^${VAR}=" "$ENV_FILE" | cut -d '=' -f 2)
        export "$VAR=$VALUE"
    else
        echo "Erreur : La variable $VAR n'existe pas dans le fichier .env."
        exit 1
    fi
done

echo "Variables d'environnement exportées :"
for VAR in "${VARIABLES[@]}"; do
    echo "$VAR ok"
done

NETWORK_NAME="${PROJECT_NAME}-docker-network"
! docker network ls | grep -q "$NETWORK_NAME" && docker network create "$NETWORK_NAME"
echo "define network = $NETWORK_NAME"

docker compose -f docker/db_sqlite/compose.yml up --build -d

























# ENV_FILE="./docker/db_sqlite/.env"

# if [[ ! -f "$ENV_FILE" ]]; then
#     echo "Erreur : le fichier .env est introuvable."
#     exit 1
# fi


# VARIABLES=(
#     "PROJECT_NAME" 
#     "SQLITE_DBNAME"
#     "SQLITE_USER"
#     "SQLITE_VOLUME"
#     "SQLITE_PASSWORD"
#     "SQLITE_CONTPORT"
#     "SQLITE_HOSTPORT"
#     "SQLITE_SCHEMA"
# )


# for VAR in "${VARIABLES[@]}"; do
#     if grep -q "^${VAR}=" "$ENV_FILE"; then
#         VALUE=$(grep "^${VAR}=" "$ENV_FILE" | cut -d '=' -f 2)
#         export "$VAR=$VALUE"
#     else
#         echo "Erreur : La variable $VAR n'existe pas dans le fichier .env."
#         exit 1
#     fi
# done

# echo "Variables d'environnement exportées :"
# for VAR in "${VARIABLES[@]}"; do
#     echo "$VAR ok"
# done

# NETWORK_NAME="${PROJECT_NAME}-docker-network"

# ! docker network ls | grep -q "$NETWORK_NAME" && docker network create "$NETWORK_NAME"

# echo "define network = $NETWORK_NAME"

# docker compose -f docker/db_sqlite/compose.yml up --build -d