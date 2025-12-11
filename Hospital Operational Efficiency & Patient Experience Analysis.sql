-- 1 List all unique hospital services available in the hospital.
SELECT DISTINCT service FROM services_weekly;

-- 2. Find all patients admitted to 'Surgery' service with a satisfaction score below 70, showing their patient_id, name, age, and satisfaction score.
SELECT patient_id, name, age, satisfaction
FROM patients
WHERE service = 'Surgery'
 AND satisfaction < 70;
 
 -- 3. Retrieve the top 5 weeks with the highest patient refusals across all services, showing week, 
 -- service, patients_refused, and patients_request. Sort by patients_refused in descending order.
 SELECT week, service, patients_refused, patients_request
FROM services_weekly
ORDER BY patients_refused DESC
LIMIT 5;

 -- 4. Find the 3rd to 7th highest patient satisfaction scores from the patients table,
 -- showing patient_id, name, service, and satisfaction. Display only these 5 records.
 SELECT patient_id, name, service, satisfaction
FROM patients
ORDER BY satisfaction DESC
LIMIT 5 OFFSET 2;

 -- 5 Calculate the total number of patients admitted, total patients refused, and the average patient satisfaction across all services and weeks. 
 -- Round the average satisfaction to 2 decimal places.
 SELECT 
 SUM(patients_admitted) AS total_patients_admitted,
 SUM(patients_refused) AS total_patients_refused,
 ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
FROM services_weekly;

 -- 6. For each hospital service, calculate the total number of patients admitted,
 -- total patients refused, and the admission rate (percentage of requests that were admitted). Order by admission rate descending.
SELECT 
    service,
    SUM(patients_admitted) AS total_admitted,
    SUM(patients_refused) AS total_refused,
    ROUND(
        (CAST(SUM(patients_admitted) AS DECIMAL(10,2)) * 100) /
        (SUM(patients_admitted) + SUM(patients_refused)),
        2
    ) AS admission_rate_percent
FROM services_weekly
GROUP BY service
ORDER BY admission_rate_percent DESC;


 -- 7.  Identify services that refused more than 100 patients in total and had an average patient satisfaction below 80. Show service name, total refused, and average satisfaction.
 SELECT service,
 SUM(patients_refused) AS total_refused,
 ROUND(AVG(patient_satisfaction), 2) AS average_satisfaction
FROM services_weekly
GROUP BY service
HAVING SUM(patients_refused) > 100
 AND AVG(patient_satisfaction) < 80;

 -- 8. Create a patient summary that shows patient_id, full name in uppercase, service in lowercase, age category (if age >= 65 then 'Senior', 
 -- if age >= 18 then 'Adult', else 'Minor'), and name length. Only show patients whose name length is greater than 10 characters.
 SELECT patient_id,
 UPPER(name) AS full_name_uppercase,
 LOWER(service) AS service_lowercase,
 LENGTH(name) AS name_length,
 CASE
 WHEN age >= 65 THEN 'Senior'
 WHEN age >= 18 THEN 'Adult'
 ELSE 'Minor'
 END AS age_category
FROM patients
WHERE LENGTH(name) > 10;

 -- 9.  Calculate the average length of stay (in days) for each service, showing only services where the average stay is more than 7 days.
 -- Also show the count of patients and order by average stay descending.
 SELECT 
 service, 
 ROUND(AVG(DATEDIFF(departure_date, arrival_date)), 2) AS avg_length_of_stay,
 COUNT(patient_id) AS count_patient,
 COUNT(service) AS total_service
FROM patients
GROUP BY service
HAVING AVG(DATEDIFF(departure_date, arrival_date)) > 7
ORDER BY avg_length_of_stay DESC;

 -- 10.  Create a service performance report showing service name, total patients admitted, and a performance category based on the following: 
 -- 'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' if >= 65, otherwise 'Needs Improvement'. Order by average satisfaction descending
 
SELECT service,
 ROUND(AVG(satisfaction), 2) AS avg_satisfaction_score,
 CASE
 WHEN AVG(satisfaction) >= 85 THEN 'Excellent'
 WHEN AVG(satisfaction) >= 75 THEN 'Good'
 WHEN AVG(satisfaction) >= 65 THEN 'Fair'
 ELSE 'Needs Improvement'
 END AS performance_category
FROM patients
GROUP BY service
ORDER BY avg_satisfaction_score DESC;

 -- 11.  Find all unique combinations of service and event type from the services_weekly table where events are not null or none, along with the count of occurrences for each combination. Order by count descending.
 SELECT 
	 service,
	 event,
	 COUNT(*) AS occurrence_count
FROM services_weekly
WHERE event IS NOT NULL
AND LOWER(event) <> 'none'
GROUP BY 
	 service,
	 event
