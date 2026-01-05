import pdfplumber
import pandas as pd
import re
from datetime import datetime
import sys


# --------------------------------------------------
# Configuration (SAFE TO EDIT)
# --------------------------------------------------

PDF_PATH = "HasilCPNS2024KemendikbudLampiran1.pdf"
OUTPUT_CSV = "cpns_dosen_rule_based.csv"
PROGRESS_EVERY = 1   # show progress every page


# --------------------------------------------------
# Helper utilities
# --------------------------------------------------

def clean(text):
    if not text:
        return ""
    return re.sub(r"\s+", " ", text).strip()


def page_should_be_skipped(text):
    """
    Skip summary/statistical pages
    """
    return (
        "Jumlah Formasi" in text
        and "Jumlah Peserta" in text
    )


# --------------------------------------------------
# Context extraction (Formasi metadata)
# --------------------------------------------------

def extract_context(text):
    context = {
        "jabatan_formasi": None,
        "lokasi_formasi": None,
        "jenis_formasi": None,
        "qual_edu": None,
    }

    for line in text.split("\n"):
        line = clean(line)

        # Jabatan Formasi (DOSEN only)
        if "Jabatan Formasi" in line and "DOSEN" in line:
            context["jabatan_formasi"] = line

        # Lokasi Formasi
        if "PERGURUAN TINGGI NEGERI" in line:
            context["lokasi_formasi"] = line

        # Jenis Formasi (finite set)
        for jenis in [
            "UMUM",
            "LULUSAN TERBAIK",
            "PENYANDANG DISABILITAS",
            "PUTRA/PUTRI PAPUA",
            "PUTRA/PUTRI PAPUA BARAT",
            "PUTRA/PUTRI KALIMANTAN",
        ]:
            if jenis in line:
                context["jenis_formasi"] = jenis

        # Pendidikan Formasi
        edu_match = re.search(r"\(\d{7}\)\s+.+", line)
        if edu_match:
            context["qual_edu"] = edu_match.group()

    return context


# --------------------------------------------------
# Participant row detection
# --------------------------------------------------

def is_participant_header(line):
    return (
        "No Peserta" in line
        and "Nama" in line
    )


def parse_participant_row(line):
    """
    Parse one participant row using positional heuristics
    """
    tokens = [t for t in re.split(r"\s{2,}", line) if t]

    if len(tokens) < 7:
        return None

    if not tokens[0].isdigit():
        return None

    return {
        "no": tokens[0],
        "no_peserta": tokens[1],
        "nama": tokens[2],
        "pendidikan_peserta": tokens[3],
        "tahun_skd": tokens[4],
        "twk": tokens[5],
        "tiu": tokens[6],
        "tkp": tokens[7] if len(tokens) > 7 else None,
        "total_skd": tokens[8] if len(tokens) > 8 else None,
        "keterangan": tokens[9] if len(tokens) > 9 else None,
    }


# --------------------------------------------------
# Core extraction logic
# --------------------------------------------------

def extract_rows(pdf_path):
    rows = []

    with pdfplumber.open(pdf_path) as pdf:
        total_pages = len(pdf.pages)
        print(f"[INFO] Total pages: {total_pages}")

        current_context = {}

        for page_number, page in enumerate(pdf.pages, start=1):

            if page_number % PROGRESS_EVERY == 0:
                print(f"[PROGRESS] Page {page_number}/{total_pages}")

            text = page.extract_text() or ""

            if page_should_be_skipped(text):
                continue

            # Update context when present
            page_context = extract_context(text)
            for k, v in page_context.items():
                if v:
                    current_context[k] = v

            lines = text.split("\n")

            in_participant_section = False

            for line in lines:
                line = clean(line)

                if not line:
                    continue

                # Detect participant header
                if is_participant_header(line):
                    in_participant_section = True
                    continue

                # Exit if new context block appears
                if "Jabatan Formasi" in line and in_participant_section:
                    in_participant_section = False
                    continue

                if not in_participant_section:
                    continue

                parsed = parse_participant_row(line)
                if not parsed:
                    continue

                # Attach context
                parsed.update(current_context)
                parsed["page_number"] = page_number

                rows.append(parsed)

    return rows


# --------------------------------------------------
# Main execution (INTENTIONALLY AT BOTTOM)
# --------------------------------------------------

if __name__ == "__main__":
    print("[START] Rule-based CPNS extraction started")
    start_time = datetime.now()

    data = extract_rows(PDF_PATH)

    if not data:
        print("[ERROR] No data extracted. Exiting.")
        sys.exit(1)

    df = pd.DataFrame(data)
    df.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")

    elapsed = datetime.now() - start_time

    print("[SUCCESS] Extraction completed")
    print(f"[INFO] Rows saved: {len(df)}")
    print(f"[INFO] Output file: {OUTPUT_CSV}")
    print(f"[INFO] Time elapsed: {elapsed}")
