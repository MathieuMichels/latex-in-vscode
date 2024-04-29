REM Dossier de sortie
set "buildDir=build"
REM Suppression des fichiers auxiliaires générés dans le dossier principal
set "choice=X"
set /p "choice=Voulez-vous aussi cleaner la table des matires ? (X pour tout nettoyer) [%choice%]:"
if /i "%choice%"=="X" (
    del /Q %buildDir%\*.toc
)
del /Q %buildDir%\*.aux
del /Q %buildDir%\*.log
del /Q %buildDir%\*.out
del /Q %buildDir%\*.gz

REM Si plusieurs sous-dossiers, ajouter les suppressions ici par exemple del /Q build\TP\*.aux
del /Q %buildDir%\TP\*.aux
REM remove le folder TP
rmdir /Q /S %buildDir%\TP
