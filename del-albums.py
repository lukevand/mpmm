#!/usr/bin/env python3

import os.path
import shutil
import sys

todel_file = os.path.expanduser("~/todel_music")
albums = []
songs = []


def my_pp(t):
    for line in t:
        print(line)
    print()


def check_sane():
    if not os.path.isfile(todel_file):
        print("todel_file doesn't exist")
        sys.exit(1)


def open_todel(fi):
    with open(fi, 'r') as f:
        for line in f:
            stripped = line.strip()
            if os.path.isdir(stripped):
                albums.append(stripped)
            elif os.path.isfile(stripped):
                songs.append(stripped)
            else:
                continue


def song_cleanup():
    """If you added say 'band/01 song.flac'
    and 'band', 'band' should just be deleted"""
    for song in songs:
        album = os.path.dirname(song)
        if album in albums:
            print("removing {}".format(os.path.basename(song)))
            songs.remove(song)


def print_status():
    print("Songs to delete are")
    my_pp(songs)
    print("Albums to del are")
    my_pp(albums)


def del_thing(thing):
    if os.path.isdir(thing):
        shutil.rmtree(thing)
    elif os.path.isfile(thing):
        os.remove(thing)
    else:
        print("Don't know what {} is".format(thing))


def del_music(t):
    for sub in t:
        re = input("Do you want to delete {}? ".format(sub))
        if re == "y":
            print("Deleting", sub)
            del_thing(sub)
        else:
            print("Skipping", sub)


def actually_deling():
    for mu in [albums, songs]:
        del_music(mu)


check_sane()
open_todel(todel_file)
song_cleanup()
print_status()
actually_deling()
