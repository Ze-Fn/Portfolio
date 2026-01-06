import pdfplumber
import re

PDF_PATH = "HasilCPNS2024KemendikbudLampiran1.pdf"          # <-- change this
OUTPUT_TXT = "extracted_raw.txt"

# =========================
# Regex patterns (explicit)
# =========================

META_PATTERNS = {
    "instansi": re.compile(r"Instansi\s*:\s*(.+)"),
    "jabatan": re.compile(r"Jabatan Formasi\s*:\s*(.+)"),
    "lokasi": re.compile(r"Lokasi Formasi\s*:\s*(.+)"),
    "jenis": re.compile(r"Jenis Formasi\s*:\s*(.+)"),
    "pendidikan": re.compile(r"Pendidikan\s+(.+)")
}

PARTICIPANT_START = re.compile(r"^\d+\s+\d{10,}")
FOOTER_DETECTOR = re.compile(r"Laporan digenerate secara otomatis", re.IGNORECASE)
TABLE_HEADER_DETECTOR = re.compile(r"\(1\)\s*\(2\)\s*\(3\)\s*\(4\)\s*\(5\)")
PAGE_HEADER_STOP = re.compile(r"Halaman\s+\d+\s+dari\s+\d+", re.IGNORECASE)

MONTHS = (
    "Januari|Februari|Maret|April|Mei|Juni|Juli|"
    "Agustus|September|Oktober|November|Desember"
)

DATE_PART = re.compile(rf"\d{{1,2}}\s+({MONTHS})")
YEAR_PART = re.compile(r"\b(19|20)\d{2}\b")

# =========================
# Helpers
# =========================

def extract_metadata(lines):
    meta = {}
    for line in lines:
        for key, pattern in META_PATTERNS.items():
            if key not in meta:
                m = pattern.search(line)
                if m:
                    meta[key] = m.group(1).strip()
    return meta


def reconstruct_birthdate(buffer):
    date_match = DATE_PART.search(buffer)
    year_match = YEAR_PART.search(buffer)

    if date_match and year_match:
        return f"{date_match.group(0)} {year_match.group(0)}"
    return None


# =========================
# Main extraction logic
# =========================

def extract_raw_records(pdf_path):
    records = []
    current_meta = {}
    capturing_table = False
    current_record = None

    with pdfplumber.open(pdf_path) as pdf:
        total_pages = len(pdf.pages)

        for page_idx, page in enumerate(pdf.pages, start=1):
            print(f"[PAGE {page_idx}/{total_pages}] Processing...")

            text = page.extract_text()
            if not text:
                continue

            lines = [l.strip() for l in text.split("\n") if l.strip()]

            # -------------------------
            # Metadata capture window
            # -------------------------
            meta_lines = []
            in_meta = False

            for line in lines:
                if "Kode Jumlah" in line:
                    in_meta = True
                elif PAGE_HEADER_STOP.search(line):
                    in_meta = False

                if in_meta:
                    meta_lines.append(line)

            page_meta = extract_metadata(meta_lines)
            if page_meta:
                current_meta = page_meta

            # -------------------------
            # Participant table logic
            # -------------------------
            for line in lines:

                if FOOTER_DETECTOR.search(line):
                    if current_record:
                        records.append(current_record)
                        current_record = None
                    capturing_table = False
                    continue

                if TABLE_HEADER_DETECTOR.search(line):
                    capturing_table = True
                    continue

                if not capturing_table:
                    continue

                if PARTICIPANT_START.match(line):
                    if current_record:
                        records.append(current_record)

                    current_record = {
                        "meta": current_meta.copy(),
                        "raw_lines": [line]
                    }
                else:
                    if current_record:
                        current_record["raw_lines"].append(line)

        if current_record:
            records.append(current_record)

    return records


# =========================
# Write TXT output
# =========================

def write_txt(records, output_path):
    if not records:
        print("[ERROR] No data extracted. Exiting.")
        return

    with open(output_path, "w", encoding="utf-8") as f:
        for i, rec in enumerate(records, start=1):
            meta = rec["meta"]
            raw = " ".join(rec["raw_lines"])

            birthdate = reconstruct_birthdate(raw)

            f.write("=== PARTICIPANT RECORD ===\n")
            f.write(f"Record #: {i}\n")

            for k in ["instansi", "jabatan", "lokasi", "jenis", "pendidikan"]:
                if k in meta:
                    f.write(f"{k.upper()}: {meta[k]}\n")

            if birthdate:
                f.write(f"RECONSTRUCTED_BIRTHDATE: {birthdate}\n")

            f.write("\nRAW_TEXT:\n")
            f.write(raw + "\n")
            f.write("=" * 40 + "\n\n")

    print(f"[DONE] Extracted {len(records)} records → {output_path}")


# =========================
# Entry point
# =========================

if __name__ == "__main__":
    print("[START] Rule-based raw extraction")
    records = extract_raw_records(PDF_PATH)
    write_txt(records, OUTPUT_TXT)
