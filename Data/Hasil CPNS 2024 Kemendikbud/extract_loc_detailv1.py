import re

def process_reordered_text(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]

    extracted_blocks = []
    
    # First, find all indices where "Lokasi Formasi" appears
    lokasi_indices = [i for i, s in enumerate(lines) if "Lokasi Formasi" in s]

    for idx, current_line_idx in enumerate(lokasi_indices):
        # 1. Get current "Lokasi Formasi" line
        lokasi_line = lines[current_line_idx]

        # 2. Get the line immediately AFTER current "Lokasi Formasi"
        # (This is usually the Fakultas/Program Studi line)
        after_line = ""
        if current_line_idx + 1 < len(lines):
            after_line = lines[current_line_idx + 1]

        # 3. Look for "KEMENTERIAN" nearby (usually right before Lokasi Formasi)
        kementerian_line = ""
        # Look back up to 5 lines to find the Ministry name
        search_start = max(0, current_line_idx - 5)
        for i in range(current_line_idx - 1, search_start - 1, -1):
            if "KEMENTERIAN" in lines[i]:
                kementerian_line = lines[i]
                break

        # 4. Look for the Page Number line (containing 16071)
        page_line = ""
        for i in range(current_line_idx - 1, search_start - 1, -1):
            if "16071" in lines[i]:
                page_line = lines[i]
                break

        # Combine them into the requested single-line format
        # Pattern: [Page] [Lokasi Formasi] [KEMENTERIAN] [Fakultas/Prodi]
        combined = f"{page_line} {lokasi_line} {kementerian_line} {after_line}".strip()
        # Clean up double spaces
        combined = " ".join(combined.split())
        extracted_blocks.append(combined)

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("\n".join(extracted_blocks))

if __name__ == "__main__":
    process_reordered_text('extracted_text_omit_newlines.csv', 'extracted_loc_details1.csv')
    print("Processing complete. Check output.txt")