#!/bin/sh

FILE=/tmp/initialized

set -e

if [ ! -f "$FILE" ]; then
  mv -n /var/www/data/pages /var/dokuwiki-storage/data/pages && \
  ln -s /var/dokuwiki-storage/data/pages /var/www/data/pages && \
  mv -n /var/www/data/meta /var/dokuwiki-storage/data/meta && \
  ln -s /var/dokuwiki-storage/data/meta /var/www/data/meta && \
  mv -n /var/www/data/media /var/dokuwiki-storage/data/media && \
  ln -s /var/dokuwiki-storage/data/media /var/www/data/media && \
  mv -n /var/www/data/media_attic /var/dokuwiki-storage/data/media_attic && \
  ln -s /var/dokuwiki-storage/data/media_attic /var/www/data/media_attic && \
  mv -n /var/www/data/media_meta /var/dokuwiki-storage/data/media_meta && \
  ln -s /var/dokuwiki-storage/data/media_meta /var/www/data/media_meta && \
  mv -n /var/www/data/attic /var/dokuwiki-storage/data/attic && \
  ln -s /var/dokuwiki-storage/data/attic /var/www/data/attic && \
  mv -n /var/www/conf /var/dokuwiki-storage/conf && \
  ln -s /var/dokuwiki-storage/conf /var/www/conf
  touch /tmp/initialized
fi


chown -R nobody /var/www
chown -R nobody /var/dokuwiki-storage

su -s /bin/sh nobody -c 'php7 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf

