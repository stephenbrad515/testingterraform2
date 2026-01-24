#!/bin/bash
set -e

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
mkdir -p /mnt/gcs-bucket
chmod 777 /mnt/gcs-bucket

#This allows users other than the one who mounted to access the filesystem
sed -i '/#user_allow_other/s/^[[:blank:]]*#//' /etc/fuse.conf

# 5. Optional: Mount the bucket (Replace 'your-bucket-name' or use a variable)
# Note: Mounting at boot usually requires a specific service account.
gcsfuse thisisalongcrazyname9 /mnt/gcs-bucket
