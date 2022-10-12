#!/bin/bash
#Step1:download the file and name it data1.csv
curl https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::recent-large-fire-perimeters-5000-acres.csv > data1.csv

#Step2:Print out the range of years:
#cut the second field and discover the wired number, so repair it firstly. Then cut the second field and sort this field 
sed -e 's/\r//g' data1.csv | sed 'N;s/\n"//;P;D' | sed "s/\".*\"//" >data2.csv
    cut -d, -f2 data2.csv | sort |uniq > data2_1.csv
    echo "The range of years is" $(awk 'NR==1' data2_1.csv) "to" $(awk 'NR==5' data2_1.csv)"." 


#Step3:Print out the number of fires in the database
awk '{if(NR > 1) {print $0}}' data2.csv > data3.csv 
echo "The number of fires is" $(cat data3.csv|wc -l)"."

#Step4: Print out the number of fires that occur each year
cut -d, -f2 data3.csv | sort |uniq -c > count.csv  
echo "The number of fires that occur from 2017 to 2021 is"$(awk '{print $1}' count.csv)"respectively."

#Step5:Print out the name largest fire
cut -d,  -f6,13 data3.csv >name.csv
sort -t, -k2 -n name.csv >name1.csv
echo "The name of the largest fire is" $(awk 'NR==134' name1.csv)"."

#Step6:Print out the total acreage burned in each year
cut -d,  -f2,13 data3.csv >acreage.csv 
echo "The total acreage burned in each year are "$(awk '{if(NR > 1) {print $0}}' acreage.csv | awk -F'[,]' '{a[$1]+=$2}END{for(i in a) print i","a[i]}') "acres."




