import pdfplumber

PDF_PATH = "HasilCPNS2024KemendikbudLampiran1.pdf"   # <-- adjust if needed
OUTPUT_TXT = "FULL_RAW_PDF_TEXT.txt"


def extract_full_raw_text(pdf_path, output_txt):
    print("[START] Extracting full raw text from PDF")

    with pdfplumber.open(pdf_path) as pdf, \
         open(output_txt, "w", encoding="utf-8") as out:

        total_pages = len(pdf.pages)
        print(f"[INFO] Total pages detected: {total_pages}")

        for idx, page in enumerate(pdf.pages, start=1):
            print(f"[PAGE {idx}/{total_pages}] Extracting text...")

            text = page.extract_text()

            out.write("\n")
            out.write("=" * 80 + "\n")
            out.write(f"PAGE {idx} / {total_pages}\n")
            out.write("=" * 80 + "\n\n")

            if text:
                out.write(text)
                out.write("\n")
            else:
                out.write("[NO TEXT DETECTED ON THIS PAGE]\n")

    print(f"[DONE] Full raw text written to: {output_txt}")


if __name__ == "__main__":
    extract_full_raw_text(PDF_PATH, OUTPUT_TXT)
