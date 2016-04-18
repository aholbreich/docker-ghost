# docker-ghost

Docker golden image ([gold/ghost](https://hub.docker.com/r/gold/ghost/)) for [Ghost](https://github.com/TryGhost/Ghost).

Most relevant tags
* 0.7.9 (latest)
* 0.7.8
* 0.7.6
* 0.7.5
* 0.7.4
* 0.7.3
* 0.7.2

Branches
* apline   [![](https://badge.imagelayers.io/gold/ghost:alpine.svg)](https://imagelayers.io/?images=gold/ghost:alpine 'alpine')

==Attention: Alpine version is still experimenthal. Use in production on your own risk==

## Why yet another image for Ghost?

[Ghost environments](http://support.ghost.org/config/#about-environments) suggest that it's better to use production

The official container for Ghost is fine for running in development mode, but it has the wrong
permissions for running in production. That, and the config file doesn't have any easy way to tweak
it (Credits to [Peter Timofev](https://github.com/ptimof/docker-ghost))

Also backup script is backed in.
Switc from dev to production environment is easy. Beware in default config both modes operate on same database
`/content/data/ghost.db`


## Quickstart

```
docker run --name some-ghost -p 8080:2368 -d gold/ghost:alpine
```

This will start Ghost in development mode and whire to the port 80 of the container.

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.

## Running in production

The official Ghost image places the blog content in `/var/lib/ghost` and exports it as a `VOLUME`.
This allows two main modes of operation:

### Content on host filesystem

In this mode, the Ghost blog content lives on the filesystem of the host with the `UID`:`GID` of
`1000`:`1000`. If this is acceptable, create a directory somewhere, and use the `-v` Docker command
line option to mount it:

```
sudo mkdir -p /var/lib/ghost
sudo chown 1000:1000 /var/lib/ghost
docker run --name some-ghost --env-file /etc/default/ghost -p 80:2368 -v /var/lib/ghost:/var/lib/ghost -d gold/ghost npm start --production
```

This is very convinient, because you can tweak your configuration directly in host's `/var/lib/ghost/confg.js`.

### Content in a data volume

This is the preferred mechanism to store the blog data. Please see the
[Docker documentation](https://docs.docker.com/userguide/dockervolumes/#backup-restore-or-migrate-data-volumes)
for backup, restore, and migration strategies.

```
docker create -v /var/lib/ghost --name some-ghost-content busybox
docker run --name some-ghost --env-file /etc/default/ghost -p 80:2368 --volumes-from some-ghost-content -d gold/ghost npm start --production
```

You should now be able to access this instance as `http://www.example.com` in a browser.

### Configuration via environment variables

Epecially in case you run the content in a volume it's good to have a posibillity to injet some config form outide.

There are environment variables that can be used:

* `GHOST_URL`: the URL of your blog (e.g., `http://www.example.com`)
* `MAIL_FROM`: the email of the blog installation (e.g., `'"Webmaster" <webmaster@example.com>'`)
* `MAIL_HOST`: which host to send email to (e.g., `mail.example.com`)
* `PROD_FORCE_ADMIN_SSL`: Relevant for prodction mode only. Tel's Ghost to force use SSL for admin pages (default: true)

These can either be set on the Docker command line directly, or stored in a file and passed on
the Docker command line:

```
docker run --name some-ghost --env-file /etc/default/ghost -p 8080:2368 -d gold/ghost
```

Here an example of ENV variables file:
```
# Ghost environment example
# Place in /etc/default/ghost

GHOST_URL=http://www.example.com
MAIL_FROM='"Webmaster" <webmaster@example.com>'
MAIL_HOST=mail.example.com
PROD_FORCE_ADMIN_SSL=true
```

### Behind a reverse proxy

Of course, you should really be running Ghost behind a reverse proxy, and set things up to auto restart. For that,
a reasonable container would be:

```
docker create --name some-ghost -h ghost.example.com --env-file /etc/default/ghost -p 127.0.0.1:2368:2368 --volumes-from some-ghost-content --restart=on-failure:10 gold/ghost npm start --production
docker run some-ghost
```

### Backup 

Backup is working for host based or volume based data (see below)

```
docker run --rm --volumes-from some-ghost -v $(pwd)/backups:/backups gold/ghost /backup.sh
```
Backups ghost to current directory.

#### Restoring Backup
**Attention:**  Restore script for volume based data keeping is not provied yet. Make sure you know what to do.

For the host based solution just extract backup file content to volume location on host.

Please contactm if you have good ideas here.


### Example docker-comose.yaml
```
ghost:
  image: gold/ghost:alpine
  command: npm start --production
  restart: always  
  ports: 
   - "2368:2368"
  volumes:
   - /var/containerdata/ghost/blog/:/var/lib/ghost
  environment:
   - GHOST_URL=http://example.com
   - PROD_FORCE_ADMIN_SSL=true
   - MAIL_FROM='"Webmaster" <webmaster@example.com>'
   - MAIL_HOST=mail.example.com

```
Even if env varibales are provided, config.js can b still found and tweaked in /var/containerdata/ghost/blog/ on the host.

### More information

* [Docker image for Ghost blog](http://alexander.holbreich.org/docker-ghost-image/)
* [Home of the project on Gihub](https://github.com/aholbreich/docker-ghost)

