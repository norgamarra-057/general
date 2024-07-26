#!/bin/bash

function init_volume() {
  DISK_NAME=$1
  DATA_DIR=$2
  echo "Initializing EBS volume for disk: $DISK_NAME mount point: $DATA_DIR"
  echo "Waiting for volume $DISK_NAME"
  while [ ! -e $DISK_NAME ] ; do sleep 1 ; done
  DATA_DISK=$(readlink -f $DISK_NAME)

  EMPTY_PARTITION=$(file -s $DATA_DISK | grep XFS)
  if [ -z "$EMPTY_PARTITION" ]; then
    echo "Formatting $DATA_DISK"
    mkfs -t xfs "$DATA_DISK"
  fi

  MOUNT_POINT=$(mount | grep $DATA_DIR)
  if [ -z "$MOUNT_POINT" ]; then
    echo "Creating data folder $DATA_DIR"
    mkdir -p $DATA_DIR
    echo "Mounting $DATA_DISK on $DATA_DIR"
    mount "$DATA_DISK" "$DATA_DIR"

    FSTAB_ENTRY=$(cat /etc/fstab | grep $DATA_DIR)
    if [ -z "$FSTAB_ENTRY" ]; then
      UUID=$(blkid | grep $DATA_DISK | awk '{ gsub(/"/,""); gsub("UUID=","");  print $2 }')
      echo "Updating fstab to mount disk at boot with UUID=$UUID on $DATA_DIR"
      echo "UUID=$UUID  $DATA_DIR  xfs  defaults,nofail  0  2" | tee -a  /etc/fstab
    fi
  fi
}

