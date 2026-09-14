# EwidencjaPrzejazdowWPF

Projekt WPF pod bazę `EwidencjaPrzejazdow`.

## Wymagania
- Visual Studio 2022 z workloadem `.NET desktop development`
- SQL Server
- baza `EwidencjaPrzejazdow` utworzona wcześniej

## Uruchomienie
1. Otwórz plik `EwidencjaPrzejazdowWPF.csproj` w Visual Studio.
2. Przywróć pakiety NuGet.
3. W pliku `DataBase/AppDbContext.cs` ustaw poprawny connection string.
4. Uruchom aplikację.

## Domyślny connection string
Projekt używa domyślnie:

`Server=.;Database=EwidencjaPrzejazdow;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True;`

Jeśli masz inną nazwę instancji SQL Server, podmień ją w `AppDbContext.cs`.
