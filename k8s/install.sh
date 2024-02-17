#!/bin/bash

# link https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd

NS="roboshop"

echo "checking mysql status"
helm ls -n $NS | grep mysql

if [ $? -eq 0 ]; then
  echo "mysql installed already, trying to upgrade mysql."
  helm upgrade mysql bitnami/mysql -n $NS --create-namespace=true --values k8s/values.yml
  MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace roboshop mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
  echo "mysql username: root and password: $MYSQL_ROOT_PASSWORD"
  else
    echo "mysql installing"
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install mysql bitnami/mysql -n $NS --create-namespace=true --values k8s/values.yml
    sleep 10
    echo "mysql installed successfully, access from below URL"

    MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace roboshop mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
    echo "mysql username: root and password: $MYSQL_ROOT_PASSWORD"
fi

# To connect to your database:
#   1. Run a pod that you can use as a client:
#       kubectl run mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.36-debian-11-r4 --namespace roboshop --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash
#   2. To connect to primary service (read/write):
#       mysql -h mysql.roboshop.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"