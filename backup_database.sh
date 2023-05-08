#!/bin/bash

# Configure your MySQL user
MYSQL_USER="your_user"

# Ask the user for the MySQL password
echo "Please enter your MySQL password:"
read -s MYSQL_PASSWORD

# Get the list of databases
databases=$(mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" 2>/dev/null | grep -Ev "Database|information_schema|performance_schema")

# Verify if the connection was successful
if [ -z "$databases" ]; then
  echo "Error connecting to MySQL. Please check your username and password. Exiting."
  exit 1
fi

# Display the databases with an associated number
echo "List of databases:"
counter=1
declare -A db_map
for db in $databases; do
  echo "$counter - $db"
  db_map[$counter]=$db
  counter=$((counter+1))
done

# Ask the user to select a database
echo "Please select the database you want to backup (enter the associated number):"
read selected_db_number

# Verify if the selected number is valid
if [[ -z "${db_map[$selected_db_number]}" ]]; then
  echo "Invalid number. Exiting."
  exit 1
fi

# Perform the backup of the selected database
selected_db="${db_map[$selected_db_number]}"
backup_file="${selected_db}_$(date +%Y%m%d_%H%M%S).sql"
mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD "$selected_db" > "$backup_file"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup of database '$selected_db' was successful. File: $backup_file"
else
  echo "Error while backing up database '$selected_db'."
fi
