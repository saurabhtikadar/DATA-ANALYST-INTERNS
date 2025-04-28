# Titanic Dataset - Exploratory Data Analysis (EDA)

## Task 5: Exploratory Data Analysis (EDA)

### **Objective**
The goal of this task is to extract meaningful insights from the Titanic dataset using visual and statistical exploration techniques.

### **Tools Used**
- **Python Libraries**:
  - `Pandas` for data manipulation and analysis.
  - `Matplotlib` and `Seaborn` for data visualization.
- **Jupyter Notebook** for interactive data analysis.


### **Dataset:** [Titanic Dataset](https://www.kaggle.com/c/titanic/data?select=train.csv&utm_source=chatgpt.com) or [Titanic Zip](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/blob/main/Task%205/titanic.zip)
---
## Overview
This project conducts an exploratory data analysis (EDA) of the Titanic dataset to uncover insights about passenger survival based on various factors such as age, class, and fare. It involves the use of Python libraries such as Pandas, NumPy, Matplotlib, and Seaborn for data manipulation and visualization.

## Libraries Used
```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
```

# 1. Prepare Dataset
This **[Titanic dataset](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/new/main#dataset-titanic-dataset-or-titanic-zip)** is divided into three parts `gender_submission`,`test` and `train`.
First we will combine these three parts into one.
### 1. *Load Titanic Datasets*
```python
gender_sub=pd.read_csv('D:/DATA ANALYST/Internship/titanic/gender_submission.csv', encoding='latin1')
test=pd.read_csv('D:/DATA ANALYST/Internship/titanic/test.csv', encoding='latin1')
train=pd.read_csv('D:/DATA ANALYST/Internship/titanic/train.csv', encoding='latin1')
```
### 2. *Merge `gender_submission` and `test` datasets*
```python
test_combined_df = gender_sub.merge(test, on="PassengerId")
test_combined_df
```
### 3. *Combine `train` Dataset with Merged `test` Dataset*
```python
final_df = pd.concat([train, test_combined_df], ignore_index=True)
final_df
```
### 4. *Save the combined dataset to a CSV for further analysis in Jupyter*
```python
output_path = "D:/DATA ANALYST/Internship/titanic_combined.csv"
final_df.to_csv(output_path, index=False)
output_path
```




The Titanic dataset (**[titanic_combined.csv](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/blob/main/Task%205/titanic_combined.csv)**) is loaded for analysis. It contains information about passengers, including their age, class, fare, and survival status.
# 2. Exploratory Data Analysis
### 1. Load the Dataset
```python
file_path = 'titanic_combined.csv'
data = pd.read_csv(file_path)
data.head()  # Display the first few rows
```

### 2. Basic Data Exploration
- #### Data Summary
```python
data.info()
```
Provides an overview of the dataset, including column names, data types, and non-null counts.

- #### Statistical Summary
```python
data.describe()
```
Generates summary statistics for numerical columns, such as mean, median, and standard deviation.

- #### Checking for Missing Values
```python
data.isnull().sum()
```
Identifies missing values in each column to determine if data cleaning is required.

# 3. Visualizations and Insights

### 1. Age Distribution
```python
plt.figure(figsize=(10, 6))
ax = sns.histplot(data['Age'], kde=True, bins=30, color='blue')

for p in ax.patches:
    height = p.get_height()
    if height > 0:
        ax.annotate(f'{int(height)}', (p.get_x() + p.get_width() / 2, height),
                    ha='center', va='bottom', fontsize=10)

plt.title('Age Distribution', fontsize=16)
plt.xlabel('Age', fontsize=14)
plt.ylabel('Frequency', fontsize=14)
plt.show()
```
**Result:**![Image](https://github.com/user-attachments/assets/d3185473-0dbd-440e-a8cf-3645d1a4e390)
- **Purpose:** A histogram is used to visualize the distribution of a single variable. It divides the data into bins and shows the frequency of data points in each bin.

- **Histogram for Age Distribution
Observation:** The histogram shows the distribution of passenger ages. The majority of passengers are between 20 and 40 years old. There are fewer passengers in the younger (below 10) and older (above 60) age groups.

- **Insight:** The dataset is skewed towards younger passengers, with a peak in the 20–30 age range.
### 2. Survival Counts
```python
plt.figure(figsize=(8, 6))
ax = sns.countplot(x='Survived', data=data, hue='Survived', palette='viridis', legend=False)

for p in ax.patches:
    count = int(p.get_height())
    ax.annotate(f'{count}', (p.get_x() + p.get_width() / 2, count),
                ha='center', va='bottom', fontsize=12)

plt.title('Survival Count', fontsize=16)
plt.xlabel('Survived (0 = No, 1 = Yes)', fontsize=14)
plt.ylabel('Count', fontsize=14)
plt.show()
```
**Result:**![Image](https://github.com/user-attachments/assets/18442e81-39d1-4d02-8902-de0c3eaa9252)
- **Purpose:** Displays the number of survivors (Survived = 1) and non-survivors (Survived = 0).

- **Survived Counts Observation:** The countplot shows the number of passengers who survived (Survived = 1) and those who didn’t (Survived = 0).
The number of non-survivors is significantly higher than the number of survivors.

- **Insight:** The survival rate is low, indicating that most passengers did not survive the Titanic disaster.
### 3. Age vs. Survival
```python
plt.figure(figsize=(10, 6))
ax = sns.boxplot(x='Survived', y='Age', data=data, hue='Survived', palette='viridis', dodge=False, legend=False)

survival_counts = data['Survived'].value_counts()
for i, count in enumerate(survival_counts):
    ax.annotate(f'Count: {count}', (i, data['Age'].max() - 5), ha='center', fontsize=12)

plt.title('Age vs. Survival', fontsize=16)
plt.xlabel('Survived (0 = No, 1 = Yes)', fontsize=14)
plt.ylabel('Age', fontsize=14)
plt.show()
```
**Result:**![Image](https://github.com/user-attachments/assets/a96dacb8-a4c0-435b-abb0-5c4f2a0a05d0)
- **Purpose:** A boxplot is used to visualize the distribution of a variable and identify outliers. It shows the median, quartiles, and potential outliers.

- **Boxplot for Age vs. Survival Observation:** The boxplot shows that the median age of survivors is slightly lower than that of non-survivors. There are more outliers in the older age group for non-survivors.

- **Insight:** Younger passengers had a higher likelihood of survival compared to older passengers.
### 4. Age vs. Fare
```python
plt.figure(figsize=(10, 6))
sns.scatterplot(x='Age', y='Fare', data=data, hue='Survived', palette='coolwarm')
plt.title('Age vs. Fare', fontsize=16)
plt.xlabel('Age', fontsize=14)
plt.ylabel('Fare', fontsize=14)
plt.legend(title='Survived', loc='upper right')
plt.show()
```
**Result:**![Image](https://github.com/user-attachments/assets/f6792405-825f-44f0-b583-259171ac5fd9)
- **Purpose:** A scatterplot is used to visualize the relationship between two continuous variables.

- **Scatterplot for Age vs. Fare
Observation:** The scatterplot shows that passengers who paid higher fares were generally younger. There is a cluster of passengers who paid low fares across all age groups.

- **Insight:** Higher fares might be associated with better survival chances, as younger passengers paying higher fares are more likely to survive.
### 5. Correlation Heatmap
```python
numeric_data = data.select_dtypes(include=['number'])
corr_matrix = numeric_data.corr()

plt.figure(figsize=(12, 8))
sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', fmt='.2f', square=True)
plt.title('Correlation Heatmap', fontsize=16)
plt.show()
```
**Result:**![Image](https://github.com/user-attachments/assets/65905cc0-32ca-4ed2-aab4-4e4ad3d775cc)
- **Purpose:** A heatmap was generated to show correlations between numeric variables.

- **Observation:**
  - Fare has a moderate positive correlation with Pclass (indicating higher-class passengers paid higher fares).
  - Survived has a weak positive correlation with Fare and a weak negative correlation with Pclass.
  - Other correlations are relatively weak.

- **Insight:** Passengers in higher classes (lower Pclass values) and those who paid higher fares were more likely to survive.

### 6. Pairplot
```python
sns.pairplot(data, hue='Survived', palette='coolwarm')
plt.show()
```
**Result:**![Image](https://github.com/user-attachments/assets/be67c3d0-3339-4075-8d4b-96a98ffd9546)
- **Purpose:** A pairplot is used to visualize pairwise relationships between numerical variables in the dataset. The hue='Survived' parameter highlights the survival status (0 = No, 1 = Yes) using different colors.

- **Observation:** The pairplot shows how variables like Age, Fare, and Pclass interact with each other. Passengers who paid higher fares (Fare) and belonged to higher classes (Pclass) were more likely to survive. Younger passengers also show a higher survival rate.

- **Insight:** The pairplot provides a comprehensive view of the relationships between variables and their impact on survival. It confirms that Fare and Pclass are significant factors influencing survival.
## Summary of Findings

1. **Age Distribution:** Most passengers were young adults (20–40 years old).
2. **Survival Counts:** The survival rate is low, with non-survivors outnumbering survivors.
3. **Age vs. Survival:** Younger passengers had better survival chances.
4. **Age vs. Fare:** Higher fares were associated with better survival outcomes.
5. **Correlation Analysis:** Fare and class are significant factors in survival, while other correlations are relatively weak.

## Conclusion
The analysis provides valuable insights into the factors influencing passenger survival on the Titanic. Key variables such as age, class, and fare play crucial roles in determining outcomes.
