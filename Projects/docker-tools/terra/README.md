# Docker container

Steps:

## Build and run the container:
```
cd ~/git/experiments/dockertop/terra

docker kill dockerterra && docker rm dockerterra
docker build -t dockerterra .

GIT_DIR=/Users/c_ngamarra/Desktop/repos/GRPN
docker run --name dockerterra -d \
  --mount type=bind,source=$GIT_DIR/raas-secrets,target=/root/git/raas-secrets,readonly \
  --mount type=bind,source=$GIT_DIR/raas,target=/root/git/raas \
  --mount type=bind,source=$GIT_DIR/raas_terraform_modules,target=/root/git/raas_terraform_modules \
  --mount type=bind,source=$GIT_DIR/rds,target=/root/git/rds \
  dockerterra

docker exec -it dockerterra bash
```

## Set up the okta pass
```
gpg --full-generate-key
# Use these options:
# (1) RSA and RSA (default)
# What keysize do you want? (3072)
# 0 = key does not expire
# Real name: pablo
# Email address: (empty)
# Comment: (empty)
# *** Empty passphrase ***

# example ID: E3DACF8364A57434
pass init 5800A121DD7E1CE81E94BFFC36170437DC1818F6

aws-okta add --domain=groupon.okta.com --username=c_ngamarra
# test (may fail the first time):
aws-okta exec dev -- aws --region us-west-2 elasticache describe-cache-clusters
```
## Tests

### Terraform:

Afterhook:
```
cd ~/git/raas/raas_aws/tf_afterhook/
./hook.rb ~/git/raas/raas_aws/terragrunt_live/stg_im_usw2/redis/
```

Beforehook:
```
cd ~/git/raas/raas_aws/tf_beforehook/
./hook.rb ~/git/raas/raas_aws/terragrunt_live/stg_im_usw2/redis/
```

Apply:
```
cd ~/git/raas/raas_aws/terragrunt_live/stg_im_usw2/redis/
ta
```
## Useful commands
```
docker pause dockerterra
docker start dockerterra
docker unpause dockerterra
```

# How to compile the aws-okta binary:
```
git clone https://github.com/segmentio/aws-okta.git
cd aws-okta
version=1.0.11
export GOARCH=arm64 # Mac M1
export GOARCH=amd64 # normal Mac
GOOS=linux O111MODULE=on go build -mod=vendor -ldflags="-X main.version=$version" -o aws-okta.$GOARCH
```
