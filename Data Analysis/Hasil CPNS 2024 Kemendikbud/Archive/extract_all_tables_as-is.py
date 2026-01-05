import pdfplumber
import pandas as pd

file_path = "HasilCPNS2024KemendikbudLampiran1.pdf"
output_csv = "extracted_tables_as-is.csv"

all_tables = []

with pdfplumber.open(file_path) as pdf:
    for page_number, page in enumerate(pdf.pages, start=1):
        print(f"Processing page {page_number}...")

        # Extract ALL tables as-is
        tables = page.extract_tables()

        # Even if no tables are found, continue (no omission logic)
        for table_number, table in enumerate(tables, start=1):

            # Convert table directly to DataFrame
            df = pd.DataFrame(table)

            # Force positional columns (no header inference)
            df.columns = range(df.shape[1])

            # Preserve provenance
            df["__page__"] = page_number
            df["__table__"] = table_number

            all_tables.append(df)

# Concatenate ALL tables into ONE dataframe
if not all_tables:
    raise RuntimeError("No tables were extracted from the PDF.")

final_df = pd.concat(all_tables, ignore_index=True)

# Export exactly as extracted
final_df.to_csv(output_csv, index=False, encoding="utf-8")

print(f"Extraction complete. Saved to '{output_csv}'.")
print("Final shape:", final_df.shape)
