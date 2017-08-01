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
ENV USER "root"
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

### Changes to fiche

In order to make it work properly in a so small image, I had to make two little changes to `fiche.c`, that can be viewed below. These changes will only make sure that fiche is ran always as `root`.

```diff
$ diff -u fiche.c fiche-root.c 
--- fiche.c     2017-07-31 02:53:26.530938821 -0300
+++ fiche-root.c        2017-07-31 18:20:20.700240056 -0300
@@ -38,6 +38,7 @@
     parse_parameters(argc, argv);
     set_domain_name();
 
+    /*
     if (getuid() == 0)
     {
         if (UID == -1)
@@ -47,6 +48,7 @@
         if (setuid(UID) != 0)
             error("Unable to drop user privileges");
     }
+    */
 
     if (BASEDIR == NULL)
         set_basedir();
@@ -466,11 +468,14 @@
 void set_uid_gid(char *username)
 {
     struct passwd *userdata = getpwnam(username);
-    if (userdata == NULL)
-        error("Provided user doesn't exist");
-
-    UID = userdata->pw_uid;
-    GID = userdata->pw_gid;
+    if (userdata == NULL) {
+        // error("Provided user doesn't exist");
+        UID = 0;
+        GID = 0;
+     } else {
+        UID = userdata->pw_uid;
+        GID = userdata->pw_gid;
+     }
 }
 
 int check_protocol(char *buffer)
```


