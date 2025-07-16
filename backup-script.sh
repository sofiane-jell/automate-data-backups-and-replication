#!/bin/bash

time=$(date +"%m-%d-%y_%H_%M_%S")
Backup_file="/home/ubuntu/bash"
Dest="/home/ubuntu/backup"
filename="file-backup-$time.tar.gz"
LOG_FILE="/home/ubuntu/backup/logfile.log"

S3_BACKET="s3-now-backup2-project"
FILE_TO_UPLOAD="$Dest/$filename"

if ! command -v aws &> /dev/null; then 
    echo "AWS CLI is not installed, Please install it first" | tee -a "$LOG_FILE"
    exit 1
fi

if [ ! -d "$Dest" ]; then
    mkdir -p "$Dest"
fi

if [ -f "$FILE_TO_UPLOAD" ]; then
    echo "Error file $filename already exists" | tee -a "$LOG_FILE"
    exit 1
else
    tar -czvf "$FILE_TO_UPLOAD" "$Backup_file" 2>> "$LOG_FILE"
    if [ $? -eq 0 ]; then
        echo "Backup completed successfully, backup file: $FILE_TO_UPLOAD" | tee -a "$LOG_FILE"
        
        # Upload to S3
        aws s3 cp "$FILE_TO_UPLOAD" "s3://$S3_BACKET/"
        
        if [ $? -eq 0 ]; then
            echo "File uploaded successfully to AWS S3 bucket: $S3_BACKET" | tee -a "$LOG_FILE"
        else
            echo "File upload to S3 failed" | tee -a "$LOG_FILE"
            exit 1
        fi
    else
        echo "Backup failed" | tee -a "$LOG_FILE"
        exit 1
    fi
fi
