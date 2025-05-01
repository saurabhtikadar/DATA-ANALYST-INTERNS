## Task 7: Get Basic Sales Summary from a Tiny SQLite Database using Python

### **Objective**
Use SQL inside Python to pull simple sales info (like total quantity sold, total revenue), and
display it using basic print statements and a simple bar chart.
### **Tools Used**
- `Python` (with `sqlite3`, `pandas`, `matplotlib`)
- `SQLite` (built into Python — no setup!)
- `Jupyter Notebook` file
- `VS Code` 

# Sales Data Analysis

This project demonstrates how to create and analyze a sales dataset using SQLite and Python. It includes generating dummy sales data, storing it in a database, querying the data for analysis, and visualizing the results.

## Features

- **Database Creation**: Automatically creates an SQLite database (`sales_dataset.db`) and a `sales` table.
- **Data Generation**: Generates 1000+ rows of random sales data for five products.
- **Data Insertion**: Inserts the generated data into the database.
- **Data Analysis**: Queries the database to calculate total quantity sold and revenue for each product.
- **Visualization**: Displays a bar chart showing revenue by product.

## Steps in the Notebook

1. **Import Required Libraries**  
   Import essential libraries like `sqlite3`, `random`, `pandas`, and `matplotlib`.
```python
import sqlite3
import random
import pandas as pd
import matplotlib.pyplot as plt
```

2. **Create SQLite Database and Table**  
   - Connect to an SQLite database (`sales_dataset.db`).
   - Create a `sales` table with columns for `id`, `product`, `quantity`, and `price`.
```python
# Connect to SQLite and create the database file
conn = sqlite3.connect("sales_dataset.db")
cursor = conn.cursor()

# Create the sales table
cursor.execute("""
CREATE TABLE IF NOT EXISTS sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price REAL NOT NULL)""")
```
3. **Generate Dummy Sales Data**  
   - Generate 1000+ rows of random sales data for five products (`Product A`, `Product B`, etc.).
   - Each row includes a product name, quantity sold, and price.
```python
products = ["Product A", "Product B", "Product C", "Product D", "Product E"]
sample_data = [(random.choice(products), random.randint(1, 20), round(random.uniform(5.0, 50.0), 2))
    for _ in range(1000)]
```
4. **Insert Data into the Database**  
   - Insert the generated dummy data into the `sales` table.
```python
cursor.executemany("INSERT INTO sales (product, quantity, price) VALUES (?, ?, ?)", sample_data)
```
5. **Commit Changes and Close the Connection**  
   - Save the changes to the database and close the connection.
```python
conn.commit()
conn.close()
print("Database 'sales_data.db' created with 1000+ rows of data successfully.")

```
6. **Query the Database for Analysis**  
   - Query the total quantity sold and revenue for each product.
```python
# Connect to the SQLite database
conn = sqlite3.connect("sales_dataset.db")
# Define the SQL query
query = """
SELECT 
    product, 
    SUM(quantity) AS total_qty, 
    SUM(quantity * price) AS revenue
FROM 
    sales
GROUP BY 
    product
"""
# Execute the query and load results into a Pandas DataFrame
df = pd.read_sql_query(query, conn)
df
```
7. **Display and Visualize the Results**
- Print the sales summary by product.
- Plot the revenue by product as a bar chart.  
```python
# Plot the results of the query as a bar chart
plt.figure(figsize=(10, 6))
df.plot(kind='bar', x='product', y='revenue', color='skyblue', legend=False)
plt.title("Revenue by Product", fontsize=16)
plt.xlabel("Product", fontsize=14)
plt.ylabel("Revenue ($)", fontsize=14)
plt.xticks(rotation=45, ha='right')
plt.tight_layout()

# Save the plot as an image (optional)
plt.savefig("sales_chart.png")

# Show the plot
plt.show()
```
#### **Result:**![Image](https://github.com/user-attachments/assets/54b5920e-1b42-4e48-a559-ad04a7f50d71)
## Output

- **Database**: [sales_dataset.db](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/blob/main/Task%207/sales_dataset.db) containing the `sales` table with 1000+ rows of data.
- **Analysis**: A summary of sales by product displayed in the console.
- **Visualization**: A bar chart ([sales_chart.png](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/edit/main/Task%207/Get%20Basic%20Sales%20Summary%20from%20a%20Tiny%20SQLite%20Database%20using%20Python.md#result)) showing revenue by product.

## How to Run

1. Clone this repository to your local machine.
2. Open the [Sales_data.ipynb](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/blob/main/Task%207/Sales_data.ipynb) notebook in Jupyter Notebook or any compatible environment.
3. Execute the cells step by step to create the database, generate data, analyze it, and visualize the results.

## Requirements

- Python 3.x
- Jupyter Notebook
- Required Python Libraries:
  - `sqlite3`
  - `random`
  - `pandas`
  - `matplotlib`
## Final Note
This project is a comprehensive demonstration of how to work with data using Python and SQLite, from database creation to data visualization.
It is designed to help you understand the end-to-end process of data analysis in a practical and hands-on way.
Feel free to explore, modify, and expand upon this project to suit your needs. Happy coding and analyzing! 🚀
