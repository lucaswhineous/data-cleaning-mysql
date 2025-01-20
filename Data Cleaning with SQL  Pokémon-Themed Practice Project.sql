USE lucas_project_cleaning;
SELECT * FROM POKEMON2;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove any columns that are irrelevant

SELECT * FROM POKEMON2;

alter table pokemon2
CHANGE COLUMN `#` ID_POKE int;


-- **** 1. Remove Duplicates ****

/* some of the ID_POKE are not duplicate , they have diferente names */

SELECT ID_POKE, name FROM POKEMON2
WHERE NAME LIKE '%MEGA%';

SELECT * FROM POKEMON2 -- Here i'm making shure that my suspesct is correct , we have ID_POKE that have another values
WHERE id_poke = 3;

/* detecting duplicates*/

SELECT * , ROW_NUMBER() OVER(PARTITION BY ID_POKE, NAME) AS ROW_NUM
FROM POKEMON2;


WITH DUPLICATES_CTE AS(
	SELECT * , ROW_NUMBER() OVER(PARTITION BY ID_POKE, NAME) AS ROW_NUM
	FROM POKEMON2
    )
SELECT * FROM DUPLICATES_CTE
WHERE ROW_NUM > 1;  -- Here we can see just the duplicates

/* CREATING ANOTHER TABLE , TO HAVE THE DUPLICATES 'MARKING' */

DESC POKEMON2;

CREATE TABLE pokemon3(
	ID_POKE int,
    name varchar(100),
    Type_1 varchar(20),
    Type_2 varchar(20),
    Total int,
    HP int,
    Attack int,
    Defense int,
    Sp_Atk int,
    Sp_Def int,
    Speed int,
    Generation int,
    Lengendary BOOLEAN,
    row_num int
);

 /* Now where a going to insert into the POKEMON3 */ 
INSERT INTO pokemon3 
SELECT ID_POKE, Name, `Type 1`, `Type 2`, Total, HP, Attack, Defense, `Sp. Atk`, `Sp. Def`, Speed, Generation,
CASE -- Here i needed to use case , because i want BOOLEAN in the field Lengendary
	WHEN Legendary = 'True' THEN 1
    WHEN Legendary = 'False' THEN 0
    ELSE null
END AS Legendary,
ROW_NUMBER() OVER(PARTITION BY ID_POKE, NAME) AS ROW_NUM
FROM POKEMON2;


SELECT * FROM POKEMON3;

/* Removing the duplicates */

-- SELECT * 
DELETE 
FROM POKEMON3
WHERE row_num > 1
;

-- 2. Standardize the Data
SELECT * FROM pokemon3;

ALTER TABLE pokemon3
DROP COLUMN row_num;

SELECT *
FROM pokemon3
WHERE name REGEXP '[^a-zA-Z0-9 ]';

UPDATE pokemon3
SET name = REGEXP_REPLACE(name, '[^a-zA-Z0-9 ]', '');

UPDATE pokemon3
SET name = 'Flabebe'
WHERE ID_POKE = 669;

SELECT * FROM POKEMON3
WHERE ID_POKE = 669;


-- 3. Null values or blank values

SELECT NAME, TYPE_2 FROM POKEMON3
WHERE TYPE_2 = '';
/* The standard of the table is NULL values is BLANK */

-- 4. Remove any columns that are irrelevant
SELECT * FROM POKEMON3;
/* All the column are relevant */









    









