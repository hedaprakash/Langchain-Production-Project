#!/bin/bash

# Funktion, um Docker-Operationen auszuführen
do_docker() {
    echo "remove registry..."
    docker stop local-registry
    docker rm local-registry

    echo "Starte Docker Registry..."
    docker run -d -p 5000:5000 --name local-registry registry:2

    echo "Build images..."
    docker build -t mypostgres ./postgres
    docker build -t myservice2 ./service2
    docker build -t myservice3 ./service3
    docker build -t myfrontend ./frontend

    echo "Tag and push images..."
    # For Postgres
    docker tag mypostgres localhost:5000/mypostgres
    docker push localhost:5000/mypostgres

    # For Service2
    docker tag myservice2 localhost:5000/myservice2
    docker push localhost:5000/myservice2

    # For Service3
    docker tag myservice3 localhost:5000/myservice3
    docker push localhost:5000/myservice3

    # For Frontend
    docker tag myfrontend localhost:5000/myfrontend
    docker push localhost:5000/myfrontend
}

# Funktion, um Kubernetes-Operationen auszuführen
do_kubernetes() {
    echo "Deploy to Kubernetes..."
    kubectl apply -f all-deployments.yaml
}

# Hauptlogik des Skripts
if [ "$1" == "--build" ]; then
    do_docker
    do_kubernetes
else
    do_kubernetes
fi

