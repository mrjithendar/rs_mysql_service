config.sql will create cities database, roboshop user and create tables cities and codesif not exist 
databse.sql will import the data into cities and codes

# import config.sql: $mysql -h database_hostname -u'user' -p'password' databsename < config.sql
# import database.sql: $mysql -h database_hostname -u'user' -p'password' databsename < database.sql