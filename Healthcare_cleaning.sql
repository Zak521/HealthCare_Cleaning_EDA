## HEALTHCARE CLEANING AND EDA
## Zak Kotschegarow

## Just opens the csv to see the data
Select *
from healthcare_readmission;

## Make a copy of the table, so we do not mess with raw data
create table healthcare_3
LIKE healthcare_readmission;

## Insert data from the original table into the new one
INSERT INTO healthcare_3
SELECT *
FROM healthcare_readmission;

## check for null values (fill if any)
## check for duplicates (remove if any)
## standarized the data (dates, extra space, capitalization)
## remove any columns 


select *
from healthcare_3;
## Null values
select *
from healthcare_3
Where `Gender` is Null
	or Trim(`Gender`) = ''
    or Upper(`Gender`) = 'Error'
    or Upper(`Gender`) = 'Unknown';
    
select *
from healthcare_3
Where `PatientID` is Null
	or Trim(`PatientID`) = ''
    or Upper(`PatientID`) = 'Error'
    or Upper(`PatientID`) = 'Unknown';


## Change header names 
ALTER TABLE healthcare_3
CHANGE `PatientID` patient_ID INT(4);

ALTER TABLE healthcare_3
CHANGE `PreviousAdmissions` previous_admissions INT(4);

ALTER TABLE healthcare_3
CHANGE `length_ofS_say` length_of_stay INT(4);

ALTER TABLE healthcare_3
CHANGE `Readmitted30Days` Readmitted_30Days INT(4);

ALTER TABLE healthcare_3
CHANGE `InsuranceType` insurance_type VARCHAR(100);

ALTER TABLE healthcare_3
CHANGE `AdmissionDate` admission_date DATE;

## check for duplicates 
SELECT `patient_ID`, `Age`, `Gender`, `Diagnosis`, `previous_admissions`, 
`length_of_stay`, `Readmitted_30Days`, `Smoker`, `BMI`, `insurance_type`, `admission_date`, COUNT(*) as count
from healthcare_3
group by `patient_ID`, `Age`, `Gender`, `Diagnosis`, `previous_admissions`, 
`length_of_stay`, `Readmitted_30Days`, `Smoker`, `BMI`, `insurance_type`, `admission_date`
having COUNT(*) > 1;

ALTER TABLE healthcare_3 ADD id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

WITH RANKED as (
	select *, 
    row_number() OVER (
    partition by patient_ID, Age, Gender, Diagnosis, previous_admissions, 
	length_of_stay, Readmitted_30Days, Smoker, BMI, insurance_type, admission_date
    order by id
    ) AS rn
    from healthcare_3
    )
	SELECT *
FROM ranked
WHERE rn > 1;



WITH RANKED AS (
	select id,
    row_number() OVER (
    partition by patient_ID, Age, Gender, Diagnosis, previous_admissions, 
	length_of_stay, Readmitted_30Days, Smoker, BMI, insurance_type, admission_date
    order by id
    ) AS rn
from healthcare_3
)

Delete from healthcare_3
where id in (
	select id
    from RANKED
    where rn > 1
    );
    
## back up table
create table healthcare_3_backup as select * from healthcare_3;

select *
from healthcare_3;
## there was no duplicates found

## remove id column
ALTER table healthcare_3
drop column id;

## add a tier of their bmi index

alter table healthcare_3
add column bmi_tier varchar(20);

UPDATE healthcare_3
set bmi_tier = 
	CASE
		WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI >= 18.5 and BMI <= 24.9 THEN 'Normal'
        WHEN BMI >= 25 and BMI <= 29.9 THEN 'Overweight'
        WHEN BMI >= 30 Then 'Obese'
        ELSE 'Unknown'
	END;

select *
from healthcare_3;
## Data is looking good for EDA
## Potential insights
