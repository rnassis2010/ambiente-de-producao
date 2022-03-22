set pagesize 1000
set linesize 200
select * from table(dbms_xplan.display)
/

