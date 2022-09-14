# Text manipulation with awk

ENV="PREP"
URL="https://prep.mywebsite.com/health"

sed -e "s?##ENV##?$ENV?g" -e "s?##URL##?$URL?g" ./template.txt
