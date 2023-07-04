#! /bin/bash
docker-compose down -v --rmi local
docker-compose build --no-cache --pull
./start.sh
