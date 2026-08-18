# AdventureWorks Sales Analysis 🚴
End-to-end AdventureWorks sales analysis using SQL, Pandas, and Matplotlib, covering sales, product, customer, territory, and return performance.

## Project Overview

This project performs a comprehensive business analysis of **AdventureWorks**, a company that sells bicycles and accessories to customers across the United States, Australia, France, the United Kingdom, and Germany.

Using SQL and Python, the project explores multiple dimensions of business performance — sales trends, product performance, customer behavior, regional revenue distribution, and return patterns — with the goal of identifying growth opportunities and areas requiring management review.

---

## Why AdventureWorks?

AdventureWorks is a rich, multi-table dataset that closely mirrors real-world business data. It provides the freedom to explore data from multiple angles — sales, customers, products, territories, and returns — making it an ideal project for demonstrating end-to-end analytical thinking rather than single-dimensional querying.

Working with multiple related tables also builds confidence in handling complex joins, CTEs, and window functions at scale.

---

## Tools Used

- **Microsoft SQL Server / SSMS** — Data exploration and business analysis
- **Python (Pandas)** — Data manipulation and preparation for visualization
- **Matplotlib** — Data visualization

---
## Project Structure

```text
AdventureWorks-Sales-Analysis/
│
├── Adventureworks_csv_file/
│
├── Adventureworks_Sql_queries/
│   ├── AdventureWorks_Data_Exploration.sql
│   ├── AdventureWorks_Sales_Analysis.sql
│   ├── AdventureWorks_Product_Analysis.sql
│   ├── AdventureWorks_Customer_Analysis.sql
│   ├── AdventureWorks_Territory_Analysis.sql
│   └── AdventureWorks_Returns_Analysis.sql
│
├── Pandas_Visualisation/
│   └── AdventureWorks_Visualisations.ipynb
│
├── Visualisation_data/
│   └── (CSV files exported from SQL)
│
├── images/
│   ├── Territory_revenue.png
│   ├── Yearly_revenue.png
│   ├── Top10_products_by_revenue.png
│   ├── Revenue_by_category.png
│   ├── Revenue_vs_return.png
│   └── Revenue_vs_sales.png
│
└── README.md
```

### File Descriptions

| File | Description |
|------|-------------|
| `AdventureWorks_Data_Exploration.sql` | Initial examination of table structures, record counts, date ranges, product hierarchy, and duplicate checks to understand the dataset before analysis |
| `AdventureWorks_Sales_Analysis.sql` | Overall sales performance including revenue trends, YoY growth, seasonal patterns, monthly performance, and cumulative revenue |
| `AdventureWorks_Product_Analysis.sql` | Product-level performance covering revenue rankings, profitability, sales volume, category analysis, and a two-dimensional priority tier classification |
| `AdventureWorks_Customer_Analysis.sql` | Customer behavior analysis including segmentation by income, age group, purchasing frequency, basket size, and revenue contribution |
| `AdventureWorks_Territory_Analysis.sql` | Regional performance covering revenue distribution, revenue per customer, average order value, basket size, and YoY territory trends |
| `AdventureWorks_Returns_Analysis.sql` | Return pattern analysis covering return rates by product, category, and territory, along with a two-dimensional high-sales/high-return classification |

---

## Key Findings

### Sales Performance
- Revenue grew substantially from **2020 to 2021**, followed by a slight decline in 2022. However, since the 2022 data only covers January to June, the business appears on pace to outperform 2021 on a full-year basis.
- **February consistently underperformed** across all three years, remaining below the monthly average each time, followed by January, March, and April as weaker months.

### Territory Insights
- **Australia was the largest revenue-generating territory**, contributing approximately **29.76% of total revenue** (~$7.42M). Its strong performance was driven by higher-priced product purchases rather than bulk buying — Australian customers buy fewer items but at significantly higher average prices.
- **Southwest** was the second-highest territory at ~$4.82M, highlighting a significant performance gap between leading and smaller territories.
- Revenue and return rate showed a **weak positive correlation (r ≈ 0.33)**, suggesting that higher-revenue territories tend to have slightly higher return rates, but revenue alone is not a strong predictor of returns.

