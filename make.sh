#!/bin/bash

# Définition des valeurs par défaut
projectName="Mon projet Latex" # Nom du projet
mainFile="main.tex" # Fichier d'entrée du projet Latex
buildDir="build" # Dossier dans lequel les fichiers générés seront stockés
compiler="lualatex" # Compilateur à utiliser (pdflatex, xelatex, lualatex)
openPDF=1 # Ouvrir le PDF généré après la compilation (1 pour oui, 0 pour non)
numCompilations=1 # Nombre de compilations à effectuer
compress=0 # Compresser le fichier PDF généré (1 pour oui, 0 pour non)
debug=0 # Debug mode (1 pour oui, 0 pour non)
clean=0 # Nettoyer les fichiers temporaires après la compilation (1 pour oui, 0 pour non)

# Analyse des arguments de ligne de commande
while [[ $# -gt 0 ]]; do
    case $1 in
        --projectName)
            projectName="$2"
            shift
            shift
            ;;
        --mainFile)
            mainFile="$2"
            shift
            shift
            ;;
        --buildDir)
            buildDir="$2"
            shift
            shift
            ;;
        --compiler)
            compiler="$2"
            shift
            shift
            ;;
        --openPDF)
            openPDF="$2"
            shift
            shift
            ;;
        --numCompilations)
            numCompilations="$2"
            shift
            shift
            ;;
        --clean)
            clean="$2"
            shift
            shift
            ;;
        --debug)
            debug="$2"
            shift
            shift
            ;;
        --compress)
            compress="$2"
            shift
            shift
            ;;
        *)
            echo "Argument non reconnu : $1"
            exit 1
            ;;
    esac
done

# correct projectName to handle spaces
projectName=$(echo $projectName | sed 's/ /_/g')

# Enregistrement de l'heure de début
start=$(date +%s%N)

# Compilation du fichier selon le nombre spécifié d'itérations
for ((i=1; i<=numCompilations; i++)); do
    echo "Compilation $i."
    # if debug is set to 1, then the -interaction=batchmode option is not used
    if [[ $debug -eq 1 ]]; then
        $compiler --shell-escape  -jobname="$buildDir/$projectName" "$mainFile" 
    else
        $compiler --shell-escape -interaction=batchmode -jobname="$buildDir/$projectName" "$mainFile"
    fi
    echo "Compilation $i: succès."
done

# Enregistrement de l'heure de fin
end=$(date +%s%N)

# Calcul du temps de compilation
elapsed=$((end - start))

# Conversion du temps de compilation en secondes
elapsedSecs=$((elapsed / 1000000000))

# Récupération des informations sur le PDF généré
pdfPath="$buildDir/$projectName.pdf"

# Ouverture du PDF généré
if [[ $openPDF -eq 1 ]]; then
    xdg-open "$pdfPath" &
fi

# Affichage des informations sur le fichier
echo "Le fichier se trouve dans le dossier $pdfPath"

# Nombre de pages dans le PDF
pages=$(pdfinfo "$pdfPath" | grep Pages | awk '{print $2}')

# Taille du fichier en octets
size=$(stat -c%s "$pdfPath")

# Date et heure de modification dd/mm/yyyy hh:mm:ss but rounded to the nearest second
modDate=$(stat -c%y "$pdfPath" | cut -d. -f1)

# Nombre de mots dans le document
wordcount=$(pdftotext -q -enc UTF-8 -eol unix "$pdfPath" - | wc -w)

# Taille en Mo avec des décimales
sizeinmo=$(echo "scale=2; $size / 1048576" | bc)

# Taille en Ko avec des décimales
sizeinko=$(echo "scale=2; $size / 1024" | bc)

# Compression du fichier PDF si nécessaire
if [[ $compress -eq 1 ]]; then
    echo "Compression du fichier PDF."
    gs -sDEVICE=pdfwrite -o "$buildDir/${projectName}_compressed.pdf" -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH "$pdfPath"

    # Obtention de la taille du fichier compressé
    size_compressed=$(stat -c%s "$buildDir/${projectName}_compressed.pdf")

    size_compressed_inko=$(echo "scale=2; $size_compressed / 1024" | bc)

    size_compressed_inmo=$(echo "scale=2; $size_compressed / 1048576" | bc)

    # Calcul du gain en taille
    diff=$((size - size_compressed))

    # Calcul du pourcentage 
    percentage=$((100 - (size_compressed * 100 / size)))
fi

# Affichage des informations dans un cadre
echo
echo "+-------------------------------------------------+"
echo "+         Informations sur le fichier PDF         +"
echo "+-------------------------------------------------+"
echo ">>> Nom du fichier : $projectName.pdf"
echo "    > Temps de compilation : $elapsedSecs secondes"
echo "    > Nombre de pages : $pages pages"
echo "    > Taille du fichier : $size octets"
echo "    > Taille du fichier : $sizeinko Ko"
echo "    > Taille du fichier : $sizeinmo Mo"
echo "    > Dernière modification : $modDate"
echo "    > Nombre de mots : $wordcount mots"
if [[ $compress -eq 1 ]]; then
    echo ""
    echo ">>> Fichier compressé : ${projectName}_compressed.pdf"
    echo "    > Taille du fichier compressé : $size_compressed octets"
    echo "    > Taille du fichier compressé : $size_compressed_inko Ko"
    echo "    > Taille du fichier compressé : $size_compressed_inmo Mo"
    echo "    > Gain en taille : $diff octets soit $percentage%"
fi
echo "+-------------------------------------------------+"


# Nettoyage des fichiers temporaires
if [[ $clean -eq 1 ]]; then
    echo "Nettoyage des fichiers temporaires."
    rm -f "$buildDir/$projectName.aux" "$buildDir/$projectName.log" "$buildDir/$projectName.out" "$buildDir/$projectName.toc" "$buildDir/$projectName.synctex.gz"
fi