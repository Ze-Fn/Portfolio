import tabula as tb
import pandas as pd

df = tb.read_pdf("HasilCPNS2024KemendikbudLampiran1.pdf", 
                 pages='all', 
                 multiple_tables=True)
df1 = tb.convert_into("HasilCPNS2024KemendikbudLampiran1.pdf", 
                      "output.csv", 
                      output_format="csv", 
                      pages='all')