#!/data/data/com.termux/files/usr/bin/bash

for file in $(find . -type f -name "*.dart"); do
  awk '
    BEGIN { skip = 0 }
    /<< *'\''?EOF'\''?/ { skip = 1; next }
    /'\''?EOF'\''?/ && skip == 1 { skip = 0; next }
    skip == 0 { print }
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done
