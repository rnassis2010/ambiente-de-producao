set lines 200
column owner format a20
column db_link format a40
column username format a30
column host format a30
select owner,db_link,username,host from dba_db_links
/

