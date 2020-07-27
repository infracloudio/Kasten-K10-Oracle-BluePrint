#!/bin/bash
salary=10000
while true; do
cp base.sql sample.sql
i=$(date +%s)
echo "Current timestamp in epoch: $i"
echo "Current timestamp: $(date)"
echo "Current Salary: $salary"
sed -i -- "s/NUMBER/$i/g" sample.sql
sed -i -- "s/Date/$(date)/g" sample.sql
sed -i -- "s/Salary/$salary/g" sample.sql
sqlplus sys/Kube#2020@192.168.99.100:30491/PSTG.localdomain as sysdba @sample.sql
sleep 1;
salary=$(($salary+1000))
done

