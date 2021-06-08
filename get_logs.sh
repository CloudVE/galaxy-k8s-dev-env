#!/bin/bash

set -x


if [ -z "$1" ]
  then
    echo "You must supply a namespace. eg: bash get_logs.sh mynamespace (events|web|job|workflow)"
    exit
fi

if [ -z "$2" ]
  then
    echo "You must supply a namespace and type of log. eg: bash get_logs.sh mynamespace (events|web|job|workflow)"
    exit
fi

NAMESPACE=$1

case "$2" in
    events) kubectl get events -n $NAMESPACE;
        ;;
    web) while [[ $(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-web-[^ ]*' | wc -l) -ge 2 ]]; do echo "Waiting for extra web pod to be terminated:\n$(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-web-[^ ]*')" && sleep 1; done && kubectl logs -n $NAMESPACE $(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-web-[^ ]*')
        ;;
    job) while [[ $(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-job-[^ ]*' | wc -l) -ge 2 ]]; do echo "Waiting for extra job pod to be terminated:\n$(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-job-[^ ]*')" && sleep 1; done && kubectl logs -n $NAMESPACE $(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-job-[^ ]*')
        ;;
    workflow) while [[ $(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-workflow-[^ ]*' | wc -l) -ge 2 ]]; do echo "Waiting for extra workflow pod to be terminated:\n$(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-workflow-[^ ]*')" && sleep 1; done && kubectl logs -n $NAMESPACE $(kubectl get pods -n $NAMESPACE | grep -o '[^ ]*-workflow-[^ ]*')
        ;;
    *) echo "Invalid choice. You must supply a namespace and type of log. eg: bash get_logs.sh mynamespace (events|web|job|workflow)"
        ;;
esac
