FROM ubuntu:jammy-20220531

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  curl \
  git \
  less \
  unzip \
  wget \
  ruby \
  && rm -rf /var/lib/apt/lists/*

#########################
# kubectl / cloud-elevator
#########################

# based on https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# see README for build instructions
COPY cloud-elevator-2.2.0.tar.gz .
RUN tar xzf ./cloud-elevator-2.2.0.tar.gz -C /usr/
RUN rm ./cloud-elevator-2.2.0.tar.gz

#########################
# helm
#########################
RUN wget https://get.helm.sh/helm-v3.9.0-linux-arm64.tar.gz
RUN tar -zxf helm-v3.9.0-linux-arm64.tar.gz
RUN mv linux-arm64/helm /usr/local/bin/helm
RUN rm -fr linux-arm64
RUN rm -fr helm-v3.9.0-linux-arm64.tar.gz

RUN mkdir -p /root/git/
WORKDIR /root/git/
RUN git clone https://github.groupondev.com/cloud-migration-factory/helm-charts.git
WORKDIR "/root/git/helm-charts"
RUN git checkout 94ca9a16

#########################
# final details
#########################

COPY ./bash_aliases.sh /root/.bash_aliases

RUN git config --global alias.co checkout
RUN git config --global alias.br branch
RUN git config --global alias.ci commit
RUN git config --global alias.st status

WORKDIR /root/git/

CMD ["/usr/bin/tail", "-f" , "/dev/null"]
