#!/bin/bash

# générer une galerie des images weathermap

IMAGE_DIR="/opt/librenms/html/plugins/Weathermap/output"
HISTORY_DIR="/opt/librenms/html/plugins/Weathermap/output/history"
DATE=`date '+%Y%m%d%H%M'`

for dir in "$HISTORY_DIR"/*/
do

    dir=${dir%*/} # Supprimer le slash à la fin du nom de répertoire
    cd "$dir"

    PNG_FILES=($(ls *.png))

    # Écrire le début du fichier HTML
    cat <<EOF > galerie.html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Galerie Weathermap $dir</title>
    </head>
    <body>
        <h1>Galerie Weathermap</h1>
EOF

    # Écrire les liens vers les images dans le fichier HTML
    for FILE in "${PNG_FILES[@]}"
    do
        echo "<a href=\"$FILE\"><img src=\"$FILE\" alt=\"$FILE\" width=\"400\"></a>" >> galerie.html
    done

    # Écrire la fin du fichier HTML
    cat <<EOF >> galerie.html
    </body>
    </html>
EOF

    cd "$HISTORY_DIR"

done
