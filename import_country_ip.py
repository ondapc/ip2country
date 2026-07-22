import os
import urllib.request
import pandas as pd
from sqlalchemy import create_engine, types, text
import db_config as cfg

# 1. Update/Download Configuration (Point to the GZIP URL)
URL_PATH = "https://github.com/sapics/ip-location-db/releases/download/latest/geolite2-country-ipv4-num.csv"
FILE_PATH = "csv/geolite2-country-ipv4-num.csv"

# 2. Database connection parameters
TABLE_NAME = "country"

# =========================================================
# STEP 1: Download, Natively Decompress, and Save the File
# =========================================================
print(f"Downloading latest dataset from {URL_PATH}...")
try:
    # urlretrieve pulls the file directly from the web and overwrites/saves it to FILE_PATH
    urllib.request.urlretrieve(URL_PATH, FILE_PATH)
    print(f"File successfully saved locally to: {FILE_PATH}")
except Exception as e:
    print(f"Error downloading file: {e}")
    # Optional: exit script if the download fails
    raise

column_names = [
    "ip_range_start", "ip_range_end", "country_code"
]

try:
    # Pandas handles the web request and the gzip decompression automatically under the hood
    df = pd.read_csv(
        FILE_PATH, 
        compression="infer", 
        header=None, 
        names=column_names, 
        keep_default_na=True
    )
    
    # Save the clean, decompressed data to your specific local text file
    df.to_csv(FILE_PATH, header=False, index=False)
    print(f"Successfully downloaded and saved locally to: {FILE_PATH}")
    
except Exception as e:
    print(f"Error handling the file: {e}")
    raise

# =========================================================
# STEP 2: Import to MySQL (Your optimized code)
# =========================================================
engine = create_engine(f"mysql+pymysql://{cfg.DB_USER}:{cfg.DB_PASS}@{cfg.DB_HOST}:{cfg.DB_PORT}/{cfg.DB_NAME}")

dtype_mapping = {
    "ip_range_start": types.BigInteger(),
    "ip_range_end": types.BigInteger(),
    "country_code": types.CHAR(length=2)
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