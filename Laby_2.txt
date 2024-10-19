-- Zadanie 1

CREATE TABLE movies AS
SELECT * FROM ZTPD.MOVIES;

-- Zadanie 2

DESCRIBE movies;

-- Zadanie 3

SELECT id, title 
FROM movies 
WHERE cover IS NULL;

-- Zadanie 4

SELECT id, title, LENGTH(cover) AS filesize
FROM movies
WHERE cover IS NOT NULL;

-- Zadanie 5

SELECT id, title, LENGTH(cover) AS filesize
FROM movies
WHERE cover is NULL; 

-- Zadanie 6 

SELECT directory_name, directory_path
FROM all_directories;

-- Zadanie 7

UPDATE movies 
SET cover = EMPTY_BLOB(), mime_type = 'image/jpeg'
WHERE id = 66;

-- Zadanie 8

SELECT id, title, LENGTH(cover) AS filesize
FROM movies
WHERE id IN (65, 66);

-- Zadanie 9 

DECLARE 
    lobd blob;
    fils BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
BEGIN 
    SELECT cover INTO lobd
    FROM movies
    WHERE id = 66
    FOR update;
    DBMS_LOB.FILEOPEN(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, fils, DBMS_LOB.getlength(fils));
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;

-- Zadanie 10 

CREATE TABLE temp_covers(
movie_id NUMBER(12),
image BFILE,
mime_type VARCHAR2(50)
);

-- Zadanie 11

INSERT INTO temp_covers
VALUES(65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpeg');

-- Zadanie 12

SELECT movie_id, DBMS_LOB.GETLENGTH(image) AS FILESIZE
FROM temp_covers
WHERE movie_id = 65;

-- ZADANIE 13

DECLARE
    lobd blob;
    bfile TEMP_COVERS.IMAGE%TYPE;
    mime_type TEMP_COVERS.MIME_TYPE%TYPE;
BEGIN 
    SELECT image, mime_type INTO bfile, mime_type
    FROM temp_covers
    WHERE movie_id = 65;
    DBMS_LOB.CREATETEMPORARY(lobd, TRUE);
    DBMS_LOB.fileOPEN(bfile, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, bfile, DBMS_LOB.getlength(bfile));
    DBMS_LOB.FILECLOSE(bfile);
    UPDATE movies
    SET cover = lobd, mime_type = mime_type
    WHERE ID = 65;
    DBMS_LOB.FREETEMPORARY(lobd);
    COMMIT;
END;

-- ZADANIE 14

SELECT id AS movie_id, LENGTH(cover) AS filesize
FROM movies
WHERE id IN (65, 66);

-- ZADANIE 15 

DROP TABLE movies;
