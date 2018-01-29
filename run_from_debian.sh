#!/bin/sh -x

set -o errexit
set -o nounset

code_legipy="${LEGIPY:-/app/legi.py.git}"
ref_legipy=${LEGIPY_REF:-master}
code_archeolex="${ARCHEOLEX:-/app/Archeo-Lex.git}"
ref_archeolex=${ARCHEOLEX_REF:-master}
tarballs="${TARBALLS:-/app/tarballs}"
db="${DB:-/app/db}"
textes="${TEXTES:-/app/textes}"
cache="${CACHE:-/app/cache}"

# Update and install some packages
apt update && apt upgrade -y
apt install -y \
    libarchive13 \
    python-pip \
    git \
    sqlite3 \
    python2.7-dev \
    libxml2-dev \
    libxslt1-dev \
    python-setuptools \
    python-wheel

# Copy code for legi.py and Archeo Lex
if ! [ -d "$code_legipy/.git" ]; then
    git clone https://github.com/Legilibre/legi.py.git "$code_legipy"
fi
( cd "$code_legipy"
  git checkout "$ref_legipy"
  pip install -r requirements.txt
)

if ! [ -d "$code_archeolex/.git" ]; then
    git clone https://github.com/Legilibre/Archeo-Lex.git "$code_archeolex"
fi
( cd "$code_archeolex"
  git checkout "$ref_archeolex"
  pip install -r requirements.txt
)

# Download tarballs & compute database
( cd "$code_legipy"
  python -m legi.download "$tarballs"
  python -m legi.tar2sqlite "$db"/legi.sqlite "$tarballs"
)

# Launch Archeo Lex on 3000 random texts
( cd "$code_archeolex"
  ./archeo-lex --textes=aleatoire-3000 \
               --bddlegi="$db"/legi.sqlite \
               --dossier="$textes" \
               --cache="$cache"
)

chown -R "$UIDGID" \
      "$code_legipy" \
      "$code_archeolex" \
      "$tarballs" \
      "$db" \
      "$textes" \
      "$cache"
