----------------------------------------------------------------
--Este script recupera os fontes dos seguintes tipos de objetos:
--PROCEDURE, FUNCTION, PACKAGE, PACKAGE BODY, VIEW, TRIGGER
----------------------------------------------------------------

SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SET TRIMSPOOL ON
set trimout on
SET LONG 1000000
set pages 0
set linesize 2000

set timing off

define SPOOLPATH="/tmp"

--------------------------------------------------------
--Recebe os parametros
--------------------------------------------------------
ACCEPT own PROMPT 'OWNER...............................: '
ACCEPT obj PROMPT 'OBJETO..............................: '
ACCEPT typ PROMPT 'TIPO (PRC,FUN,PKG,PKS,PKB,TRG,VIE)..: '
ACCEPT pth PROMPT 'Caminho do spool [&SPOOLPATH].......: '
prompt

------------------------------------------------------
--Prepara execuç do RecFonte1.sql
------------------------------------------------------
set termout off
col typ new_value typ
col typ2 new_value typ2
col obj new_value obj
col own new_value own

select
	upper(trim('&obj')) obj,
	upper(trim('&own')) own,
	case when upper('&typ') in ('VIW','VIEW') then 'VIE' else upper('&typ') end typ,
	decode(upper('&typ'),'PKG','PKB','""') typ2
from dual;
define typori=&typ

set termout on

------------------------------------------------------
--Prepara spool
------------------------------------------------------
SPOOL &SPOOLPATH/&obj..&typori

------------------------------------------------------
--Executa RecFonte1.sql (recupera o fonte)
------------------------------------------------------
define typ=&typori
@@RecFonte1
define typ=&typ2
@@RecFonte1

------------------------------------------------------
--Finaliza
------------------------------------------------------
SPOOL OFF
prompt Gerado spool em &SPOOLPATH/&obj..&typori
prompt

set feedback on

