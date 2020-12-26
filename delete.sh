#!/bin/bash
if [ $# -eq 1 ]
then
  echo "Going to delete stuff for the Terasology server $1";
  kubectl delete -f $1/tera-deployment.yaml
  kubectl delete -f $1/tera-pvc.yaml
  kubectl delete -f $1/TeraOverrideConfigCM.yaml
  kubectl delete -f $1/tera-service.yaml
  # TODO: Consider using a stateful set just to get a cleaner pod name? Only ever 0 or 1 instances ...
else
  echo "Didn't get exactly one arg, so will delete global things instead. Got: $*"
  echo "Valid server names are: tera1, tera2"
  kubectl delete -f TeraPlayerListsCM.yaml
  kubectl delete -f tera-server-secrets.yaml
fi
