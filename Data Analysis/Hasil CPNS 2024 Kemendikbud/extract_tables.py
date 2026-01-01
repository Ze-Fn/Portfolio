import tabula

pdf_path = "HasilCPNS2024KemendikbudLampiran1.pdf"

dfs = tabula.read_pdf(pdf_path, pages='all')

for i in range(len(dfs)):
    dfs[i].to_csv(f"all_pages_table[i].csv")