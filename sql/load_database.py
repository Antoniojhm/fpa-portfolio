import sqlite3
import pandas as pd
import os

DB_PATH = "data/forge.db"
DATA_PATH = "data/"

tables = {
    "customers": "customers.csv",
    "contracts": "contracts.csv",
    "revenue_transactions": "revenue_transactions.csv",
    "headcount": "headcount.csv",
    "budget": "budget.csv",
}

print("Connecting to FORGE database...")
conn = sqlite3.connect(DB_PATH)

for table_name, file_name in tables.items():
    file_path = os.path.join(DATA_PATH, file_name)
    print(f"Loading {table_name} from {file_name}...")
    df = pd.read_csv(file_path)
    df.to_sql(table_name, conn, if_exists="replace", index=False)
    print(f"  {len(df)} rows loaded")

conn.commit()
conn.close()

print("\nDone! FORGE database created at data/forge.db")
print("\nTables in database:")
conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()
cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
for row in cursor.fetchall():
    print(f"  - {row[0]}")
conn.close()