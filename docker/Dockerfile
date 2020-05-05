ARG IMAGE=ubuntu:focal
FROM ${IMAGE}

ARG UID=1000
ARG GID=1000
ARG USERNAME=pvaradharajan

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
      ca-certificates \
      curl \
      fontconfig \
      xz-utils \
      sudo \
    && apt-get clean

RUN groupadd -g ${GID} -o ${USERNAME} \
    && useradd -m -u ${UID} -g ${GID} -o -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
ENV USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["bash"]
