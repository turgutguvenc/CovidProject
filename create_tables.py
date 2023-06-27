import psycopg2
from sql_queries import create_table_queries, drop_table_queries


def create_database():
    """
    - Creates and connects to the cricket
    - Returns the connection and cursor to cricket
    """

    # connect to default database
    conn = psycopg2.connect("host=127.0.0.1 dbname=postgres user=postgres password=user")
    conn.set_session(autocommit=True)
    cur = conn.cursor()

    # create covid database with UTF8 encoding
    cur.execute("DROP DATABASE IF EXISTS covid")
    cur.execute("CREATE DATABASE covid WITH ENCODING 'utf8' TEMPLATE template0")

    # close connection to default database
    conn.close()

    # connect to covid database
    conn = psycopg2.connect("host=127.0.0.1 dbname=covid user=postgres password=user")
    cur = conn.cursor()

    return cur, conn


def drop_tables(cur, conn):
    """
    Drops each table using the queries in `drop_table_queries` list.
    """
    for query in drop_table_queries:
        cur.execute(query)
        conn.commit()


def create_tables(cur, conn):
    """
    Creates each table using the queries in `create_table_queries` list. 
    """
    for query in create_table_queries:
        cur.execute(query)
        conn.commit()


def main():
    """
    - Drops (if exists) and Creates the cricket database.
    
    - Establishes connection with the cricket database and gets
    cursor to it.  
    
    - Drops all the tables.  
    
    - Creates all tables needed. 
    
    - Finally, closes the connection. 
    """
    cur, conn = create_database()

    # drop_tables(cur, conn) # first time creating your database don't use this code
    create_tables(cur, conn)

    conn.close()


if __name__ == "__main__":
    main()