ORDER BY occurrence_count DESC;
 
 -- 12  Analyze the event impact by comparing weeks with events vs weeks without events. Show: event status ('With Event' or 'No Event'), count of weeks, average patient satisfaction, and average staff morale. Order by average patient satisfaction descending.
 SELECT
	 CASE 
	 WHEN event IS NOT NULL 
	 AND event <> '' 
	 AND LOWER(event) <> 'none' 
	 THEN 'With Event' 
	 ELSE 'No Event' 
	 END AS event_status,
	 COUNT(week) AS count_of_weeks,
	 ROUND(AVG(patient_satisfaction), 2) AS avg_patient_satisfaction,
	 ROUND(AVG(staff_morale), 2) AS avg_staff_morale
FROM services_weekly
GROUP BY event_status
ORDER BY avg_patient_satisfaction DESC;
 -- 13. Create a report showing: patient_id patient name age service total staff members available in that service Include only patients from services with more than 5 staff, and sort by: staff count (descending) patient name
 
SELECT
	 p.patient_id,
	 p.name AS patient_name,
	 p.age,
	 p.service,
	 staff_counts.total_staff
FROM patients p
INNER JOIN
 (
 SELECT service, COUNT(staff_id) AS total_staff
 FROM staff
 GROUP BY service
 HAVING COUNT(staff_id) > 5
 ) AS staff_counts
ON p.service = staff_counts.service
ORDER BY
 staff_counts.total_staff DESC,
 patient_name;
 -- 14.  Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service) and the count of weeks they were present (from staff_schedule). 
 --    Include staff members even if they have no schedule records. Order by weeks present descending.
 SELECT
	 s.staff_id,
	 s.staff_name,
	 s.role,
	 s.service,
	 COUNT(ss.week) AS weeks_present
FROM staff s
LEFT JOIN 
 staff_schedule ss 
ON s.staff_id = ss.staff_id 
 AND ss.present = 1
GROUP BY
	 s.staff_id,
	 s.staff_name,
	 s.role,
	 s.service
ORDER BY
 weeks_present DESC,
 s.staff_name ASC;
 -- 15. Create a comprehensive service analysis report for week 20 showing: service name, total patients admitted that week, total patients refused, average patient satisfaction, 
 --    count of staff assigned to service, and count of staff present that week. Order by patients admitted descending.
 SELECT 
	 sw.service,
	 sw.patients_admitted,
	 sw.patients_refused,
	 ROUND(sw.patient_satisfaction, 2) AS avg_satisfaction,
	 COALESCE(assigned_staff.total_assigned_staff, 0) AS total_assigned_staff,
	 COALESCE(present_staff.total_present_staff, 0) AS staff_present
FROM services_weekly sw
LEFT JOIN (
 SELECT service, COUNT(staff_id) AS total_assigned_staff
 FROM staff
 GROUP BY service
) AS assigned_staff
 ON sw.service = assigned_staff.service
LEFT JOIN (
 SELECT 
	 s.service, 
	 COUNT(DISTINCT ss.staff_id) AS total_present_staff
 FROM staff_schedule ss
 INNER JOIN staff s ON ss.staff_id = s.staff_id
 WHERE ss.week = 20 
 AND ss.present = 1
 GROUP BY s.service
) AS present_staff
 ON sw.service = present_staff.service
WHERE sw.week = 20
ORDER BY sw.patients_admitted DESC;
 -- 16. Find all patients who were admitted to services that had at least one week where patients were refused AND the average patient satisfaction for that service was below the overall hospital average satisfaction. 
 -- Show patient_id, name, service, and their personal satisfaction score.
 SELECT 
	 p.patient_id, 
	 p.name, 
	 p.service, 
	 p.satisfaction
FROM patients p
WHERE p.service IN (

 -- Services with average satisfaction less than hospital-wide average
 SELECT sw.service
 FROM services_weekly sw
 WHERE sw.service IN (
 
 -- Services that had patient refusals in at least one week
 SELECT DISTINCT service
 FROM services_weekly
 WHERE patients_refused > 0
 )
 GROUP BY sw.service
 HAVING AVG(sw.patient_satisfaction) < (
 
 -- Overall hospital satisfaction average
 SELECT AVG(patient_satisfaction) 
 FROM services_weekly
 )
);
 -- 17. Create a report showing each service with: service name, total patients admitted, the difference between their total admissions and the average admissions across all services, and a rank indicator ('Above Average', 'Average', 'Below Average'). 
 --  Order by total patients admitted descending.
 WITH total_admissions_per_service AS (
    SELECT 
        service,
        SUM(patients_admitted) AS total_admissions
    FROM services_weekly
    GROUP BY service
),
overall_avg AS (
    SELECT AVG(total_admissions) AS avg_admissions
    FROM total_admissions_per_service
)

