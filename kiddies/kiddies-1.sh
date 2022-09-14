# Text manipulation with awk

ENV="PREP"
URL="https://prep.mywebsite.com/health"

awk -v e=$ENV -v u=$URL '{gsub(/##ENV##/,e,$0);gsub(/##URL##/,u,$0);print}' ./template.txt
