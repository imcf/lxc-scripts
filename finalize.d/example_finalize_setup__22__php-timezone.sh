#!/bin/bash

set -e

# explicitly set the timezone for PHP:
sed -i 's,^;date.timezone =,date.timezone = "Europe/Zurich",' /etc/php5/apache2/php.ini
