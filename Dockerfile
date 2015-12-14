# Ghost Docker image.
# Ghost is a simple, powerful publishing platform.
#
# Ghost version: latest
#
FROM ghost:latest

MAINTAINER Alexander Holbreich http//alexander.holbreich.org

# Add in better default config 
ADD config.example.js config.example.js
ADD *.sh /
# Fix permisions for management sripts 
RUN chmod a+x /backup.sh && chmod a+x /restore.sh

# Fix ownership in src
RUN chown -R user $GHOST_SOURCE/content

#volume for backupscripts
VOLUME /backups

# Default environment variables
ENV GHOST_URL http://localhost