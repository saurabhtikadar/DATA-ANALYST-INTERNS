## Task 8: Simple Sales Dashboard Design

### **Objective**
This repository contains a Python script to generate a synthetic sales dataset for a simple sales dashboard design. 
The dataset includes information about sales, profit, regions, and product categories. 
The generated dataset can be used to create a simple dashboard in Power BI for data visualization and analysis.


### **Tools Used**
- **Python Libraries**:
  - `Pandas` for data manipulation and analysis.
  - `Numpy` for generating random data and performing numerical operations.
- **Power BI** for data visualization and analysis.
---
## Data Preparation

This section explains the step-by-step process of generating a synthetic sales dataset using Python.

### Step 1: Import Required Libraries
We start by importing the necessary libraries:
- `Pandas` for data manipulation and analysis.
- `Numpy` for generating random data and performing numerical operations.

```python
import pandas as pd
import numpy as np
```

### Step 2: Define Data Parameters
We define the parameters for the dataset, including months, regions, and product categories.
```python
np.random.seed(42)  # Set seed for reproducibility
months = pd.date_range("2022-01-01", "2022-12-31", freq="MS").strftime("%b-%Y").tolist()
regions = ["North", "South", "East", "West"]
categories = ["Technology", "Furniture", "Office Supplies"]
```

### Step 3: Generate Random Data
Using Numpy, we generate random data for order dates, regions, categories, sales, and profit.
```python
data = {
    "Order Date": np.random.choice(months, 1000),
    "Region": np.random.choice(regions, 1000),
    "Category": np.random.choice(categories, 1000),
    "Sales": np.random.uniform(50, 1000, 1000).round(2),
    "Profit": np.random.uniform(5, 200, 1000).round(2),}
```

### Step 4: Create a DataFrame
We use Pandas to create a DataFrame from the generated data.
```python
df = pd.DataFrame(data)
```

### Step 5: Save the Dataset to a CSV File
Finally, we save the DataFrame to a CSV file for further use in the dashboard design.
```python
file_path = "D:/DATA ANALYST/Internship/Day-8-Simple Sales Dashboard Design/Dummy_Sales_Data.csv"
df.to_csv(file_path, index=False)
```

The dataset is now ready to be used for creating a simple sales dashboard in Power BI.
<h2 align="center">OR</h2>

#### Download Dataset: [Dummy_Sales_Data](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/blob/main/Task%208/Dummy_Sales_Data.csv)
---
## Dashboard Creation
I used this dummy data to create a simple sales dashboard as part of my internship project. You can access the dashboard by clicking the link below:

[Click here to view the dashboard](https://app.powerbi.com/groups/me/reports/724cdd2b-a672-45cb-8b4b-dce0d94364e4/7d9bc1d33b582d009dcb?experience=power-bi) or [Download Sales.pbix](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/blob/main/Task%208/Sales.pbix)
