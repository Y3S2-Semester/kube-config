#!/bin/bash

# Define services and their corresponding ports for port forwarding
declare -A services=(
  ["user-service"]=8000
  ["course-service"]=8100
  ["course-content-service"]=8200
  ["enrollment-service"]=8300
  ["notification-service"]=7000
  ["payment-service"]=3000
  ["api-gateway"]=8765
)

for service in "${!services[@]}"; do
  echo "Deleting deployment and service for $service"
  kubectl delete deployment,service "$service"
done

for dir in "${!services[@]}"; do
  echo "Applying YAML files for $dir"
  cd $dir
  kubectl apply -f deployment.yml
  kubectl apply -f service.yml
  cd ..
done

echo "All services are set up."
