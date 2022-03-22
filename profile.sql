set pagesize 1000
set linesize 4000
set verify off

COLUMN profile_option_name      FORMAT a20
COLUMN user_profile_option_name FORMAT a35
COLUMN created_by               FORMAT a20
COLUMN last_updated_by          FORMAT a15
COLUMN context                  FORMAT a30
COLUMN value                    FORMAT a25
COLUMN level                    FORMAT a15
COLUMN description              FORMAT a55

ACCEPT vProfileName  prompt "Profile Name      : "
ACCEPT vUserProfName prompt "User Profile Name : "
ACCEPT vLanguage     prompt "Language (PTB/US) : " default "PTB"

select fpo.profile_option_name
,      fpot.user_profile_option_name
,      decode(to_char(fpov.level_id),'10001', 'SITE', 
                                     '10002', 'APP', 
                                     '10003', 'RESP', 
                                     '10005', 'SERVER', 
                                     '10006', 'ORG', 
                                     '10004', 'USER',
                                     '10007', 'SERVER+RESP', to_char(fpov.level_id)) "LEVEL"
,      decode(to_char(fpov.level_id),'10001', '', 
                                     '10002', fa.application_short_name, 
                                     '10003', fr.responsibility_key, 
                                     '10005', fn.node_name, 
                                     '10006', hou.name, 
                                     '10004', fu3.user_name, 
                                     '10007', fn.node_name||'+'||fr.responsibility_key,
                                     to_char(fpov.level_id)) "CONTEXT"
,      nvl(frv.responsibility_name,fu3.description) description
,      fpov.profile_option_value            "VALUE"
--,      '*' x
--,      fpov.*
--,      '*' y
--,      fu.user_name  created_by
--,      fu2.user_name last_updated_by
--,      fpov.creation_date
--,      fpov.last_update_date
from   apps.fnd_profile_options       fpo
,      apps.fnd_profile_options_tl    fpot
,      apps.fnd_profile_option_values fpov
,      apps.fnd_user                  fu
,      apps.fnd_user                  fu2
,      apps.fnd_user                  fu3
,      apps.fnd_application           fa
,      apps.fnd_responsibility        fr
,      apps.fnd_responsibility_vl     frv
,      apps.fnd_nodes                 fn
,      apps.hr_operating_units        hou
where  ( fpo.profile_option_name       like UPPER('&vProfileName%') or '&vProfileName'  IS NULL )
and    ( fpot.user_profile_option_name like '&vUserProfName%'       or '&vUserProfName' IS NULL )
and    fpo.profile_option_name   = fpot.profile_option_name
and    fpot.language             = UPPER('&vLanguage')
and    fpo.application_id        = fpov.application_id
and    fpo.profile_option_id     = fpov.profile_option_id
and    fu.user_id                = fpov.created_by
and    fu2.user_id               = fpov.last_updated_by
and    fu3.user_id           (+) = fpov.level_value
and    fa.application_id     (+) = fpov.level_value_application_id
and    fr.responsibility_id  (+) = fpov.level_value
and    fa.application_id     (+) = fpov.level_value
and    fn.node_id            (+) = fpov.level_value
and    hou.organization_id   (+) = fpov.level_value
and    frv.application_id    (+) = fr.application_id
and    frv.responsibility_id (+) = fr.responsibility_id
order  by 3
/
undefine vProfileName
undefine vUserProfName
undefine vLanguage

