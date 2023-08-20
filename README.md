# SQL Project 5 - Exploratory Data Analysis - Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) Survey Analysis

## Complete code attached - HCAHPS.sql

## Data Insights Using SQL.

### 1) Average hospital response rate for the survey.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/8ecfa262-853d-42bd-84c4-3fa5ac2f1c72)

### 2) Average response rate for the survey for each consecutive year. Check whether the response rate has been increasing or decreasing each year.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/46aeaad0-e9a3-412b-b7c7-05fb01db9fcc)\
The above analysis shows that the overall avg response rate dropped each year from 2015 to 2023 from 30% to 22% respectively.

### 3) Total Number of Facilities (Hospitals) registered within the database for each state and overall count.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/e024905e-09dd-409f-b2ea-d6c7a88740b5)
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/a57adfa7-f110-467b-b64e-684bd4d596f5)\
Texas has the highest (467) number of hospitals that completed the survey, while Delaware has the lowest (7).

![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/16a17be3-4227-4440-9ec8-20d582b3bc77)

### 4) Avg overall top box percentage in 2015 Vs 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/85dd9785-61b0-4028-8617-1ff1d05dc924)\
The above analysis proves that the overall positive responses received from patients at various hospitals from 2015 to 2023 dropped by 2%.

### 5) Individual measure analysis. (National Results).
### 5a) Top 3 Highest and lowest rated measures (Avg of top box percentage).
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/af480429-cc8f-4a4a-826c-942c89e2f362)\
The above analysis proves that communication with doctors and nurses along with discharge information was highly rated by patients while communication about medicines, the quietness of the hospital, and care transition was least appreciated.

### 5b) Cleanliness of hospital environment. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/925d3b57-66ae-482d-93cb-12f619771ad3)\
The above analysis shows that there was an initial increase in the positive response rate from 2015 (74%) to 2021 (76%) from patients regarding the cleanliness of hospitals. However, this number dropped from 76% to 72% in just two years.

### 5c) Communication with Nurses. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/d797f9d2-9f39-494e-a2cf-9a0dca8a1499)\
79% positive response as recorded in 2015. This number gradually increased to 81% over a 6-year period, post which it dropped back to 79% in 2023.

### 5d) Communication with Doctors. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/2074d6b7-8cbf-44ac-a5a3-214fd093c154)\
Communication with doctors dropped slightly from 82% in 2015 to 79% in 2023. However, it is still one of the highest-rated measures.

### 5e) Responsiveness of Hospital Staff. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/de201919-60f0-4a5c-bdb3-f8a1659014b0)\
The responsiveness from hospital staff dropped from 68% to 65% from 2015 to 2023 respectively. 

### 5f) Communication about Medicines. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/614a0070-b9e7-4f2b-a5c8-0162b6d85ae5)\
Communication about medicines dropped from 65% to 61% from 2015 to 2023 respectively.

### 5g) Discharge information. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/5be1ea41-87ce-493b-8853-5a0bd02896c1)\
Discharge information was the highest recorded measure and remained stable at 86% from 2015 to 2023.

### 5h) Care transition. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/fca5aee1-b11d-4538-a0c2-7e3b5909b34f)\
Care transition was recorded to be the lowest measure in the survey. No imporvement was recorded from 2015 (52%) to 2023 (51%)

### 5i) Overall Hospital Rating. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/67126719-64a2-4cc1-b2a8-d529e8469d5e)\
Not much difference was seen in the overall hospital ratings from 2015 (71%) to 2023 (70%). 

### 5j) Quietness of Hospital Environment. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/d5999765-5b5f-4e71-8925-1e284ad54e6a)\
The quietness of the hospital environment remained more or less the same throughout all years from 2015 to 2023

### 5k) Willingness to Recommend the Hospital. Avg top box response rate from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/5b168933-2b0a-4005-b8bc-28f1f406bee0)\
Willingness to recommend a hospital dropped by 2% from 2015 to 2023.

### 6) Individual measure analysis. (State Results)
### 6a) Average overall top box percentage for each state. (Top 5 based on dense rank)
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/5423e9ea-15a5-4959-8990-e743351e8459)\
This analysis shows the percentage of positive responses received from patients from each state. Above displayed are the top 5 results based on dense rank.

### 6b) Average overall top box percentage for each state. (Bottom 5 based on dense rank)
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/b214c152-689f-4538-a002-50df33dcff59)\
This analysis shows the percentage of positive responses received from patients from each state. Above displayed are the bottom 5 results based on dense rank.

### 6c) State-wise response rate.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/216f43c2-7b34-4f32-bef3-017e0466d88b)
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/e6776804-ab38-4775-88f3-e99dbdb1104d)\
The above shows the percentage of response rate for the survey from each state.

### 6d) Avg top box percentage for all states with all measures from 2015 to 2023.
![image](https://github.com/JoshuaSequeira2000/SQL-Project5-Exploratory-Data-Analysis/assets/92262753/2271ac6a-550d-42f5-8b01-7833c901909a)\
Where clause added to filter the result based on State and Measure_ID.



