set pagesize 1000
set linesize 1000
set trimspool on
column owner format a30
column directory_name format a30
column directory_path format a80
accept DirName prompt "Nome do Diretorio: "
accept DirPath prompt "Caminho do Diretorio: "
select *
from   dba_directories
where  ( 
         ( '&DirName' is null or directory_name like upper('%&DirName%') ) and
         ( '&DirPath' is null or directory_path like upper('%&DirPath%') )
       )
order  by 1,2;
