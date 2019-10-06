FROM dockcross/linux-x86:latest AS dep-quickjs
ENV QUICKJS_VERSION="2019-09-18"
RUN apt update -y && apt install -y \
    --no-install-recommends \
        g++-multilib \
        make \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src
ADD "https://bellard.org/quickjs/quickjs-${QUICKJS_VERSION}.tar.xz" .
RUN tar xvJf "quickjs-${QUICKJS_VERSION}.tar.xz" \
    && mv "quickjs-${QUICKJS_VERSION}" "quickjs" \
    && cd "quickjs" \
    && make

FROM dockcross/linux-x86:latest AS dep-gawain
WORKDIR /usr/local/gawain
COPY . .

FROM dockcross/linux-x86:latest AS build-linux-x86
LABEL maintainer="Hyeseong Kim <cometkim.kr@gmail.com>"
ENV CUSTOM_BUILD_ENV=DOCKER_LINUX_X86
RUN apt update -y && apt install -y \
    --no-install-recommends \
        libsdl2-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
COPY --from=dep-quickjs /usr/src/quickjs /usr/src/quickjs
COPY --from=dep-gawain /usr/local/gawain /usr/local/gawain
RUN ln -s /usr/src/quickjs/qjsc /usr/bin/qjsc

WORKDIR /usr/src/app

COPY docker-buildscript.sh /
RUN chmod +x /docker-buildscript.sh
CMD ["/docker-buildscript.sh"]

ONBUILD COPY src .
