import pdfplumber
import pandas as pd

tables = []
with pdfplumber.open("foo.pdf") as pdf:
    for page in pdf.pages:
        tables_on_page = page.extract_tables({})

        if tables_on_page:
            for table in tables_on_page:
                if table:
                    tables.append({
                        'page' : pdf.pages.index(page) + 1,
                        'data' : table
                    })

for table in tables:
    print('Page:', table['page'])
    print(pd.DataFrame(table['data']))