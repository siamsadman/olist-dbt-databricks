import csv
from pathlib import Path

SOURCE = Path(r"L:\Python_Env\Portfolio03\raw_data\olist_orders_dataset.csv")
OUT_DIR = Path(r"L:\Python_Env\Olist_dbt\lakeflow_batches")
CUTOFF = "2018-01-01"

OUT_DIR.mkdir(exist_ok=True)

with SOURCE.open(newline="", encoding="utf-8") as src, \
     (OUT_DIR / "orders_batch_1.csv").open("w", newline="", encoding="utf-8") as out1, \
     (OUT_DIR / "orders_batch_2.csv").open("w", newline="", encoding="utf-8") as out2:

    reader = csv.reader(src)
    writer1 = csv.writer(out1)
    writer2 = csv.writer(out2)

    header = next(reader)
    writer1.writerow(header)
    writer2.writerow(header)
    ts_index = header.index("order_purchase_timestamp")

    count1 = count2 = 0
    for row in reader:
        if row[ts_index] < CUTOFF:
            writer1.writerow(row)
            count1 += 1
        else:
            writer2.writerow(row)
            count2 += 1

print(f"batch 1 (before {CUTOFF}): {count1} rows")
print(f"batch 2 (from {CUTOFF}): {count2} rows")
print(f"total: {count1 + count2} rows")