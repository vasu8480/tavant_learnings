#!/bin/bash

services=(
"newfi-uat-new_agent"
"newfi-uat-new_discovery"
"newfi-uat-new_finexpapigateway"
"newfi-uat-new_finexpbrokermngmt"
"newfi-uat-new_finexpconfigserver"
"newfi-uat-new_finexploan"
"newfi-uat-new_finexpnotification"
"newfi-uat-new_finexppricing"
"newfi-uat-new_finexpproxy"
"newfi-uat-new_finexpuiapp"
"newfi-uat-new_finexpusermgmt"
"newfi-uat-new_portainer"
)

for svc in "${services[@]}"; do
  echo "Stopping service: $svc"
  docker service scale "$svc"=0
done

echo "All services scaled to 0."
