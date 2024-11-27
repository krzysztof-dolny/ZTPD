--- Zadanie 1
-- A

CREATE TABLE A6_LRS(
    GEOM SDO_GEOMETRY
);

-- B

INSERT INTO A6_LRS (GEOM)
SELECT S.GEOM
FROM STREETS_AND_RAILROADS S
WHERE SDO_RELATE(
    S.GEOM,
    SDO_GEOM.SDO_BUFFER(
        (SELECT C.GEOM 
         FROM MAJOR_CITIES C 
         WHERE C.CITY_NAME = 'Koszalin'),
        10, -- Promień bufora w kilometrach
        1, -- Tolerancja
        'unit=km'
    ),
    'MASK=ANYINTERACT'
) = 'TRUE';

-- C

SELECT 
    SDO_GEOM.SDO_LENGTH(GEOM, 0.05) AS DISTANCE,
    SDO_UTIL.GETNUMVERTICES(GEOM) AS ST_NUMPOINTS
FROM A6_LRS;

-- D 

UPDATE A6_LRS 
SET GEOM = SDO_LRS.CONVERT_TO_LRS_GEOM(
    GEOM, 
    0, 
    SDO_LRS.GEOM_SEGMENT_LENGTH(GEOM)
);

-- E

INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES (
    'A6_LRS', 
    'GEOM', 
    SDO_DIM_ARRAY(
        SDO_DIM_ELEMENT('X', 0, 1000000, 0.05),
        SDO_DIM_ELEMENT('Y', 0, 1000000, 0.05),
        SDO_DIM_ELEMENT('M', 0, NULL, 0.05) 
    ),
    4326 
);

-- F

CREATE INDEX A6_LRS_IDX
ON A6_LRS(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

--- Zadanie 2 
-- A

SELECT SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500 
FROM A6_LRS;

-- B.

SELECT SDO_LRS.GEOM_SEGMENT_END_PT(GEOM) END_PT
FROM A6_LRS;

-- C.

SELECT SDO_LRS.LOCATE_PT(GEOM, 150, 0) AS KM150 
FROM A6_LRS;

-- D.

SELECT SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160) AS CLIPPED
FROM A6_LRS;

-- E

SELECT SDO_LRS.GET_NEXT_SHAPE_PT(A6.GEOM, SDO_LRS.PROJECT_PT(A6.GEOM, C.GEOM)) AS WJAZD_NA_A6
FROM A6_LRS A6, MAJOR_CITIES C 
WHERE C.CITY_NAME = 'Slupsk';

-- F

SELECT SDO_GEOM.SDO_LENGTH(SDO_LRS.OFFSET_GEOM_SEGMENT(A6.GEOM, M.DIMINFO, 50, 200, 50, 'unit=m arc_tolerance=0.05'), 1, 'unit=m') / 1000 * 1000000 AS COST
FROM A6_LRS A6, USER_SDO_GEOM_METADATA M
WHERE M.TABLE_NAME = 'A6_LRS' AND M.COLUMN_NAME = 'GEOM';
