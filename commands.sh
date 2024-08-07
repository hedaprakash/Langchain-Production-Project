
# cleanup
sudo systemctl restart docker
docker ps -aq | xargs docker rm -f
docker network prune -f
sudo lsof -i :5433
sudo kill -9 $(sudo lsof -t -i :5433)


docker rm -f $(docker ps -aq)

docker images --format "{{.Repository}}"
# Remove dangling images
docker rmi $(docker images -q -f "dangling=true")

docker images  | grep -v -e redis -e postgres -e python
docker images  | grep -v '^(postgres:15)'
docker images | grep '^postgres:15'


docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -e redis -e postgres -e python)

images_to_remove=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -e redis -e postgres -e python); [ -n "$images_to_remove" ] && docker rmi $images_to_remove || echo "No images to remove"
# delete all images other than these specific tags
images_to_remove=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -E '^(redis:latest|postgres:15|python:3.10-slim-buster|python:3.9-slim-buster)$'); [ -n "$images_to_remove" ] && docker rmi $images_to_remove || echo "No images to remove"

docker rmi $(docker images | grep '^postgres *15' | awk '{print $3}')


docker ps -a
docker images

docker pull postgres:16
docker pull dpage/pgadmin4
docker pull redis
docker pull python:3.10-slim-buster
docker pull python:3.9-slim-buster

docker compose build postgres
docker compose build pgadmin
docker compose build redis
docker compose build service2
docker compose build service3
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

docker compose up postgres -d
docker compose up redis -d
docker compose up service2 -d
docker compose up service3 -d
docker compose up pgadmin -d

docker compose build service2
docker compose up service2 -d
cat /home/hvadmin/proj/Langchain-Production-Project/service2/requirements.txt


docker compose up

docker compose build service3


docker logs cpostgres
docker logs service2
docker logs service3
docker logs redis
docker logs pgadmin

docker compose build redis
docker compose build service2
docker compose build service3

sudo kill -9 $(sudo lsof -t -i :5433)
sudo systemctl restart docker

docker logs cservice2
