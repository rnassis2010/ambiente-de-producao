set feedback off
set heading on
set verify off
set timing off
set linesize 500

accept wUSER_CONCURRENT_PROGRAM_NAME prompt "Nome Concurrent           = "
accept wCONCURRENT_PROGRAM_NAME      prompt "Nome Concurrent abreviado = "
accept wUSER_EXECUTABLE_NAME         prompt "Nome Executável           = "
accept wEXECUTABLE_NAME              prompt "Nome Executável abreviado = "

column USER_CONCURRENT_PROGRAM_NAME format a70
column SHORT_NAME                   format a10
column APPLICATION_ID        new_value APPL_ID
column CONCURRENT_PROGRAM_ID new_value PROGRAM_ID

--alter session set nls_language="BRAZILIAN PORTUGUESE";

select a.USER_CONCURRENT_PROGRAM_NAME
,      a.CONCURRENT_PROGRAM_NAME
,      c.application_short_name short_name
,      b.EXECUTABLE_NAME
,      decode(b.EXECUTION_METHOD_CODE,'Q','SQL','I','PL/SQL','P','REPORT',b.EXECUTION_METHOD_CODE) METHOD
,      b.EXECUTION_FILE_NAME
,      a.APPLICATION_ID
,      a.CONCURRENT_PROGRAM_ID
from   apps.FND_APPLICATION            c
,      apps.FND_EXECUTABLES_FORM_V     b
,      apps.FND_CONCURRENT_PROGRAMS_VL a
where  (
         a.USER_CONCURRENT_PROGRAM_NAME like '&wUSER_CONCURRENT_PROGRAM_NAME' or
         a.CONCURRENT_PROGRAM_NAME      like '&wCONCURRENT_PROGRAM_NAME'      or
         b.USER_EXECUTABLE_NAME         like '&wUSER_EXECUTABLE_NAME'         or
         b.EXECUTABLE_NAME              like '&wEXECUTABLE_NAME'
       )
and    a.executable_application_id = b.application_id
and    a.executable_id             = b.executable_id
and    a.enabled_flag              = 'Y'
and    a.application_id            = c.application_id
/

set heading off


--select '================================================='||chr(10)||
--       'GRUPO DE SOLICITACOES = '||b.request_group_name   ||chr(10)||
--       '================================================='

prompt
prompt ========================
prompt GRUPO(S) DE SOLICITACOES
prompt ========================
select b.request_group_name||' ('||trim(c.description)||')' || ' - REQUEST CODE = '||b.request_group_code||' SHORT APPL = '||c.application_short_name
from   apps.FND_APPLICATION_VL         c
,      apps.FND_REQUEST_GROUPS         b
,      apps.FND_REQUEST_GROUP_UNITS    a
where  a.unit_application_id = &appl_id
and    a.request_unit_id     = &program_id
and    a.application_id      = b.application_id
and    a.request_group_id    = b.request_group_id
and    a.application_id      = c.application_id
/

prompt

set feedback on
set verify on
set heading on

