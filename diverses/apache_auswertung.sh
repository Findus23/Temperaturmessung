#!/bin/sh
zcat -f /var/log/apache2/access.log* | goaccess -a
