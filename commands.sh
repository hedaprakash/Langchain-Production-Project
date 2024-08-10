
# cleanup
sudo systemctl restart docker
docker ps -aq | xargs docker rm -f
docker network prune -f
sudo lsof -i :5433
sudo kill -9 $(sudo lsof -t -i :5433)
sudo ps aux | grep postgres
pstree -p 396
sudo lsof -iTCP:5433 -sTCP:ESTABLISHED

sudo cat /etc/postgresql/*/main/postgresql.conf | grep port
sudo cat /etc/postgresql/*/main/pg_hba.conf
sudo tail -n 100 /var/log/postgresql/postgresql-*.log
sudo netstat -plant | grep 5433
sudo ss -tuln | grep 5433

# remove postgresq  l ibstallation
sudo systemctl stop postgresql
sudo apt-get --purge remove postgresql -y

sudo rm -rf /etc/postgresql
sudo rm -rf /var/lib/postgresql
sudo rm -rf /var/log/postgresql

dpkg -l | grep postgres
sudo apt-get --purge remove postgresql-16 postgresql-common postgresql-contrib -y

sudo apt-get autoremove -y
sudo apt-get autoclean

psql --version




docker images --format "{{.Repository}}"

docker images  | grep -v -e redis -e postgres -e python
docker images  | grep -v '^(postgres:15)'
docker images | grep '^postgres:15'


docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -e redis -e postgres -e python)

# delete all images other than these specific tags
# Remove dangling images
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q -f "dangling=true") 
docker images --format "{{.Repository}}:{{.Tag}}"
docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -E '^(redis:latest|postgres:16|dpage/pgadmin4:latest|python:3.12-slim|node:22-alpine|frdel/agent-zero-exe:latest)$'
docker rmi -f $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -E '^(redis:latest|postgres:16|dpage/pgadmin4:latest|python:3.12-slim|node:22-alpine|frdel/agent-zero-exe:latest)$')
docker compose up --build



# docker rmi $(docker images | grep '^python *3.9-slim-buster' | awk '{print $3}')


docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
docker images --format "{{.Repository}}:{{.Tag}}"


# docker pull postgres:16
# docker pull dpage/pgadmin4
# docker pull redis
# docker pull python:3.12-slim
# docker pull python:3.11-slim-buster
# docker pull python:3.10-slim-buster
# docker pull python:3.9-slim-buster
# docker pull  node:22-alpine

docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
docker rm -f $(docker ps -aq)
docker compose build
docker images --format "{{.Repository}}:{{.Tag}}" | grep -v -E '^(redis:latest|postgres:16|dpage/pgadmin4:latest|python:3.12-slim|node:22-alpine)$'

docker compose up --build
docker compose up
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

docker compose down
docker compose up --build

docker compose build postgres
docker compose build pgadmin
docker compose build redis
docker compose build langservice2dependencies
docker compose build service2
docker compose build langservice3dependencies
docker compose build service3
docker compose build frontend
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
sudo docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

docker compose up postgres -d
docker compose up redis -d
docker compose up service2 -d
docker compose up service3 -d
docker compose up pgadmin -d
docker compose up frontend -d

docker compose build service2
docker compose up service2 -d
cat /home/hvadmin/proj/Langchain-Production-Project/service2/requirements.txt

docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"


docker exec -it cservice2 /bin/sh
pip list | grep uvicorn

docker logs cservice2
docker compose build service2
docker compose up service2
docker run -it --entrypoint /bin/sh langservice2:latest



docker compose up

docker compose build service3


docker logs cpostgres
docker logs cservice2
docker logs cfrontend
docker logs redis
docker logs pgadmin

docker compose build redis
docker compose build service2
docker compose build service3

sudo kill -9 $(sudo lsof -t -i :5433)
sudo systemctl restart docker

docker logs cservice2


docker compose down
docker compose build redis
docker compose up redis


docker run -it --privileged --entrypoint /bin/sh redis:latest
