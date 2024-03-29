#!/usr/bin/env bash

# Using "$1" directly for the container name.
# Defining user and group, with defaults to "$1" if "$2" and "$3" are not provided.
user="${2:-$1}"
group="${3:-$1}"

# Checking if the specified Docker container is running.
container_running=$(docker container inspect -f '{{.State.Running}}' "${1}")

if [ "${container_running}" == "true" ]; then
  # If the container is running, attempt to execute commands.
  if docker exec "${1}" bash -c "\
    mkdir -p /var/${user}_home/.ssh && \
    touch /var/${user}_home/.ssh/known_hosts && \
    ssh-keygen -R 192.168.90.11 >/dev/null 2>&1 && \
    ssh-keyscan -H 192.168.90.11 >> /var/${user}_home/.ssh/known_hosts && \
    chown ${user}:${group} /var/${user}_home/.ssh/known_hosts && \
    chmod 644 /var/${user}_home/.ssh/known_hosts"; then
    echo "Commands successfully executed in container ${1}."
  else
    echo "Error executing commands in container ${1}."
  fi
else
  echo "Container ${1} is not running. Skipping SSH setup steps."
fi

# Continuing with the rest of the script...
echo "Continuing with the next steps of the script..."