# ============================================
# create_database.py
# Converts your Retail CSV to SQLite for SQL practice
# ============================================

import pandas as pd
import sqlite3
import os

print("=" * 60)
print("🛢️  CREATING SQLITE DATABASE FROM ONLINE RETAIL DATA")
print("=" * 60)

# ============================================
# 1. Load your raw transaction data
# ============================================

# Option A: Load from your raw Excel file
if os.path.exists("online_retail_II.xlsx"):
    df_0910 = pd.read_excel("online_retail_II.xlsx", sheet_name="Year 2009-2010")
    df_1011 = pd.read_excel("online_retail_II.xlsx", sheet_name="Year 2010-2011")
    df = pd.concat([df_0910, df_1011], ignore_index=True)
    print("✅ Loaded data from Excel file.")
else:
    # Option B: Load from your cleaned CSV (rfm_clv_output.csv)
    # This is customer-level, not transaction-level. For JOINs, we want transaction-level.
    # So I'll use a pre-cleaned version or fetch from the CSV if available.
    print("❌ Could not find online_retail_II.xlsx.")
    print("Please download it from Kaggle and place it in this folder.")
    exit()

# Clean just enough to make it usable for SQL
df.columns = df.columns.str.strip()
df = df[df['Customer ID'].notna()].copy()
df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])
df = df[(df['Quantity'] > 0) & (df['Price'] > 0)].copy()
df['TotalPrice'] = df['Quantity'] * df['Price']

print(f"✅ Loaded {len(df)} transactions for {df['Customer ID'].nunique()} customers.")

# ============================================
# 2. Create the Orders Table (Transaction Level)
# ============================================

orders = df[['Invoice', 'StockCode', 'Description', 'Quantity', 'InvoiceDate', 'Price', 'TotalPrice', 'Customer ID', 'Country']].copy()
orders.columns = ['Invoice', 'StockCode', 'Description', 'Quantity', 'InvoiceDate', 'UnitPrice', 'TotalPrice', 'CustomerID', 'Country']

# Convert InvoiceDate to string for SQLite (it handles dates better)
orders['InvoiceDate'] = orders['InvoiceDate'].astype(str)

print(f"✅ Orders table ready: {len(orders)} rows.")

# ============================================
# 3. Create the Customers Table (Aggregated)
# ============================================

customers = df.groupby('Customer ID').agg({
    'InvoiceDate': lambda x: x.max(),  # Last purchase date
    'Invoice': 'nunique',              # Frequency
    'TotalPrice': 'sum'                # Monetary
}).reset_index()

customers.columns = ['CustomerID', 'LastPurchaseDate', 'Frequency', 'Monetary']
customers['LastPurchaseDate'] = customers['LastPurchaseDate'].astype(str)

# Add a dummy segment (or we can leave it empty for JOIN practice)
print(f"✅ Customers table ready: {len(customers)} rows.")

# ============================================
# 4. Write to SQLite Database
# ============================================

db_path = "retail.db"

# If DB exists, remove it to start fresh
if os.path.exists(db_path):
    os.remove(db_path)

conn = sqlite3.connect(db_path)

# Write tables
orders.to_sql('orders', conn, index=False, if_exists='replace')
customers.to_sql('customers', conn, index=False, if_exists='replace')

# Create indexes for faster queries (this is what real DBAs do)
conn.execute("CREATE INDEX idx_orders_customer ON orders (CustomerID);")
conn.execute("CREATE INDEX idx_orders_invoice ON orders (Invoice);")
conn.execute("CREATE INDEX idx_orders_date ON orders (InvoiceDate);")

conn.close()

print("=" * 60)
print(f"✅ Database created successfully: {db_path}")
print(f"   📊 Tables: orders ({len(orders)} rows), customers ({len(customers)} rows)")
print("=" * 60)

# ============================================
# 5. Optional: Verify by running a quick query
# ============================================

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

cursor.execute("""
SELECT COUNT(*) AS total_orders, 
       SUM(TotalPrice) AS total_revenue,
       AVG(TotalPrice) AS avg_order_value
FROM orders;
""")
result = cursor.fetchone()
print("\n📊 Database Verification Query:")
print(f"   Total Orders: {result[0]:,}")
print(f"   Total Revenue: ${result[1]:,.2f}")
print(f"   Avg Order Value: ${result[2]:.2f}")

conn.close()