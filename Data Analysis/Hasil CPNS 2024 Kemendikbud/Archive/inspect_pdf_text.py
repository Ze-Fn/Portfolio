import pdfplumber

PDF_PATH = "HasilCPNS2024KemendikbudLampiran1.pdf"

with pdfplumber.open(PDF_PATH) as pdf:
    page = pdf.pages[1]   # try page 0 first
    text = page.extract_text()

    print("===== RAW TEXT START =====")
    print(text)
    print("===== RAW TEXT END =====")
