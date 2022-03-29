# Med Phys Spreadsheets
Spreadsheets from my work as Radiation Physicist Assistant at Cookeville Regional Medical Center. Also includes a few Excel and Word VBA scripts. Some spreadsheets have sensitive information redacted—thus the filenames ending in _REDACTED_. All files were created in Excel or Word 2016 and are not guaranteed to work in any other version of Excel/Word.

Some spreadsheets include "How to Use" instructions for end users, and this document includes data dictionaries and explains some technical/implementation details relevant to anyone who wants to change a spreadsheet beyond entering data.

## Spreadsheets
### Brachy Txs
#### Dependencies
- [`CustomValidation`](.\CustomValidation.xlam) add-in
#### Data Dictionary
<!-- HTML table instead of markdown table for finer style control -->
##### `BrachyTxs` Table
Each row represents a brachytherapy treatment (fraction). This is the only unhidden table.
<table>
    <tr>
        <th>Column</th>
        <th>Description</th>
        <th>Constraints</th>
        <th>Constraint Enforcement Method</th>
    </tr>
    <tr>
        <th>Tx_Type</th>
        <td>Brachytherapy source</td>
        <td>
            Dropdown list of possible values:
            <ul>
                <li>Cs-137</li>
                <li>I-131 Low Dose</li>
                <li>I-131 High Dose</li>
                <li>Ra-223 (Xofigo)</li>
            </ul>
        </td>
        <td>Excel Data Validation</td>
    </tr>
    <tr>
        <th>Date</th>
        <td>Date of the brachytherapy treatment</td>
        <td>Today or a past date</td>
        <td>Excel Data Validation</td>
    </tr>
    <tr>
        <th>Pt</th>
        <td>Patient who received the brachytherapy treatment</td>
        <td>
            MRN or patient name</br>
            Name is used for patients that were treated before the full implementation of our EMR
        </td>
        <td>Excel Data Validation in combination with named ranges and VBA (see <strong>Other Technical Details</strong>)</td>
    </tr>
    <tr>
        <th>Physicist(s)</th>
        <td>Initials of physicist(s) that were involved in the brachytherapy treatment</td>
        <td>Comma-separated list of initials of existing physicist(s)</td>
        <td>Excel Data Validation in combination with named ranges and VBA (see <strong>Other Technical Details</strong>)</td>
    </tr>
    <tr>
        <th>MD(s)</th>
        <td>Initials of MD(s) that were involved in the brachytherapy treatment</td>
        <td>Comma-separated list of initials of existing MD(s)</td>
        <td>Excel Data Validation in combination with named ranges and VBA (see <strong>Other Technical Details</strong>)</td>
    </tr>
</table>

##### Other Technical Details
There are four tables on the single worksheet: `BrachyTxs`, `AllPhysicists`, `AllMDs`, and `Validations`. `BrachyTxs` is the only unhidden table. The other tables are hidden because they are not for the end user: they are only used for validating data entries. 

The `BrachyTxs` table contains a hidden column for each physicist and MD. These values are `1` if the physicist/MD is in the list in the `Physicist`/`MD` column, `0` otherwise. These columns are used in the `Personnel Involved` PivotTable.

`AllPhysicists` and `AllMDs` are lists of valid physicist and MD initials, respectively. 

The first row of `Validation` contains named ranges that call VBA functions that return whether a certain value in `BrachyTxs` is valid. The data validation in `BrachyTxs` uses this named range in its Data Validation. This workaround is necessary because Excel disallows VBA functions in Data Validation formulas. The first column of `ValidatePt` uses a function in the [`CustomValidation`](.\CustomValidation.xlam) add-in to verify that the `Pt` entry is either an MRN or a name in a certain format. The other two columns ensure that each physicist or MD in the comma-separated lists are present in the `AllPhysicists` or `AllMDs` table, respectively. 
<hr>

