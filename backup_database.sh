#!/bin/bash

# Ask the user for the MySQL user
read -p "Please enter your MySQL user: " mysql_user

# Ask the user for the MySQL password
read -s -p "Please enter your MySQL password: " mysql_password
echo

# Check if the MySQL user is valid
mysql --user="$mysql_user" --password="$mysql_password" --execute="SELECT 1;" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Invalid MySQL user or password. Please check your credentials. Exiting."
    exit 1
fi

# Get the list of databases
databases=$(mysql --user="$mysql_user" --password="$mysql_password" --execute="SHOW DATABASES;" 2>/dev/null | grep -Ev "Database|information_schema|performance_schema")

# Verify if the connection was successful
if [ -z "$databases" ]; then
    echo "Error connecting to MySQL. Please check your username and password. Exiting."
    exit 1
fi

# Display the databases with an associated number
echo "List of databases:"
db_map=()
counter=1
for db in $databases; do
    echo "$counter - $db"
    db_map+=("$db")
    counter=$((counter+1))
done

# Ask the user to select a database
read -p "Please select the database you want to backup (enter the associated number): " selected_db_number

# Verify if the selected number is valid
if [ -z "${db_map[selected_db_number-1]}" ]; then
    echo "Invalid number. Exiting."
    exit 1
fi

# Perform the backup of the selected database
selected_db="${db_map[selected_db_number-1]}"
backup_file="${selected_db}_$(date +'%Y%m%d_%H%M%S').sql"
mysqldump --user="$mysql_user" --password="$mysql_password" "$selected_db" > "$backup_file"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup of database '$selected_db' was successful. File: $backup_file"
else
    echo "Error while backing up database '$selected_db'."
fi
