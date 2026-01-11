import re

def process_formation_file(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        # Load lines and strip trailing newlines
        lines = [line.rstrip() for line in f.readlines()]

    # Regex patterns for wildcards
    loc_pattern = re.compile(r"Lokasi Formasi.*")
    type_pattern = re.compile(r"Jenis Formasi.*")

    indices_to_delete = set()

    for i in range(len(lines)):
        # 1. Identify "Jenis Formasi*" for deletion regardless of location
        if type_pattern.search(lines[i]):
            indices_to_delete.add(i)
            continue # Move to next line

        # 2. Locate "Lokasi Formasi*"
        if loc_pattern.search(lines[i]):
            # Check if line below does NOT contain "Jenis Formasi*"
            next_exists = i + 1 < len(lines)
            is_jenis_below = next_exists and type_pattern.search(lines[i+1])

            if not is_jenis_below:
                # Identify the "source" lines
                prev_idx = i - 1
                next_idx = i + 1
                
                prefix = ""
                suffix = ""

                # Move data from Line Before (i-1)
                if prev_idx >= 0:
                    prefix = lines[prev_idx]
                    indices_to_delete.add(prev_idx)
                
                # Move data from Line After (i+1)
                if next_exists:
                    suffix = lines[next_idx]
                    indices_to_delete.add(next_idx)
                
                # 3. Concatenate to the right most of Lokasi Formasi line
                lines[i] = f"{lines[i]} {prefix} {suffix}"

    # 4. Final Cleanup: Create list excluding all indices marked for deletion
    final_output = [lines[i] for i in range(len(lines)) if i not in indices_to_delete]

    # Save to the new text file
    with open(output_file, 'w', encoding='utf-8') as f:
        for line in final_output:
            f.write(line + '\n')

# Execute the process
process_formation_file('extracted_loc_details.csv', 'fixed_loc_details.csv')