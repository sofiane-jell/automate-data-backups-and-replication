## 📦 Project Description

This project provides a Bash script to automate the process of backing up virtual machine (VM) data and replicating the backups to an Amazon S3 bucket in AWS. The script is designed to be scheduled via `cron` (or any scheduling system) to ensure regular, unattended backups.

---

## 🛠️ Requirements

- A Linux/Unix-based system with:
  - `bash`
  - `awscli`
  - Access to the VM data directory
- An AWS account with:
  - An S3 bucket already created
  - IAM user with programmatic access and sufficient S3 permissions

---
## 🔧 Setup Instructions
1. **Start the instance and configure it:**
<img width="940" height="221" alt="image" src="https://github.com/user-attachments/assets/54098a03-7862-4cbb-964d-b5c732180101" />

2. **Install AWS CLI (if not installed):**

```bash
sudo apt install awscli  # Debian/Ubuntu
# or
sudo yum install awscli  # RHEL/CentOS
```
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/3376a8ba-0a6d-45db-9b8d-3e78059b3144" />
3. **Configure with aws credentilas**
- Either via aws configure:
  <img width="778" height="381" alt="image" src="https://github.com/user-attachments/assets/f919a015-5ea1-4d5b-8a68-8a04c97b7796" />
  <img width="906" height="171" alt="image" src="https://github.com/user-attachments/assets/46f79323-71d5-464c-b1ca-d264fb76c1a6" />
- attaching an IAM Role with these permissions:

```json
{
  "Effect": "Allow",
  "Action": ["s3:PutObject", "s3:GetObject"],
  "Resource": "arn:aws:s3:::your-bucket-name/*"
}
```

- or via console: 
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/14f1ea70-c829-4b5c-a1d3-09aa6c31efc7" />
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/053f3304-a45c-4b70-b2f0-f383302c0f92" />
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/6175a19b-60da-412b-a210-f6fb8fae1a12" />
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/b56e69cd-9d48-49a9-8ce1-ea998905ef19" />
<img width="933" height="805" alt="image" src="https://github.com/user-attachments/assets/348886d5-1c3e-4532-8142-2aab302ca969" />


## 📝 Configuration Script
1. **adding the script**


```bash
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
```

2. **Clone this repository and make the script executable:**
```bash
git clone https://github.com/sofiane-jell/automate-data-backups-and-replication.git
cd your-repo-name
chmod +x backup-script.sh
```

<img width="940" height="279" alt="image" src="https://github.com/user-attachments/assets/904a1ad9-2dc7-4462-9a27-8ec7ca9fb727" />
<img width="940" height="304" alt="image" src="https://github.com/user-attachments/assets/adb9e032-33ac-4c70-8957-482d484fd60e" />

## 📅 Automate with Cron

1. **open crontab**

``` bash
crontab -e
```
<img width="613" height="92" alt="image" src="https://github.com/user-attachments/assets/623a582a-48ac-4c42-8daa-613ebbacadcd" />

2. **Add a cron job (e.g., every day at 2am):**

``` bash
0 2 * * * /path/to/backup-script.sh
````
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/63c96d3f-1789-49cf-988b-4961e370c796" />

## 📅 Backup automated now : 
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/e4fd0a83-aad2-434b-8631-38ed61fa9e5f" />
<img width="909" height="400" alt="image" src="https://github.com/user-attachments/assets/e162b034-7e9c-47f0-b8f1-07e9876aa5ab" />
<img width="940" height="504" alt="image" src="https://github.com/user-attachments/assets/68ebcaed-c2ea-412d-9513-7e4036e6454c" />

## Additional Notes
- Make sure the AWS user has the necessary permissions for s3:PutObject on the target bucket.
- Adjust backup retention by adding logic to remove older backups locally or in S3.
- Monitor logs (/var/log/vm_backup.log) for successful backup and upload operations.
- Secure your backup script and credentials carefully.


## 🔐Troubleshooting
- Backup archive not created: Check if VM_DATA_DIR exists and permissions are correct.
- AWS upload fails: Verify AWS CLI configuration and IAM permissions.
- Cron job not running: Confirm the cron service is running and that paths in the script and cron job are absolute.


## 📁 License
This project is open-source and free to use under the MIT License.
```yaml


Let me know if you'd like:
- A downloadable `.zip` of this README with script included
- Help creating the full GitHub repo structure (`/scripts`, `/logs`, etc.)
- Or to turn this into a GitHub Actions workflow for remote automation
```

## Author
sofiane jellouli — sofiane2003jellouli@gmail.com
Feel free to open an issue or reach out for collaboration or feedback!









