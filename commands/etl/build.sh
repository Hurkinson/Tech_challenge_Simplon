#!/bin/bash

ENV_FILE="./docker/etl_mage_ia/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Erreur : le fichier .env est introuvable."
    exit 1
fi

VARIABLES=(
    "PROJECT_NAME"
    "ENV"
    "MAGEAI_HOSTPORT"
    "MAGEAI_CONTPORT"
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

docker compose -f docker/etl_mage_ia/compose.yml up --build -d










# ENV_FILE="./docker/etl/.env"

# if [[ ! -f "$ENV_FILE" ]]; then
#     echo "Erreur : le fichier .env est introuvable."
#     exit 1
# fi


# VARIABLES=(
#     "PROJECT_NAME" 
#     "ENV"
#     "MAGEAI_CONTPORT"
#     "MAGEAI_HOSTPORT"
#     "POSTGRES_HOST_SERVICENAME"
#     "MONGO_HOST_SERVICENAME"
#     "POSTGRES_DBNAME"
#     "POSTGRES_USER"
#     "POSTGRES_PASSWORD"
#     "POSTGRES_CONTPORT"
#     "POSTGRES_HOSTPORT"
#     "POSTGRES_SCHEMA"
#     "MONGO_DBNAME"
#     "MONGO_USER"
#     "MONGO_PASSWORD"
#     "MONGO_HOST"
#     "MONGO_CONTPORT"
#     "MONGO_HOSTPORT"
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



# docker compose -f docker/etl/compose.yml up --build -d