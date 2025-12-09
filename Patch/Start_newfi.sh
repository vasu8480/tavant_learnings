#!/bin/bash

# ===========================
# 1. SERVICES LIST TO STOP
# ===========================
ALL_SERVICES=(
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

# ===========================
# 2. ORDERED START SEQUENCE
# ===========================
ORDERED_SERVICES=(
"newfi-uat-new_discovery"
"newfi-uat-new_finexpconfigserver"
"newfi-uat-new_finexpuiapp"
"newfi-uat-new_finexpproxy"
"newfi-uat-new_finexpapigateway"
"newfi-uat-new_finexploan"      # mortgageservices
)

WAIT_AFTER_ORDERED=120  # 2 minutes
WAIT_AFTER_MORTGAGE=10  # 10 seconds

# START SERVICES IN ORDER
# ===========================
echo "Starting ordered services..."

for svc in "${ORDERED_SERVICES[@]}"; do
  echo "Starting: $svc"
  docker service scale "$svc"=1

  if [[ "$svc" == "newfi-uat-new_finexploan" ]]; then
    echo "mortgageservices started → waiting ${WAIT_AFTER_MORTGAGE}s..."
    sleep $WAIT_AFTER_MORTGAGE
  else
    echo "Waiting ${WAIT_AFTER_ORDERED}s before next service..."
    docker service ls
    sleep $WAIT_AFTER_ORDERED
  fi
done

echo "Ordered startup complete."
echo

# ===========================
# START REMAINING SERVICES
# ===========================
echo "Starting remaining services..."

for svc in "${ALL_SERVICES[@]}"; do
  # Skip ones we already started
  if printf '%s\n' "${ORDERED_SERVICES[@]}" | grep -q "$svc"; then
    continue
  fi

  # new_agent must have 2 replicas
  if [[ "$svc" == "newfi-uat-new_agent" ]]; then
    echo "Starting $svc with 2 replicas (global)..."
    docker service scale "$svc"=2
    continue
  fi
  docker service ls

  echo "Starting: $svc"
  docker service scale "$svc"=1
done

echo "All services successfully started."


