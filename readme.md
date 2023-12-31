Covid Pandemic Analyzing Project

The dataset is the real Coronavirus (COVID-19) Deaths dataset. Source; [https://codebasics.io/resources/data-analytics-project-for-beginners](https://ourworldindata.org/covid-deaths)

I create ETL processes to get data from CSV file that is downloaded from the Our World in Data website and created a database in PostgreSQL.

The purpose of the project makes COVID-19 data more understandable. Make dashboards and visualizations to help get more insight into the Covid pandemic.

To run these files properly, you must have PostgreSQL software on your computer.

Fact Tables ;
covid.csv - all metadata downloaded from the source website.
covid_death - relevant records in the covid.csv file show covid_death summary.
covid_vac - relevant records in the covid.csv file for vaccination, show the vaccination in the Covid pandemic summary.

sql_queries.py: has necessary SQL queries for creating and inserting values to covid_death and covid_vac datasets. 
create_tables.py: contains SQL and Python code to connect to PostgreSQL, and create our new database and tables. insert values to tables.
eda.sql: Making Exploratory Data Analysis with SQL to get insight and understand our tables. (CTE, Views, Stored Procedures, Triggers, user-defined functions ...)

Finally, I connected Postgresql to Power BI for data visualization,
<img width="1466" alt="image" src="https://github.com/turgutguvenc/CovidProject/assets/63226091/51fe3ccb-f71a-43a3-844a-b373d79aa47f">
<img width="1469" alt="image" src="https://github.com/turgutguvenc/CovidProject/assets/63226091/34b9dedd-72ee-4c8a-970c-a3e1ec4871f1">



