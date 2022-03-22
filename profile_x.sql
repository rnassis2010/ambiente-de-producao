set long 10000
 set pagesize 500
 set linesize 160
 column SHORT_NAME format a30
 column NAME format a40
 column LEVEL_SET format a15
 column CONTEXT format a30
 column VALUE format a40
 select p.profile_option_name SHORT_NAME,
 n.user_profile_option_name NAME,
 decode(v.level_id,
 10001, 'Site',
 10002, 'Application',
 10003, 'Responsibility',
 10004, 'User',
 10005, 'Server',
 10006, 'Org',
 10007, decode(to_char(v.level_value2), '-1', 'Responsibility',
 decode(to_char(v.level_value), '-1', 'Server',
 'Server+Resp')),
 'UnDef') LEVEL_SET,
 decode(to_char(v.level_id),
 '10001', '',
 '10002', app.application_short_name,
 '10003', rsp.responsibility_key,
 '10004', usr.user_name,
 '10005', svr.node_name,
 '10006', org.name,
 '10007', decode(to_char(v.level_value2), '-1', rsp.responsibility_key,
 decode(to_char(v.level_value), '-1',
 (select node_name from apps.fnd_nodes
 where node_id = v.level_value2),
 (select node_name from apps.fnd_nodes
 where node_id = v.level_value2)||'-'||rsp.responsibility_key)),
 'UnDef') "CONTEXT",
 v.profile_option_value VALUE
 from apps.fnd_profile_options p,
 apps.fnd_profile_option_values v,
 apps.fnd_profile_options_tl n,
 apps.fnd_user usr,
 apps.fnd_application app,
 apps.fnd_responsibility rsp,
 apps.fnd_nodes svr,
 apps.hr_operating_units org
 where p.profile_option_id = v.profile_option_id (+)
 and p.profile_option_name = n.profile_option_name
 and upper(p.profile_option_name) in ( select profile_option_name
 from apps.fnd_profile_options_tl
 where upper(user_profile_option_name)
 like upper('%&user_profile_name%'))
 and usr.user_id (+) = v.level_value
 and rsp.application_id (+) = v.level_value_application_id
 and rsp.responsibility_id (+) = v.level_value
 and app.application_id (+) = v.level_value
 and svr.node_id (+) = v.level_value
 and org.organization_id (+) = v.level_value
 order by short_name, user_profile_option_name, level_id, level_set;

