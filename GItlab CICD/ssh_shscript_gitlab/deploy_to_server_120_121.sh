#!/bin/bash

# Input arguments
DEPLOY_SERVER=$1
DEPLOY_PATH_WARS=$2
DEPLOY_PATH_CONFIGS=$3
PKEY=$4
DEPLOY_SCRIPT=$5

# Predefined server for additional tasks
DEPLOY_SERVER_1="appuser@10.10.11.120"
ADDITIONAL_SCRIPT="/home/appuser/ci/deploy_util_wildfly/scripts/test.sh"

# Colors for formatting
INFO_COLOR="\033[1;37;44m"
SUCCESS_COLOR="\033[1;30;42m"
ERROR_COLOR="\033[1;37;41m"
RESET_COLOR="\033[0m"

# Validate input arguments
if [[ -z "$DEPLOY_SERVER" || -z "$DEPLOY_PATH_WARS" || -z "$DEPLOY_PATH_CONFIGS" || -z "$PKEY" || -z "$DEPLOY_SCRIPT" ]]; then
  echo -e "${ERROR_COLOR} Error: Missing required arguments. ${RESET_COLOR}"
  echo "Usage: $0 <DEPLOY_SERVER> <DEPLOY_PATH_WARS> <DEPLOY_PATH_CONFIGS> <PKEY> <DEPLOY_SCRIPT>"
  exit 1
fi


# Function to copy files
copy_files() {
  local source_dir=$1
  local dest_dir=$2
  local file_pattern=$3
  local description=$4

  echo -e "${INFO_COLOR} Checking for $description... ${RESET_COLOR}"
  # Find files and store them in an array
  files=$(find "$source_dir" -type f -name "$file_pattern")
  if [[ -n "$files" ]]; then
    echo -e "${SUCCESS_COLOR} Found $description. Copying... ${RESET_COLOR}"
    # Loop through the files and copy them individually
    for file in $files; do
      # rsync --version
      rsync -avz -e "ssh -p 7222 -i $PKEY" "$file" "$DEPLOY_SERVER:$dest_dir"
      #scp -P 7222 -i "$PKEY" "$file" "$DEPLOY_SERVER:$dest_dir"
      if [[ $? -ne 0 ]]; then
        echo -e "${ERROR_COLOR} Failed to copy $description: $file. ${RESET_COLOR}"
        exit 1
      fi
    done
    echo -e "${SUCCESS_COLOR} Successfully copied $description: $file. ${RESET_COLOR}"
  else
    echo -e "${ERROR_COLOR} No $description found to copy. ${RESET_COLOR}"
  fi
}


# Deployment start
echo -e "${INFO_COLOR} Deploying to the server $DEPLOY_SERVER ${RESET_COLOR}"

# Copy webapp WAR files
copy_files "$(pwd)/webapp/target" "$DEPLOY_PATH_WARS" "*.war" "webapp WAR"

# Copy configuration files
copy_files "$(pwd)/etc/uat/appservers" "$DEPLOY_PATH_CONFIGS" "*" "configuration"

# Execute main deployment script
echo -e "${INFO_COLOR} Executing deployment script... ${RESET_COLOR}"
ssh -p 7222 -i "$PKEY" "$DEPLOY_SERVER" "$DEPLOY_SCRIPT"
if [[ $? -ne 0 ]]; then
  echo -e "${ERROR_COLOR} Deployment script failed. ${RESET_COLOR}"
  exit 1
else
  echo -e "${SUCCESS_COLOR} Deployment completed successfully. ${RESET_COLOR}"
fi

# Execute additional deployment script if applicable
if [[ "$DEPLOY_SERVER" == "$DEPLOY_SERVER_1" ]]; then
  echo -e "${INFO_COLOR} Executing additional deployment script for $DEPLOY_SERVER... ${RESET_COLOR}"
  ssh -p 7222 -i "$PKEY" "$DEPLOY_SERVER" "$ADDITIONAL_SCRIPT"
  if [[ $? -ne 0 ]]; then
    echo -e "${ERROR_COLOR} Additional deployment script failed. ${RESET_COLOR}"
    exit 1
  else
    echo -e "${SUCCESS_COLOR} Additional deployment completed successfully. ${RESET_COLOR}"
  fi
fi
