#!/bin/sh
srcDir="../php/public"
webroot="../php"

if [ ! -d "$srcDir" ]; then
 sudo  mkdir -p "$srcDir"
  echo "Created folder: $srcDir"
else
  echo "Folder $srcDir exists."
fi
echo "Fixing folder ownership $srcDir"
sudo chown 1000:1000 -R $webroot
echo "OK"
