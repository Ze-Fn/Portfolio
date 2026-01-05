import camelot

lattice_table = camelot.read_pdf("HasilCPNS2024KemendikbudLampiran1.pdf", pages='all', flavor='lattice', suppress_stdout=False)
stream_table = camelot.read_pdf("HasilCPNS2024KemendikbudLampiran1.pdf", pages='all', flavor='stream', suppress_stdout=False)

for table in lattice_table:
    print('Lattice Table')
    print(table.df)

for table in stream_table:
    print('Stream Table')
    print(table.df)