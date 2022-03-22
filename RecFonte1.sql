------------------------------------------------------
--Guarda a linha do nome do objeto, para colocar owner
------------------------------------------------------
col v_linha new_value v_linha noprint
select 
	line v_linha 
from
	dba_source
where
	NAME = '&obj' AND
	TYPE = 	decode(
		'&typ',
		'PRC','PROCEDURE',
		'FUN','FUNCTION',
		'PKS','PACKAGE',
		'PKG','PACKAGE',
		'PKB','PACKAGE BODY') AND
	OWNER LIKE '&own%' AND 
	UPPER(TEXT) LIKE UPPER('%'||name||'%') AND ROWNUM=1
/

------------------------------------------------------
--Extrai fonte da DBA_SOURCE
------------------------------------------------------
col dummy noprint 
select
	0 dummy, 'CREATE OR REPLACE' 
from
	dual
where
	'&typ' in ('PRC','FUN','PKS','PKG','PKB')
UNION
select
	line dummy, decode(line, to_number('&v_linha'), replace(upper(TEXT), name, owner||'.'||name ), TEXT)
from
	dba_source
where
	NAME = '&obj' AND
	TYPE = 	decode(
		'&typ',
		'PRC','PROCEDURE',
		'FUN','FUNCTION',
		'PKS','PACKAGE',
		'PKG','PACKAGE',
		'PKB','PACKAGE BODY') AND
	OWNER = '&own'
order by
	1
/

------------------------------------------------------
--Extrai fonte de trigger
------------------------------------------------------
col trigger_body format a500
--col trigger_body clear

select
	'CREATE OR REPLACE TRIGGER ' || chr(10) || upper(description), trigger_body
from
	dba_triggers
where
	trigger_name = '&obj' AND OWNER = '&own'
	and '&typ' = 'TRG'
;

------------------------------------------------------
--Extrai fonte de view
------------------------------------------------------
col text for a500 word_wrap
select
	decode(column_id, 1,
		'CREATE OR REPLACE VIEW ' || owner || '.' || table_name || ' (' || column_name,
		',' || column_name )
from
	dba_tab_columns
where
	table_name = '&obj' AND OWNER = '&own' AND '&typ' = 'VIE'
order by
	column_id
;

select
	') AS', text 
from
	dba_views v
where
	view_name = '&obj' AND OWNER = '&own' AND '&typ' = 'VIE'
;

------------------------------------------------------
--Finaliza com /
------------------------------------------------------
select '/' from dual where '&typori' = 'PKG' or '&typ' is not null;
prompt

