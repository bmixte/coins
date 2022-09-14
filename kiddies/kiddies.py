import fileinput

with open('template.txt', 'r') as file:
    for line in file:
        nl = line.replace( "##ENV##", "PREP" )
        nl = nl.replace( "##URL##", "prep.mywebsite.com/health" )
        print (nl)
    file.close()