### Contacts
Contact information for employees, vendors, support, etc.
#### Data Dictionary
##### `Personnel` Table
Employee contact information
Column | Description
--- | ---
`Last` | Employee last name
`First` | Employee first name
`Company/Product` | Employee's employer, or product that the employee is associated with
`Position` | Employee's job title
`Email` | Employee's email address
`Ph` | Employee's phone number. There may be multiple lines for multiple types of phone numbers, such as extension, work, cell, and fax.
`Notes` | Notes about any field values in the row
##### `Support` Table
Contact information for application and technical support for software and other tools
Column | Description
--- | ---
`Company/Product` | Company or product we need support for
`Ph` | Support phone number
`Email` | Support email address
`URL` | Support URL
`Notes` | Notes about any field values in the row
##### `Other Exts` Table
Internal phone extensions for locations/services in the hospital
Column | Description
--- | ---
`Description` | What/where the extension is for
`Ext` | The extension
##### `CRMC Usernames` Table
Domain usernames of past and current clinic employees
Column | Description
--- | ---
`Name` | Employee name
`Username` | Employee's CRMC domain username
<hr>

#### Credentials & Computer Info
Usernames and passwords, network drive paths, etc.
<hr>

#### CT Dose Calculator
Calculate and evaluate CT-only dose based on age and body site.
Spreadsheet was originally created by King Turnbull, but I heavily modified it.
<hr>

#### Inpatient I-131 Room Cleanup Survey Data
Radioactivity readings from an inpatient I-131 brachytherapy treatment.

CRMC does our high-dose I-131 brachytherapy treatments as inpatient. We measure room background before the patient arrives, after the patient leaves but before we clean up the room, and after cleanup. Before treatment, we measure background using two different survey meters: a Geiger-Müller (GM) counter and an ion chamber (IC). We compute a "cutoff" for a normal (nonradioactive) reading as three dtandard deviations above background. The post-treatment and post-cleanup background readings are compared to this "cutoff" to determine whether the room is safe for release.

We leave the patient with trash cans for trash and for linens. The nurses' trash can and linen cart should therefore be nonradioactive, and we measure them (a) for comparison to the radioactive trash cans, and (b) to ensure they are indeed nonradioactive. We also measure the toilet and the restroom background. 

The post-cleanup readings should be below the background "cutoff" taken before the patient arrived.
##### Dependencies
- [`CustomValidation`](.\CustomValidation.xlsm) add-in
##### Other Technical Details
Entered data is validated using Excel Data Validation, radio buttons to constrain values to a predefined list, and my [`CustomValidation`](.\CustomValidation.xlsm) add-in. The hidden column `ValidatePt`is used by `CustomValidation`; see the Brachy Txs technical details for more details.

`Date` must be a valid date. (Excel Data Validation requires a minimum date. This date has no significance and is just the date on which I set the Data Validation.)

Ion chamber readings must be non-negative numbers, and GM readings must be non-negative integers. Each IC reading unit is either `mR/hr` or `μR/hr`, selected from a group of ActiveX `OptionButton`s. The grouping ensures that only one unit may be selected at any given time. When a unit is selected, or the IC SD or background value is changed, the "cutoff" is recalculated using VBA. The units selection for this field is disabled because it is controlled by the VBA: the unit is μR/hr if and only if both the SD and background are in μR/hr; otherwise it is mR/hr.

The `Room` field is also an `OptionButton` group.

The `Clear All Radio Buttons` button sets all `OptionButton` values to `False`.
<hr>

