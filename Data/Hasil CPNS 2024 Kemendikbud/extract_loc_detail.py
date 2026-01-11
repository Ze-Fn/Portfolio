import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, encoding="utf-8") as f:
    lines = f.readlines()

out = []
i = 0

while i < len(lines):
    line = lines[i].strip()

    # 1. KEMENTERIAN line
    if line.startswith("KEMENTERIAN"):
        out.append(line)

    # 2. Lokasi Formasi + next line
    elif line.startswith("Lokasi Formasi"):
        out.append(line)
        if i + 1 < len(lines):
            out.append(lines[i + 1].strip())

    # 3. Page count line
    elif line.endswith("/ 16071"):
        out.append(line)

    i += 1

with open(output_file, "w", encoding="utf-8") as f:
    f.write("\n".join(out))
