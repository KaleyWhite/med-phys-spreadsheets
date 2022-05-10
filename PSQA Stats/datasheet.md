# **PSQA Stats**
(template based on https://arxiv.org/abs/1803.09010)
## **1. Motivation**
### **1.1** For what purpose was the dataset created? Was there a specific task in mind? Was there a specific gap that needed to be filled? Please provide a description.
The dataset was created according to recommendations from the American Association of Physicists in Medicine (AAPM) Task Group Report 218, which recommends statistical process control (SPC) and process capability analysis (PCA) of patient-specific IMRT QA. In addition to SPC and PCA, we collected the data in a general effort to be more data driven in our Cancer Center. The data is intended for replication of statistical work on PSQA as well as for discoveries to inform decisions and best practices in our department. The data come from PSQA plans run on our linear accelerators (linacs) using the Delta4 Phantom+ and its accompanying software. Gamma is global. We rescale each plan according to a scale factor (see "Composition" below) and then optimize the phantom position in the PSQA software.
### **1.2**  Who created this dataset (e.g., which team, research group) and on behalf of which entity (e.g., company, institution, organization)?
The dataset was created by Kaley White, Radiation Physicist Assistant at Cookeville Regional Medical Center (CRMC), with input from Zachary Carter, Chief Radiation Physicist at CRMC.
### **1.3**  Who funded the creation of the dataset? If there is an associated grant, please provide the name of the grantor and the grant name and number.
The dataset creation was not funded.
### **1.4**  Any other comments?
None.
## **2. Composition**
### **2.1** What do the instances that comprise the dataset represent (e.g., documents, photos, people, countries)? Are there multiple types of instances (e.g., movies, users, and ratings; people and interactions between them; nodes and edges)? Please provide a description.
Each row in the "PSQAStats" table represents a run of a PSQA plan on a linac.
### **2.2**  How many instances are there in total (of each type, if appropriate)?
At the time of compilation of this document, there are 248 instances.
### **2.3**  Does the dataset contain all possible instances or is it a sample (not necessarily random) of instances from a larger set? If the dataset is a sample, then what is the larger set? Is the sample representative of the larger set (e.g., geographic coverage)? If so, please describe how this representativeness was validated/verified. If it is not representative of the larger set, please describe why not (e.g., to cover a more diverse range of instances, because instances were withheld or unavailable).
The dataset is a sample of PSQA plans run at CRMC over a certain time period. A run was excluded from the sample if (a) it was not run by Kaley, (b) Kaley neglected to record certain essential fields (e.g., gamma pass ratio) for the plan, (c) Kaley realized after the fact that she had recorded the wrong values, or (d) the paper on which the data were recorded was lost. As far as the authors know, fewer than 10 runs were excluded. No tests were run to determine representativeness.
### **2.4**  What data does each instance consist of? "Raw" data (e.g., unprocessed text or images) or features? In either case, please provide a description.
The table consists of the following fields:
Column | Description | Constraints
--- | --- | ---
`Date` | The date on which the plan was run on the linac | Today or a past date
`D4 Version` | Version of the Delta4 software used to evaluate the run | `pre-1.00.0211`, `1.00.0211`, or `1.00.0220`
`Machine` | The linac on which the plan was run | `Tomo` (a TomoTherapy Hi Art), `E1` (Synergy linac with Agility MLC), or `E2` (Infinity linac with Agility MLC)
`Radiation Device` | The Radiation Device in the Delta4 software. Each Radiation Device has its own calibration. | `ELEKTA`, `E1`, or `E2`
`Dose Type` | The type of dose that the DQA plan was shot for: the entire plan dose, or an individual beam dose in a multi-beam plan. Note that this document uses the terms _plan_ and _beam_ interchangeably to refer to a row in the table. | `Plan` or `Beam`
`Dose Type Rescaled` | The dose that was rescaled. When a plan dose is rescaled, beam doses are unaffected and thus invalid for evaluating the DQA results. When beam doses are rescaled, the plan dose is recalculated as the sum of the rescaled beam doses. | For plan doses, `Plan` or `Beam`. For beam doses, `Beam`.
`Tx Technique` | The technique used by the treatment plan | Tomo plans are all `IMRT` (intensity modulated radiation therapy). Elekta plans are `SBRT` (stereotactic body radiation therapy), `SRS` (stereotactic radiosurgery), or `VMAT` (volumetric modulated arc therapy).
`Body Site` | The general anatomical region of the treatment plan | `Abdomen`, `Brain`, `Head and Neck`, `Pelvis`, or `Thorax`. `SBRT` is only for `Thorax` (lung), and `SRS` is only for `Brain`.
`Scale Factor` | The factor by which the measured PSQA dose was scaled, rounded to four decimal places. The Tomo scale factor is the ratio of the latest measured TG-51 monthly dose rate, to the commissioning dose rate. The Elekta scale factor is the ratio of the daily DailyQA3 output measurement, to the expected measurement, according to SunCHECK Machine software. The scale factor is 1 for plans that were not rescaled; there is no way to differentiate between this type of plan and a plan for which the calculated scale factor is actually 1 (rare). | Non-negative number
`Dose Threshold (%)` | The lower dose threshold for doses included in the dose analysis in the PSQA software. The upper dose threshold was kept constant at 500%. | Percentage between 0 and 100, inclusive
`Temp Correction` | Whether or not a temperature correction was applied in the PSQA software. Near the beginning of data collection, the phantom was stored in a cool room at around 20&deg;C, and temperature was taken as the temperature of the room according to a thermocouple. Later, the phantom was moved to a more temperate room, and temperature was taken using a handheld thermometer placed on top of the phantom. | `TRUE` or `FALSE`
`Dose Dev Tol Level (%)` | The value (proportion of reference dose) above which a dose deviation is considered out of tolerance | Percentage between 0 and 100, inclusive
`Dose Dev Action Level (%)` | The value (proportion of reference dose) above which a dose deviation is considered actionable | Percentage between 0 and 100, inclusive
`Dose Dev W/I Tol - Initial (%)` | Proportion of dose deviations that are in tolerance before rescale or optimization | Percentage between 0 and 100, inclusive
`Dose Dev W/I Tol - Rescale (%)` | Proportion of dose deviations that are in tolerance after rescale (if applied) but before optimization | Percentage between 0 and 100, inclusive
`Dose Dev W/I Tol - Opt (%)` | Proportion of dose deviations that are in tolerance after rescale (if applied) and optimization | Percentage between 0 and 100, inclusive
`DTA Tol Level (mm)` | The value (mm) above which a distance to agreement (DTA) value is considered out of tolerance | Non-negative number
`DTA Action Level (mm)` | The value (mm) above which a distance to agreement (DTA) value is considered actionable | Non-negative number
`DTA W/I Tol - Initial (%)` | Proportion of DTA values that are in tolerance before rescale or optimization | Percentage between 0 and 100, inclusive
`DTA W/I Tol - Rescale (%)` | Proportion of DTA values that are in tolerance after rescale (if applied) but before optimization | Percentage between 0 and 100, inclusive
`DTA W/I Tol - Opt (%)` | Proportion of DTA values that are in tolerance after rescale (if applied) and optimization | Percentage between 0 and 100, inclusive
`Gamma PR Tol Level (%)` | The gamma pass ratio below which a plan is considered out of tolerance | Percentage between 0 and 100, inclusive
`Gamma PR Action Level (%)` | The gamma pass ratio below which a plan is considered actionable | Percentage between 0 and 100, inclusive
`Gamma PR - Initial (%)` | Gamma pass ratio before rescale or optimization | Percentage between 0 and 100, inclusive
`Gamma PR - Rescale (%)` | Gamma pass ratio after rescale (if applied) but before optimization | Percentage between 0 and 100, inclusive, or `PASS` or `FAIL`
`Gamma PR - Opt (%)` | Gamma pass ratio after rescale (if applied) and optimization | Percentage between 0 and 100, inclusive
`Gamma Avg Initial` | Gamma average before rescale or optimization | Non-negative number
`Gamma Avg Rescale` | Gamma average after rescale (if applied) but before optimization | Non-negative number
`Gamma Avg Opt` | Gamma average after rescale (if applied) and optimization | Non-negative number
`X - Initial (mm)` | *x*-coordinate (mm) of the phantom before optimization | Number
`X - Opt (mm)` | *x*-coordinate (mm) of the phantom after optimization | Number
`Y - Initial (mm)` | *y*-coordinate (mm) of the phantom before optimization | Number
`Y - Opt (mm)` | *y*-coordinate (mm) of the phantom after optimization | Number
`Z - Initial (mm)` | *z*-coordinate (mm) of the phantom before optimization | Number
`Z - Opt (mm)` | *z*-coordinate (mm) of the phantom after optimization | Number

The following fields only apply to plans failing even after phantom position optimization:
Column | Description | Constraints
--- | --- | ---
`Rx (cGy)` | Prescription, in cGy | Positive integer
`Max Gantry Spacing (mm)` | The maximum allowed gantry spacing set in the TPS. Does not apply to Tomo plans | `#N/A` for Tomo. Positive number for Elekta.
`Dose Grid Res (mm)` | The resolution (mm) of the plan's uniform dose grid | Positive number
`Beam Delivery Time (s)` | List of beam delivery times in the plan | Comma-separated list of non-negative numbers 
`Beam MU` | List of beam MUs in the plan | Comma-separated list of non-negative numbers
### **2.5**  Is there a label or target associated with each instance? If so, please provide a description.
No.
### **2.6**  Is any information missing from individual instances? If so, please provide a description, explaining why this information is missing (e.g., because it was unavailable). This does not include intentionally removed information, but might include, e.g., redacted text.
We only recently started recording pre-rescale pass ratios, so these values are missing for dates prior to 2/24/22. During this time, we simply recording whether the gamma pass ratio indicated a `PASS` or `FAIL`.
### **2.7**  Are relationships between individual instances made explicit (e.g., users' movie ratings, social network links)? If so, please describe how these relationships are made explicit.
The dataset is a single denormalized table.
### **2.8**  Are there recommended data splits (e.g., training, development/validation, testing)? If so, please provide a description of these splits, explaining the rationale behind them.
No.
### **2.9**  Are there any errors, sources of noise, or redundancies in the dataset? If so, please provide a description.
No.
### **2.10** Is the dataset self-contained, or does it link to or otherwise rely on external resources (e.g., websites, tweets, other datasets)? If it links to or relies on external resources, (a) are there guarantees that they will exist, and remain constant, over time; (b) are there official archival versions of the complete dataset (i.e., including the external resources as they existed at the time the dataset was created); (c) are there any restrictions (e.g., licenses, fees) associated with any of the external resources that might apply to a future user? Please provide descriptions of all external resources and any restrictions associated with them, as well as links or other access points, as appropriate.
The dataset is entirely self contained.
### **2.11** Does the dataset contain data that might be considered confidential (e.g., data that is protected by legal privilege or by doctor-patient confidentiality, data that includes the content of individuals' non-public communications)? If so, please provide a description.
No.
### **2.12** Does the dataset contain data that, if viewed directly, might be offensive, insulting, threatening, or might otherwise cause anxiety? If so, please describe why.
No.
### **2.13** Does the dataset relate to people? If not, you may skip the remaining questions in this section.
The PSQA plans are created from treatment plans used on real patients.
### **2.14** Does the dataset identify any subpopulations (e.g., by age, gender)? If so, please describe how these subpopulations are identified and provide a description of their respective distributions within the dataset.
No.
### **2.15** Is it possible to identify individuals (i.e., one or more natural persons), either directly or indirectly (i.e., in combination with other data) from the dataset? If so, please describe how.
No.
### **2.16** Does the dataset contain data that might be considered sensitive in any way (e.g., data that reveals racial or ethnic origins, sexual orientations, religious beliefs, political opinions or union memberships, or locations; financial or health data; biometric or genetic data; forms of government identification, such as social security numbers; criminal history)? If so, please provide a description.
No.
### **2.17** Any other comments?
None.
## **3. Collection Process**
### **3.1**  How was the data associated with each instance acquired? Was the data directly observable (e.g., raw text, movie ratings), reported by subjects (e.g., survey responses), or indirectly inferred/derived from other data (e.g., part-of-speech tags, model-based guesses for age or language)? If data was reported by subjects or indirectly inferred/derived from other data, was the data validated/verified? If so, please describe how.
The data was directly observed as part of the PSQA process.

Data entry into the Excel spreadsheet was verified using Excel Data Validation. If an invalid value was entered, the user was warned with an error message popup, and the invalid value was disallowed.
### **3.2**  What mechanisms or procedures were used to collect the data (e.g., hardware apparatus or sensor, manual human curation, software program, software API)? How were these mechanisms or procedures validated?
The data were manually copied from the PSQA software onto paper after a PSQA plan was run, then manually entered into an Excel spreadsheet. The accuracy of the PSQA software was initially verified by qualified medical physicists at the time of phantom and software commissioning.
### **3.3**  If the dataset is a sample from a larger set, what was the sampling strategy (e.g., deterministic, probabilistic with specific sampling probabilities)?
There was no sampling strategy.
### **3.4**  Who was involved in the data collection process (e.g., students, crowdworkers, contractors) and how were they compensated (e.g., how much were crowdworkers paid)?
All data was collected by Kaley White as part of her role as a medical physics assistant.
### **3.5**  Over what timeframe was the data collected? Does this timeframe match the creation timeframe of the data associated with the instances (e.g., recent crawl of old news articles)? If not, please describe the timeframe in which the data associated with the instances was created.
Data collection began on 5/7/21.
### **3.6**  Were any ethical review processes conducted (e.g., by an institutional review board)? If so, please provide a description of these review processes, including the outcomes, as well as a link or other access point to any supporting documentation.
No.
### **3.7**  Does the dataset relate to people? If not, you may skip the remainder of the questions in this section.
No.
### **3.8**  Did you collect the data from the individuals in question directly, or obtain it via third parties or other sources (e.g., websites)?
### **3.9**  Were the individuals in question notified about the data collection? If so, please describe(or show with screenshots or other information) how notice was provided, and provide a link or other access point to, or otherwise reproduce, the exact language of the notification itself.
### **3.10** Did the individuals in question consent to the collection and use of their data? If so, please describe (or show with screenshots or other information) how consent was requested and provided, and provide a link or other access point to, or otherwise reproduce, the exact language to which the individuals consented.
### **3.11*** If consent was obtained, were the consenting individuals provided with a mechanism to revoke their consent in the future or for certain uses? If so, please provide a description, as well as a link or other access point to the mechanism (if appropriate).
### **3.12** Has an analysis of the potential impact of the dataset and its use on data subjects (e.g., a data protection impact analysis)been conducted? If so, please provide a description of this analysis, including the outcomes, as well as a link or other access point to any supporting documentation.
### **3.13** Any other comments?
None.
## **4. Preprocessing/Cleaning/Labeling**
### **4.1**  Was any preprocessing/cleaning/labeling of the data done (e.g., discretization or bucketing, tokenization, part-of-speech tagging, SIFT feature extraction, removal of instances, processing of missing values)? If so, please provide a description. If not, you may skip the remainder of the questions in this section.
No.
### **4.2**  Was the "raw" data saved in addition to the preprocessed/cleaned/labeled data (e.g., to support unanticipated future uses)? If so, please provide a link or other access point to the "raw" data.
### **4.3**  Is the software used to preprocess/clean/label the instances available? If so, please provide a link or other access point.
### **4.4**  Any other comments?
None.
## **5. Uses**
### **5.1**  Has the dataset been used for any tasks already? If so, please provide a description.
No.
### **5.2**  Is there a repository that links to any or all papers or systems that use the dataset? If so, please provide a link or other access point.
No.
### **5.3**  What (other) tasks could the dataset be used for?
The dataset can be used for statistical process control; any statistical analysis relating to PSQA, such as general department-specific analytics (e.g., which machine gets the most IMRT patients?); or replication of published research results.
### **5.4**  Is there anything about the composition of the dataset or the way it was collected and preprocessed/cleaned/labeled that might impact future uses? For example, is there anything that a future user might need to know to avoid uses that could result in unfair treatment of individuals or groups (e.g., stereotyping, quality of service issues) or other undesirable harms (e.g., financial harms, legal risks) If so, please provide a description. Is there anything a future user could do to mitigate these undesirable harms?
No.
### **5.5**  Are there tasks for which the dataset should not be used? If so, please provide a description.
The data was collected solely from CRMC with the specified machines, PSQA phantom and software, and treatment planning systems, so results may not generalize to other situations.
### **5.6**  Any other comments?
None.
## 6. Distribution
### **6.1**  Will the dataset be distributed to third parties outside of the entity (e.g., company, institution, organization) on behalf of which the dataset was created? If so, please provide a description.
Yes, the dataset will be made public on the Internet.
### **6.2**  How will the dataset will be distributed (e.g.,tarball on website, API, GitHub)? Does the dataset have a digital object identifier (DOI)?
The dataset will be distributed via one of Kaley White's GitHub repositories. Hopefully, the dataset will also be posted to Kaggle and data.world as well as several research data repositories. The data does not have a DOI, and there is no redundant archive.
### **6.3**  When will the dataset be distributed?
The dataset was first distributed to GitHub on 3/4/22.
### **6.4**  Will the dataset be distributed under a copyright or other intellectual property (IP) license, and/or under applicable terms of use (ToU)? If so, please describe this license and/or ToU, and provide a link or other access point to, or otherwise reproduce, any relevant licensing terms or ToU (Terms of Use), as well as any fees associated with these restrictions.
The dataset is licensed under the General Public License version 3+ (GPLv3+).
### **6.5**  Have any third parties imposed IP-based or other restrictions on the data associated with the instances? If so, please describe these restrictions, and provide a link or other access point to, or otherwise reproduce, any relevant licensing terms, as well as any fees associated with these restrictions.
No.
### **6.6**  Do any export controls or other regulatory restrictions apply to the dataset or to individual instances? If so, please describe these restrictions, and provide a link or other access point to, or otherwise reproduce, any supporting documentation.
No.
### **6.7**  Any other comments?
None.
## **7. Maintenance**
### **7.1**  Who is supporting/hosting/maintaining the dataset?
Kaley White is supporting/maintaining the dataset.
### **7.2**  How can the owner/curator/manager of the dataset be contacted (e.g., email address)?
Kaley White can be contacted by email at [kwhite31415@gmail.com](kwhite31415@gmail.com) or via [LinkedIn](https://linked.com/in/kaley-white). You may also raise an issue on the GitHub [repository]().
### **7.3**  Is there an erratum? If so, please provide a link or other access point.
No.
### **7.4**  Will the dataset be updated (e.g., to correct labeling errors, add new instances, delete instances)? If so, please describe how often, by whom, and how updates will be communicated to users (e.g., mailing list, GitHub)?
There will be periodic updates as more PSQA data is collected. Updated versions of the dataset will be posted to all of the sites listed in 6.2.
### **7.5**  If the dataset relates to people, are there applicable limits on the retention of the data associated with the instances (e.g., were individuals in question told that their data would be retained for a fixed period of time and then deleted)? If so, please describe these limits and explain how they will be enforced.
The dataset does not relate to people.
### **7.6**  Will older versions of the dataset continue to be supported/hosted/maintained? If so, please describe how. If not, please describe how its obsolescence will be communicated to users.
No, all older versions of the dataset will be removed from all sites when a new version is released.
### **7.7**  If others want to extend/augment/build on/contribute to the dataset, is there a mechanism for them to do so? If so, please provide a description. Will these contributions be validated/verified? If so, please describe how. If not, why not? Is there a process for communicating/distributing these contributions to other users? If so, please provide a description.
No, data is specific to CRMC.
### **7.8**  Any other comments?
None.