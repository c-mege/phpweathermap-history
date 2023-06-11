#!/bin/bash

# script for saving and accessing weathermaps :
# cmege 2023-03-13

# parameters :
# where are stored the 'raw' weathermaps :
IMAGE_DIR="/opt/librenms/html/plugins/Weathermap/output"
# where do we save weathermaps history
HISTORY_DIR="/opt/librenms/html/plugins/Weathermap/output/history"
# beware, this date format is used in the script, if you change it, you'll have to modify the script
DATE=`date '+%Y%m%d%H%M'`


# première partie : gestion des fichiers images
#   recopie dans le répertoire d'archivage
#   et suppression des vieux fichiers

for file in "$IMAGE_DIR"/*.png ; do

    # pour chaque image (donc map) générée par WM :
    # Obtention du nom de fichier sans l'extension
    name=$(basename "$file") ;
    name=${name%.*} ;

    # Création d'un sous-répertoire avec le nom de fichier sans l'extension
    mkdir -p "$HISTORY_DIR/$name" ;

    # Copie de l'image
    cp ${file}  "$HISTORY_DIR/$name"/map_$DATE.png ;

    # Suppression des anciens historiques
    find "$HISTORY_DIR/$name" -name "*.png" -mtime +2 -delete

done

# Deuxième partie : génération d'un fichier html pour parcourir ces images
for dir in "$HISTORY_DIR"/*/
do

    dir=${dir%*/} # Supprimer le slash à la fin du nom de répertoire
    cd "$dir"

    # Créer un tableau de noms de fichiers PNG dans le répertoire courant
    PNG_FILES=($(ls -c -r *.png))

    # Écrire le début du fichier HTML
    cat <<EOF > index.html

            <!DOCTYPE html>
            <html>
            <head>
            <style>
                h1 { font-family: Verdana, Geneva, sans-serif; font-size: 24px; font-style: normal; font-variant: normal; font-weight: 700; line-height: 26.4px; }
                h2 { font-family: Verdana, Geneva, sans-serif; font-size: 16px; font-style: normal; font-variant: normal; font-weight: 700; line-height: 18.4px; }
                h3 { font-family: Verdana, Geneva, sans-serif; font-size: 14px; font-style: normal; font-variant: normal; font-weight: 700; line-height: 15.4px; }
                p { font-family: Verdana, Geneva, sans-serif; font-size: 14px; font-style: normal; font-variant: normal; font-weight: 400; line-height: 20px; }
                blockquote { font-family: Verdana, Geneva, sans-serif; font-size: 21px; font-style: normal; font-variant: normal; font-weight: 400; line-height: 30px; }
                pre { font-family: Verdana, Geneva, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: 400; line-height: 18.5667px; }
            </style>
            <title>Historique Weathermap</title>
            <script>
                var animation = 0;
                var currentIndex = 0;
                var pngFiles = [$(printf "'%s'," "${PNG_FILES[@]}")];

                function changeImage(delta) {
                    currentIndex += delta;
                    if (currentIndex < 0) {
                        currentIndex = pngFiles.length - 1;
                    } else if (currentIndex >= pngFiles.length) {
                        currentIndex = 0;
                    }
                    document.getElementById('image').src = pngFiles[currentIndex];
                    document.getElementById('image_url').href = pngFiles[currentIndex];
                }
                function loadImage(index) {
                    currentIndex = index;
                    if (currentIndex < 0) {
                        currentIndex = pngFiles.length - 1;
                    } else if (currentIndex >= pngFiles.length) {
                        currentIndex = 0;
                    }
                    document.getElementById('image').src = pngFiles[currentIndex];
                    document.getElementById('image_url').href = pngFiles[currentIndex];
                }
                function avance(index) {
                    changeImage(1);
                }
                function toggleAnimation(index) {
                    if (animation) {
                        animation = 0;
                        clearInterval(interval);
                        document.getElementById('btnAnim').innerText = "Animer";
                    } else {
                        animation = 1;
                        interval  = setInterval(avance, 500);
                        document.getElementById('btnAnim').innerText = "Arreter";
                    }
                }

            </script>
            </head>
            <body>
                <h1>Historique <a href="../../$(basename "$dir").html">Weathermap</a></h1>
                <table>
                <TR>
                <TD style="vertical-align:top; border: 1px solid black">
                <div style="text-align:right;font-family: Verdana, Geneva, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: 400; line-height: 18.5667px; ">
                        Navigation :&nbsp;
                        <a href="../../$(basename "$dir").html">[Weathermap]</a>
                        <button onclick="loadImage(0)">Premier</button>&nbsp;
                        <button onclick="changeImage(-1)">Précédent</button>&nbsp;
                        <button id="btnAnim" onclick="toggleAnimation(1)">Animer</button>&nbsp;
                        <button onclick="changeImage(1)">Suivant</button>&nbsp;
                        <button onclick="loadImage(-1)">Dernier</button>&nbsp;
                </div>
                <div>
                        <a id="image_url" href="${PNG_FILES[0]}"><img id="image" src="${PNG_FILES[0]}" alt="${PNG_FILES[0]}"></a>
                </div>
                </TD>
                <TD style="vertical-align:top; border: 1px solid black; font-family: Verdana, Geneva, sans-serif; font-size: 13px; font-style: normal; font-variant: normal; font-weight: 400; line-height: 18.5667px; ">
                <div>
                    <h2 align="center">Historique</h2>
                    <ul>
EOF

    # show all historical maps
    #    count=0
    #    for FILE in "${PNG_FILES[@]}"
    #    do
    #        date_clean=$(echo $FILE | sed 's/map_\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\).*\.png/\1-\2-\3\ \4:\5/' )
    #        echo "<li><button onclick=\"loadImage($count)\">charger</button>&nbsp;<a href=\"$FILE\">${date_clean}</a></li>" >> index.html
    #        ((count++))
    #    done

    # Group files by day / hour
    count=0
    declare -A files
    for FILE in "${PNG_FILES[@]}"
    do
        date_group=$(echo $FILE | sed 's/map_\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\).*\.png/\1-\2-\3\_\4h/' )
        date_min=$(echo $FILE | sed 's/map_\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\).*\.png/\5/' )
        files[$date_group]="${files[$date_group]}<button onclick=\"loadImage($count)\">${date_min}</button>"
        ((count++))
    done

    for date_group in $(echo "${!files[@]}" | tr ' ' '\n' | sort ); do
        date_clean=$(echo "$date_group" | sed 's/_/\&nbsp\;/');
        echo "<li>${date_clean}${files[$date_group]}</li>" >> index.html
    done

    unset files

    # Écrire la fin du fichier HTML
    cat <<EOF >> index.html
                    </ul>
                </div>
                </TD>
            </body>
        </html>
EOF

    # On remonte à la racine des historiques
    cd "$HISTORY_DIR"

done


