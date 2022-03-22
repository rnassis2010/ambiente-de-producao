clear screen
set linesize 80
column name format a30

accept patch prompt "Numero do Patch: "

select patch.name
,      TO_CHAR(patch.created, 'DD/MM/YYYY HH24:MI:SS') CREATED
,      patch.tipo
from   (
         SELECT patch_name     NAME
         ,      creation_date  CREATED
         ,      'PATCH'        TIPO
         FROM   apps.ad_applied_patches
         WHERE  patch_name LIKE UPPER('&patch%')
         UNION ALL
         SELECT bug_number    NAME
         ,      creation_date CREATED
         ,      'BUG'         TIPO
         FROM   apps.ad_bugs
         WHERE  bug_number LIKE UPPER('%&patch%')
         ORDER  BY 2
       ) patch
--where  patch.created >= trunc(sysdate,'YYYY')
/

undefine patch

