#! /bin/bash

[ -s "/usr/local/rvm/scripts/rvm" ] && . "/usr/local/rvm/scripts/rvm"

rvm 2.4.1@hyrax

echo "$(date)" >> /media/Library/ESPYderivatives/processNewUploads/addAccessions.log
cd /var/www/hyrax-UAlbany

rake add:accessions
