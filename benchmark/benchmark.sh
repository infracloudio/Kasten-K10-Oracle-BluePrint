source /home/oracle/.bashrc

export PATH=$ORACLE_HOME/jdk/bin:$PATH

# Benchmark Settings
USERS=$1
RUNTIME=$2

echo "---DB SIZE---"
sqlplus -S '/ as sysdba' <<EOF 2>&1 
set heading off pagesize 0
select
( select sum(bytes)/1024/1024/1024 data_size from dba_data_files ) +
( select nvl(sum(bytes),0)/1024/1024/1024 temp_size from dba_temp_files ) +
( select sum(bytes)/1024/1024/1024 redo_size from sys.v_\$log ) +
( select sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024 controlfile_size from v\$controlfile) "Size in GB"
from
dual;
EOF


sqlplus -S '/ as sysdba' <<EOF 2>&1 
exec dbms_workload_repository.create_snapshot;
EOF

./swingbench/bin/charbench -c ../configs/SOE_Server_Side_V2.xml -cs //localhost:1521/PSTGPDB1.localdomain -dt thin -u soe -p soe -uc $USERS -v users,tps,tpm,dml,errs,resp -mr -min 0 -max 100 -ld 1000 -rt $RUNTIME 

sqlplus -S '/ as sysdba' <<EOF 2>&1 
exec dbms_workload_repository.create_snapshot;
EOF


