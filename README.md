# docker-ghost

Docker golden image ([gold/ghost](https://hub.docker.com/r/gold/ghost/)) for [Ghost](https://github.com/TryGhost/Ghost).


## Why yet another image for Ghost?

### Prod environment
[Ghost environments](http://support.ghost.org/config/#about-environments) suggest that it's better to use production

The official container for Ghost is fine for running in development mode, but it has the wrong
permissions for running in production. That, and the config file doesn't have any easy way to tweak
it.

### Build in backup

//TODO not ready yet

### Ready for compose out of the box

// TODO

### Utills

//TODO

## Quickstart

```
docker run --name some-ghost -p 8080:2368 -d gold/ghost
```

This will start Ghost in development mode and whire to the port 80 of the container.

```

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.

## Configuration


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

### Content in a data volume

This is the preferred mechanism to store the blog data. Please see the
[Docker documentation](https://docs.docker.com/userguide/dockervolumes/#backup-restore-or-migrate-data-volumes)
for backup, restore, and migration strategies.

```
docker create -v /var/lib/ghost --name some-ghost-content busybox
docker run --name some-ghost --env-file /etc/default/ghost -p 80:2368 --volumes-from some-ghost-content -d gold/ghost npm start --production
```

You should now be able to access this instance as `http://www.example.com` in a browser.

### Behind a reverse proxy

Of course, you should really be running Ghost behind a reverse proxy, and set things up to auto restart. For that,
a reasonable container would be:

```
docker create --name some-ghost -h ghost.example.com --env-file /etc/default/ghost -p 127.0.0.1:2368:2368 --volumes-from some-ghost-content --restart=on-failure:10 gold/ghost npm start --production
docker run some-ghost
```
## Aknowledges

* [Peter Timofev](https://github.com/ptimof/docker-ghost)
