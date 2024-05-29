@echo off
for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
chcp 1252>nul
setlocal

REM Définition des valeurs par défaut
set "projectName=Mon projet Latex"
set "mainFile=main.tex" 
set "buildDir=build"
set "compiler=lualatex"
set "openPDF=1"
set "numCompilations=1"
set "compress=0"

REM Analyse des arguments de ligne de commande
:parse_args
if "%~1" neq "" (
    if /I "%~1" equ "--projectName" (
        set "projectName=%~2"
        shift
        shift
        goto :parse_args
    ) else if /I "%~1" equ "--mainFile" (
        set "mainFile=%~2"
        shift
        shift
        goto :parse_args
    ) else if /I "%~1" equ "--buildDir" (
        set "buildDir=%~2"
        shift
        shift
        goto :parse_args
    ) else if /I "%~1" equ "--compiler" (
        set "compiler=%~2"
        shift
        shift
        goto :parse_args
    ) else if /I "%~1" equ "--openPDF" (
        set "openPDF=%~2"
        shift
        shift
        goto :parse_args
    ) else if /I "%~1" equ "--numCompilations" (
        set "numCompilations=%~2"
        shift
        shift
        goto :parse_args
    ) else if /I "%~1" equ "--compress" (
        set "compress=%~2"
        shift
        shift
        goto :parse_args
    ) else (
        echo Argument non reconnu : %1
        exit /b 1
    )
)

REM Enregistrement de l'heure de début
for /f "tokens=1-4 delims=:., " %%a in ("%time%") do (
    set /a "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)


REM Compilation du fichier selon le nombre spécifié d'itérations
for /L %%i in (1,1,%numCompilations%) do (
    echo Compilation %%i.
    %compiler% --shell-escape -jobname="%buildDir%/%projectName%" %mainFile% -output-directory=%buildDir% 
    echo Compilation %%i: succès.
)


REM Enregistrement de l'heure de fin
for /f "tokens=1-4 delims=:., " %%a in ("%time%") do (
    set /a "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

REM Calcul du temps de compilation
set /a elapsed=end-start

REM Conversion du temps de compilation en secondes
set /a elapsedSecs=elapsed/100



REM Récupération des informations sur le PDF généré
set "pdfPath=%buildDir%\%projectName%.pdf"

REM Ouverture du PDF généré
if %openPDF%==1 (
    start "" "%pdfPath%"
)

echo.
powershell -Command "Write-Host 'Le fichier se trouve dans le dossier " "%pdfPath%" ".' -ForegroundColor Green"
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

REM Taille en Mo avec des décimales
set /a sizeinmo=size / 1048576
set /a remainderMo=(size %% 1048576) * 100 / 1048576
if %remainderMo% lss 10 set remainderMo=0%remainderMo%

REM Taille en Ko avec des décimales
set /a sizeinko=size / 1024
set /a remainderKo=(size %% 1024) * 100 / 1024
if %remainderKo% lss 10 set remainderKo=0%remainderKo%


if "%compress%"=="1" (
    echo Compression du fichier PDF.
    gswin64c -sDEVICE=pdfwrite -o "%buildDir%\%projectName%_compressed.pdf" -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH "%pdfPath%"

    REM Obtention de la taille du fichier compressé
    for %%I in ("%buildDir%\%projectName%_compressed.pdf") do set "size_compressed=%%~zI"

    REM Calcul du gain en taille
    set /a diff=size-size_compressed

    REM Calcul du pourcentage 
    set /a percentage=100 - size_compressed*100/size

)

REM Echo un joli cadre pour les informations
echo.
echo +-------------------------------------------------+
echo +-------------------------------------------------+
echo +         Informations sur le fichier PDF         +
echo +-------------------------------------------------+
echo +-------------------------------------------------+
echo + Temps de compilation : %elapsedSecs% secondes              +
echo +-------------------------------------------------+
echo + Nombre de pages : %pages% pages                      +
echo +-------------------------------------------------+
echo + Taille du fichier : %sizeinmo%.%remainderMo% Mo                    +
echo +-------------------------------------------------+
echo + Taille du fichier : %sizeinko%.%remainderKo% Ko                 +
echo +-------------------------------------------------+
echo + Last modification : %date% %time%        +
echo +-------------------------------------------------+
echo + Nombre de mots : %wordcount% mots                      +
echo +-------------------------------------------------+
if "%compress%"=="1" (
    echo + Taille du fichier compressé : %size_compressed% octets   +
    echo +-------------------------------------------------+
    echo + Gain en taille : %diff% octets soit %percentage%%%      +
    echo +-------------------------------------------------+
)
endlocal
chcp %cp%>nul