#### Inventory
Tracks inventory and calibration dates. Rows are color coded by calibration status.
##### Data Dictionary
<!-- HTML table instead of markdown table for finer style control -->
<table>
    <tr>
        <th>Column</th>
        <th>Description</th>
        <th>Constraints* or calculation</th>
    </tr>
    <tr>
        <th>Type</th>
        <td>Type of product</td>
        <td>
            Dropdown list of possible values:
            <ul>
                <li>Annual QA equipment</li>
                <li>Barometer</li>
                <li>Daily/monthly QA equipment</li>
                <li>Electrometer</li>
                <li>Film equipment</li>
                <li>In-vivo dosimeter</li>
                <li>Ion chamber</li>
                <li>Linac</li>
                <li>Room monitor</li>
                <li>Scanning detector</li>
                <li>Software</li>
                <li>Survey meter</li>
                <li>Thermometer</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th>Manufacturer</th>
        <td>Producer of the product</td>
        <td>
            Dropdown list of possible values:
            <ul>
                <li>Accuray</li>
                <li>Elekta</li>
                <li>Fluke</li>
                <li>IBA</li>
                <li>Ludlum</li>
                <li>MIM</li>
                <li>PTW</li>
                <li>RaySearch</li>
                <li>Scanditronix</li>
                <li>Standard Imaging</li>
                <li>Sun Nuclear</li>
                <li>Varian</li>
                <li>Victoreen</li>
                <li>Vidar</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th>Product</th>
        <td>Product name</td>
        <td></td>
    </tr>
    <tr>
        <th>Description</th>
        <td>Description of the product/item</td>
        <td></td>
    </tr>
    <tr>
        <th>S/N</th>
        <td>Item serial number</td>
        <td></td>
    </tr>
    <tr>
        <th>Location</th>
        <td>Where the item lives/is stored</td>
        <td>
            Dropdown list of possible values:<br>
            <ul>
                <li>Block room</li>
                <li>E1 closet</li>
                <li>E1 console</li>
                <li>E1 vault</li>
                <li>E2 closet</li>
                <li>E2 console</li>
                <li>E2 vault</li>
                <li>Elekta console</li>
                <li>Elekta vault</li>
                <li>Hot lab</li>
                <li>Physics cabinet</li>
                <li>Physics mid room</li>
                <li>Physics office</li>
                <li>Tomo closet</li>
                <li>Tomo console</li>
                <li>Tomo vault</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th>On license</th>
        <td>Whether or not the item is under license</td>
        <td><code>TRUE</code> or <code>FALSE</code></td>
    </tr>
    <tr>
        <th>Vendor doc</th>
        <td>Whether or not we have vendor documentation on our network drive</td>
        <td><code>TRUE</code> or <code>FALSE</code></td>
    </tr>
    <tr>
        <th>TG-40 req for cal</th>
        <td>Calibration requirement according to AAPM Task Group Report 40</td>
        <td><code>initial use</code> (case insensitive) or positive integer number of years</td>
    </tr>
    <tr>
        <th>Date last cal</th>
        <td>Date of last calibration of the item</td>
        <td><code>not req'd</code> (case insensitive) or past date (including today)</td>
    </tr>
    <tr>
        <th>Cal due date</th>
        <td>Due date of the item's next calibration</td>
        <td>Calculation based on <code>TG-40 req for cal</code> and <code>Date last cal</code></td>
    </tr>
    <tr>
        <th>Preparing for cal</th>
        <td>Whether or not we are currently preparing the item for sending out for calibration</td>
        <td>If no due date, must be blank. Otherwise, <code>TRUE</code> or <code>FALSE</code></td>
    </tr>
    <tr>
        <th>Out for cal</th>
        <td>Whether or not the item is currently out for calibration</td>
        <td>If no due date, must be blank. If preparing for calibration, must be <code>FALSE</code>. Otherwise, <code>TRUE</code> or <code>FALSE</code></td>
    </tr>
    <tr>
        <th>Notes</th>
        <td>Additional information about the item</td>
        <td></td>
    </tr>
    <tr>
        <th>Neither prepping, out, nor late</th>
        <td>Column is not for user use, so it should remain hidden! Only used for conditional highlighting (coloring) rules.
        <td></td>
    </tr>
</table>
<sub>*Enforced by Excel Data Validation</sub>
<hr>

#### MOSAIQ QA Patients
An Excel spreadsheet describing the QA patients that we periodically create in MOSAIQ. It is necessary to periodically create new patients because MOSAIQ slows down as a patient acquires more images.

There is a sheet for each patient: `Morning Warmup` and `Penta-Guide`. The sheet tells how often to create a new patient of this type, the registration information, and the diagnosis and treatment information.
<hr>

#### Periodic QA Checklist
I overhauled King's master spreadsheet of QA tasks. Put the contents of the `Periodic QA Checklists` directory in a year folder (e.g., `2022`). Use the color legend in the spreadsheets to track the status of the annual, quarterly, monthly, and daily QA tasks. You should replace any `YYYY` with the year. For leap years, add a row on the `Daily` sheet of the `Monthly and Daily/02` for Feb. 29.
<hr>

