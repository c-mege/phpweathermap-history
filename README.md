# Weathermap History

Ces fichiers permettent de conserver un historique des graphes weather map et de naviguer pour voir l'évolution du traffic réseau.

## Installation

Il faut ajouter un cron qui va sauvegarder les fichiers puis créer le fichier index permettant de les visualiser.

Comme les weathermaps ne sont générées "que" toutes les 5 minutes, le cron se lance toutes les 5 minutes : 

*/5  *    * * *   /opt/librenms/weathermapHistory.sh  >> /dev/null 2>&1

## Fichier bash 

Un seul fichier bash permet de sauvegarder les wm, et de générer l'index.html.

Voir ce fichier pour plus de détails.


## Idée initiale

Largement inspiré de https://forums.cacti.net/viewtopic.php?t=40310
mais amélioré, la solution initiale demandait un script, un fichier php, ne gérait qu'une seule map et ne faisait que lister sous forme de lien les maps.

J'ai ajouté la gestion de toutes les maps existantes, la navigation, l'autoplay, bref j'ai rendu ça utile.
Merci à chatGPT pour certains snippets ;-)

