import csv

input_file = 'extracted_loc_details1.csv'
output_file = 'add_nulls_extd_loc_details1.csv'

with open(input_file, 'r', newline='') as f:
    reader = list(csv.reader(f))
    
    # 1. Determine the number of columns (based on the first row/header)
    # If the header itself might be missing values, use: max(len(row) for row in reader)
    num_columns = len(reader[0])

# 2. Write the fixed data to a new file
with open(output_file, 'w', newline='') as f:
    writer = csv.writer(f)
    
    for row in reader:
        # Calculate how many "Null" values are needed
        padding_needed = num_columns - len(row)
        
        if padding_needed > 0:
            row.extend(["Null"] * padding_needed)
        
        # In case a row is somehow longer than the header, 
        # this ensures we only keep the expected number of columns
        writer.writerow(row[:num_columns])

print(f"File processed. Fixed version saved as {output_file}")