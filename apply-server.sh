#!/bin/bash
if [ $# -eq 1 ]
then
  echo "Going to work with the Terasology server $1";
  kubectl apply -f $1/tera-pvc.yaml
  kubectl apply -f $1/TeraOverrideCfgCM.yaml
  kubectl apply -f TeraPlayerListsCM.yaml
  echo "Hope you remembered to update the passwords in the secrets file only locally!"
  kubectl apply -f tera-server-secrets.yaml
  kubectl apply -f $1/tera-service.yaml
  kubectl apply -f $1/tera-deployment.yaml
  # TODO: Consider using a stateful set just to get a cleaner pod name? Only ever 0 or 1 instances ...
else
  echo "Didn't get exactly one arg, got $# ! $*"
  echo "Valid server names are: tera1, tera2"
fi
