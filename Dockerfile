FROM circleci/node:12-buster
LABEL maintainer "Mandy Schoep <mandyschoep@gmail.com>"


USER root
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y vim wget curl python3-pip file desktop-file-utils nodejs --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN wget -qO- "https://github.com/hadolint/hadolint/releases/download/v1.17.3/hadolint-Linux-x86_64" > hadolint \
    && cp "hadolint" /usr/bin/ \
    && chmod +x /usr/bin/hadolint

# hadolint ignore=DL4006
RUN scversion="stable" \
    && wget -qO- "https://storage.googleapis.com/shellcheck/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv \
    && cp "shellcheck-${scversion}/shellcheck" /usr/bin/




# hadolint ignore=DL3016
RUN npm install -g bats
# hadolint ignore=DL3013
RUN pip3 install wheel
# hadolint ignore=DL3013
RUN pip3 install setuptools
# hadolint ignore=DL3013
RUN pip3 install yamllint
# hadolint ignore=DL3013
RUN npm install -g markdownlint-cli


USER circleci
