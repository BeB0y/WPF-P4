CREATE DATABASE EwidencjaPrzejazdow;
GO
USE EwidencjaPrzejazdow;
GO
USE EwidencjaPrzejazdow;
GO

CREATE TABLE Kierowcy (
    id_kierowcy INT IDENTITY(1,1) PRIMARY KEY,
    imie NVARCHAR(30) NOT NULL,
    nazwisko NVARCHAR(40) NOT NULL,
    dzial NVARCHAR(50) NOT NULL,
    stanowisko NVARCHAR(50) NOT NULL
);

CREATE TABLE Pojazd (
    id_pojazdu INT IDENTITY(1,1) PRIMARY KEY,
    marka NVARCHAR(40) NOT NULL,
    model NVARCHAR(40) NOT NULL,
    numer_rejestracyjny NVARCHAR(15) NOT NULL UNIQUE,
    typ_wlasnosci NVARCHAR(20) NOT NULL,
    rodzaj_paliwa NVARCHAR(20) NOT NULL,
    srednie_spalanie_100km DECIMAL(5,2) NOT NULL,
    cena_paliwa_za_litr DECIMAL(6,2) NOT NULL,

    CONSTRAINT CHK_Pojazd_TypWlasnosci
        CHECK (typ_wlasnosci IN (N's³u¿bowy', N'prywatny')),

    CONSTRAINT CHK_Pojazd_RodzajPaliwa
        CHECK (rodzaj_paliwa IN (N'benzyna', N'diesel', N'LPG', N'hybryda', N'elektryczny')),

    CONSTRAINT CHK_Pojazd_Spalanie
        CHECK (srednie_spalanie_100km >= 0),

    CONSTRAINT CHK_Pojazd_CenaPaliwa
        CHECK (cena_paliwa_za_litr >= 0)
);

CREATE TABLE PrawoJazdy (
    id_prawa_jazdy INT IDENTITY(1,1) PRIMARY KEY,
    numer_prawa_jazdy NVARCHAR(30) NOT NULL UNIQUE,
    data_wydania DATE NOT NULL,
    data_waznosci DATE NOT NULL,
    id_kierowcy INT NOT NULL UNIQUE,

    CONSTRAINT FK_PrawoJazdy_Kierowcy
        FOREIGN KEY (id_kierowcy) REFERENCES Kierowcy(id_kierowcy),

    CONSTRAINT CHK_PrawoJazdy_Daty
        CHECK (data_waznosci >= data_wydania)
);

