import os
import glob
import psycopg2
import pandas as pd
from sql_queries import *
import json

# I will create dictionary to connect this table others

# def covid_death(cur, filepath):
#     data = pd.read_csv(filepath) # "datasets/covid_death.csv"
#     for index, row in data.iterrows():
#         cur.execute(death_table_insert, list(row))
#
# def covid_vaccine(cur, filepath):
#     data = pd.read_csv(filepath)  # "datasets/covid_death.csv"
#     for index, row in data.iterrows():
#             cur.execute(death_table_insert, list(row))

def covid_death(cur, filepath, conn):
    data = pd.read_csv(filepath)
    for index, row in data.iterrows():
        cur.execute(death_table_insert, list(row))
    conn.commit()  # Commit the changes to the database

def covid_vaccine(cur, filepath, conn):
    data = pd.read_csv(filepath)
    for index, row in data.iterrows():
        cur.execute(vaccine_table_insert, list(row))
    conn.commit()  #
def main():
    conn = psycopg2.connect("host=127.0.0.1 dbname=covid user=postgres password=user")
    cur = conn.cursor()

    covid_death(cur, "datasets/covid_death.csv", conn)
    covid_vaccine(cur, "datasets/covid_vac.csv", conn)

    conn.close()


if __name__ == "__main__":
    main()