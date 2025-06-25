#!/bin/bash

ENV_FILE="./docker/db_sqlite/.env"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Erreur : le fichier .env est introuvable."
    exit 1
fi


VARIABLES=(
    "PROJECT_NAME" 
    "SQLITE_DBNAME"
    # "SQLITE_USER"
    "SQLITE_VOLUME"
    # "SQLITE_PASSWORD"
    # "SQLITE_CONTPORT"
    # "SQLITE_HOSTPORT"
    # "SQLITE_SCHEMA"
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

COMPOSE_FILE="./docker/db_sqlite/compose.yml"
VOLUME_NAME=${SQLITE_VOLUME}

CONTAINER_NAME_1=${PROJECT_NAME}-${DB_NAME}
CONTAINER_NAME_2=${PROJECT_NAME}-${DB_NAME}-webui

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Le fichier docker-compose.yml n'existe pas à l'emplacement spécifié."
  exit 1
fi

# if [ -z "$CONTAINER_NAME" ]; then
#   echo "Aucun nom de conteneur trouvé dans le fichier docker-compose.yml."
#   exit 1
# fi

echo "Arrêt du conteneur $CONTAINER_NAME_1..."
docker stop $CONTAINER_NAME_1

echo "Suppression du conteneur $CONTAINER_NAME_1..."
docker rm $CONTAINER_NAME_1

echo "Arrêt du conteneur $CONTAINER_NAME_2..."
docker stop $CONTAINER_NAME_2

echo "Suppression du conteneur $CONTAINER_NAME_2..."
docker rm $CONTAINER_NAME_2

if docker volume inspect $VOLUME_NAME > /dev/null 2>&1; then
  echo "Suppression du volume $VOLUME_NAME..."
  docker volume rm $VOLUME_NAME
else
  echo "Le volume $VOLUME_NAME n'existe pas."
fi

IMAGE_ID=$(docker inspect -f '{{.Image}}' $CONTAINER_NAME 2>/dev/null)
if [ ! -z "$IMAGE_ID" ]; then
  echo "Suppression de l'image $IMAGE_ID..."
  docker rmi $IMAGE_ID
fi

echo "Nettoyage des caches Docker..."
docker system prune -af

echo "Opération terminée."