CREATE TABLE KategoriaPrawaJazdy (
    id_kategorii INT IDENTITY(1,1) PRIMARY KEY,
    nazwa_kategorii NVARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE PrawoJazdy_Kategoria (
    id_prawa_jazdy INT NOT NULL,
    id_kategorii INT NOT NULL,

    CONSTRAINT PK_PrawoJazdy_Kategoria
        PRIMARY KEY (id_prawa_jazdy, id_kategorii),

    CONSTRAINT FK_PJK_PrawoJazdy
        FOREIGN KEY (id_prawa_jazdy) REFERENCES PrawoJazdy(id_prawa_jazdy),

    CONSTRAINT FK_PJK_Kategoria
        FOREIGN KEY (id_kategorii) REFERENCES KategoriaPrawaJazdy(id_kategorii)
);

CREATE TABLE Przejazd (
    id_przejazdu INT IDENTITY(1,1) PRIMARY KEY,
    data_przejazdu DATE NOT NULL,
    cel_przejazdu NVARCHAR(100) NOT NULL,
    trasa NVARCHAR(150) NOT NULL,
    liczba_kilometrow DECIMAL(8,2) NOT NULL,
    stan_licznika_przed DECIMAL(10,2) NOT NULL,
    stan_licznika_po DECIMAL(10,2) NOT NULL,
    id_kierowcy INT NOT NULL,
    id_pojazdu INT NOT NULL,

    CONSTRAINT FK_Przejazd_Kierowcy
        FOREIGN KEY (id_kierowcy) REFERENCES Kierowcy(id_kierowcy),

    CONSTRAINT FK_Przejazd_Pojazd
        FOREIGN KEY (id_pojazdu) REFERENCES Pojazd(id_pojazdu),

    CONSTRAINT CHK_Przejazd_LiczbaKm
        CHECK (liczba_kilometrow > 0),

    CONSTRAINT CHK_Przejazd_LicznikPrzed
        CHECK (stan_licznika_przed >= 0),

    CONSTRAINT CHK_Przejazd_LicznikPo
        CHECK (stan_licznika_po >= 0),

    CONSTRAINT CHK_Przejazd_Liczniki
        CHECK (stan_licznika_po >= stan_licznika_przed)
);

CREATE TABLE Koszty (
    id_kosztu INT IDENTITY(1,1) PRIMARY KEY,
    rodzaj_kosztu NVARCHAR(30) NOT NULL,
    kwota DECIMAL(10,2) NOT NULL,
    data_kosztu DATE NOT NULL,
    opis NVARCHAR(255) NULL,
    id_przejazdu INT NOT NULL,

    CONSTRAINT FK_Koszty_Przejazd
        FOREIGN KEY (id_przejazdu) REFERENCES Przejazd(id_przejazdu),

    CONSTRAINT CHK_Koszty_Rodzaj
        CHECK (rodzaj_kosztu IN (N'paliwo', N'parking', N'op³ata drogowa', N'inny')),

    CONSTRAINT CHK_Koszty_Kwota
        CHECK (kwota >= 0)
);
USE EwidencjaPrzejazdow;
GO

INSERT INTO Kierowcy (imie, nazwisko, dzial, stanowisko)
VALUES (N'Jan', N'Kowalski', N'Transport', N'Kierowca');

INSERT INTO Pojazd (
    marka, model, numer_rejestracyjny, typ_wlasnosci,
    rodzaj_paliwa, srednie_spalanie_100km, cena_paliwa_za_litr
)
VALUES (
    N'Skoda', N'Octavia', N'SBI12345', N's³u¿bowy',
    N'diesel', 7.50, 6.40
);

INSERT INTO PrawoJazdy (
    numer_prawa_jazdy, data_wydania, data_waznosci, id_kierowcy
)
VALUES (
    N'ABC123456', '2020-01-01', '2030-01-01', 1
);

INSERT INTO KategoriaPrawaJazdy (nazwa_kategorii)
VALUES (N'B');

INSERT INTO PrawoJazdy_Kategoria (id_prawa_jazdy, id_kategorii)
VALUES (1, 1);

INSERT INTO Przejazd (
    data_przejazdu, cel_przejazdu, trasa, liczba_kilometrow,
    stan_licznika_przed, stan_licznika_po, id_kierowcy, id_pojazdu
)
VALUES (
    '2026-06-01', N'delegacja', N'Bielsko-Bia³a - Katowice',
    50, 12000, 12060, 1, 1
);

INSERT INTO Koszty (
    rodzaj_kosztu, kwota, data_kosztu, opis, id_przejazdu
)
VALUES (
    N'paliwo', 50.00, '2026-06-01', N'tankowanie', 1
);

USE master;
GO

IF DB_ID('EwidencjaPrzejazdow') IS NOT NULL
BEGIN
    ALTER DATABASE EwidencjaPrzejazdow SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EwidencjaPrzejazdow;
END
GO

CREATE DATABASE EwidencjaPrzejazdow;
GO

USE EwidencjaPrzejazdow;
GO

/* =========================================================
   TABELA: Kierowcy
   ========================================================= */
CREATE TABLE Kierowcy (
    id_kierowcy INT IDENTITY(1,1) PRIMARY KEY,
    imie NVARCHAR(30) NOT NULL,
    nazwisko NVARCHAR(40) NOT NULL,
    dzial NVARCHAR(50) NOT NULL,
    stanowisko NVARCHAR(50) NOT NULL
);
GO

/* =========================================================
   TABELA: Pojazd
   ========================================================= */
CREATE TABLE Pojazd (
    id_pojazdu INT IDENTITY(1,1) PRIMARY KEY,
    marka NVARCHAR(40) NOT NULL,
    model NVARCHAR(40) NOT NULL,
    numer_rejestracyjny NVARCHAR(15) NOT NULL UNIQUE,
    typ_wlasnosci NVARCHAR(20) NOT NULL,
    rodzaj_paliwa NVARCHAR(20) NOT NULL,
    srednie_spalanie_100km DECIMAL(5,2) NOT NULL,
    cena_paliwa_za_litr DECIMAL(6,2) NOT NULL,

    CONSTRAINT CHK_Pojazd_TypWlasnosci
        CHECK (typ_wlasnosci IN (N's³u¿bowy', N'prywatny')),

    CONSTRAINT CHK_Pojazd_RodzajPaliwa
        CHECK (rodzaj_paliwa IN (N'benzyna', N'diesel', N'LPG', N'hybryda', N'elektryczny')),

    CONSTRAINT CHK_Pojazd_Spalanie
        CHECK (srednie_spalanie_100km >= 0),

    CONSTRAINT CHK_Pojazd_CenaPaliwa
        CHECK (cena_paliwa_za_litr >= 0)
);
GO

/* =========================================================
   TABELA: PrawoJazdy
   ========================================================= */
CREATE TABLE PrawoJazdy (
    id_prawa_jazdy INT IDENTITY(1,1) PRIMARY KEY,
    numer_prawa_jazdy NVARCHAR(30) NOT NULL UNIQUE,
    data_wydania DATE NOT NULL,
    data_waznosci DATE NOT NULL,
    id_kierowcy INT NOT NULL UNIQUE,

    CONSTRAINT FK_PrawoJazdy_Kierowcy
        FOREIGN KEY (id_kierowcy) REFERENCES Kierowcy(id_kierowcy),

    CONSTRAINT CHK_PrawoJazdy_Daty
        CHECK (data_waznosci >= data_wydania)
);
GO

/* =========================================================
   TABELA: KategoriaPrawaJazdy
   ========================================================= */
CREATE TABLE KategoriaPrawaJazdy (
    id_kategorii INT IDENTITY(1,1) PRIMARY KEY,
    nazwa_kategorii NVARCHAR(10) NOT NULL UNIQUE
);
GO

/* =========================================================
   TABELA: PrawoJazdy_Kategoria
   ========================================================= */
CREATE TABLE PrawoJazdy_Kategoria (
    id_prawa_jazdy INT NOT NULL,
    id_kategorii INT NOT NULL,

    CONSTRAINT PK_PrawoJazdy_Kategoria
        PRIMARY KEY (id_prawa_jazdy, id_kategorii),

    CONSTRAINT FK_PJK_PrawoJazdy
        FOREIGN KEY (id_prawa_jazdy) REFERENCES PrawoJazdy(id_prawa_jazdy),

    CONSTRAINT FK_PJK_Kategoria
        FOREIGN KEY (id_kategorii) REFERENCES KategoriaPrawaJazdy(id_kategorii)
);
GO

/* =========================================================
   TABELA: Przejazd
   ========================================================= */
CREATE TABLE Przejazd (
    id_przejazdu INT IDENTITY(1,1) PRIMARY KEY,
    data_przejazdu DATE NOT NULL,
    cel_przejazdu NVARCHAR(100) NOT NULL,
    trasa NVARCHAR(150) NOT NULL,
    liczba_kilometrow DECIMAL(8,2) NOT NULL,
    stan_licznika_przed DECIMAL(10,2) NOT NULL,
    stan_licznika_po DECIMAL(10,2) NOT NULL,
    id_kierowcy INT NOT NULL,
    id_pojazdu INT NOT NULL,

    CONSTRAINT FK_Przejazd_Kierowcy
        FOREIGN KEY (id_kierowcy) REFERENCES Kierowcy(id_kierowcy),

    CONSTRAINT FK_Przejazd_Pojazd
        FOREIGN KEY (id_pojazdu) REFERENCES Pojazd(id_pojazdu),

    CONSTRAINT CHK_Przejazd_LiczbaKm
        CHECK (liczba_kilometrow > 0),

    CONSTRAINT CHK_Przejazd_LicznikPrzed
        CHECK (stan_licznika_przed >= 0),

    CONSTRAINT CHK_Przejazd_LicznikPo
        CHECK (stan_licznika_po >= stan_licznika_przed)
);
GO

/* =========================================================
   TABELA: Koszty
   ========================================================= */
CREATE TABLE Koszty (
    id_kosztu INT IDENTITY(1,1) PRIMARY KEY,
    rodzaj_kosztu NVARCHAR(30) NOT NULL,
    kwota DECIMAL(10,2) NOT NULL,
    data_kosztu DATE NOT NULL,
    opis NVARCHAR(255) NULL,
    id_przejazdu INT NOT NULL,

    CONSTRAINT FK_Koszty_Przejazd
        FOREIGN KEY (id_przejazdu) REFERENCES Przejazd(id_przejazdu),

    CONSTRAINT CHK_Koszty_Rodzaj
        CHECK (rodzaj_kosztu IN (N'paliwo', N'parking', N'op³ata drogowa', N'inny')),

    CONSTRAINT CHK_Koszty_Kwota
        CHECK (kwota >= 0)
);
GO

/* =========================================================
   DANE: Kierowcy
   ========================================================= */
INSERT INTO Kierowcy (imie, nazwisko, dzial, stanowisko) VALUES
(N'Jan', N'Kowalski', N'Transport', N'Kierowca'),
(N'Piotr', N'Nowak', N'Transport', N'Kierowca'),
(N'Andrzej', N'Wiœniewski', N'Logistyka', N'Kierowca'),
(N'Tomasz', N'Wójcik', N'Transport', N'Kierowca'),
(N'Marek', N'Kamiñski', N'Transport', N'Kierowca'),
(N'Pawe³', N'Lewandowski', N'Logistyka', N'Kierowca'),
(N'Krzysztof', N'Zieliñski', N'Transport', N'Kierowca'),
(N'£ukasz', N'Szymañski', N'Transport', N'Kierowca'),
(N'Adam', N'WoŸniak', N'Logistyka', N'Kierowca'),
(N'Micha³', N'D¹browski', N'Transport', N'Kierowca'),
(N'Robert', N'Koz³owski', N'Transport', N'Kierowca'),
(N'Jakub', N'Jankowski', N'Logistyka', N'Kierowca');
GO

/* =========================================================
   DANE: Pojazdy
   ========================================================= */
INSERT INTO Pojazd (marka, model, numer_rejestracyjny, typ_wlasnosci, rodzaj_paliwa, srednie_spalanie_100km, cena_paliwa_za_litr) VALUES
(N'Skoda', N'Octavia', N'SBI12345', N's³u¿bowy', N'diesel', 6.10, 6.49),
(N'Volkswagen', N'Passat', N'SBI23456', N's³u¿bowy', N'diesel', 6.80, 6.49),
(N'Ford', N'Transit', N'SBI34567', N's³u¿bowy', N'diesel', 8.90, 6.49),
(N'Renault', N'Master', N'SBI45678', N's³u¿bowy', N'diesel', 9.20, 6.49),
(N'Toyota', N'Corolla', N'SBI56789', N's³u¿bowy', N'hybryda', 5.20, 6.79),
(N'Opel', N'Astra', N'SBI67890', N'prywatny', N'benzyna', 7.10, 6.69),
(N'Peugeot', N'308', N'SBI78901', N'prywatny', N'diesel', 5.80, 6.49),
(N'Kia', N'Ceed', N'SBI89012', N'prywatny', N'LPG', 8.20, 3.19),
(N'Hyundai', N'i30', N'SBI90123', N'prywatny', N'benzyna', 6.90, 6.69),
(N'Dacia', N'Duster', N'SBI11223', N's³u¿bowy', N'LPG', 8.70, 3.19),
(N'Mercedes', N'Sprinter', N'SBI22334', N's³u¿bowy', N'diesel', 10.50, 6.49),
(N'Fiat', N'Ducato', N'SBI33445', N's³u¿bowy', N'diesel', 9.80, 6.49);
GO

/* =========================================================
   DANE: Prawo jazdy
   ========================================================= */
INSERT INTO PrawoJazdy (numer_prawa_jazdy, data_wydania, data_waznosci, id_kierowcy) VALUES
(N'PJ000001', '2017-01-10', '2030-01-10', 1),
(N'PJ000002', '2016-03-15', '2029-03-15', 2),
(N'PJ000003', '2015-06-20', '2028-06-20', 3),
(N'PJ000004', '2018-09-11', '2031-09-11', 4),
(N'PJ000005', '2019-04-04', '2032-04-04', 5),
(N'PJ000006', '2014-02-02', '2027-02-02', 6),
(N'PJ000007', '2016-11-30', '2029-11-30', 7),
(N'PJ000008', '2017-07-07', '2030-07-07', 8),
(N'PJ000009', '2013-05-18', '2026-05-18', 9),
(N'PJ000010', '2020-08-08', '2033-08-08', 10),
(N'PJ000011', '2018-12-12', '2031-12-12', 11),
(N'PJ000012', '2015-10-10', '2028-10-10', 12);
GO

/* =========================================================
   DANE: Kategorie
   ========================================================= */
INSERT INTO KategoriaPrawaJazdy (nazwa_kategorii) VALUES
(N'A'),
(N'B'),
(N'BE'),
(N'C'),
(N'C+E'),
(N'D');
GO

/* =========================================================
   DANE: PrawoJazdy_Kategoria
   ========================================================= */
INSERT INTO PrawoJazdy_Kategoria (id_prawa_jazdy, id_kategorii) VALUES
(1, 2),
(2, 2),
(3, 2),
(3, 4),
(4, 2),
(5, 2),
(6, 2),
(6, 3),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(11, 4),
(11, 5),
(12, 2),
(12, 4);
GO

/* =========================================================
   DANE: Przejazdy
   ========================================================= */
INSERT INTO Przejazd (data_przejazdu, cel_przejazdu, trasa, liczba_kilometrow, stan_licznika_przed, stan_licznika_po, id_kierowcy, id_pojazdu) VALUES
('2026-06-01', N'Delegacja', N'Bielsko-Bia³a - Katowice', 62.00, 12000.00, 12070.00, 1, 1),
('2026-06-01', N'Dostawa dokumentów', N'Bielsko-Bia³a - ¯ywiec', 28.00, 22100.00, 22132.00, 2, 2),
('2026-06-02', N'Spotkanie z kontrahentem', N'Bielsko-Bia³a - Kraków', 96.00, 17500.00, 17605.00, 3, 5),
('2026-06-02', N'Dostawa materia³ów', N'Bielsko-Bia³a - Tychy', 42.00, 41200.00, 41248.00, 4, 3),
('2026-06-03', N'Kontrola oddzia³u', N'Bielsko-Bia³a - Cieszyn', 38.00, 19800.00, 19844.00, 5, 1),
('2026-06-03', N'Delegacja', N'Bielsko-Bia³a - Gliwice', 74.00, 13900.00, 13981.00, 6, 6),
('2026-06-04', N'Przewóz sprzêtu', N'Bielsko-Bia³a - Rybnik', 88.00, 50120.00, 50215.00, 7, 11),
('2026-06-04', N'Serwis urz¹dzeñ', N'Bielsko-Bia³a - Czechowice-Dziedzice', 19.00, 16000.00, 16024.00, 8, 8),
('2026-06-05', N'Spotkanie projektowe', N'Bielsko-Bia³a - Sosnowiec', 78.00, 24500.00, 24586.00, 9, 9),
('2026-06-05', N'Delegacja', N'Bielsko-Bia³a - Opole', 142.00, 31000.00, 31155.00, 10, 2),
('2026-06-06', N'Dostawa materia³ów', N'Bielsko-Bia³a - Zabrze', 84.00, 52600.00, 52692.00, 11, 12),
('2026-06-06', N'Wizyta u klienta', N'Bielsko-Bia³a - Oœwiêcim', 54.00, 11400.00, 11460.00, 12, 7),
('2026-06-07', N'Kontrola inwestycji', N'Bielsko-Bia³a - Pszczyna', 46.00, 12070.00, 12122.00, 1, 1),
('2026-06-08', N'Delegacja', N'Bielsko-Bia³a - Czêstochowa', 164.00, 22132.00, 22308.00, 2, 2),
('2026-06-08', N'Przewóz sprzêtu', N'Bielsko-Bia³a - Bytom', 93.00, 41248.00, 41349.00, 4, 3),
('2026-06-09', N'Spotkanie z partnerem', N'Bielsko-Bia³a - Tarnów', 176.00, 17605.00, 17792.00, 3, 5),
('2026-06-09', N'Dostawa', N'Bielsko-Bia³a - Jastrzêbie-Zdrój', 67.00, 19844.00, 19918.00, 5, 10),
('2026-06-10', N'Delegacja', N'Bielsko-Bia³a - Warszawa', 318.00, 13981.00, 14316.00, 6, 6),
('2026-06-10', N'Serwis', N'Bielsko-Bia³a - Ustroñ', 33.00, 16024.00, 16062.00, 8, 8),
('2026-06-11', N'Wizyta u klienta', N'Bielsko-Bia³a - Kêty', 22.00, 24586.00, 24612.00, 9, 9),
('2026-06-11', N'Dostawa towaru', N'Bielsko-Bia³a - £ódŸ', 268.00, 52692.00, 52975.00, 11, 12),
('2026-06-12', N'Delegacja', N'Bielsko-Bia³a - Wroc³aw', 210.00, 11460.00, 11684.00, 12, 7),
('2026-06-12', N'Spotkanie zarz¹du', N'Bielsko-Bia³a - Katowice', 62.00, 12122.00, 12190.00, 1, 1),
('2026-06-13', N'Kontrola magazynu', N'Bielsko-Bia³a - Gliwice', 74.00, 22308.00, 22388.00, 2, 2),
('2026-06-13', N'Dostawa materia³ów', N'Bielsko-Bia³a - Ruda Œl¹ska', 80.00, 41349.00, 41436.00, 4, 3),
('2026-06-14', N'Serwis techniczny', N'Bielsko-Bia³a - Chrzanów', 58.00, 17792.00, 17856.00, 3, 5),
('2026-06-14', N'Delegacja', N'Bielsko-Bia³a - Zakopane', 212.00, 19918.00, 20142.00, 5, 10),
('2026-06-15', N'Wyjazd s³u¿bowy', N'Bielsko-Bia³a - Poznañ', 352.00, 14316.00, 14683.00, 6, 6),
('2026-06-15', N'Kontrola oddzia³u', N'Bielsko-Bia³a - Tychy', 42.00, 16062.00, 16108.00, 8, 8),
('2026-06-16', N'Przewóz dokumentów', N'Bielsko-Bia³a - Kraków', 96.00, 24612.00, 24716.00, 9, 9);
GO

/* =========================================================
   DANE: Koszty
   ========================================================= */
INSERT INTO Koszty (rodzaj_kosztu, kwota, data_kosztu, opis, id_przejazdu) VALUES
(N'paliwo', 31.20, '2026-06-01', N'Tankowanie przed wyjazdem', 1),
(N'parking', 12.00, '2026-06-01', N'Parking w Katowicach', 1),
(N'paliwo', 18.50, '2026-06-01', N'Tankowanie', 2),
(N'op³ata drogowa', 9.00, '2026-06-02', N'Autostrada A4', 3),
(N'paliwo', 43.20, '2026-06-02', N'Tankowanie', 3),
(N'paliwo', 38.00, '2026-06-02', N'Tankowanie', 4),
(N'parking', 8.00, '2026-06-03', N'Parking centrum', 5),
(N'paliwo', 26.70, '2026-06-03', N'Tankowanie', 6),
(N'paliwo', 67.80, '2026-06-04', N'Tankowanie busa', 7),
(N'inny', 45.00, '2026-06-04', N'Myjnia i p³yny', 7),
(N'paliwo', 12.10, '2026-06-04', N'LPG', 8),
(N'paliwo', 34.80, '2026-06-05', N'Tankowanie', 9),
(N'parking', 15.00, '2026-06-05', N'Parking przy biurowcu', 9),
(N'paliwo', 81.50, '2026-06-05', N'Tankowanie', 10),
(N'op³ata drogowa', 27.00, '2026-06-05', N'Autostrada', 10),
(N'paliwo', 71.00, '2026-06-06', N'Tankowanie', 11),
(N'paliwo', 23.30, '2026-06-06', N'Tankowanie', 12),
(N'paliwo', 29.90, '2026-06-07', N'Tankowanie', 13),
(N'paliwo', 92.10, '2026-06-08', N'Tankowanie', 14),
(N'parking', 18.00, '2026-06-08', N'Parking w centrum', 14),
(N'paliwo', 44.50, '2026-06-08', N'Tankowanie', 15),
(N'paliwo', 63.90, '2026-06-09', N'Tankowanie', 16),
(N'op³ata drogowa', 30.00, '2026-06-09', N'Autostrada', 16),
(N'paliwo', 19.60, '2026-06-09', N'LPG', 17),
(N'paliwo', 148.00, '2026-06-10', N'Tankowanie do Warszawy', 18),
(N'parking', 20.00, '2026-06-10', N'Parking Warszawa', 18),
(N'paliwo', 11.80, '2026-06-10', N'LPG', 19),
(N'paliwo', 9.50, '2026-06-11', N'Dolewka paliwa', 20),
(N'paliwo', 126.00, '2026-06-11', N'Tankowanie trasa £ódŸ', 21),
(N'op³ata drogowa', 36.00, '2026-06-11', N'Autostrada', 21),
(N'paliwo', 74.40, '2026-06-12', N'Tankowanie', 22),
(N'paliwo', 30.50, '2026-06-12', N'Tankowanie', 23),
(N'paliwo', 37.00, '2026-06-13', N'Tankowanie', 24),
(N'paliwo', 41.80, '2026-06-13', N'Tankowanie', 25),
(N'paliwo', 28.60, '2026-06-14', N'Tankowanie', 26),
(N'paliwo', 49.90, '2026-06-14', N'LPG', 27),
(N'paliwo', 162.00, '2026-06-15', N'Tankowanie Poznañ', 28),
(N'op³ata drogowa', 42.00, '2026-06-15', N'Autostrada A4/A1', 28),
(N'paliwo', 13.90, '2026-06-15', N'LPG', 29),
(N'paliwo', 39.40, '2026-06-16', N'Tankowanie', 30);
GO

/* =========================================================
   FUNKCJA: orientacyjny koszt paliwa
   ========================================================= */
CREATE FUNCTION dbo.FN_WyliczKosztPaliwa
(
    @liczba_kilometrow DECIMAL(8,2),
    @srednie_spalanie_100km DECIMAL(5,2),
    @cena_paliwa_za_litr DECIMAL(6,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @wynik DECIMAL(10,2);
    SET @wynik = (@liczba_kilometrow / 100.0) * @srednie_spalanie_100km * @cena_paliwa_za_litr;
    RETURN @wynik;
END;
GO

/* =========================================================
   TRIGGER: wa¿noœæ prawa jazdy
   ========================================================= */
CREATE TRIGGER TRG_Przejazd_SprawdzPrawoJazdy
ON Przejazd
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN PrawoJazdy pj
            ON i.id_kierowcy = pj.id_kierowcy
        WHERE pj.id_prawa_jazdy IS NULL
           OR i.data_przejazdu < pj.data_wydania
           OR i.data_przejazdu > pj.data_waznosci
    )
    BEGIN
        RAISERROR (N'Nie mo¿na zapisaæ przejazdu. Kierowca nie posiada wa¿nego prawa jazdy w dniu przejazdu.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

/* =========================================================
   TRIGGER: data kosztu nie wczeœniejsza ni¿ data przejazdu
   ========================================================= */
CREATE TRIGGER TRG_Koszty_SprawdzDate
ON Koszty
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Przejazd p
            ON i.id_przejazdu = p.id_przejazdu
        WHERE i.data_kosztu < p.data_przejazdu
    )
    BEGIN
        RAISERROR (N'Data kosztu nie mo¿e byæ wczeœniejsza ni¿ data przejazdu.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

/* =========================================================
   PROCEDURA: dodawanie przejazdu
   ========================================================= */
CREATE PROCEDURE DodajPrzejazd
    @data_przejazdu DATE,
    @cel_przejazdu NVARCHAR(100),
    @trasa NVARCHAR(150),
    @liczba_kilometrow DECIMAL(8,2),
    @stan_licznika_przed DECIMAL(10,2),
    @stan_licznika_po DECIMAL(10,2),
    @id_kierowcy INT,
    @id_pojazdu INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Przejazd (
        data_przejazdu,
        cel_przejazdu,
        trasa,
        liczba_kilometrow,
        stan_licznika_przed,
        stan_licznika_po,
        id_kierowcy,
        id_pojazdu
    )
    VALUES (
        @data_przejazdu,
        @cel_przejazdu,
        @trasa,
        @liczba_kilometrow,
        @stan_licznika_przed,
        @stan_licznika_po,
        @id_kierowcy,
        @id_pojazdu
    );
END;
GO

/* =========================================================
   TEST: czy dane s¹
   ========================================================= */
SELECT COUNT(*) AS LiczbaKierowcow FROM Kierowcy;
SELECT COUNT(*) AS LiczbaPojazdow FROM Pojazd;
SELECT COUNT(*) AS LiczbaPrawJazdy FROM PrawoJazdy;
SELECT COUNT(*) AS LiczbaPrzejazdow FROM Przejazd;
SELECT COUNT(*) AS LiczbaKosztow FROM Koszty;
GO