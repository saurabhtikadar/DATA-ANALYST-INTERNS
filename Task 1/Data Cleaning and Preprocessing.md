## Task 1: Data Cleaning and Preprocessing
**Objective :** Clean and prepare a raw dataset (with nulls, duplicates, inconsistent formats).

**Tools :** Excel / Python (Pandas)

**Deliverables :** Cleaned dataset + short summary of changes

**Dataset names from Kaggle suitable for Task 1 :**
[Customer Personality Analysis](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis/data)

## *Opening CSV File in Excel*
When you open the provided CSV file in Microsoft Excel, the data might initially appear misaligned or improperly formatted due to Excel's default settings. 

![Image](https://github.com/user-attachments/assets/656cf8f2-4094-43cd-8856-912821174e24)

## *Formatting the CSV File in Excel*
If the CSV file appears misaligned or all data is in a single column when opened in Excel, follow the steps below to properly format the data:

**1. Select the First Column :**
- Open the CSV file in Excel.
- Click on the header of the first column to select the entire column containing the data.
  
**2. Use the `"Text to Columns"` Feature :**
- Go to the `Data` tab in the Excel ribbon.
- Click on the `Text to Columns` option.
  
**3. Choose `Delimited` :**
- In the "Convert Text to Columns Wizard", select `Delimited` as the file type and click `Next`.
  
**4. Select `Delimiters` :**
- In the next step, choose `Tab` as the delimiter option. You can preview the changes in the Data Preview section.
- Click `Finish` to apply the changes.
  
**5. Result :**
The data will now be separated into individual columns and properly formatted for analysis.
![Image](https://github.com/user-attachments/assets/60f71508-9017-40af-afa2-66b70f6ea3c6)
**Note :** `E12` cell is Blank.

## *Handle Null Values*
- **Identify Null Values:**
  - Check the columns for any `null` or `empty cells`.

- **Replace Null Values:**
  - Select the column with null values (`Income Column`).
  - Press `Ctrl + H` to open the "`Find and Replace`" dialog box.
  - In the "Find what" field, leave it `blank`.
  - In the "Replace with" field, enter `0`.

Click `Replace All` to update all null values with `0`.
![Image](https://github.com/user-attachments/assets/733de163-a7b5-41a5-89ad-9cc6dae15b90)
**Note:** Now `E12` is `0`.This step ensures that calculations involving these columns won't face errors due to missing data.

## *Convert Column Headers to Lowercase and Remove Spaces*
- **Select the Headers:**
  - Highlight the first row (where the column headers are located).

- **Use Formulas to Modify Headers:**
  - `Insert a new row` and use the following formula in an empty cell:

```excel
=LOWER(SUBSTITUTE(A1, " ", ""))
```
  - `Replace A1` with the corresponding header cell reference.

- **Apply Changes to All Headers:**
  - Drag the formula across all header cells.

- **Replace Original Headers:**
  - `Copy` the modified headers and `paste` them over the original ones as `values`.
  - 
![Image](https://github.com/user-attachments/assets/026d1685-d6c1-488c-ad27-53657f31bc73)
  
## **Final Note**
By following the above steps, your CSV file will be clean, consistent, and ready for further analysis or integration into your projects.
Proper formatting and cleaning ensure that the data can be efficiently used without errors or compatibility issues in calculations or scripts.
