#!/bin/sh
srcDir="../php/public"

if [ ! -d "$srcDir" ]; then
  mkdir -p "$srcDir"
  echo "Created folder: $srcDir"
else
  echo "Folder $srcDir exists."
fi
echo "Fixing folder ownership $srcDir"
sudo chown 1000:1000 -R $srcDir
echo "OK"
