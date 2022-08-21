FROM ubuntu:latest

ARG BUILD_DATE
ARG ANSIBLE_VERSION=2.8.0
ARG ANSIBLE_LINT_VERSION=4.3
ARG MITOGEN_VERSION
ARG VCS_REF

USER root
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers

RUN apt-get update -y
RUN apt-get install -y \
        ca-certificates \
        git \
        openssh-client \
        openssh-server \
        openssl \
        python3 \
        python3-pip \
        python3-cryptography \
        rsync \
        sshpass 

RUN apt-get install -y \
        python3-dev \
        libffi-dev \
        libssl-dev \
        curl \
 && pip3 install --upgrade \
        pip \
        cffi \
        wheel \
 && pip3 install \
        ansible==${ANSIBLE_VERSION} \
        ansible-lint==${ANSIBLE_LINT_VERSION}

RUN mkdir -p /etc/ansible \
 && echo 'localhost' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

COPY entrypoint /usr/local/bin/

WORKDIR /ansible

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN mkdir -p "${JENKINS_AGENT_HOME}/.ssh/"
RUN addgroup --gid "${gid}" --group "${group}"
# Set the home directory (h), set user and group id (u, G), set the shell, don't ask for password (D)
RUN adduser --home "${JENKINS_AGENT_HOME}" --uid "${uid}" --ingroup "${group}" --shell /bin/bash --disabled-login "${user}"
RUN usermod -aG sudo

RUN apt-get update && apt-get install -y \
    bash \
    git-lfs \
    netcat-openbsd \
    openjdk-11-jdk

RUN mkdir /usr/local/openjdk-11/
RUN mkdir /usr/local/openjdk-11/bin
RUN ln -s /opt/java/openjdk/bin/java /usr/local/openjdk-11/bin/java

# setup SSH server
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' \
        -e 's/#PermitUserEnvironment.*/PermitUserEnvironment yes/' \
    && mkdir /var/run/sshd

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

# Alpine's ssh doesn't use $PATH defined in /etc/environment, so we define `$PATH` in `~/.ssh/environment`
# The file path has been created earlier in the file by `mkdir -p` and we also have configured sshd so that it will
# allow environment variables to be sourced (see `sed` command related to `PermitUserEnvironment`)

RUN echo "PATH=${PATH}" >> ${JENKINS_AGENT_HOME}/.ssh/environment
COPY setup-sshd /usr/local/bin/setup-sshd

USER jenkins

EXPOSE 22

ENTRYPOINT ["setup-sshd"]
