accept vSid      prompt "SID        : "
accept vSerial   prompt "SERIAL     : "
accept vSqlTrace prompt "True/False : "
execute sys.dbms_system.set_sql_trace_in_session(&vSid,&vSerial,&vSqlTrace)
