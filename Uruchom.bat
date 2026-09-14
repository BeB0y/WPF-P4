@echo off
chcp 65001 >nul
setlocal

cd /d "%~dp0"

echo ================================
echo  EwidencjaPrzejazdowWPF
echo ================================
echo.

where dotnet >nul 2>&1
if errorlevel 1 (
    echo BLAD: Nie znaleziono polecenia dotnet.
    echo Zainstaluj .NET 8 SDK i uruchom ten plik ponownie.
    echo.
    pause
    exit /b 1
)

if not exist "EwidencjaPrzejazdowWPF.csproj" (
    echo BLAD: Nie znaleziono pliku EwidencjaPrzejazdowWPF.csproj.
    echo Plik Uruchom.bat musi znajdowac sie w katalogu projektu.
    echo.
    pause
    exit /b 1
)

echo Przywracanie pakietow NuGet...
dotnet restore "EwidencjaPrzejazdowWPF.csproj"
if errorlevel 1 goto :error

echo.
echo Uruchamianie aplikacji...
dotnet run --project "EwidencjaPrzejazdowWPF.csproj"
if errorlevel 1 goto :error

exit /b 0

:error
echo.
echo ================================
echo Wystapil blad podczas uruchamiania.
echo Sprawdz komunikaty powyzej.
echo ================================
pause
exit /b 1
