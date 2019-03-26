#!/bin/bash
###############################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2017, 2019. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
#
# Contributors:
#  IBM Corporation - initial API and implementation
###############################################################################
# First we create a var's file that contains the needed AWS credential data
cat << "END_OF_BANNER"
*========================================================================================================*
|   _   _            _____      _                        _   ____        _        _                      |
|  | | | |___  ___  | ____|_  _| |_ ___ _ __ _ __   __ _| | |  _ \  __ _| |_ __ _| |__   __ _ ___  ___   |
|  | | | / __|/ _ \ |  _| \ \/ / __/ _ \ '__| '_ \ / _` | | | | | |/ _` | __/ _` | '_ \ / _` / __|/ _ \  |
|  | |_| \__ \  __/ | |___ >  <| ||  __/ |  | | | | (_| | | | |_| | (_| | || (_| | |_) | (_| \__ \  __/  |
|   \___/|___/\___| |_____/_/\_\\__\___|_|  |_| |_|\__,_|_| |____/ \__,_|\__\__,_|_.__/ \__,_|___/\___|  |
*========================================================================================================*
END_OF_BANNER

#log function prefixes a timestamp
function log {
  if [ "$1" == "" ]; then
    echo "ERROR: No log message provided"
    exit 1
  fi
  echo "[" `date` " ] $1"
}

CURRENT_PATH=`pwd`
log "Current PATH: ${CURRENT_PATH}"
log "Generating external databases variables YAML file from uiconfig.yml."

bosh int ${CURRENT_PATH}/ext-dbs-vars-template.yml \
  --vars-file ${CURRENT_PATH}/uiconfig.yml \
  >${CURRENT_PATH}/ext-dbs-vars.yml
if [ $? -ne 0 ]; then
  log "Failed to generate ext-dbs-vars.yml."
	exit 1
fi

log "Applying external databases ops file"
bosh int /data/CloudFoundry/cf-deploy.yml \
  --vars-file ${CURRENT_PATH}/ext-dbs-vars.yml \
  -o ${CURRENT_PATH}/use-external-dbs.yml \
  >/data/CloudFoundry/cf-deploy.yml_NEW
if [ $? -ne 0 ]; then
  log "Failed to apply external databases ops file"
  exit 1
fi

mv /data/CloudFoundry/cf-deploy.yml_NEW /data/CloudFoundry/cf-deploy.yml
if [ $? -ne 0 ]; then
  log "Failed to move /data/CloudFoundry/cf-deploy.yml_NEW /data/CloudFoundry/cf-deploy.yml"
  exit 1
fi
