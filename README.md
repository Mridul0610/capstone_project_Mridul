# Mamaearth Returns & Growth Intelligence Pipeline

## About the Project

This project analyzes Mamaearth's e-commerce data to understand sales, product returns, and business performance.

It has three main parts:

- **SQL:** Used to store data and calculate business results.
- **Python:** Used to clean data, analyze it, and create charts.
- **AI Narrator:** Used to turn analysis results into a simple business report.

## Project Structure

```text
├── README.md
├── sql/
│   ├── schema.sql
│   ├── seed_data.sql
│   └── reports.sql
├── data/
│   ├── customers.csv
│   ├── products.csv
│   └── orders.csv
├── analysis/
│   ├── clean_and_eda.py
│   └── visualize.py
├── visualizations/
│   ├── return_rate_by_payment.png
│   └── monthly_revenue_trend.png
└── narrator/
    ├── findings.json
    └── generate_narrative.py
```

## How to Run the Project

Run the three parts in the following order.

### 1. SQL Analysis

The SQL files are used to create the database tables, load the data, and calculate important business metrics.

Run these files in order using your SQL environment:

1. `sql/schema.sql` — Creates the required tables.
2. `sql/seed_data.sql` — Adds the data to the tables.
3. `sql/reports.sql` — Runs queries to analyze sales and returns.

### 2. Python Data Analysis and Visualization

First, make sure Python and the required libraries are installed.

Run the data cleaning and analysis script:

```bash
python analysis/clean_and_eda.py
```

This script reads the original CSV files, cleans the data, handles missing values and duplicates, and calculates important business metrics.

It generates two important outputs:

orders_merged_clean.csv — contains the cleaned orders merged with product and customer information, including calculated order values and outlier flags. The file is used by visualize.py as the input for creating visualizations.

narrator/findings.json — stores the verified business metrics from the analysis, including revenue reconciliation, return rates, the highest-risk customer segment, and monthly revenue findings. The narrator uses this file to generate the SCR business narrative.

Next, create the charts:

```bash
python analysis/visualize.py
```

The visualization script reads orders_merged_clean.csv to create charts from the cleaned dataset, such as:

- `return_rate_by_payment.png` — Compares return rates for different payment methods.
- `monthly_revenue_trend.png` — Shows the monthly revenue trend after excluding the identified quantity outliers.

Both charts are saved in the `visualizations/` folder.

### 3. Generate the Business Report

The final step uses the analysis results to generate a business report with the help of Gemini AI.

If you have a Gemini API key, set it before running the script.

**Windows PowerShell:**

```powershell
$env:GEMINI_API_KEY="your_api_key"
python narrator/generate_narrative.py
```

If you do not have an API key, you can still run:

```bash
python narrator/generate_narrative.py
```

The script uses its offline fallback when the API key is unavailable, provided the fallback is configured correctly.

## Project Workflow

```text
Raw CSV Files
     ↓
SQL Analysis
     ↓
Python Data Cleaning and EDA
     ↓
findings.json
     ↓
Charts and Visualizations
     ↓
AI-Generated Business Report
```

## Expected Results

After running the project, you will have:

- SQL reports containing business metrics.
- Cleaned data and exploratory analysis results.
- A JSON file containing the key findings.
- Two charts showing payment-wise returns and monthly revenue.
- A business report summarizing the main findings.

## Project Goal

The goal of this project is to understand sales trends, identify payment methods and customer segments with higher return rates, and explain business findings in a clear and useful way.

The project combines data analysis, visualization, and AI-assisted reporting to support better business decisions.
