import psycopg2

DB_HOST = "terraform-20251210055559055800000002.clikews6m40s.ap-south-1.rds.amazonaws.com"  
DB_NAME = "source_db"
DB_USER = "postgres"
DB_PASS = "MySecurePassword123!"


try:
    print("Connecting to Database...")
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        port="5432"
    )
    conn.autocommit = True
    cursor = conn.cursor()

    # 1. Create table
    print("Creating table 'employees'...")
    create_table_query = """
    CREATE TABLE IF NOT EXISTS employees (
        id INT PRIMARY KEY,
        name VARCHAR(50),
        department VARCHAR(50),
        salary INT
    );
    """
    cursor.execute(create_table_query)

    # 2. insert data
    print("Inserting dummy data...")
    insert_query = """
    INSERT INTO employees (id, name, department, salary) VALUES
    (1, 'Amit Sharma', 'Engineering', 80000),
    (2, 'Priya Singh', 'HR', 60000),
    (3, 'Rahul Verma', 'Data Science', 95000),
    (4, 'Sneha Gupta', 'Marketing', 70000)
    ON CONFLICT (id) DO NOTHING;
    """
    cursor.execute(insert_query)

    print(" Success! Data inserted. Ab aap Glue Job run kar sakte hain.")

except Exception as e:
    print(f"❌ Error: {e}")
finally:
    if 'conn' in locals() and conn:
        cursor.close()
        conn.close()