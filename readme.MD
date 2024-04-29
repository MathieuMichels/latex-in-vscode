# Compilations de fichiers Latex depuis VSCode
> [!WARNING]  
> Ce script ne fonctionne actuellement que sur Windows. Pour Linux, vous pouvez utiliser un script bash similaire.
## Configuration
- Installer l'extension pour Latex (mathematic.vscode-latex) dans VSCode.
- Installer MikTex (https://miktex.org/download) pour compiler les fichiers Latex.
- Activez la compilation automatique dans les paramètres de l'extension Latex, ainsi que la compilation en mode batch si ce n'est pas fait par défaut. 

## Utilisation
- Ouvrez le fichier make.bat dans le dossier contenant vos fichiers Latex.
- Modifiez les paramètres du fichier make.bat selon vos besoins.
- Exécutez le fichier ```make.bat``` pour compiler vos fichiers Latex. ```.\make.bat```	
- Choissisez le nombre de compilations. Une seule compilation est généralement suffisante, mais deux compilations peuvent être nécessaires pour actualiser la table des matières.
### Paramètres à modifier dans make.bat
- ```projectName``` : Nom du projet, qui sera le titre du fichier PDF généré.
- ```mainFile``` : Nom du fichier principal .tex.
- ```buildDir``` : Dossier de compilation.
- ```compiler``` : Compilateur (à modifier pour utiliser certaines options spécifiques).
- ```openPDF``` : Ouvrir automatiquement le fichier PDF à la fin de la compilation (1 pour oui, 0 pour non).

## Informations sur le fichier PDF
- Nombre de pages.
- Taille du fichier en Mo et Ko.
- Date et heure de la dernière modification.
- Nombre de mots dans le document.

## Pour nettoyer les fichiers temporaires
- Ouvrez le fichier clean.bat dans le dossier contenant vos fichiers Latex.
- Modifiez les paramètres du fichier clean.bat selon vos besoins.
- Exécutez le fichier ```clean.bat``` pour nettoyer les fichiers temporaires. ```.\clean.bat```
- Choisissez si vous souhaitez également nettoyer la table des matières.

### Paramètres à modifier dans clean.bat
- ```buildDir``` : Dossier de compilation.
- Si vous avez plusieurs sous-dossiers, ajoutez les suppressions dans le fichier ```clean.bat```.