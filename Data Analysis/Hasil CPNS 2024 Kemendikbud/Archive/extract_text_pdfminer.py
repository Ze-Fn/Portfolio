from pdfminer.high_level import extract_pages
from pdfminer.layout import LTTextContainer
from tqdm import tqdm
import csv
import re

PDF_PATH = "HasilCPNS2024KemendikbudLampiran1.pdf"
OUTPUT_CSV = "lokasi_formasi_extracted.csv"

START_PATTERN = re.compile(r"Lokasi Formasi\s*:")
STOP_PATTERN = re.compile(
    r"(Jenis Formasi\s*:|Pendidikan\s|Jabatan Formasi\s*:)",
    re.IGNORECASE
)

results = []

# tqdm wraps the page iterator
for page_number, page_layout in tqdm(
    enumerate(extract_pages(PDF_PATH), start=1),
    desc="Processing PDF pages",
    unit="page"
):
    page_text_blocks = []

    for element in page_layout:
        if isinstance(element, LTTextContainer):
            text = element.get_text().replace("\n", " ").strip()
            if text:
                page_text_blocks.append(text)

    page_text = " ".join(page_text_blocks)
    page_text = re.sub(r"\s+", " ", page_text)

    pos = 0
    while True:
        start_match = START_PATTERN.search(page_text, pos)
        if not start_match:
            break

        start_idx = start_match.start()

        stop_match = STOP_PATTERN.search(page_text, start_idx + 1)
        end_idx = stop_match.start() if stop_match else len(page_text)

        lokasi_formasi = page_text[start_idx:end_idx].strip()

        results.append({
            "page_number": page_number,
            "lokasi_formasi_raw": lokasi_formasi
        })

        pos = end_idx

# Write CSV
with open(OUTPUT_CSV, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(
        f,
        fieldnames=["page_number", "lokasi_formasi_raw"]
    )
    writer.writeheader()
    writer.writerows(results)

print(f"\nExtraction complete.")
print(f"Pages processed : {page_number}")
print(f"Rows extracted  : {len(results)}")
print(f"Output file     : {OUTPUT_CSV}")
