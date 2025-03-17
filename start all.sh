#!/bin/bash

# Define the order of scaling
ORDERED_SERVICES=("discovery" "configserver" "uiapp" "proxy" "apigateway" "mortgageservices")

# Scale ordered services first
for SERVICE in "${ORDERED_SERVICES[@]}"; do
    SERVICE_ID=$(docker service ls --format '{{.ID}} {{.Name}}' | grep "bayview_lo_demo_finexp$SERVICE" | awk '{print $1}')
    if [[ -n "$SERVICE_ID" ]]; then
        echo "Scaling $SERVICE_ID (bayview-nondel-qa_finexp$SERVICE) to 1"
        docker service scale "$SERVICE_ID"=1
        docker service ls
        sleep 90
    else
        echo "Service $SERVICE not found!"
    fi
done

# Scale any remaining services
docker service ls --format '{{.ID}} {{.Name}}' | while read SERVICE_ID SERVICE_NAME; do
    if [[ ! " ${ORDERED_SERVICES[@]} " =~ " ${SERVICE_NAME##*_} " ]]; then
        echo "Scaling $SERVICE_ID ($SERVICE_NAME) to 1"
        docker service scale "$SERVICE_ID"=1
        docker service ls
        sleep 90
    fi
done



nohup bash scale_services.sh > scale_services.log 2>&1 &



tail -f scale_services.log


