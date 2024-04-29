@echo off
setlocal
REM Nom du projet: ce sera le titre de votre fichier.pdf généré.
set "projectName=LEPL1000 - Compilation de fichiers Latex depuis VSCode - 2023-2024"
REM Nom du fichier principal .tex
set "mainFile=main.tex"
REM Dossier de compilation
set "buildDir=build"
REM Compilateur (à modifier pour utiliser certaines options spécifiques)
set "compiler=pdflatex.exe"
REM Ouvrir automatiquement le fichier à la fin de la compilation (1 pour oui, 0 pour non)
set "openPDF=0"

REM Demande à l'utilisateur s'il souhaite compiler une ou deux fois. La table des matières s'actualise après 2 compilations.
set /p choice=Voulez-vous compiler une ou deux fois (2 permet d'actualiser la table des matieres)? (1 ou 2) :
for /L %%i in (1,1,%choice%) do (
    echo Compilation %%i.
    %compiler% -interaction=batchmode -jobname="%projectName%" %mainFile% -output-directory=%buildDir%
    REM echo en vert compilation i réussie
    echo Compilation %%i: succès.
)

REM Récupération des informations sur le PDF généré
set "pdfPath=%buildDir%\%projectName%.pdf"

REM Ouverture du PDF généré
if %openPDF%==1 (
    start "" "%pdfPath%"
)

echo.
powershell -Command "Write-Host 'Le fichier se trouve dans le dossier ""%pdfPath%"".' -ForegroundColor Green"
echo.


for /f "tokens=2" %%a in ('pdfinfo "%pdfPath%" ^| find "Pages:"') do set "pages=%%a"

REM Utilisation de for pour obtenir la taille du fichier
for %%I in ("%pdfPath%") do set "size=%%~zI"

REM Utilisation de forfiles pour obtenir la date et l'heure de modification
for /f "tokens=4,5,6 delims= " %%b in ('forfiles /p "%~dp0" /m "%~nx1" /c "cmd /c echo @fdate @ftime"') do (
    set "date=%%b"
    set "time=%%c"
)
REM obtenir le nombre de mots dans le document
set "wordcount=0"
for /f %%a in ('pdftotext -q -enc UTF-8 -eol unix "%pdfPath%" - ^| find /c /v ""') do set "wordcount=%%a"

REM Echo un joli cadre pour les informations
echo.
echo +-------------------------------------------------+
echo +-------------------------------------------------+
echo +         Informations sur le fichier PDF         +
echo +-------------------------------------------------+
echo +-------------------------------------------------+



echo + Nombre de pages : %pages% pages                     +

echo +-------------------------------------------------+

REM Taille en Mo avec des décimales
set /a sizeinmo=%size% / 1048576
set /a remainderMo=(%size% %% 1048576)*100 / 1048576
if %remainderMo% lss 10 set remainderMo=0%remainderMo%
echo + Taille du fichier : %sizeinmo%.%remainderMo% Mo                     +

echo +-------------------------------------------------+

REM Taille en Ko avec des décimales
set /a sizeinko=%size% / 1024
set /a remainderKo=(%size% %% 1024)*100 / 1024
if %remainderKo% lss 10 set remainderKo=0%remainderKo%
echo + Taille du fichier : %sizeinko%.%remainderKo% Ko                  +

echo +-------------------------------------------------+


REM Dernière modification
echo + Last modification : %date% %time%        +

echo +-------------------------------------------------+


echo + Nombre de mots : %wordcount% mots                     +

echo +-------------------------------------------------+



endlocal