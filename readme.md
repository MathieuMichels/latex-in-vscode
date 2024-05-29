# Compilations de fichiers Latex depuis VSCode
> [!NOTE]  
> Ce script est destiné à Windows et Linux. MacOS n'est pas supporté officiellement. Le support sur Linux est à ce jour plus complet que sur Windows.

## Windows [Testé sur Windows 11]
### Installation

> [!WARNING]
> Si vous désirez utiliser certains packages tels que ```svg```, vous aurez besoin d'installer ```inkscape```. 
> 
> Rendez-vous sur https://inkscape.org/release/0.92.1/windows/64-bit/, et téléchargez l'installateur.
> 
> Installez ensuite ```inkscape``` sur votre ordinateur en suivant les étapes à l'écran. 
1. Installer MikTek (https://miktek.org/download).
2. Lors de l'installation:
     - Activez la compilation via le terminal.
     - Activez l'installation automatique des packages.
3. Utilisez le fichier ```./make.bat``` comme expliqué dans la section [utilisation](#Utilisation).

---
### Problèmes fréquents

> [!NOTE]
> Aucun problème fréquent répertorié.
> 


## Linux - Ubuntu [Testé sur Ubuntu 23.10]
### Installation

> [!NOTE]
> Si vous utilisez une autre distribution linux qu'Ubuntu, il faut adapter les commandes ```apt-get``` par celles respectives à votre système.
Ouvrez un terminal et effectuez les opérations suivantes:
1. Mettre à jour la liste des paquets: ```sudo apt-get update```
> [!WARNING]
> Si vous désirez utiliser certains packages tels que ```svg```, vous aurez besoin d'installer ```inkscape```. Si vous l'avez installé via ```snap```, désinstallez le avec la commande ```sudo snap remove --purge inkscape```.
> 
> Vous pouvez l'installer avec la commande suivante: ```sudo apt-get install inkscape```
>
> Vérifiez ensuite qu'```inkscape``` est correctement installé et accessible depuis n'importe où sur votre ordinateur. Pour cela, ouvrez n'importe quel autre dossier dans le terminal et tapez ```inkscape --version```. Si une version s'affiche, ça fonctionne.
1. Installer Teklive: ```sudo apt-get install texlive```
2. Installer tous les packages complémentaires: ```sudo apt-get install texlive-full```
3. Utilisez le fichier ```./make.sh``` comme expliqué à la section [utilisation](#utilisation).

---


### Problèmes fréquents
#### Problèmes avec les ```svg```:

- Désinstaller et réinstaller ```inkscape```
- Utiliser des liens absolus et non relatifs pour référencer les images. 
  - Par exemple, utiliser ```\includesvg{/home/user/latex-project/imgs/img-1}``` 
  - Plutôt que ```\includesvg{imgs/img-1}```.

#### Problèmes avec des packages manquants:

- Installer la version complète de Texlive: ```sudo apt-get install texlive-full```.
- Se référer à [ce post](https://tex.stackexchange.com/questions/134365/installation-of-texlive-full-on-ubuntu-12-04).


## MacOS [Non supporté officiellement]
> [!WARNING]
> Non supporté officiellement.

## Utilisation

1. Clonez ou copier le fichier dont vous avez besoin: ```git clone https://github.com/MathieuMichels/latex-in-vscode.git```
2. Placez le fichier dont vous avez besoin (```make.bat``` si vous êtes sur Windows et ```make.sh``` si vous êtes sur Linux) dans le répertoir de votre projet latex.
3. Adaptez le fichier à vos besoins. Vous pouvez soit le modifier intrinsèquement, dans les premières lignes du fichier, ou bien passer les valeurs en argument. 
4. Lancer la commande pour compiler:
    - Voici l'exemple de commande minimale fonctionnel à condition que votre fichier d'entrée s'appelle ```main.tex``` et que vous souhaitiez ouvrir le fichier PDF à la fin de la compilation: 
        ```bash
        ./make.sh
        ```             
    - Exemple d'utilisation complet: 
        ```bash
        ./make.sh --projectName "Mon projet" --mainFile "main.tex" --buildDir "build" --compiler "lualatex" --openPDF 1 --numCompilations 1 --compress 0 --debug 0 --clean 0
        ```

## Paramètres
> [!TIP]
> Lorsque vous travaillez sur un projet, il est préférable de modifier les paramètres directement dans le fichier ```make.bat``` ou ```make.sh```. Cela vous évitera de devoir passer les arguments à chaque compilation.

- ```projectName``` : Nom du projet, qui sera le titre du fichier PDF généré.
- ```mainFile``` : Nom du fichier principal .tex.
- ```buildDir``` : Dossier de compilation.
- ```compiler``` : Compilateur (à modifier pour utiliser certaines options spécifiques).
- ```openPDF``` : Ouvrir automatiquement le fichier PDF à la fin de la compilation (1 pour oui, 0 pour non).
- ```numCompilations``` : Nombre de compilations à effectuer. Une seule compilation est généralement suffisante. Cependant, pour actualiser la table des matières il faut effectuer deux compilations (une première pour calculer les pages nécessaires et générer le .toc, et une seconde pour ajouter la table des matières).
- ```debug``` : Afficher les messages de débogage (1 pour oui, 0 pour non).
- ```clean``` : Nettoyer les fichiers temporaires (1 pour oui, 0 pour non).
- ```compress``` : Compresser le fichier PDF (1 pour oui, 0 pour non).
>[!NOTE]
>Si le fichier est petit, la compression ne sera pas très efficace. Il est possible que le fichier compressé soit plus grand que le fichier original.

> [!WARNING] 
> Si vous souhaitez compresser le fichier PDF, si vous êtes sur Linux, vous n'avez rien à faire.
>
> Si vous êtes sur Windows, vous devez installer ```ghostscript``` (https://www.ghostscript.com/download/gsdnld.html) et ajouter le chemin d'accès à ```gswin64c.exe``` dans les variables d'environnement de Windows.


## Informations fournies sur le fichier PDF
- Nom du fichier généré.
- Nombre de pages.
- Temps de comimpilation.
- Nombre de pages.
- Taille du fichier en Octets, Ko et Mo.
- Date et heure de la dernière modification.
- Nombre de mots dans le document.

Si vous avez compressé le fichier, il affichera également les informations: 
- Nom du fichier compressé.
- Taille du fichier compressé en Octets, Ko et Mo.
- Gain en taille par rapport au fichier non compressé.


## Pour nettoyer les fichiers temporaires
Deux options s'offrent à vous pour nettoyer les fichiers temporaires:
1. Vous nettoyez directement lors de la compilation en ajoutant l'argument ```--clean 1```. 
    - Exemple:
         ```bash
         ./make.sh --clean 1
         ```
2. Vous nettoyez après la compilation en exécutant le fichier ```clean.bat``` ou ```clean.sh```:
   - Ouvrez le fichier ```clean.bat``` si vous êtes sur Windows et ```clean.sh``` si vous êtes sur Linux dans le dossier contenant vos fichiers Latex.
   - Modifiez les paramètres du fichier ```clean.bat``` ou ```clean.sh``` si nécessaire.
   - Exécutez le fichier ```clean.bat``` ou ```clean.sh``` pour nettoyer les fichiers temporaires:
       ```bash
       ./clean.sh
       ```
   - Choisissez si vous souhaitez également nettoyer la table des matières.

### Paramètres à modifier dans clean
- ```buildDir``` : Dossier de compilation.
- Si vous avez plusieurs sous-dossiers, ajoutez les suppressions dans le fichier ```clean.bat``` ou ```clean.sh```.

## Divers
> [!WARNING]
> Si vous êtes sur ```Linux```, il est possible qu'exécuter les fichiers depuis le terminal intégré à VSCode ne fonctionne pas. Dans ce cas, ouvrez un terminal (```CTRL + ALT + T```), placez-vous dans le répertoire de votre projet et exécutez le fichier ```make.sh```:
> ```bash
> ./make.sh
> ```
>
> Si vous souhaitez tout de même exécuter les fichiers depuis le terminal intégré à VSCode, désinstaller la version de VSCode installée via ```snap``` et installer la version via ```apt-get```:
> ```bash
> sudo snap remove --purge code
> sudo apt-get install code
> ```
---
> [!TIP]
> Si vous désirez utiliser la même police d'écriture qu'Overleaf, vous pouvez télécharger la police d'écriture ```CMU Serif``` sur le site officiel de [Computer Modern Unicode](https://sourceforge.net/projects/cm-unicode/).
>
> Ensuite, au début de votre fichier .tex, ajoutez la ligne suivante:
> ```latex
> \usepackage{fontspec}
> \setmainfont{CMUSerif-Roman}
> ```
---
> [!TIP]
> Si vous désirez utiliser des images vectorielles mais ne voulez pas vous embêter avec Inkscape, vous pouvez convertir vos images en pdf.
