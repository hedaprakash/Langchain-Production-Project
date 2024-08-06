docker rm -f $(docker ps -aq)

docker images --format "{{.Repository}}"
# Remove dangling images
docker rmi $(docker images -q -f "dangling=true")

docker images  | grep -v -e redis -e postgres:13
docker images  | grep -v redis

docker rmi $(docker images -q | grep -v -e redis -e postgres:13)
docker ps
docker images

docker pull postgres:13
docker pull redis
docker pull python:3.10-slim-buster
docker pull python:3.9-slim-buster


docker compose build postgres
docker compose build service2
docker compose build service3
docker compose up

docker-compose build service3
