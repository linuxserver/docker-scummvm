# syntax=docker/dockerfile:1
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SCUMMVM_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=ScummVM

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/scummvm-logo.png && \
  echo "**** install packages ****" && \
  if [ -z "${SCUMMVM_VERSION+x}" ]; then \
    SCUMMVM_VERSION=$(curl -sX GET "https://api.github.com/repos/scummvm/scummvm/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/scummvm.deb -L \
    "https://downloads.scummvm.org/frs/scummvm/$(echo ${SCUMMVM_VERSION} | sed 's/^v//g')/scummvm_$(echo ${SCUMMVM_VERSION} | sed 's/^v//g')-1_ubuntu24_04_amd64.deb" && \
  apt-get update && \
  apt-get install -y \
    /tmp/scummvm.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
