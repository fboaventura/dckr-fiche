# -----------------------------------
# Fiche MAKEFILE
# https://github.com/solusipse/fiche
# solusipse.net
# -----------------------------------

CFLAGS+=-pthread -O2
prefix=/usr/local

all: fiche fiche-static

fiche:
	gcc ${CFLAGS} fiche.c -o fiche

fiche-static:
	gcc ${CFLAGS} -static -w fiche-root.c -o fiche-static

install: fiche
	install -m 0755 fiche $(prefix)/bin

clean:
	rm -f fiche fiche-static

.PHONY: clean
