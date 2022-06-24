# syntax = docker/dockerfile:1.0-experimental
# Big thanks and credit to the coder crew and https://github.com/coder/code-server

FROM registry.access.redhat.com/ubi9/ubi:${RHEL_VERSION:-latest}

ARG TARGETPLATFORM

ENV PASSWORD=${PASSWORD:-devops}

LABEL maintainer="Tok - Tony Kay tony.g.kay@gmail.com"

COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      ARCHITECTURE=amd64; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      ARCHITECTURE=arm64; \
    fi \
    && dnf install -y https://github.com/coder/code-server/releases/download/v4.4.0/code-server-4.4.0-${ARCHITECTURE}.rpm \
      python-devel \
      sudo \
    && useradd devops \
    && echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && chmod +x /usr/bin/entrypoint.sh \
    && dnf clean all \
    && rm -rf /var/cache/dnf /root/.cache

# RUN pip3 --no-cache-dir install ansible 

#    && pip3 cache purge \
# TODO Install Ansible tooling (ansible, no need for navigator?)
# TODO Install oc
# TODO Install kubectl
# TODO Install nice to have utilities - so terminal feels like "a VM", ping, dig, nslookup etc

USER devops
WORKDIR /home/devops

EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]