function add_admin_user() {
  USER_NAME=$1
  USER_PUBLIC_KEY=$2

  id "$1" &>/dev/null;
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

function create_group() {
  USER_GROUP=$1

  echo "Configuring group $USER_GROUP"
  groupadd "$USER_GROUP"
}

function add_user_to_group() {
  USER_NAME=$1
  USER_GROUP=$2

  echo "Configuring user $USER_NAME in gds group"
  usermod -a -G "$USER_GROUP" "$USER_NAME"
  usermod -g "$USER_GROUP" "$USER_NAME"
}

##########################################################################
# Initialize EBS volumes
# usage init_volume device_name mountPoint
# e.g. init_volume "/dev/sdb" "/var/groupon"
##########################################################################
init_volume "/dev/sdb" "/var/groupon/data"

##########################################################################
# Initialize Additional Sudo users
# usage add_admin_user user_name public_key
# e.g. add_admin_user "user_admin" "ssh-rsa AAAAB3NzaC1yc.."
##########################################################################

## Adds public keys and user to allow remote ssh
add_admin_user "ec2-user" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpcGGhWZ8SyVlIV15PEUpxTKprCCB9a8fhCCbBOyilnJAQA8AEa7LTkOt1L09QCqG+Dgq3bjCZngX22MRpTnsXkSQS9z2l/yEGVh4IdnFlz9A1zJbuxYQB0vSoJRkxTRO4fhFhph8H5OayB8Q0gpw7faslKSQq89PDjOLbuaonX7l8nuz+9B19GMOT4ac0g3HPJ99cbzE8ctp9GhJZBSBC4rIvKg39AvlMCYjEkCioRiOusBa3/ThOlus95RsDUgORjTVUzjtYn/rOyG/u9j/Vp2lchtyrqBBH6A7/wcsRjLZZGw9O9umu0eaqvXGks16rjsUocAkfO+5ONrWCxzYX krkinnal@C02X2NCPJG5H.group.on"
add_admin_user "mohjamal" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRhrhfesJU75cBn9qIIcnzmdfeKBsTIq8LcsrtoL/MEIkTOPqKxFagzNvPaJ+XTIw66wZacju5AVPfRNXIZ0xeX1As7Fw3kHGKAk68HrX/Kot6EUgbxuEm5Yq04unx0htRTA9e4OMszOKWJk8jyyOaJDr8ivLAVf+XYvaH/EqX0sOVLpCB7AE4/eCIOvqlLux7L4D2qsKJL4UvHXywKHWxYZmNgPofWMcKM2mZQZudOwlSLWzKOMcAbTikXqA+Prei23OiLLih2vtQc4A8rh1y2m/7WYjiL/rWSsOKOM2MoGTs7r+BesButiI5mFTCyqeUQE9wceTXQGGiPI7qMi0PKyum6G3jC29AsryfAnN2Ig3Ni837ilmi2ovBQPmn6mjGxinVvHRdlpoeDo0otlgi31zN5z220477/fhcYdvE8kDmJqX4y10YBiDZsOiF5FMOcR0vGK8zVjJBNaEZkC/etLl5uQJWxQmy4ODWVtAZGHvMhADZTzz9LzWx+yU/P3RYvFEbIEdia4ONSrUU3e3gNiiH/6W15ba5ou5jfgvJ5QWHH+VfpLri9w0Vsmaw2GBap0lIRxU7Sv8Y7KFUAIOtlV99o13vAenxNOFd6JdM0P9wxS2duuDfp+WxoWPX/iNuGYOZV+cnQ8pGinElNkqi7pT3oBZkVpULGiH0jguPfw== mohjamal@192.168.1.23"
add_admin_user "fkalamidas" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDqT2lhmLUyqMIvr0lXQ7ovOBzDMEGlC3TabkQZnM8nnZ4hGGjZuXROzy8pv3q/O8IBX+vJyLbOJUuKXXMc3K3oQTecaZIGBr0qB7nmjKSZtgYa6kqryE5utNWgi8SXFxVBMFHjKX1Sq0WhKc4QiUYOeDjqhJlm9St9NqmeAmIEwU8qohSmgLPIJv0rkWjZGEhXNVU7mq1anUfu5kHDY6+0afrUZx1T0EVL5Yfqp7BtW7kc+VR00ZrlJExTAExyBV0YjllIzQrs9eItBSuMgBDiCPPMXqYxVmx0gTXERnysLf/tA7oxvzmcRvdaV/0ocVdVNrh/Tb/Q9Bg0zLqTQfs7 
fkalamidas@groupon.com"
add_admin_user "rsagarwal" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHcqua9heseZ7VOVjXSdo8czH10Nq7VhNIV7Eoe3vLOmamaZcH7PpgEk0Xbb8koe0vxBaGOodOWS+G/WwqlurXfmq9aKwSsHrd+htxi6tuu8VMz3o97yxvzNWPhhpGffMCAbp89aPJYvvBULtJGLhwrVvHVd0fF5CaU6mrOCO0nIPI9Nq+PfsZ1qrur9vojZZ4sZpChw6R+kmhBoQ+4QinxnbF37VjkD3eQZdy/tYC1c7kPym58e/nlHMpnwdTq4bqQaJxkQJEnY5EBYgCKWxVImBS6V2fionHkdVWgcS7Olz8M/jB0FxOiGyDvKsc8ZvXCMhr9A0Iun5R4F3BAL3mOw4LoC9x3klc8nTLnLPTkkOPHyP7EzaqMY1zzp3ne8w7bU31sUIgkfp8YfVOGiM3tiHeU/ESK1hHidFb+MSEJ5jhzVKCSoVuIK7tDfVbvvK915mNXV+35aAVpnfBkkWH0AHU4JucCUcNI+BEU+owIt6sbIXojM9qseHGj6JRufbgoJ5UtqaD3Rr12kfsOvwPVsj/ZsJnUZy082CPTsbKQf7od7HruTDFY2aLq7S4e/dF2oi+LmXvqjy0uVo1cWfWrHqs9UngpRT81NNShanXBaQswXk7Dk224LocuYuuDKoqoAOFvkrdQID2lgDqvfkjGPkMTKaQkOa3ZrMbkGT9xQ== rsagarwal@DQXV92YHHQ.local"


## Configures gds group and adds users
create_group "gds"
add_user_to_group "mohjamal" "gds"
add_user_to_group "fkalamidas" "gds"

## Steps to initialize the ansible controller box with git and ansible
## As of now we use same versions as the aws ansible controller for backward compatibility

#printf "y\n" | yum update
#printf "y\n" | yum install git

#curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py
#python2 /tmp/get-pip.py

#pip install pip --upgrade
#pip install ansible==2.7.8
#pip install cryptography==2.7


#### Steps to fetch aws_certificates to connect to Kafka using TLS
#yum install jq -y
#wget https://raw.github.groupondev.com/ApplicationSecurity/aws_certificate/master/scripts/fetch_cert
#chmod u+x fetch_cert
#./fetch_cert --cert_role arn:aws:iam::${AWS_CERT_ACCT_ID}:role/ca.${SERVICE_NAME}.${ENV}
