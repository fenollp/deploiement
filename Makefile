.PHONY: run

all: run

run: /tmp/apt out/legi.py.git out/Archeo-Lex.git out/tarballs out/db out/textes out/cache
	docker run --rm -it \
	  -e UIDGID=$$(id -u):$$(id -g) \
	  -v /tmp/apt:/var/cache/apt/archives:rw \
	  -v "$$PWD"/out/legi.py.git:/app/legi.py.git \
	  -v "$$PWD"/out/Archeo-Lex.git:/app/Archeo-Lex.git \
	  -v "$$PWD"/out/tarballs:/app/tarballs \
	  -v "$$PWD"/out/db:/app/db \
	  -v "$$PWD"/out/textes:/app/textes \
	  -v "$$PWD"/out/cache:/app/cache \
	  -v "$$PWD"/run_from_debian.sh:/app/do:ro \
	  python:2.7-wheezy /app/do

/tmp/apt out/legi.py.git out/Archeo-Lex.git out/tarballs out/db out/textes out/cache:
	mkdir -p $@
