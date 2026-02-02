#!/bin/bash
set -e

# Define the flag file location if this files exists script will not run
FLAG_FILE="/etc/startup_was_launched"

# Check if the flag file exists
if [ -f "$FLAG_FILE" ]; then
  echo "Startup script has already run. Exiting."
  exit 0
fi


# This is where the magic happens
  metadata_startup_script = <<-EOT
    #!/bin/bash
    # 1. Update the system
    dnf update -y

    # 2. Add the gcsfuse repository
    tee /etc/yum.repos.d/gcsfuse.repo <<EOF
[gcsfuse]
name=gcsfuse (packages.cloud.google.com)
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

    # 3. Install gcsfuse
    dnf install -y gcsfuse
  EOT

# 4. Create a directory to mount the bucket
sudo mkdir -p /mnt/gcs-bucket
sudo chmod 777 /mnt/gcs-bucket

#This allows users other than the one who mounted to access the filesystem
sed -i '/#user_allow_other/s/^[[:blank:]]*#//' /etc/fuse.conf

# 5. Optional: Mount the bucket (Replace 'your-bucket-name' or use a variable)
# Note: Mounting at boot usually requires a specific service account.
#gcsfuse thisisalongcrazyname9 /mnt/gcs-bucket

#Create A systemd service to mount the bucket with gcsfuse /etc/systemd/system/gcsfuse-my-bucket.service
echo "[Unit]
Description=Mount GCS bucket my-bucket
After=network-online.target local-fs.target
Wants=network-online.target
Requires=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/gcsfuse --foreground -o allow_other --implicit-dirs --file-mode=777 --dir-mode=777 thisisalongcrazyname9 /mnt/gcs-bucket
ExecStop=/bin/umount -l /mnt/gcs-bucket
Restart=on-failure
RestartSec=3
TimeoutStartSec=30

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/gcsfuse-my-bucket.service

# Reload configurations
sudo systemctl daemon-reload

# Enable automatic startup
#sudo systemctl enable gcsfuse-my-bucket.service

# Start the service
sudo systemctl start gcsfuse-my-bucket.service

#Create mount to GCP bucket in fstab
echo "thisisalongcrazyname9 /mnt/gcs-bucket gcsfuse auto,rw,allow_other,file_mode=777,dir_mode=777,user,_netdev 0 0" | sudo tee -a /etc/fstab

# Create the flag file to mark the script as executed
sudo touch "$FLAG_FILE"
echo "One-time setup complete and flag file created."