#### PSQA Stats
Tracks patient-specific QA results over time.

The data can be used to answer myriad statistical questions, such as:
- Does the average gamma pass ratio differ by body site?
- Are the shifts greater on Tomo than on Elekta, as we expect?
- Does dose rescale actually increase any of the pass ratios?
##### Dependencies
- [`CustomValidation`](.\CustomValidation.xlam) add-in
##### Other Technical Details
There are two tables on the single worksheet in the XLSM file: `PSQAStats` and `Validation`. See the Brachy Txs Technical Details for an explanation of how the `Validation` table is used for data validation. 

See the [Datasets for Datasets](https://arxiv.org/abs/1803.09010) [datasheet](.\PSQA Stats\datasheet.md) for more details, including the data dictionary.
<hr>

#### SNC Alternatives Log
Log of when we had to use an alternative to Sun Nuclear DailyQA3 for daily QA on Elekta.
<hr>

### VBA
These are not "end user" tools, so only technical information is provided below.
#### CustomValidation
Excel add-in for data validation that cannot be done using Excel's Data Validation alone.

The add-in contains a single module with several functions. Each function's name starts with `Validate` (e.g., `ValidateMRN`). Most functions takes a single argument: the range (must be a single cell) whose value to validate. Each function returns `True` if the value is valid, `False` otherwise.

These functions are meant to be used in named ranges which can be used in Custom Data Validation.
##### Example
Here is an example of implementing custom data validation using this add-in, named ranges, and Excel's built-in Data Validation.

In my [Brachy Txs](.\Brachy Txs.xlsm) spreadsheet, each `Pt` value must be either an MRN or a patient name. The `CustomValidation` `ValidatePatient` performs this validation. To implement the validation, I:
1. Create a `Validation` table with a column `ValidatePt`.

<img src="./images_for_readme/CustomValidation/Validation_table.png" alt="Validation table"/>

<img src="./images_for_readme/CustomValidation/Validation_table_name.jpg" alt="Validation table name"/>

2. In the first row of the `ValidatePt` column, call the `ValidatePatient` function, passing in the `Pt` cell as an argument.

<img src="./images_for_readme/CustomValidation/call_ValidatePatient.png" alt="call ValidatePatient"/>

3. Create a named range from the cell in the previous step.

<img src="./images_for_readme/CustomValidation/named_range.jpg" alt="Named Range"/>

4. Fill in the remaining rows of the `Validation` table.

<img src="./images_for_readme/CustomValidation/remaining_Validation_rows.png" alt="remaining Validation rows"/>

5. Add Data Validation to the `Pt` column. Use the range name as the custom formula.

<img src="./images_for_readme/CustomValidation/Data_Validation.jpg" alt="Data Validation"/>
<hr>

#### FmtTbls
Macro that applies a standard format to all tables in the current Word document. Specifically, it does the following:
- Sets default borders.
- Horizontally and vertically center aligns table values.
- Sets uniform row height.
- Center aligns the table.
- AutoFits column widths.
- Disallows the table from spanning multiple pages.
- Bolds the first row (header row).
- Changes red text to black highlighted text.
- Sets the font.
<hr>

#### RedactedSpreadsheet
Excel add-in for redacting sensitive values from tables in a spreadsheet. A copy of the current workbook is created, with the following cell values replaced with `[redacted]`:
- Email addresses
- Non-blank cell values in the user-specified columns
The add-in contains a single macro, `RedactedSpreadsheet`.
##### Example
I used the `RedactedSpreadsheet` add-in to redact sensitive information in my `Credentials & Computer Info` spreadsheet. Here are my steps:
1. I want a redacted copy called `redacted`.<br/>
<img src="./images_for_readme/RedactedSpreadsheet/filename.png" alt="Filename prompt"/><br/>

2. For each table in each sheet, I specify the columns I want desensitized. In table `Creds`, these are `Username` and `Password`.<br/>
<img src="./images_for_readme/RedactedSpreadsheet/redact_columns.png" alt="Column names prompt"/><br/>
If no columns contain sensitive information, you may leave the input blank.

3. A spreadsheet `redacted.xlsx` has been created, opened, and saved in the same directory as the original spreadsheet.