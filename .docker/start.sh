#! /bin/bash
docker-compose up -d
docker-compose exec corn-app bash -c "yarn install && yarn serve"
