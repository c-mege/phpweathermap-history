# Weathermap History

Based on an initial idea from jwhitaker on [cacti forums](https://forums.cacti.net/viewtopic.php?t=40310), this script create an history of php weathermap maps.

It parses all the maps in a source directory, archive them, and creates a web page galery showing them with dated links, and can also animate them.

## Installation

*If you read that I'll assume you already have php weathermap installed and generating maps.*

To generate the galery, you'll need to add a cron with a user with correct rights :

`*/5  *    * * *   /opt/librenms/weathermapHistory.sh  >> /dev/null 2>&1`

In my case, I use [libreNMS](https://www.librenms.org/), so this cron is for the `librenms` user.

I update weathermaps every 5 minutes, so I also save them every 5 minutes. 

Change this delay according to your generation rythm, and your achive needs.

## bash file

There is only one bash file that does all the magic :

- save the weathermaps, 
- and generate the web galery

see inside this bash script for adjustements if needed.

## Tips

To easily access history from your weather map, add a virtual device in your phpweathermaps : 

```
NODE Historique
        LABEL Historique
        INFOURL http://10.201.10.34/plugins/Weathermap/output/history/cameras/index.html
        POSITION 1226 26
```
The url will have to be adapted for each weathermap you generate.

## Thanks

Thanks [jwhitaker](http://forums.cacti.net/memberlist.php?mode=viewprofile&u=29739) for the initial idea and [chatGPT](https://chat.openai.com/chat) for some snippets ;-)
