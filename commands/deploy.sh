#!/bin/bash

./commands/docker/clean-with-cache.sh
./commands/db/olap/build.sh 
./commands/etl/build.sh 

wait
echo
echo "Déploiement terminé !"












# #!/bin/bash

# ./commands.sh docker/clean-with-cache
# ./commands.sh db/olap/build &
# ./commands.sh etl/build &

# wait 

# echo
# echo "Déploiement terminé !"