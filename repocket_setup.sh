#!/bin/bash

# Set environment variables
RP_EMAIL="abyantrader@gmail.com"
RP_API_KEY="cd2cb2ba-38b1-484d-b303-387f15ad4e06"
PROXY_URL="http://45.195.80.59:5432"
PROXY_USERNAME="dmqkq"
PROXY_PASSWORD="tjwpatm9"

# Update system and install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Pull Repocket Docker image
sudo docker pull repocket/repocket

# Create and run container 1 without proxy
sudo docker run -d --name repocket_no_proxy \
  -e RP_EMAIL=$RP_EMAIL \
  -e RP_API_KEY=$RP_API_KEY \
  repocket/repocket

# Create and run container 2 with proxy
sudo docker run -d --name repocket_with_proxy \
  -e RP_EMAIL=$RP_EMAIL \
  -e RP_API_KEY=$RP_API_KEY \
  -e HTTP_PROXY="$PROXY_URL" \
  -e HTTPS_PROXY="$PROXY_URL" \
  -e PROXY_USERNAME=$PROXY_USERNAME \
  -e PROXY_PASSWORD=$PROXY_PASSWORD \
  repocket/repocket

# Check the status of the containers
NO_PROXY_STATUS=$(sudo docker inspect -f '{{.State.Status}}' repocket_no_proxy)
WITH_PROXY_STATUS=$(sudo docker inspect -f '{{.State.Status}}' repocket_with_proxy)

echo "Repocket containers status:"
echo "Container 1 (No Proxy): $NO_PROXY_STATUS"
echo "Container 2 (With Proxy): $WITH_PROXY_STATUS"

# Show logs if containers exited
if [ "$NO_PROXY_STATUS" != "running" ]; then
  echo "Logs for container 1 (No Proxy):"
  sudo docker logs repocket_no_proxy
fi

if [ "$WITH_PROXY_STATUS" != "running" ]; then
  echo "Logs for container 2 (With Proxy):"
  sudo docker logs repocket_with_proxy
fi
