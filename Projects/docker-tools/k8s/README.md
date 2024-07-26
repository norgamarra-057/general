# Docker container

Steps:

## Build and run the container:
```
cd ~/git/experiments/dockertop/k8s

docker kill dockerk8s && docker rm dockerk8s
docker build -t dockerk8s .

GIT_DIR=~/desktop/repos/GRPN/
docker run --name dockerk8s -d \
  --mount type=bind,source=$GIT_DIR/raas,target=/root/git/raas \
  --mount type=bind,source=$GIT_DIR/gds-monitoring,target=/root/git/gds-monitoring \
  dockerk8s

docker exec -it dockerk8s bash
```

## Tests
```
kubectl plugin list
kubectl cloud-elevator auth
kubectl config get-contexts
shuttle
helm
```
## Useful commands
```
docker pause dockerk8s
docker start dockerk8s
docker unpause dockerk8s
```

# How to create a cloud elevator pkg for linux arm64

Using a temporary go container (v 1.7 until CCLOUD-3294):
```
docker run --rm -it --entrypoint bash golang:1.17.12-bullseye
# inside the container:
git clone https://github.groupondev.com/conveyor-cloud/cv2.git
cd cv2/
make GOOS=linux GOARCH=arm64 package/tools
# don't worry about the pipenv error
# this is what matters:
ls -lh build/linux-arm64/cloud-elevator-*.tar.gz
# before exiting from the container, from another terminal,
# the the go container's name (example: optimistic_gould):
docker ps
# and rescue the tar:
docker cp peaceful_satoshi:/go/cv2/build/linux-arm64/cloud-elevator-2.1.0.tar.gz ~/desktop/repos/GRPN/docker-tools/k8s
```

FYI: they don't publish linux-arm64 packages, but only amd64, so don't use this:
```
# based on https://pages.github.groupondev.com/conveyor/aws/aws_user_onboarding.html#installing-tools
RUN wget https://artifactory.groupondev.com:443/artifactory/artifacts-conveyor/cloud-elevator/v2.0.1/linux-amd64/cloud-elevator-2.0.1.tar.gz
```