ARG ARCH
FROM ${ARCH}/ubuntu:bionic
MAINTAINER yhaenggi <yhaenggi-git-public@darkgamex.ch>

ARG ARCH
ARG VERSION
ARG IMAGE
ENV VERSION=${VERSION}
ENV ARCH=${ARCH}
ENV IMAGE=${IMAGE}

COPY ./qemu-x86_64-static /usr/bin/qemu-x86_64-static
COPY ./qemu-i386-static /usr/bin/qemu-i386-static
COPY ./qemu-arm-static /usr/bin/qemu-arm-static
COPY ./qemu-aarch64-static /usr/bin/qemu-aarch64-static

RUN echo force-unsafe-io | tee /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
RUN apt-get update

# set noninteractive installation
ENV DEBIAN_FRONTEND=noninteractive
#install tzdata package
RUN apt-get install tzdata -y
# set your timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Zurich /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install software-properties-common -y
RUN add-apt-repository universe
RUN add-apt-repository multiverse

RUN apt-get install socat -y

RUN mkdir -p /home/socat
RUN useradd -M -d /home/socat -u 911 -U -s /bin/bash socat
RUN usermod -G users socat

RUN chown socat:socat /home/socat -R

RUN apt-get clean
RUN rm -Rf /var/lib/apt/lists
RUN rm -Rf /var/cache/apt

RUN rm /usr/bin/qemu-i386-static /usr/bin/qemu-x86_64-static /usr/bin/qemu-arm-static /usr/bin/qemu-aarch64-static

USER socat
WORKDIR /home/socat

ENTRYPOINT ["/usr/bin/socat"]
