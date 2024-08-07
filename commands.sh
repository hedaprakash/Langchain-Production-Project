docker rm -f $(docker ps -aq)

docker images --format "{{.Repository}}"
# Remove dangling images
docker rmi $(docker images -q -f "dangling=true")

docker images  | grep -v -e redis -e postgres -e python
docker images  | grep redis

docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -e redis -e postgres -e python)

images_to_remove=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -e redis -e postgres -e python); [ -n "$images_to_remove" ] && docker rmi $images_to_remove || echo "No images to remove"
# delete all images other than these specific tags
images_to_remove=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -E '^(redis:latest|postgres:15|python:3.10-slim-buster|python:3.9-slim-buster)$'); [ -n "$images_to_remove" ] && docker rmi $images_to_remove || echo "No images to remove"



docker ps
docker images

docker pull postgres:15
docker pull redis
docker pull python:3.10-slim-buster
docker pull python:3.9-slim-buster


docker compose build postgres
docker compose build service2
docker compose build service3
docker compose build service3
docker compose up

docker compose build service3


docker logs 