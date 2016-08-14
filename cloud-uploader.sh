#!/bin/bash
FOLDER="/path/to/folder"                                                                # main-Folder to watch
inotifywait --format "%w%f" "$FOLDER" -mre close_write,moved_to |                       # inotifywait to watch the $FOLDER
        while read file; do                                                             # look how many uploads are running
                p=`ps -aux | grep acd_cli | wc -l`                                      # we do not want more then 6 same uploads
                while [ $p -gt 6 ]; do                                                  #
                        sleep 5                                                         # wait to check for running uploads
                        p=`ps -aux | grep acd_cli | wc -l`                              #
                done                                                                    #
                dest=`sed s@"$FOLDER"@@g <<< "$(dirname "$file")"`                      # $(dirname "$file") give the dirctory of $file. <<< $(dirname "$file) runs sed on the path
                if [ "" == "$dest" ]; then                                              #
                        dest="/"                                                        # if the file is in $FOLDER we need to add a /
                fi                                                                      #
                echo "The file '$file' appeared and will be uploaded into '$dest'"      # info
                (                                                                       #
                acd_cli mkdir --parents "$dest"                                         # create folder to send file to if not exist
                acd_cli sync                                                            # sync creater files else you get error 400
                acd_cli ul -x 4 -r 5 -o -f -rsf "$file" "$dest"                         # -x uploadpipes -r retrys after fail -o to overwrite if better -f force -rsf deletes the file from your computer. make sure this is what you want
                find $FOLDER/ -type d -empty -delete                                    # cleanup and delete empty folders
                ) &                                                                     #
         done                                                                           #
