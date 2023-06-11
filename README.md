# Weathermap History

Based on an initial idea from jwhitaker on [cacti forums](https://forums.cacti.net/viewtopic.php?t=40310), this script create an history of php weathermap maps.

It parses all the maps in a source directory, archive them, and creates a web page galery showing them with dated links, and can also animate them.

## Installation

*If you read that I'll assume you already have php weathermap installed and generating maps.*

To generate the galery, you'll need to add a cron with a user with correct rights :

`*/5  *    * * *   /opt/librenms/weathermapHistory.sh  >> /dev/null 2>&1`

In my case, I use [libreNMS](https://www.librenms.org/), so this cron is for the `librenms` user.

## Fichier bash 

One bash file will save the weathermaps, and generate the web galery, see inside this bash script for parameters.

## Thanks

Thanks for chatGPT for some snippets ;-)
