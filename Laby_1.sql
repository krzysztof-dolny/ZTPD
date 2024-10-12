-- ZADANIE 1

CREATE TYPE samochod AS OBJECT(
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2)
);

DESC samochod;

CREATE TABLE samochody OF samochod;
INSERT INTO samochody VALUES(NEW samochod('fiat', 'brava', 60000, 
    TO_DATE('30-11-1999', 'DD-MM-YYYY'), 25000));
INSERT INTO samochody VALUES(NEW samochod('ford', 'mondeo', 80000,
    TO_DATE('10-05-1997', 'DD-MM-YYYY'), 45000));
INSERT INTO samochody VALUES(NEW samochod('mazda', '323', 12000, 
    TO_DATE('22-09-2000', 'DD-MM-YYYY'), 52000));

SELECT * from samochody;

-- ZADANIE 2

CREATE TABLE wlasciciele (
    imie VARCHAR2(100),
    nazwisko VARCHAR2(100),
    auto SAMOCHOD
);

DESC wlasciciele;

INSERT INTO wlasciciele VALUES('Jan', 'Kowalski',
    NEW samochod('fiat', 'seicento', 30000, TO_DATE('02-12-0010', 'DD-MM-YYYY'), 19500));
INSERT INTO wlasciciele VALUES('Adam', 'Nowak',
    NEW samochod('opel', 'astra', 34000, TO_DATE('01-06-0009', 'DD-MM-YYYY'), 33700));

SELECT * FROM wlasciciele;

-- ZADANIE 3 i 4
ALTER TYPE samochod REPLACE AS OBJECT (
    marka VARCHAR(20),
    model VARCHAR(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER,
    MAP MEMBER FUNCTION value RETURN NUMBER -- Dodajemy również funkcję MAP
);

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        lata NUMBER;
        aktualna_wartosc NUMBER;
    BEGIN
        lata := TRUNC(MONTHS_BETWEEN(SYSDATE, data_produkcji) / 12);
        aktualna_wartosc := cena * POWER(0.9, lata);
        
        RETURN ROUND(aktualna_wartosc, 2);
    END;

    MAP MEMBER FUNCTION value RETURN NUMBER IS
    BEGIN
        RETURN (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_produkcji)) + (kilometry / 10000);
    END;
END;

SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

-- ZADANIE 5
CREATE TYPE wlasciciel AS OBJECT (imie VARCHAR(100), nazwisko VARCHAR(100));

-- ZADANIE 6 
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- ZADANIE 7 
DECLARE
    TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(100);
    moje_ksiazki t_ksiazki := t_ksiazki();
BEGIN
    moje_ksiazki.EXTEND(3); 
    moje_ksiazki(1) := 'Wiedźmin';
    moje_ksiazki(2) := 'Hobbit';
    moje_ksiazki(3) := 'Harry Potter';

    DBMS_OUTPUT.PUT_LINE('Zawartość kolekcji książek:');
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;

    moje_ksiazki.TRIM(2);
    DBMS_OUTPUT.PUT_LINE('Zawartość po usunięciu 2 tytułów:');
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;

    moje_ksiazki.EXTEND; 
    moje_ksiazki(moje_ksiazki.COUNT) := 'Zbrodnia i kara';

    DBMS_OUTPUT.PUT_LINE('Zawartość po dodaniu nowej książki:');
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementów: ' || moje_ksiazki.COUNT());
END;

-- ZADANIE 8
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- ZADANIE 9
DECLARE
    TYPE t_miesiace IS TABLE OF VARCHAR2(20);
    moje_miesiace t_miesiace := t_miesiace();
BEGIN
    moje_miesiace.EXTEND(12);
    moje_miesiace(1) := 'Styczeń';
    moje_miesiace(2) := 'Luty';
    moje_miesiace(3) := 'Marzec';
    moje_miesiace(4) := 'Kwiecień';
    moje_miesiace(5) := 'Maj';
    moje_miesiace(6) := 'Czerwiec';
    moje_miesiace(7) := 'Lipiec';
    moje_miesiace(8) := 'Sierpień';
    moje_miesiace(9) := 'Wrzesień';
    moje_miesiace(10) := 'Październik';
    moje_miesiace(11) := 'Listopad';
    moje_miesiace(12) := 'Grudzień';

    DBMS_OUTPUT.PUT_LINE('Zawartość kolekcji miesięcy:');
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
    END LOOP;

    moje_miesiace.DELETE(2); 
    moje_miesiace.DELETE(12); 

    DBMS_OUTPUT.PUT_LINE('Zawartość po usunięciu miesięcy:');
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        IF moje_miesiace.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Liczba elementów: ' || moje_miesiace.COUNT());
END;

-- ZADANIE 10 
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- ZADANIE 11
CREATE TYPE lista_produkty AS TABLE OF VARCHAR2(20);
/
CREATE TYPE koszyk_produktow AS OBJECT(
    numer NUMBER,
    produkty lista_produkty
);
/

CREATE TABLE ZAKUPY OF koszyk_produktow
NESTED TABLE produkty STORE AS tab_produkty;
/

INSERT INTO ZAKUPY VALUES (koszyk_produktow(1, lista_produkty('jajka', 'bułki', 'mleko')));
INSERT INTO ZAKUPY VALUES (koszyk_produktow(2, lista_produkty('chleb', 'ser')));
INSERT INTO ZAKUPY VALUES (koszyk_produktow(3, lista_produkty('mąka', 'cukier', 'kawa', 'herbata')));
/

SELECT z.numer, p.*
FROM ZAKUPY z, TABLE(z.produkty) p;

DELETE FROM ZAKUPY z
WHERE EXISTS (
    SELECT 1
    FROM TABLE(z.produkty) p
    WHERE p.COLUMN_VALUE = 'jajka'
);

SELECT z.numer, p.*
FROM ZAKUPY z, TABLE(z.produkty) p;

-- ZADANIE 12, 13, 14, 15

CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;
