#!/bin/bash
set -e

#gcloud secrets versions access 1 --secret=first


# Update and install dependencies
sudo apt-get update
sudo apt-get install -y curl lsb-release

# 1. Add the gcsfuse distribution URI as a package source
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list

# 2. Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# 3. Update and install gcsfuse
sudo apt-get update
sudo apt-get install -y gcsfuse

# 4. Create a directory to mount the bucket
sudo mkdir -p /mnt/gcs-bucket
sudo chmod 777 /mnt/gcs-bucket

#This allows users other than the one who mounted to access the filesystem
sed -i '/#user_allow_other/s/^[[:blank:]]*#//' /etc/fuse.conf

# 5. Optional: Mount the bucket (Replace 'your-bucket-name' or use a variable)
# Note: Mounting at boot usually requires a specific service account.
gcsfuse thisisalongcrazyname9 /mnt/gcs-bucket

#Create A systemd service to mount the bucket with gcsfuse /etc/systemd/system/gcsfuse-my-bucket.service
echo "[Unit]
Description=Mount GCS bucket my-bucket
After=network-online.target local-fs.target
Wants=network-online.target
Requires=network-online.target

[Service]
Type=simple
User=root
Environment=GOOGLE_APPLICATION_CREDENTIALS=/data/gcp-key.json
ExecStartPre=/bin/mkdir -p /mnt/gcs-bucket
ExecStart=/usr/bin/gcsfuse --foreground --file-mode=777 --dir-mode=777 thisisalongcrazyname9 /mnt/gcs-bucket
ExecStop=/bin/umount -l /mnt/gcs-bucket
Restart=on-failure
RestartSec=3
TimeoutStartSec=30

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/gcsfuse-my-bucket.service

# Reload configurations
sudo systemctl daemon-reload

# Enable automatic startup
sudo systemctl enable gcsfuse-my-bucket.service

# Start the service
sudo systemctl start gcsfuse-my-bucket.service
