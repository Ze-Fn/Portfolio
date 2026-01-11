BEGIN { capture_next = 0 }

# 1. Line starting with "KEMENTERIAN"
$0 ~ /^ *KEMENTERIAN/ {
    print
}

# 2. "Lokasi Formasi" line
$0 ~ /^ *Lokasi Formasi *:/ {
    print
    capture_next = 1
    next
}

# 3. Line immediately after "Lokasi Formasi"
capture_next {
    print
    capture_next = 0
}

# 4. Page counter line containing "/ 16071"
/---[[:space:]]*[Pp]age[[:space:]]+[0-9]+[[:space:]]*---/ {
    match($0, /[0-9]+/, m)
    page = m[0]
}

