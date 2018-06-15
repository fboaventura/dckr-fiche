# for debug add -g -O0 to line below
CFLAGS+=-pthread -O2 -Wall -Wextra -Wpedantic -Wstrict-overflow -fno-strict-aliasing -std=gnu11
prefix=/usr/local/bin

all:
	${CC} main.c fiche.c $(CFLAGS) -w -static -o fiche-static

install: fiche
	install -m 0755 fiche $(prefix)

clean:
	rm -f fiche fiche-static

.PHONY: clean
