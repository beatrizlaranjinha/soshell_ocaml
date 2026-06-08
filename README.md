cat < origem.txt | wc -l
cat origem.txt | wc -l > total.txt
cat total.txt
cat < origem.txt | grep linha | wc -l > total_filtrado.txt
cat total_filtrado.txt
Pipeline em background
cat origem.txt | wc -l &

O prompt deve reaparecer imediatamente.
