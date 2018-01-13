# Useful bashisms

## wait-for-dependencies.sh

The age old question - how to wait for things to happen? Here is a well tested, modern & clean bash script to wait for dependencies to come up - for example, wait for a mysql server to start.
Use this pattern while waiting docker containers to be ready, waiting for other daemon-like processes to start etc.

Examples:
```
wait-for-dependencies.sh echo "I am ready"
wait-for-dependencies.sh make build-my-awesome-project
```
