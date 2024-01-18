#!/bin/sh
srcDir="../php/public"
webroot="../php"
logroot="./.log"

if [ ! -d "$srcDir" ]; then
 sudo  mkdir -p "$srcDir"
  echo "Created folder: $srcDir"
else
  echo "Folder $srcDir exists."
fi
echo "Fixing folder ownership $srcDir"
sudo chown 1000:1000 -R $webroot
echo "Fixing folder ownership $logroot"
sudo chown 1000:1000 -R $logroot
echo "Fixing folder permissions $srcDir"
sudo chmod  -R 755 $webroot
echo "Fixing folder permissions $logroot"
sudo chmod  -R 777 $logroot

echo "OK"
