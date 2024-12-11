--- Zadanie 1
-- B

select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;

-- B

select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

-- C

CREATE TABLE myst_major_cities(
    fips_cntry VARCHAR2(2),
    city_name VARCHAR2(40),
    stgeom ST_POINT
);

-- D

INSERT INTO myst_major_cities
SELECT fips_cntry, city_name, ST_POINT(GEOM) stgeom
FROM major_cities;

--- Zadanie 2 

INSERT INTO myst_major_cities (fips_cntry, city_name, stgeom)
VALUES ('PL', 'Szczyrk', ST_POINT(19.036107, 49.718655, 8307));

--- Zadanie 3 
-- A

CREATE TABLE myst_country_boundaries(
    fips_cntry VARCHAR2(2),
    cntry_name VARCHAR2(40),
    stgeom ST_MULTIPOLYGON
);

-- B 

INSERT INTO myst_country_boundaries 
SELECT fips_cntry, cntry_name, st_multipolygon(geom)
FROM country_boundaries;

-- C

SELECT B.STGEOM.ST_GEOMETRYTYPE() AS TYP_OBIEKTU, COUNT(*) AS ILE
FROM myst_country_boundaries B 
GROUP BY B.STGEOM.ST_GEOMETRYTYPE();

-- D

SELECT B.STGEOM.ST_ISSIMPLE() FROM myst_country_boundaries B;

--- Zadanie 4
-- A

SELECT B.CNTRY_NAME, COUNT(*)
FROM myst_country_boundaries B, myst_major_cities C
WHERE B.STGEOM.ST_CONTAINS(C.STGEOM) = 1 GROUP BY B.CNTRY_NAME;

-- B

SELECT A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
FROM myst_country_boundaries A, myst_country_boundaries B
WHERE  B.CNTRY_NAME = 'Czech Republic' AND A.STGEOM.ST_TOUCHES(B.STGEOM) = 1;

-- C

SELECT DISTINCT B.CNTRY_NAME, R.NAME
FROM myst_country_boundaries B, rivers R
WHERE B.CNTRY_NAME = 'Czech Republic' AND B.STGEOM.ST_CROSSES(ST_LINESTRING(R.GEOM)) = 1;

-- D

SELECT SUM(B.STGEOM.ST_AREA()) POWIERZCHNIA
FROM myst_country_boundaries B
WHERE  B.cntry_name ='Czech Republic' OR  B.cntry_name ='Slovakia';

-- E

SELECT B.STGEOM OBIEKT, B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GEOMETRYTYPE() WEGRY_BEZ
FROM myst_country_boundaries B, water_bodies W
WHERE  B.CNTRY_NAME = 'Hungary' AND W.name = 'Balaton';

--- Zadanie 5
-- A

SELECT B.cntry_name KRAJ, COUNT(*)
FROM myst_country_boundaries B, myst_major_cities C
WHERE SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE'
AND B.cntry_name = 'Poland' GROUP BY B.cntry_name;

-- B

INSERT INTO USER_SDO_GEOM_METADATA
SELECT 'MYST_MAJOR_CITIES', 'STGEOM', T.DIMINFO, T.SRID
FROM   ALL_SDO_GEOM_METADATA T WHERE  T.TABLE_NAME = 'major_cities';

-- C

CREATE INDEX idx_myst_major_cities_geom 
ON myst_major_cities(stgeom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- D

EXPLAIN PLAN FOR SELECT B.cntry_name KRAJ, COUNT(*)
FROM myst_country_boundaries B, myst_major_cities C
WHERE SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE'
AND B.cntry_name = 'Poland' GROUP BY B.cntry_name;

SELECT plan_table_output
FROM table(dbms_xplan.display('plan_table', null, 'basic'));




