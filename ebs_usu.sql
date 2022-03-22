set pagesize 30
set linesize 500
column LOGIN         format a15
column DESCRIPTION   format a40
column EMAIL_ADDRESS format a40
column USER_GUID     format a35
accept user prompt "User Name: "
SELECT user_id
--,      employee_id
--,      person_party_id
,      USER_NAME LOGIN
,      USER_GUID
--,      CREATION_DATE
--,      CREATED_BY
,      LAST_UPDATE_DATE
,      LAST_UPDATED_BY
,      LAST_LOGON_DATE
,      PASSWORD_DATE
,      START_DATE
,      END_DATE
--,      PASSWORD_LIFESPAN_DAYS
,      DESCRIPTION
--,      EMAIL_ADDRESS
--,      ENCRYPTED_FOUNDATION_PASSWORD
--,      ENCRYPTED_USER_PASSWORD
,      EMPLOYEE_ID
,      PERSON_PARTY_ID
FROM   apps.FND_USER --as of timestamp systimestamp - interval '240' minute
WHERE  USER_NAME like upper('%&USER%')
/

