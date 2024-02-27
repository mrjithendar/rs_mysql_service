POD=$(kubectl get pods -n $NS | grep mysql | awk '{print $1}' | head -n 1)

echo "copying databases"
kubectl cp dbs/config.sql $POD:/tmp/ -n $NS
kubectl cp dbs/database.sql $POD:/tmp/ -n $NS
kubectl exec -it $POD -n $NS -- ls -al /tmp

echo "importing databases"
kubectl exec -it $POD -n $NS -- "mysql -u root -p$MYSQL_ROOT_PASSWORD cities < /tmp/config.sql"
kubectl exec -it $POD -n $NS -- "mysql -u root -p$MYSQL_ROOT_PASSWORD cities  < /tmp/database.sql"

kubectl create configmap sql-script-configmap --from-file=config.sql=dbs/config.sql,database.sql=dbs/database.sql
kubectl create configmap sql-script-configmap --from-file=config.sql=dbs/database.sql