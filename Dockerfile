# Ghost Docker image.
# Ghost is a simple, powerful publishing platform.
#
# Ghost version: latest
#
FROM ghost:latest

MAINTAINER Alexander Holbreich http//alexander.holbreich.org

# Add in better default config 
ADD config.example.js config.example.js

# Fix ownership in src
RUN chown -R user $GHOST_SOURCE/content

# Default environment variables
ENV GHOST_URL http://my-ghost.com