#!/bin/bash

# Check for kubectl command
if ! command -v kubectl &> /dev/null; then
    echo "kubectl command not found. Please install kubectl and ensure it's in your PATH."
    exit 1
fi

# Define services and their corresponding ports for port forwarding
services=("user-service" "course-service" "course-content-service" "enrollment-service" "notification-service" "payment-service" "api-gateway")

# Delete existing deployments and services
for service in "${services[@]}"; do
  echo "Deleting deployment and service for $service"
  kubectl delete deployment "$service" --ignore-not-found
  kubectl delete service "$service" --ignore-not-found
done

# Apply YAML files for each service
for dir in "${services[@]}"; do
  echo "Applying YAML files for $dir"
  if [ -d "$dir" ]; then
    cd "$dir" || exit
    if [ -f "deployment.yml" ]; then
      kubectl apply -f deployment.yml || {
        echo "Failed to apply deployment.yml for $dir"
        exit 1
      }
    else
      echo "deployment.yml not found in $dir"
      exit 1
    fi
    if [ -f "service.yml" ]; then
      kubectl apply -f service.yml || {
        echo "Failed to apply service.yml for $dir"
        exit 1
      }
    else
      echo "service.yml not found in $dir"
      exit 1
    fi
    cd ..
  else
    echo "Directory $dir does not exist"
    exit 1
  fi
done

echo "All services are set up."
