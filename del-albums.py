#!/usr/bin/env python3

import os.path
import shutil
import sys

todel_file = os.path.expanduser("~/todel_music")
albums = []
songs = []


def pprint(t):
    for line in t:
        print(line)
    print()


def del_album_song(thing):
    if os.path.isdir(thing):
        shutil.rmtree(thing)
    elif os.path.isfile(thing):
        os.remove(thing)
    else:
        print("DNE {}".format(thing))


def del_music(t):
    for sub in t:
        re = input("Delete {}? [yn] ".format(sub))
        if re == "y":
            print("DEL", sub)
            del_album_song(sub)
        else:
            print("SKIP", sub)
        print()


if not os.path.isfile(todel_file):
    print("todel_file doesn't exist")
    sys.exit(1)

with open(todel_file, 'r') as f:
    for line in f:
        stripped = line.strip()
        if os.path.isdir(stripped):
            albums.append(stripped)
        elif os.path.isfile(stripped):
            songs.append(stripped)


for song in songs:
    album = os.path.dirname(song)
    if album in albums:
        print("removing {}".format(os.path.basename(song)))
        songs.remove(song)

print("Songs to delete are")
pprint(songs)
print("Albums to del are")
pprint(albums)

for mu in [albums, songs]:
    del_music(mu)
