set feedback off
set verify off
set pagesize 300
set linesize 200

column tabela format a40
column indice format a40
column unico  format a5
column coluna format a30
column ordem  format a3

break on tabela on indice on unico on last_analyzed on tablespace on status skip 1

Accept wOwner  prompt "Owner         : "
Accept wTabela prompt "Nome da tabela: "
Accept wIndice prompt "Nome do Índice: "

select a.table_name                             TABELA
,      a.owner||'.'||a.index_name               INDICE
,      decode(a.uniqueness,'UNIQUE','YES','NO') UNICO
,      a.last_analyzed                          LAST_ANALYZED
,      a.tablespace_name                        TABLESPACE
,      a.status                                 STATUS
,      b.column_name                            COLUNA
,      b.descend                                ORDEM
from   dba_ind_columns b
,      dba_indexes     a
where  ( a.owner      = upper('&wOwner')  or '&wOwner'  is null )
and    ( a.table_name = upper('&wTabela') or '&wTabela' is null )
and    ( a.index_name = upper('&wIndice') or '&wIndice' is null )
and    a.owner      = b.index_owner
and    a.index_name = b.index_name
order  by 1,2,b.column_position
/
undefine wOwner
undefine wTabela
undefine wIndice

set feedback on
set verify on

