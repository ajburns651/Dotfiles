#!/bin/bash
TARGET=/home/keb/Documents/School-Org-Notes
for i in {1..100}; do inotifywait -r -e create -e modify -e move -e delete --exclude index.md $TARGET && /home/keb/Documents/School-Org-Notes/Upload.sh ; done
