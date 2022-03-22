set heading off
clear screen

select 'SQL> select global_name from global_name;'|| chr(10) || chr(13) ||
       ' '|| chr(10) || chr(13) ||
       ' GLOBAL_NAME ' || chr(10) || chr(13) ||
       '-------------------------------------------------------------------------------' || chr(10) || chr(13) ||
       global_name || chr(10) || chr(13) ||
       'SQL>' || chr(10) || chr(13) ||
       ' ' || chr(10) || chr(13) ||
       'SQL> show user;' || chr(10) || chr(13) ||
       'USER is "' || user ||'"'
from global_name;

set heading on;

