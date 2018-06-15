# fboaventura/dckr-fiche

Docker instance to run [solusipse/fiche](https://github.com/solusipse/fiche) implementation of a pastebin app that have terminal command line in mind, called [termbin](https://termbin.com).

This image is intended to only run the fiche app, and will store the received input into `/data` folder, that is also exported as a `VOLUME` from the Docker Intance.

The most amazing feature of this instance is the size of the image, that is smaller than `1Mb`.
## How to use

This instance is published at [Docker Hub](https://hub.docker.com/r/fboaventura/dckr-fiche/), so it's public available.  All you need to run this instance is:

```bash
$ docker run -d -v `pwd`:/data -p 9999:9999 fboaventura/dckr-fiche
```

You can, of course, pass some custom values to fiche, in order to make it more prone to your usage.  The variables, and their defaults are:

```dockerfile
ENV DOMAIN "localhost"
ENV SLUG 8
ENV BUFFER 4096
ENV USER "nobody"
ENV PORT "9999"
```

Once the instance is running, all you have to do is run:

```
$ echo 'Hello World!' | nc localhost 9999
http://localhost/nzzf6lk0
```

And you will have the file created inside a folder, on your `/data` mounted volume:

```
$ tree
.
└── nzzf6lk0
    └── index.txt

1 directory, 1 file
$ cat nzzf6lk0/index.txt
Hello World!
```

## Better usage

The best scenario to use this image is as a webserver instance sidekick.  I've built an image just to this end ([fboaventura/dckr-httpd](https://hub.docker.com/r/fboaventura/dckr-httpd/)), and here is the `docker-compose.yml` to use both images:

```YAML
version: '2'
volumes:
  fiche-data:
services:
  fiche-app:
    image: fboaventura/dckr-fiche
    environment:
      DOMAIN: example.com
    ports:
      - "9999"
    volumes:
    - fiche-data:/data
  fiche-www:
    image: fboaventura/dckr-httpd
    environment:
        DOMAIN: example.com
    ports:
      - "80"
    volumes:
    - fiche-data:/app/www
```

