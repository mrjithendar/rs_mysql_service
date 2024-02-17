kubectl cp your_database_dump.sql <mysql-pod>:/tmp/
kubectl exec -it <mysql-pod> -- mysql -u root -p <your_database> < /tmp/your_database_dump.sql