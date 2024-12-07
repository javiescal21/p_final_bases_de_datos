select * from mammalia_full limit 10;

-- Evaluar fechas: años
-- final
WITH 
full_data AS (
    SELECT 
        'Full Dataset' AS sample_size,
        COUNT(*) AS "Size",
        MAX(observation_date) AS "max date", 
        MIN(observation_date) AS "min date",
        AVG(EXTRACT(EPOCH FROM observation_date)) AS "AVG date",
        STDDEV_POP(EXTRACT(EPOCH FROM observation_date)) AS "StDev date"
    FROM mammalia_full
),
limited_data AS (
    SELECT 
        'Limited Dataset (50000)' AS sample_size,
        COUNT(*) AS "Size",
        MAX(observation_date) AS "max date", 
        MIN(observation_date) AS "min date",
        AVG(EXTRACT(EPOCH FROM observation_date)) AS "AVG date",
        STDDEV_POP(EXTRACT(EPOCH FROM observation_date)) AS "StDev date"
    FROM (
        SELECT observation_date
        FROM mammalia_full
        LIMIT 50000
    ) lim
)
SELECT * FROM full_data
UNION ALL
SELECT * FROM limited_data;

-- 		Observaciones: no hay pérdida mayor de fechas

-- Evaluar fechas: Distribución de meses
-- 	NOTA: quitar/poner línea "LIMIT 50000" como comentario para ver

WITH 
full_data AS (
    SELECT EXTRACT(MONTH FROM observation_date) as MonthNum, COUNT(*) as total_Obs_Mo, (COUNT(*)::FLOAT/1032896)*100 as relative_Obs_Mo
	FROM mammalia_full
	GROUP BY EXTRACT(MONTH FROM observation_date)
	order by MonthNum
),
limited_data AS (
	SELECT EXTRACT(MONTH FROM observation_date) as MonthNum, COUNT(*) as LIM_total_Obs_Mo, (COUNT(*)::FLOAT/50000)*100 as LIM_relative_Obs_Mo
	FROM (
        SELECT observation_date
        FROM mammalia_full
        LIMIT 50000
	)
	GROUP BY EXTRACT(MONTH FROM observation_date)
	order by MonthNum
)
SELECT l.monthnum, relative_Obs_Mo, LIM_relative_Obs_Mo 
FROM full_data as f
INNER JOIN limited_data as l ON l.MonthNum = f.MonthNum;

-- 		Observaciones: cambios insignificantes

-- Evaluar cantidad de especies
WITH 
full_data AS (
    SELECT 
        'Full Dataset' AS sample_size,
        COUNT(*)
    FROM (
    	SELECT DISTINCT scientific_name
    	from mammalia_full
    )
),
limited_data AS (
    SELECT 
        'Limited Dataset (50000)' AS sample_size,
        COUNT(*)
    FROM (
        SELECT DISTINCT scientific_name
        FROM (
        	SELECT scientific_name
        	FROM mammalia_full
        	LIMIT 50000
        )
    ) lim
)
SELECT * FROM full_data
UNION ALL
SELECT * FROM limited_data;
-- 		Obs: se pierden 2193 especies

-- Evaluar rango de latitud
WITH 
full_data AS (
    SELECT 
        'Full Dataset' AS sample_size,
        COUNT(*) AS "Size",
        MAX(observation_date) AS "max date", 
        MIN(observation_date) AS "min date",
        AVG(EXTRACT(EPOCH FROM observation_date)) AS "AVG date",
        STDDEV_POP(EXTRACT(EPOCH FROM observation_date)) AS "StDev date"
    FROM mammalia_full
),
limited_data AS (
    SELECT 
        'Limited Dataset (50000)' AS sample_size,
        COUNT(*) AS "Size",
        MAX(observation_date) AS "max date", 
        MIN(observation_date) AS "min date",
        AVG(EXTRACT(EPOCH FROM observation_date)) AS "AVG date",
        STDDEV_POP(EXTRACT(EPOCH FROM observation_date)) AS "StDev date"
    FROM (
        SELECT observation_date
        FROM mammalia_full
        LIMIT 50000
    ) lim
)
SELECT * FROM full_data
UNION ALL
SELECT * FROM limited_data;

-- Evaluar rango de latitud y longitud
WITH 
full_data AS (
    SELECT 
        'Full Dataset' AS sample_size,
        COUNT(*) AS "Size",
        MAX(latitude) AS "max lat", 
        MIN(latitude) AS "min lat",
        AVG(latitude) AS "AVG lat",
        STDDEV_POP(latitude) AS "StDev lat",
        MAX(longitude) AS "max lng", 
        MIN(longitude) AS "min lng",
        AVG(longitude) AS "AVG lng",
        STDDEV_POP(longitude) AS "StDev lng"
    FROM mammalia_full
),
limited_data AS (
    SELECT 
        'Limited Dataset (50000)' AS sample_size,
        COUNT(*) AS "Size",
        MAX(latitude) AS "Lim max lat", 
        MIN(latitude) AS "Lim min lat",
        AVG(latitude) AS "Lim AVG lat",
        STDDEV_POP(latitude) AS "Lim StDev lat",
        MAX(longitude) AS "Lim max lng", 
        MIN(longitude) AS "Lim min lng",
        AVG(longitude) AS "Lim AVG lng",
        STDDEV_POP(longitude) AS "Lim StDev lng"
    FROM (
        SELECT latitude, longitude
        FROM mammalia_full
        LIMIT 50000
    ) lim
)
SELECT * FROM full_data
UNION ALL
SELECT * FROM limited_data;

-- 		Obs: distribución global uniforme, cambios insignificantes

-- Evaluar cantidad de regiones

-- 	Set up
ALTER TABLE mammalia_full ADD continental_region VARCHAR(50);
ALTER TABLE mammalia_full ADD sub_region VARCHAR(50);

UPDATE mammalia_full
SET 
    continental_region = SPLIT_PART(time_zone, '/', 1),
    sub_region = SPLIT_PART(time_zone, '/', 2);
    
SELECT id, continental_region, sub_region from mammalia_full limit 10;

--	Evaluar sub region
WITH 
full_data AS (
    SELECT 
        'Full Dataset' AS sample_size,
        COUNT(*)
    FROM (
    	SELECT DISTINCT sub_region
    	from mammalia_full
    )
),
limited_data AS (
    SELECT 
        'Limited Dataset (50000)' AS sample_size,
        COUNT(*)
    FROM (
        SELECT DISTINCT sub_region
        FROM (
        	SELECT sub_region
        	FROM mammalia_full
        	LIMIT 50000
        )
    ) lim
)
SELECT * FROM full_data
UNION ALL
SELECT * FROM limited_data;
-- 		Obs: pérdida de 86 sub regiones

-- 	Evaluar regiones continentales
WITH 
full_data AS (
    SELECT 
        'Full Dataset' AS sample_size,
        COUNT(*)
    FROM (
    	SELECT DISTINCT continental_region
    	from mammalia_full
    )
),
limited_data AS (
    SELECT 
        'Limited Dataset (50000)' AS sample_size,
        COUNT(*)
    FROM (
        SELECT DISTINCT continental_region
        FROM (
        	SELECT continental_region
        	FROM mammalia_full
        	LIMIT 50000
        )
    ) lim
)
SELECT * FROM full_data
UNION ALL
SELECT * FROM limited_data;
--		Obs: sin pérdida de regiones continentales
