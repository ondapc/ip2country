import os
import pandas as pd
from sqlalchemy import create_engine, types, text
import db_config as cfg

# 1. Update/Download Configuration (Point to the GZIP URL)
URL_PATH = "https://github.com/sapics/ip-location-db/releases/download/latest/geolite2-city-ipv6-num.csv.gz" # <-- Paste your download URL here
FILE_PATH = "csv/geolite2-city-ipv6-num.csv.gz" # <-- Your specific destination file

# 2. Database connection parameters
DB_USER = "ip2country"
DB_PASS = "sevilla1"
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "IP2COUNTRY"
TABLE_NAME = "city_v6"

# =========================================================
# STEP 1: Download, Natively Decompress, and Save the File
# =========================================================
print(f"Downloading and decompressing dataset from {URL_PATH}...")

column_names = [
    "ip_range_start", "ip_range_end", "country_code", "region_name", "county_name", "city_name", "postal_code", "latitude", "longitude", "timezone"
]

try:
    # Pandas handles the web request and the gzip decompression automatically under the hood
    df = pd.read_csv(
        URL_PATH, 
        compression="gzip", 
        header=None, 
        names=column_names, 
        keep_default_na=True,
        dtype={
            "country_code": str,
            "region_name": str,
            "county_name": str,
            "city_name": str,
            "postal_code": str,
            "latitude": str,
            "longitude": str,
            "timezone": str
        }        
    )
    
    # Save the clean, decompressed data to your specific local text file
    df.to_csv(FILE_PATH, header=False, index=False)
    print(f"Successfully decompressed and saved locally to: {FILE_PATH}")
    
except Exception as e:
    print(f"Error handling the gzip file: {e}")
    raise

# =========================================================
# STEP 2: Import to MySQL (Your optimized code)
# =========================================================
engine = create_engine(f"mysql+pymysql://{cfg.DB_USER}:{cfg.DB_PASS}@{cfg.DB_HOST}:{cfg.DB_PORT}/{cfg.DB_NAME}")

dtype_mapping = {
    "ip_range_start": types.DECIMAL(precision=41, scale=0),
    "ip_range_end": types.DECIMAL(precision=41, scale=0),
    "country_code": types.CHAR(length=2),
    "region_name": types.VARCHAR(length=100),
    "county_name": types.VARCHAR(length=100),
    "city_name": types.VARCHAR(length=100),
    "postal_code": types.VARCHAR(length=20),
    "latitude": types.DECIMAL(precision=7, scale=4),
    "longitude": types.DECIMAL(precision=7, scale=4),
    "timezone": types.VARCHAR(length=50)
}

print(f"Importing {len(df)} rows into '{TABLE_NAME}' table...")
df.to_sql(
    name=TABLE_NAME,
    con=engine,
    if_exists="replace",  
    index=False,         
    dtype=dtype_mapping, 
    chunksize=10000      
)

print("Data imported. Reindexing and applying primary keys...")
with engine.begin() as conn:
    conn.execute(text(f"ALTER TABLE {TABLE_NAME} ADD PRIMARY KEY (ip_range_start, ip_range_end);"))
    conn.execute(text(f"ALTER TABLE {TABLE_NAME} ADD INDEX idx_ip_lookup (ip_range_start, ip_range_end);"))

print("Update routine completely finished successfully!")