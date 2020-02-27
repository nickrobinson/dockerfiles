#!/bin/sh

FILE=/var/dokuwiki-storage/conf/manifest.json

set -e

if test -f "$FILE"; then
  echo "Found files"
  rm -fr /var/www/data/pages
  rm -fr /var/www/data/meta
  rm -fr /var/www/data/media
  rm -fr /var/www/data/media_attic
  rm -fr /var/www/data/media_meta
  rm -fr /var/www/data/attic
  rm -fr /var/www/conf
  ln -s /var/dokuwiki-storage/data/pages/ /var/www/data/pages
  ln -s /var/dokuwiki-storage/data/meta/ /var/www/data/meta
  ln -s /var/dokuwiki-storage/data/media/ /var/www/data/media
  ln -s /var/dokuwiki-storage/data/media_attic/ /var/www/data/media_attic
  ln -s /var/dokuwiki-storage/data/media_meta/ /var/www/data/media_meta
  ln -s /var/dokuwiki-storage/data/attic/ /var/www/data/attic
  ln -s /var/dokuwiki-storage/conf/ /var/www/conf
else
  echo "Did NOT find files"
  mv -n /var/www/data/pages /var/dokuwiki-storage/data/pages && \
  ln -s /var/dokuwiki-storage/data/pages/ /var/www/data/pages && \
  mv -n /var/www/data/meta /var/dokuwiki-storage/data/meta && \
  ln -s /var/dokuwiki-storage/data/meta/ /var/www/data/meta && \
  mv -n /var/www/data/media /var/dokuwiki-storage/data/media && \
  ln -s /var/dokuwiki-storage/data/media/ /var/www/data/media && \
  mv -n /var/www/data/media_attic /var/dokuwiki-storage/data/media_attic && \
  ln -s /var/dokuwiki-storage/data/media_atti/c /var/www/data/media_attic && \
  mv -n /var/www/data/media_meta /var/dokuwiki-storage/data/media_meta && \
  ln -s /var/dokuwiki-storage/data/media_meta/ /var/www/data/media_meta && \
  mv -n /var/www/data/attic /var/dokuwiki-storage/data/attic && \
  ln -s /var/dokuwiki-storage/data/attic/ /var/www/data/attic && \
  mv -n /var/www/conf /var/dokuwiki-storage/conf && \
  ln -s /var/dokuwiki-storage/conf/ /var/www/conf
fi

# Setup Plugins
while IFS=, read -r url name; do
   wget $url -O master.zip
   mkdir /var/www/lib/plugins/$name
   bsdtar -C /var/www/lib/plugins/$name -xf master.zip -s'|[^/]*/||'
   rm master.zip
done <plugins.txt

chown -R nobody /var/www
chown -R nobody /var/dokuwiki-storage

su -s /bin/sh nobody -c 'php7 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
