#!/bin/bash

# Setting up the date format for filename
BACKUP_DATE=$(date +\%F-\%H\%M)

# Path to docker-compose.yml
DOCKER_COMPOSE_PATH="/service/docker/"

# S3 Bucket details
S3_BUCKET="s3://bucketname"

# Change to the directory where your docker-compose.yml is located
cd $DOCKER_COMPOSE_PATH

# Delete backups older than 10 days
find /backups -name 'db-backup-*.sql' -mtime +10 -exec rm {} \;

# Execute mysqldump and save the output
docker compose exec -T db sh -c 'exec mysqldump -u root -p123 DBNAME' > /backups/db-backup-$BACKUP_DATE.sql

# Upload to S3
aws s3 cp /backups/db-backup-$BACKUP_DATE.sql $S3_BUCKET