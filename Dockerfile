# Ghost Docker image.
# Ghost is a simple, powerful publishing platform.
#
# Ghost version: 0.7.9
# 
# ATTENTION: This branch has experimental sttus now. use on your own risk.
#
FROM  mhart/alpine-node:4
MAINTAINER Alexander Holbreich http//alexander.holbreich.org

#Versions
ENV GOSU_VERSION=1.7 \
    GHOST_VERSION=0.7.9 \
    GHOST_SOURCE=/usr/src/ghost

#1. Install GOSU (Docker optimized sudo tool)
RUN set -x && apk add --no-cache --virtual .gosu-deps \
        dpkg gnupg openssl \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps

# 2. Install Node.js 4.x as package
#   https://pkgs.alpinelinux.org/packages?name=nodejs&repo=all&arch=all&maintainer=all
RUN apk --no-cache add nodejs

# 3. Install ghost 

RUN adduser -h /home/user -D user

WORKDIR $GHOST_SOURCE

RUN apk --update add --virtual build-dependencies \
    curl gcc make python unzip \
	&& set -x \
	&& curl -sSL "https://ghost.org/archives/ghost-${GHOST_VERSION}.zip" -o ghost.zip \
	&& unzip ghost.zip \
	&& npm install --production \
    && apk del build-dependencies \
	&& rm ghost.zip \
	&& npm cache clean \
	&& rm -rf /tmp/npm*

VOLUME $GHOST_SOURCE

# Add better default config 
ADD config.example.js config.example.js
ADD backup.sh /
# Fix permisions for backup script
RUN chmod a+x /backup.sh 

# Fix ownership in src
RUN chown -R user $GHOST_SOURCE/content

#volume for backupscripts
VOLUME /backups

# Default environment variables
ENV GHOST_URL=http://localhost PROD_FORCE_ADMIN_SSL=true

EXPOSE 2368
CMD ["npm", "start", "--production"]