### Product Insights
- Revenue was **heavily concentrated in the Bikes category**, which contributed approximately **95% of total revenue**. Accessories and Clothing each contributed only a small fraction.
- **Mountain-200 variants dominated** top product revenue, with Mountain-200 Black (46) generating the highest product-level revenue at ~$1.24M.
- **Water Bottle - 30 oz.** was a standout performer — achieving approximately **62.6% profit margin** with sales volume more than **1,100% above the overall average**, making it one of the strongest products in the entire portfolio.
- A **two-dimensional Priority Tier classification** (combining profitability and sales performance) identified Very Low Priority products including Short-Sleeve Classic Jersey (~23% margin, 40–45% below average sales) and Long-Sleeve Logo Jersey (~34% margin, 34–41% below average sales) as candidates for repricing, cost reduction, or discontinuation review.
- Products with **high profitability but low sales** should not automatically be discontinued — these may represent opportunities for improved marketing or promotional strategies.

### Returns Insights
- The overall return rate across all products was approximately **2.17%** — roughly 2 out of every 100 units sold were returned.
- **Water Bottle - 30 oz.** had the highest return volume at 155 units, followed by Patch Kit/8 Patches (95) and Mountain Tire Tube (93).
- **Road-650 Red, 52** had the highest return rate at approximately **11.76%**, concentrated among specific bicycle models.
- **Bikes had the highest category return rate at 3.08%**, followed by Clothing (2.16%) and Accessories (1.95%).
- **France had the highest territory return rate at 2.37%** despite generating relatively lower revenue, warranting further investigation.

---

## Visualizations

### Territory Revenue
![Territory Revenue]([images/Territory_revenue.png](https://github.com/rahuldattaroy2727-cmd/AdventureWorks-Sales-Analysis/blob/main/adventureworks/images/Territory_revenue.png))

### Yearly Revenue Trend
![Yearly Revenue](images/Yearly_revenue.png)

### Top 10 Products by Revenue
![Top 10 Products](images/Top10_products_by_revenue.png)

### Revenue Share by Category
![Revenue by Category](images/Revenue_by_category.png)

### Revenue vs Return Rate by Territory
![Revenue vs Return Rate](images/Revenue_vs_return.png)

### Revenue vs Sales Volume by Product
![Revenue vs Sales](images/Revenue_vs_sales.png)

---

## How to Reproduce

1. Install **Microsoft SQL Server** and **SSMS** (or use the SQL Server extension in VS Code)
2. Download the raw CSV files from the `Adventureworks_csv_file` folder in this repository
3. Import the CSV files into your SQL Server instance using SSMS Import Wizard or SQL Server Import and Export tool
4. Once tables are loaded, each SQL query is **self-contained and independent** — copy any individual query and run it directly in your SQL environment to reproduce the result
5. For visualizations, open `AdventureWorks_Visualisations.ipynb` in Jupyter Notebook or VS Code
6. Install required Python libraries before running the notebook:

```bash
pip install pandas matplotlib
```

7. Make sure the exported CSV files from `Visualisation_data` folder are in the same directory as the notebook before running

---

## Dataset Source

The AdventureWorks dataset used in this project was obtained from Kaggle:  
[AdventureWorks Dataset](https://www.kaggle.com/datasets/shaikhshoeb/adventureworks-dataset-for-data-analysis)

## Dataset Limitations

- Sales data covers **January 2020 to June 2022** — full-year 2022 data is not available
- Revenue figures for 2022 reflect only the first half of the year and should not be directly compared to full-year 2020 and 2021 figures without adjustment
- The 2022 partial data suggests the business was on track to match or exceed 2021 performance if projected to a full year

---

## Author

**Rahul Datta Roy**  
Aspiring Data Analyst | SQL | Python | Power BI  
[GitHub](https://github.com/rahuldattaroy2727-cmd) | [LinkedIn](https://www.linkedin.com/in/rahul-datta-roy-0340a209)