SELECT 
    t.service AS service_name,
    t.total_admissions,
    ROUND(t.total_admissions - o.avg_admissions, 2) AS diff_from_avg,
    CASE
        WHEN t.total_admissions > o.avg_admissions THEN 'Above Average'
        WHEN t.total_admissions = o.avg_admissions THEN 'Average'
        ELSE 'Below Average'
    END AS rank_indicator
FROM total_admissions_per_service t
CROSS JOIN overall_avg o
ORDER BY t.total_admissions DESC;

 
 -- 18. Create a comprehensive personnel and patient list showing: identifier (patient_id or staff_id), full name, type ('Patient' or 'Staff'), and associated service. Include only those in 'surgery' or 'emergency' services. Order by type, then service, then name.
  SELECT 
    CAST(patient_id AS CHAR) AS identifier,
    name,
    'Patient' AS type,
    service
FROM patients
WHERE service IN ('surgery', 'emergency')

UNION ALL

SELECT 
    CAST(staff_id AS CHAR) AS identifier,
    staff_name AS name,
    'Staff' AS type,
    service
FROM staff
WHERE service IN ('surgery', 'emergency')
ORDER BY type, service, name;

 -- 19. For each service, rank the weeks by patient satisfaction score (highest first). Show service, week, patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service.
 WITH RankedWeeks AS (
 SELECT 
	 service, 
	 week, 
	 patient_satisfaction, 
	 patients_admitted,
 RANK() OVER (
 PARTITION BY service 
 ORDER BY patient_satisfaction DESC
 ) AS sat_rank
 FROM services_weekly
)
SELECT 
	 service, 
	 week, 
	 patient_satisfaction, 
	 patients_admitted, 
	 sat_rank
FROM RankedWeeks
WHERE sat_rank <= 3
ORDER BY service, sat_rank;

 -- 20. Create a trend analysis showing for each service and week: week number, patients_admitted, running total of patients admitted (cumulative), 3-week moving average of patient satisfaction (current week and 2 prior weeks), and the difference between current week admissions and the service average. Filter for weeks 10-20 only
  WITH ServiceAvg AS (
    SELECT 
        service, 
        AVG(patients_admitted) AS service_avg
    FROM services_weekly
    GROUP BY service
)
SELECT 
    sw.service,
    sw.week,
    sw.patients_admitted,

    -- Running total
    SUM(sw.patients_admitted) OVER (
        PARTITION BY sw.service 
        ORDER BY sw.week
    ) AS running_total,

    -- 3-week moving average
    ROUND(
        AVG(sw.patient_satisfaction) OVER (
            PARTITION BY sw.service 
            ORDER BY sw.week 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_wk_moving_avg_sat,

    -- Difference from service average
    ROUND(
        sw.patients_admitted - sa.service_avg,
        2
    ) AS diff_from_service_avg

FROM services_weekly sw
JOIN ServiceAvg sa 
    ON sw.service = sa.service
WHERE sw.week BETWEEN 10 AND 20
ORDER BY sw.service, sw.week;


 -- 21. Create a comprehensive hospital performance dashboard using CTEs. Calculate: 1) Service-level metrics (total admissions, refusals, avg satisfaction), 2) Staff metrics per service (total staff, avg weeks present), 3) Patient demographics per service (avg age, count). Then combine all three CTEs to create a final report showing service name, all calculated metrics, and an overall performance score (weighted average of admission rate and satisfaction). Order by performance score descending.
 WITH hospital_performance AS (
    SELECT 
        service,
        SUM(patients_admitted) AS total_admissions,
        SUM(patients_refused) AS total_refusals,
        AVG(patient_satisfaction) AS avg_satisfaction
    FROM services_weekly
    GROUP BY service
),

cte_staff AS (
    SELECT 
        service,
        COUNT(staff_id) AS total_staff,
        AVG(week) AS avg_weeks_present
    FROM staff_schedule
    GROUP BY service
),

cte_patient AS (
    SELECT
        service,
        AVG(age) AS avg_age,
        COUNT(patient_id) AS total_patients
    FROM patients
    GROUP BY service
)

SELECT 
    hp.service,
    hp.total_admissions,
    hp.total_refusals,
    hp.avg_satisfaction,
    s.total_staff,
    s.avg_weeks_present,
    p.avg_age,
    p.total_patients,

    -- Performance score = 70% satisfaction + 30% admission rate
    (
        0.7 * hp.avg_satisfaction +
        0.3 * (hp.total_admissions * 1.0 / NULLIF(hp.total_admissions + hp.total_refusals, 0))
    ) AS performance_score

FROM hospital_performance hp
JOIN cte_staff s
    ON hp.service = s.service
JOIN cte_patient p
    ON hp.service = p.service
ORDER BY performance_score DESC;
