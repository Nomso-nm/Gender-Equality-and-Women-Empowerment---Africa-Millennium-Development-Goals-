-- Analysing the African millennium goals related to gender equality and women empowerment

-- A table with infromation for Goal 3: Promote gender equality and empower women

SELECT 
  CountryName,
  Country,
  GoalName AS Goal,
  IndicatorName AS Indicator,
  "Social GroupName" AS SocialGroupName,
  "Social Group" AS SocialGroup,
  Date,
  Value,
  Scale,
  Frequency
FROM 
  DA_africa_millennium_development_goals
WHERE 
  GoalName = 'Goal 3: Promote gender equality and empower women'
ORDER BY 
  CountryName, IndicatorName, Date;


-- Analysis 
--1. The historical trend in the proportion of parliamentry seats held by women 
/*
SELECT 
  CountryName,
  Date,
  Value AS ProportionOfSeats
FROM 
  DA_africa_millennium_development_goals
WHERE 
  IndicatorName = 'Proportion of seats held by women in national parliament (%)'
ORDER BY 
  CountryName, Date;
*/
 -- 2. The countries with the most increase parliamentry seat held by women
/*
WITH CountryProgress AS (
  SELECT
    CountryName,
    MAX(Value) - MIN(Value) AS Increase
  FROM
    DA_africa_millennium_development_goals
  WHERE
    IndicatorName = 'Proportion of seats held by women in national parliament (%)'
  GROUP BY
    CountryName
)
SELECT
  CountryName,
  Increase
FROM
  CountryProgress
ORDER BY
  Increase DESC
*/ 

/* Here: 
- The FirstLast CTE finds the first and last dates of recorded data for each country.
- FirstValue CTE gets the value of the proportion of seats held by women for the first recorded date for each country.
- LastValue CTE gets the value for the last recorded date for each country.
The final SELECT statement calculates the increase for each country and orders the results to find the countries with the greatest increase
*/


-- 3. How the ratio of girls to boys in primary, secondary, and tertiary education compare across countries
/*
SELECT 
  CountryName,
  IndicatorName,
  MAX(Date) AS LatestDate,
  Value AS Ratio
FROM 
  DA_africa_millennium_development_goals
WHERE 
  IndicatorName IN ('Ratios of girls to boys in primary education', 'Ratios of girls to boys in secondary education', 'Ratios of girls to boys in tertiary education')
GROUP BY 
  CountryName, IndicatorName
ORDER BY 
  CountryName, IndicatorName;
*/

-- 4. Parity in Education 
/*
SELECT 
  CountryName,
  ABS(Value - 1.0) AS DifferenceFromParity
  -- The ABS function is used to calculate the absolute difference from 1.0.
  -- This query finds the country where the ratio of girls to boys in primary education is closest to 1.0, indicating parity.
  -- The IndicatorName for this query was changed for secondary and tertiary education as well. 
FROM 
  DA_africa_millennium_development_goals
WHERE 
  IndicatorName = 'Ratios of girls to boys in primary education'
ORDER BY 
  DifferenceFromParity
LIMIT 1;
*/

-- 5. Progress towards increasing the share of women employment in non-agricutural sector
/*
WITH EmploymentData AS (
  SELECT 
    CountryName,
    IndicatorName,
    MAX(Value) AS LatestValue,
    MIN(Value) AS EarliestValue,
    MAX(Date) AS LatestDate,
    MIN(Date) AS EarliestDate
  FROM 
    DA_africa_millennium_development_goals
  WHERE 
    IndicatorName = 'Share of women in wage employment in the non agricultural sector (%)'
  GROUP BY 
    CountryName
)
SELECT 
  CountryName,
  LatestValue,
  EarliestValue,
  LatestDate,
  EarliestDate,
  (LatestValue - EarliestValue) AS Increase
FROM 
  EmploymentData
ORDER BY 
  Increase DESC;
 */
/* 
The WITH clause creates a Common Table Expression (CTE) named EmploymentData and selects the country name and indicator of interest.
It will use the MAX and MIN functions to find the latest and earliest values for each country, as well as the corresponding dates, to understand the timeline of the data.
The main SELECT statement:
Will retrive the country name, the latest and earliest values, and their respective dates from the EmploymentData CTE.
Calculate the Increase in women's employment share from the earliest to the latest date.
*/ 

-- 6. Relationship between higher education and non-agricultural wage employment for women
/*
WITH LatestTertiaryRatio AS (
  SELECT 
    CountryName,
    MAX(Date) AS LatestDate,
    Value AS TertiaryEducationRatio
  FROM 
    DA_africa_millennium_development_goals
  WHERE 
    IndicatorName = 'Ratios of girls to boys in tertiary education'
  GROUP BY 
    CountryName
),
LatestEmploymentRatio AS (
  SELECT 
    CountryName,
    MAX(Date) AS LatestDate,
    Value AS EmploymentRatio
  FROM 
    DA_africa_millennium_development_goals
  WHERE 
    IndicatorName = 'Share of women in wage employment in the non agricultural sector (%)'
  GROUP BY 
    CountryName
)
SELECT 
  ltr.CountryName,
  ltr.TertiaryEducationRatio,
  ler.EmploymentRatio
FROM 
  LatestTertiaryRatio ltr
JOIN 
  LatestEmploymentRatio ler ON ltr.CountryName = ler.CountryName;
  */

 /* The first step here was to create two Common Table Expressions (CTEs):
  * (i) to get the latest ratio of girls to boys in tertiary education
 (ii) for the latest proportion of women in non-agricultural wage employment for each country.
Then, joined the CTEs on CountryName to ensure the comparison of the values from the same country.
 */






