#!/bin/bash

COMPOSE_FILE="./docker/etl/compose.yml"
VOLUME_NAME="etl_mageai"
CONTAINER_NAME=${PROJECT_NAME}-mageai


if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Le fichier docker-compose.yml n'existe pas à l'emplacement spécifié."
  exit 1
fi

if [ -z "$CONTAINER_NAME" ]; then
  echo "Aucun nom de conteneur trouvé dans le fichier docker-compose.yml."
  exit 1
fi

echo "Arrêt du conteneur $CONTAINER_NAME..."
docker stop $CONTAINER_NAME

echo "Suppression du conteneur $CONTAINER_NAME..."
docker rm $CONTAINER_NAME

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
