#!/bin/sh
##FileBot needs that:
LOG="/root/logs/amc.log"
EXCLUDE="/root/logs/amc.txt"
SERIEN="/path/to/uploadfolder/{plex}"
FILME="/path/to/uploadfolder/{plex}"
UNSORTIERT="/path/to/uploadfolder/unsorted/{file.structurePathTail}" ### separate folder for filebot for the case that it cannot recognize a movie / series

##execute filebot
filebot -script fn:amc --lang de --log-file $LOG --action move "$1" --def "seriesFormat=$SERIEN" "movieFormat=$FILME" "unsortedFormat=$UNSORTIERT" -non-strict --def unsorted=y --def skipExtract=y --def minFileSize=104857600 --def exclud$

## clean everything
filebot -script fn:cleaner "$1" --def root=y "exts=jpg|nfo|rar|nfo|htm|html|url|txt|etc" "terms=sample|trailer|etc"
