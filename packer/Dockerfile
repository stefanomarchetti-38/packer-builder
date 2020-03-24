# We will use base-packer-builder image
FROM docker.artifactory.yoox.net/ynap-infrastructure/base-packer-builder:2.5.3

LABEL maintainer="E-Comm Ops Infrastructure Automation <ecops_infrastructure_automation@ynap.com>"

WORKDIR /src

COPY src/ ${WORKDIR}

RUN chmod u+x build.sh

CMD ["./build.sh"]