#!/bin/bash

######################################################################
# Waits for Mongodb, Redis and Mysql to be ready
# usage examples:
#    wait-for-dependencies.sh echo "READY TO GO"
#    wait-for-dependencies.sh make build
# Exit Codes: 0 for success, 2 if wait command timed out
######################################################################

TIME_LIMIT=15
INTERVAL=2

set -e
POST_RUN_CMD=( "$@" )

wait_for_command() {
  SECONDS=0
  DEP_NAME="${1}"
  CMD="${2}"
  until ${CMD} &> /dev/null; do
    >&2 echo "${DEP_NAME} is unavailable - sleeping. Time elapsed: ${SECONDS}"
    sleep $INTERVAL
    if [ "${SECONDS}" -gt "${TIME_LIMIT}" ]; then
      >&2 echo "TIMEOUT: ${DEP_NAME} failed to come up"
      exit 2
    fi
  done
  >&2 echo "${DEP_NAME} is ready"
}

# WAIT FOR MONGO
MONGO_NAME='mongodb'
MONGO_WAIT_CMD='mongo --eval "db.stats()" --host mongo'

# WAIT FOR MYSQL
MYSQL_NAME='mysql'
MYSQL_WAIT_CMD='mysqladmin ping  --protocol tcp --host mysql --user root'

# WAIT FOR REDIS
REDIS_NAME='redis'
REDIS_WAIT_CMD='redis-cli ping'

wait_for_command "${MONGO_NAME}" "${MONGO_WAIT_CMD}"
wait_for_command "${MYSQL_NAME}" "${MYSQL_WAIT_CMD}"
wait_for_command "${REDIS_NAME}" "${REDIS_WAIT_CMD}"

# Finally, run the arbitrary command after this wait it done.
exec "${POST_RUN_CMD[@]}"
