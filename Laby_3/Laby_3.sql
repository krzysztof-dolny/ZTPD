-- Zadanie 1

CREATE TABLE dokumenty(
    id NUMBER(12) PRIMARY KEY,
    dokument CLOB
)

-- Zadanie 2

DECLARE
    tekst CLOB;
BEGIN 
    FOR i IN 1..10000 LOOP
        tekst := tekst || 'Oto tekst. ';
    END LOOP;
    INSERT INTO dokumenty (id, dokument)
    VALUES (1, tekst);
    COMMIT;
END;

-- Zadanie 3 

SELECT * FROM dokumenty WHERE id = 1;
SELECT UPPER(dokument) FROM dokumenty WHERE id = 1;
SELECT LENGTH(dokument) FROM dokumenty WHERE id = 1;
SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty WHERE id = 1;
SELECT SUBSTR(dokument, 5, 1000) FROM dokumenty WHERE id = 1;
SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty WHERE id = 1;

-- Zadanie 4

INSERT INTO dokumenty (id, dokument) VALUES(2, EMPTY_CLOB());

-- Zadanie 5 

INSERT INTO dokumenty (id, dokument) VALUES(3, NULL);

-- Zadanie 6 

SELECT * FROM dokumenty;
SELECT UPPER(dokument) FROM dokumenty;
SELECT LENGTH(dokument) FROM dokumenty;
SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;
SELECT SUBSTR(dokument, 5, 1000) FROM dokumenty;
SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

-- Zadanie 7 

DECLARE 
    lobd CLOB;
    fils BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    doffset INTEGER := 1;
    soffset INTEGER := 1;
    langctx INTEGER := 0;
    warn INTEGER := null;
BEGIN
    SELECT dokument INTO lobd FROM dokumenty
    WHERE id = 2 FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE,
    doffset, soffset, 873, langctx, warn);
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: ' || warn);
END;

-- Zadanie 8 

UPDATE DOKUMENTY
SET DOKUMENT = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'))
WHERE ID = 3;


-- Zadanie 9 

SELECT * FROM dokumenty; 

-- Zadanie 10 

SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

-- Zadanie 11

DROP TABLE dokumenty;

-- Zadanie 12

CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    lobd IN OUT CLOB,
    pattern VARCHAR2)
IS
    position INTEGER;
    nth INTEGER := 1;
    replace_with VARCHAR2(100);
    counter INTEGER;
BEGIN
    FOR counter IN 1..length(pattern) LOOP
        replace_with := replace_with || '.';
    END LOOP;

    LOOP
        position := dbms_lob.instr(lobd, pattern, 1, nth);
        EXIT WHEN position = 0;
        dbms_lob.write(lobd, LENGTH(pattern), position, replace_with);
    END LOOP;
END CLOB_CENSOR;

-- Zadanie 13

CREATE TABLE BIOGRAPHIES AS SELECT * FROM ZTPD.BIOGRAPHIES;

DECLARE
    lobd CLOB;
BEGIN
    SELECT bio INTO lobd FROM biographies
    WHERE id=1 FOR UPDATE;   
    CLOB_CENSOR(lobd, 'Cimrman');  
    COMMIT;
END;

-- Zadanie 14

DROP TABLE BIOGRAPHIES;
