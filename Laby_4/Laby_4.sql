-- Zadanie 1 

CREATE TABLE figury(
    id NUMBER(1) PRIMARY KEY,
    ksztalt MDSYS.SDO_GEOMETRY
);

-- Zadanie 2 

INSERT INTO figury VALUES
(1,MDSYS.SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,4),
    SDO_ORDINATE_ARRAY(3,5 ,5,3 ,7,5)
    )
);
			
INSERT INTO figury VALUES
(2,MDSYS.SDO_GEOMETRY(
    2003, 
    NULL, 
    NULL, 
    MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
    MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);
				
INSERT INTO figury VALUES
(3,MDSYS.SDO_GEOMETRY(
    2002,
    null,
    null,
    SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1 ,5,2,2),
    SDO_ORDINATE_ARRAY(3,2 ,6,2 ,7,3 ,8,2, 7,1)
    )
);

-- Zadanie 3 

-- Koło którego punkty leza na jednej prostej
INSERT INTO figury VALUES
(4,MDSYS.SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,4),
    SDO_ORDINATE_ARRAY(0,0 ,1,1 ,2,2)
    )
);

-- Zadanie 4 

SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01)
FROM figury; 

-- Zadanie 5

DELETE FROM figury 
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01) <> 'TRUE';

-- Zadanie 6

COMMIT;

-- Zakończenie pracy

DROP TABLE figury;