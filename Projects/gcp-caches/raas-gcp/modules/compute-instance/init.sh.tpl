#!/bin/bash

function add_admin_user() {
  USER_NAME=$1
  USER_PUBLIC_KEY=$2

  id "$USER_NAME" &>/dev/null;
  if id "$USER_NAME" &>/dev/null; then
      echo "Skipping user creation, User $USER_NAME already defined"
  else
      echo "Initializing user account for : $USER_NAME with public key: $USER_PUBLIC_KEY"
      adduser "$USER_NAME"
      passwd -l "$USER_NAME"
      mkdir -p /home/$USER_NAME/.ssh
      echo "$USER_PUBLIC_KEY" > /home/$USER_NAME/.ssh/authorized_keys
      chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
      chmod 700 /home/$USER_NAME/.ssh
      chmod 600 /home/$USER_NAME/.ssh/authorized_keys

      echo "Adding user: $USER_NAME to sudoers group"

      echo "# Created by terraform init.sh $(date)" >> /etc/sudoers.d/$USER_NAME
      echo "# User rules for $USER_NAME" >> /etc/sudoers.d/$USER_NAME
      echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER_NAME
      echo "User: $USER_NAME, successfully configured"
  fi
}

##########################################################################
# Initialize Additional Sudo users
# usage add_admin_user user_name public_key
##########################################################################

add_admin_user "c_ngamarra" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMxSueYV5YyYJueVFZwBwoEGZ4u62wGq2IhiZSDj9xpfyNp05d9fixSKCgbKyXjv03NVsUG+A59l/n10FYn6V4MUDFdmRNB0+oRZLJzji+5dVhKhlA3lTnskVUvYG3yWiLppRhWvGqzB7Z++7jFfIbP/iEalg4TELQvKWCYw5OphxajMD+C2gkovY9xgVv/7XGbYfdvPnpEmkzotMYbUGI1Kw6qBHkM9iTPivh542u2xHmv/1oogtpezbrtO+3kDiQmzV2pvifUqsrVX47zKhIw0ouHdMgDNTqeH82tZO5kKm66YJsMmpb62U75Tbod6dQs/e6EzJ2p+d4huVVekv7xwXPPqvmxoKCEi44K6cew//CsFu/vKfbAdDe858Gtr/NMXM3IpdXzfpY/uIzMvz3+VfJdsPOqdToPogreHgLY/HcveOimyKik75cpyF4mJvMl02C+8/akgTW/USmj85Rnv4TZQUfTFJ/Bt/RkPZkAw1XDTfSw3o3Mtrr6lVBguk= c_ngamarra@c-ngamarras-MacBook-Pro.local"
add_admin_user "ec2-user" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpcGGhWZ8SyVlIV15PEUpxTKprCCB9a8fhCCbBOyilnJAQA8AEa7LTkOt1L09QCqG+Dgq3bjCZngX22MRpTnsXkSQS9z2l/yEGVh4IdnFlz9A1zJbuxYQB0vSoJRkxTRO4fhFhph8H5OayB8Q0gpw7faslKSQq89PDjOLbuaonX7l8nuz+9B19GMOT4ac0g3HPJ99cbzE8ctp9GhJZBSBC4rIvKg39AvlMCYjEkCioRiOusBa3/ThOlus95RsDUgORjTVUzjtYn/rOyG/u9j/Vp2lchtyrqBBH6A7/wcsRjLZZGw9O9umu0eaqvXGks16rjsUocAkfO+5ONrWCxzYX krkinnal@C02X2NCPJG5H.group.on"

##########################################################################
# Install necessary packages
##########################################################################

sudo apt-get update
printf "y\n" | sudo apt-get install -y openjdk-17-jdk unzip redis-tools

##########################################################################
# Install Riot Redis Tools
##########################################################################

# Create directories for riot tools
mkdir -p /opt/riot-4.0.3 /opt/riot-3.2.3

# Download and unzip riot tools
wget https://github.com/redis/riot/releases/download/v4.0.3/riot-4.0.3.zip -O /tmp/riot-4.0.3.zip
sudo unzip /tmp/riot-4.0.3.zip -d /opt/
rm /tmp/riot-4.0.3.zip

wget https://github.com/redis-developer/riot/releases/download/v3.2.3/riot-3.2.3.zip -O /tmp/riot-3.2.3.zip
sudo unzip /tmp/riot-3.2.3.zip -d /opt/
rm /tmp/riot-3.2.3.zip

# Create symbolic links for all users
sudo ln -sf /opt/riot-4.0.3/bin/riot /usr/local/bin/riot4
sudo ln -sf /opt/riot-3.2.3/bin/riot /usr/local/bin/riot3

echo "Riot Redis Tools installed and symbolic links created."