#!/bin/bash

# Dossier de sortie
buildDir="build"
# Suppression des fichiers auxiliaires générés dans le dossier principal
read -p "Voulez-vous aussi cleaner la table des matires ? (X pour tout nettoyer) [X]:" choice
if [ "$choice" == "X" ]; then
    rm -f $buildDir/*.toc
fi
rm -f $buildDir/*.aux
rm -f $buildDir/*.log
rm -f $buildDir/*.out
rm -f $buildDir/*.gz

# Si plusieurs sous-dossiers, ajouter les suppressions ici par exemple rm -f build/TP/*.aux
rm -f $buildDir/TP/*.aux
# remove le folder TP
rm -rf $buildDir/TP



