## Zak Kotschegarow EDA of healthcare 

select *
from healthcare_3;
## 1. Readmission Patterns Insight: 
## What percentage of patients are readmitted? What factors are most common among readmitted patients?


## gives age and the count of the readmission_status
## 1 patient being readmiited, 0 was not readmitted
select Age, 
	readmitted_30Days AS readmission_status,
	count(*) as count
from healthcare_3
group by Age, readmitted_30Days
order by Age, readmitted_30Days;

## gives gender and the count of the readmission_status
select Gender, 
	readmitted_30Days AS readmission_status,
	count(*) as count
from healthcare_3
group by Gender, readmitted_30Days
order by Gender, readmitted_30Days;

## gives diagnosis and the count of the readmission_status
SELECT Diagnosis AS primary_diagnosis, 
       Readmitted_30Days AS readmission_status, 
       COUNT(*) AS count
FROM healthcare_3
GROUP BY Diagnosis, Readmitted_30Days
ORDER BY Diagnosis, Readmitted_30Days;

## 2. Readmission vs. Cost
## Do readmitted patients have higher average healthcare costs?
## this does not work as we do not have any cost column but if we did
SELECT previous_admissions, AVG(total_cost) AS avg_cost
FROM healthcare_3
GROUP BY readmission_status;


## 3. Age and Readmission
## What percentage of patients are getting readmitted?
SELECT age, 
       COUNT(*) AS total_patients,
       SUM(CASE WHEN previous_admissions = 'Yes' THEN 1 ELSE 0 END) AS readmitted,
       ROUND(100.0 * SUM(CASE WHEN previous_admissions = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmitted_percent
FROM healthcare_3
GROUP BY age
ORDER BY age ASC;

## 4. Smokers
## Which patients smoke and what is the percentage of them that had previous hospital admissions?
SELECT 
    Diagnosis,
    COUNT(*) AS total_patients,
    ROUND(100.0 * SUM(CASE WHEN Smoker = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS smoker_percent,
    ROUND(100.0 * SUM(CASE WHEN previous_admissions = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS prev_admit_percent
FROM healthcare_3
GROUP BY Diagnosis
ORDER BY prev_admit_percent DESC;
## total patients that have that diagnosis and what percent are smokers and
## what previous percentage has been prev admitted


## 5. Diagnoses That Lead to Readmission
## What are the top diagnoses that are linked with readmiited patients
SELECT diagnosis, COUNT(*) AS readmit_count
FROM healthcare_3
WHERE previous_admissions > '0'
GROUP BY Diagnosis
ORDER BY readmit_count DESC
LIMIT 5;

## 6. Cost Drivers
## Which factors (diagnosis, age, length of stay) lead to the highest costs?
## again this wont work cause we dont have a cost column, if we did it would
## look something like:
SELECT primary_diagnosis, AVG(total_cost) AS avg_cost
FROM healthcare_3
GROUP BY primary_diagnosis
ORDER BY avg_cost DESC
LIMIT 5;


## 7. Length of Stay Analysis
## Does longer stay correlate with readmission or cost?

## how many times there have been previous admitted and there avg stay, for each diagnosis and there len of stay
select previous_admissions, Diagnosis, AVG(length_of_stay) as avg_stay
from healthcare_3
group by previous_admissions, Diagnosis
order by previous_admissions, Diagnosis asc;

## this output just gives how many times there were readmitted and the avg len of stay
select previous_admissions, AVG(length_of_stay) as avg_stay
from healthcare_3
group by previous_admissions
order by previous_admissions asc;

## 8. How many patients are in that bmi caterogry, smoker, and their diagnosis
SELECT bmi_tier,
	Smoker, 
    Diagnosis, count(*) as patient_cnt
from healthcare_3
group by bmi_tier, Smoker, Diagnosis;

## had some unknowns, got that fixed
select bmi_tier, BMI
from healthcare_3
where bmi_tier = 'Unknown';

select *
from healthcare_3;

## End of EDA
