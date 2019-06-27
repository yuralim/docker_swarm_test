#!/bin/bash

# Remove existing nodes
docker-machine rm -f swarmtest1
docker-machine rm -f swarmtest2

# Create a manager node
docker-machine create -d virtualbox swarmtest1
eval $(docker-machine env swarmtest1)

docker swarm init --advertise-addr `docker-machine ip swarmtest1`
WORKER_JOIN_TOKEN=$(docker swarm join-token -q worker)

docker network create --driver overlay swarm_test_network

# Create a worker node
docker-machine create -d virtualbox swarmtest2
eval $(docker-machine env swarmtest2)

docker swarm join --token $WORKER_JOIN_TOKEN `docker-machine ip swarmtest1`:2377