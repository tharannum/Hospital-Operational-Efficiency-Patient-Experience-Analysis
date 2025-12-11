# Hospital-Operational-Efficiency-Patient-Experience-Analysis


**General Hospital**, an established healthcare facility, processes thousands of patient interactions weekly across its primary service lines: Emergency, Surgery, ICU, and General Medicine.

The facility possesses significant amounts of data on patient admissions, service refusals, staff schedules, and satisfaction scores that has been previously underutilized. This project thoroughly analyzes and synthesizes this data to uncover critical insights that will improve the hospital's operational capacity and service quality.

Insights and recommendations are provided on the following key areas:

* **Capacity & Demand Analysis:** Evaluation of patient admission versus refusal rates across service lines to identify critical bottlenecks.
* **Service Level Performance:** An analysis of the hospital's four primary departments, understanding their impact on overall patient flow.
* **Event Impact Assessment:** An evaluation of how external events (Flu outbreaks, Strikes) affect patient satisfaction and staff morale.
* **Staff Utilization:** An assessment of workforce allocation and its correlation with service delivery.

The SQL queries utilized to clean, organize, and prepare data for analysis can be found here.
Targeted SQL queries regarding various business questions can be found here.

---

## Data Structure & Initial Checks

The Hospital database structure consists of four primary tables: `services_weekly`, `patients`, `staff`, and `staff_schedule`, containing a comprehensive log of operational metrics.



* **`services_weekly`**: The central fact table recording weekly aggregations of admissions, refusals, and satisfaction scores.
* **`patients`**: Granular patient demographics, admission dates, and individual satisfaction ratings.
* **`staff`**: Personnel directory including roles and service assignments.
* **`staff_schedule`**: Weekly attendance logs for staff members.

---

## Executive Summary

### Overview of Findings
The analysis reveals a facility under significant demand pressure. [cite_start]While the hospital maintains a commendable average patient satisfaction score of **80.00**[cite: 22], it is facing a critical capacity crisis. [cite_start]Total patient refusals (**7,642**) significantly outnumber total admissions (**5,851**)[cite: 22], driven primarily by severe bottlenecks in the Emergency department.

Despite these capacity constraints, the quality of care remains resilient. Interestingly, patient satisfaction scores actually *increase* during logged external events (e.g., Flu seasons), suggesting that while operational systems are stressed, clinical care teams perform exceptionally well under pressure.

---

## Detailed Analysis

### Capacity & Service Bottlenecks
The hospital's ability to meet patient demand varies drastically by department.
* **The Emergency Crisis:** The Emergency department is the primary bottleneck, with an admission rate of just **19.13%**.  It turned away **5,008** patients while admitting only **1,185**. This single department accounts for the vast majority of the hospital's total refusals.
*  **General Medicine:** This service handles the highest volume of admitted patients (**2,332**) but also faces high demand, refusing 1,938 patients (54.61% admission rate).
*  **High Efficiency Units:** In contrast, the ICU and Surgery departments perform efficiently, with admission rates of **82.13%** and **75.23%** respectively.

### Event Impact on Operations
External events such as Flu outbreaks, Strikes, and Donation drives have a measurable impact on hospital metrics:
*  **Satisfaction Resilience:** Surprisingly, weeks "With Event" recorded a higher average patient satisfaction (**81.02**) compared to weeks "No Event" (**79.73**) .
* **Staff Strain:** This performance comes at a cost to the workforce.  Average staff morale drops from **73.15** during normal operations to **70.41** during event weeks. This suggests staff are absorbing the pressure of these events to protect the patient experience.

### Patient Satisfaction Drivers
*  **Top Performers:** The Surgery service maintains a high satisfaction average of **80.31**, followed closely by ICU at **79.92** .
*  **Room for Improvement:** General Medicine, while the highest volume department, lags slightly in satisfaction with a score of **78.57**.
*  **Length of Stay:** Services with longer average stays, such as Surgery (7.87 days) and ICU (7.61 days), tend to have higher satisfaction scores than the rapid-turnover Emergency department[cite: 73, 87], indicating a positive correlation between care duration and patient sentiment.

---

## Recommendations

Based on the uncovered insights, the following recommendations have been provided:

*  ]**Immediate Expansion of Emergency Capacity:** With an admission rate of only **19.13%** and over **5,000** refusals, the Emergency department is losing significant patient volume. Capital investment is required to expand triage beds or divert non-critical patients to a "Fast Track" General Medicine clinic to capture this lost demand.
*  **Implement "Surge Support" for Staff:** Staff morale drops by nearly 3 points during event weeks. To prevent burnout and turnover, the hospital should implement a "Crisis Bonus" or mandatory recovery days for staff following high-stress events like Flu seasons or Strikes.
*  **Standardize Best Practices in General Medicine:** General Medicine is the highest volume service but has the lowest satisfaction (78.57). Management should audit the high-performing Surgery and ICU departments (Scores ~80+) to identify care protocols that can be adapted for General Medicine patients.
* **Investigate Event Protocols:** The counter-intuitive finding that satisfaction *rises* during crisis events suggests that emergency protocols (perhaps faster triage or higher staffing ratios) are effective. These protocols should be analyzed and potentially integrated into standard daily operations to raise the baseline satisfaction score.
