
CREATE OR REPLACE
PROCEDURE      APPS.XXFND_HIST_CONC_REQUESTS_PRC IS
  vTable VARCHAR2(30);
BEGIN
  --
  -- GUARDAR HISTORICO DOS CONCURRENTS SUBMETIDOS NO ERP DA EDITORA ABRIL
  --
  vTable := 'XXFND_HIST_CONCURRENT_REQUESTS';
  --
  INSERT INTO xxfnd_hist_concurrent_requests
       (
         REQUEST_ID                                --001
       , LAST_UPDATE_DATE                          --002
       , LAST_UPDATED_BY                           --003
       , REQUEST_DATE                              --004
       , REQUESTED_BY                              --005
       , PHASE_CODE                                --006
       , STATUS_CODE                               --007
       , PRIORITY_REQUEST_ID                       --008
       , PRIORITY                                  --009
       , REQUESTED_START_DATE                      --010
       , HOLD_FLAG                                 --011
       , ENFORCE_SERIALITY_FLAG                    --012
       , SINGLE_THREAD_FLAG                        --013
       , HAS_SUB_REQUEST                           --014
       , IS_SUB_REQUEST                            --015
       , IMPLICIT_CODE                             --016
       , UPDATE_PROTECTED                          --017
       , QUEUE_METHOD_CODE                         --018
       , ARGUMENT_INPUT_METHOD_CODE                --019
       , ORACLE_ID                                 --020
       , PROGRAM_APPLICATION_ID                    --021
       , CONCURRENT_PROGRAM_ID                     --022
       , RESPONSIBILITY_APPLICATION_ID             --023
       , RESPONSIBILITY_ID                         --024
       , NUMBER_OF_ARGUMENTS                       --025
       , NUMBER_OF_COPIES                          --026
       , SAVE_OUTPUT_FLAG                          --027
       , NLS_COMPLIANT                             --028
       , LAST_UPDATE_LOGIN                         --029
       , NLS_LANGUAGE                              --030
       , NLS_TERRITORY                             --031
       , PRINTER                                   --032
       , PRINT_STYLE                               --033
       , PRINT_GROUP                               --034
       , REQUEST_CLASS_APPLICATION_ID              --035
       , CONCURRENT_REQUEST_CLASS_ID               --036
       , PARENT_REQUEST_ID                         --037
       , CONC_LOGIN_ID                             --038
       , LANGUAGE_ID                               --039
       , DESCRIPTION                               --040
       , REQ_INFORMATION                           --041
       , RESUBMIT_INTERVAL                         --042
       , RESUBMIT_INTERVAL_UNIT_CODE               --043
       , RESUBMIT_INTERVAL_TYPE_CODE               --044
       , RESUBMIT_TIME                             --045
       , RESUBMIT_END_DATE                         --046
       , RESUBMITTED                               --047
       , CONTROLLING_MANAGER                       --048
       , ACTUAL_START_DATE                         --049
       , ACTUAL_COMPLETION_DATE                    --050
       , COMPLETION_TEXT                           --051
       , OUTCOME_PRODUCT                           --052
       , OUTCOME_CODE                              --053
       , CPU_SECONDS                               --054
       , LOGICAL_IOS                               --055
       , PHYSICAL_IOS                              --056
       , LOGFILE_NAME                              --057
       , LOGFILE_NODE_NAME                         --058
       , OUTFILE_NAME                              --059
       , OUTFILE_NODE_NAME                         --060
       , ARGUMENT_TEXT                             --061
       , ARGUMENT1                                 --062
       , ARGUMENT2                                 --063
       , ARGUMENT3                                 --064
       , ARGUMENT4                                 --065
       , ARGUMENT5                                 --066
       , ARGUMENT6                                 --067
       , ARGUMENT7                                 --068
       , ARGUMENT8                                 --069
       , ARGUMENT9                                 --070
       , ARGUMENT10                                --071
       , ARGUMENT11                                --072
       , ARGUMENT12                                --073
       , ARGUMENT13                                --074
       , ARGUMENT14                                --075
       , ARGUMENT15                                --076
       , ARGUMENT16                                --077
       , ARGUMENT17                                --078
       , ARGUMENT18                                --079
       , ARGUMENT19                                --080
       , ARGUMENT20                                --081
       , ARGUMENT21                                --082
       , ARGUMENT22                                --083
       , ARGUMENT23                                --084
       , ARGUMENT24                                --085
       , ARGUMENT25                                --086
       , CRM_THRSHLD                               --087
       , CRM_TSTMP                                 --088
       , CRITICAL                                  --089
       , REQUEST_TYPE                              --090
       , ORACLE_PROCESS_ID                         --091
       , ORACLE_SESSION_ID                         --092
       , OS_PROCESS_ID                             --093
       , PRINT_JOB_ID                              --094
       , OUTPUT_FILE_TYPE                          --095
       , RELEASE_CLASS_APP_ID                      --096
       , RELEASE_CLASS_ID                          --097
       , STALE_DATE                                --098
       , CANCEL_OR_HOLD                            --099
       , NOTIFY_ON_PP_ERROR                        --100
       , CD_ID                                     --101
       , REQUEST_LIMIT                             --102
       , CRM_RELEASE_DATE                          --103
       , POST_REQUEST_STATUS                       --104
       , COMPLETION_CODE                           --105
       , INCREMENT_DATES                           --106
       , RESTART                                   --107
       , ENABLE_TRACE                              --108
       , RESUB_COUNT                               --109
       , NLS_CODESET                               --110
       , OFILE_SIZE                                --111
       , LFILE_SIZE                                --112
       , STALE                                     --113
       , SECURITY_GROUP_ID                         --114
       , RESOURCE_CONSUMER_GROUP                   --115
       , EXP_DATE                                  --116
       , QUEUE_APP_ID                              --117
       , QUEUE_ID                                  --118
       , OPS_INSTANCE                              --119
       , INTERIM_STATUS_CODE                       --120
       , ROOT_REQUEST_ID                           --121
       , ORIGIN                                    --122
       , NLS_NUMERIC_CHARACTERS                    --123
       , PP_START_DATE                             --124
       , PP_END_DATE                               --125
--       , ORG_ID                                    --126
--       , RUN_NUMBER                                --127
--       , NODE_NAME1                                --128
--       , NODE_NAME2                                --129
--       , CONNSTR1                                  --130
--       , CONNSTR2                                  --131
       )
  SELECT
         REQUEST_ID                                --001
       , LAST_UPDATE_DATE                          --002
       , LAST_UPDATED_BY                           --003
       , REQUEST_DATE                              --004
       , REQUESTED_BY                              --005
       , PHASE_CODE                                --006
       , STATUS_CODE                               --007
       , PRIORITY_REQUEST_ID                       --008
       , PRIORITY                                  --009
       , REQUESTED_START_DATE                      --010
       , HOLD_FLAG                                 --011
       , ENFORCE_SERIALITY_FLAG                    --012
       , SINGLE_THREAD_FLAG                        --013
       , HAS_SUB_REQUEST                           --014
       , IS_SUB_REQUEST                            --015
       , IMPLICIT_CODE                             --016
       , UPDATE_PROTECTED                          --017
       , QUEUE_METHOD_CODE                         --018
       , ARGUMENT_INPUT_METHOD_CODE                --019
       , ORACLE_ID                                 --020
       , PROGRAM_APPLICATION_ID                    --021
       , CONCURRENT_PROGRAM_ID                     --022
       , RESPONSIBILITY_APPLICATION_ID             --023
       , RESPONSIBILITY_ID                         --024
       , NUMBER_OF_ARGUMENTS                       --025
       , NUMBER_OF_COPIES                          --026
       , SAVE_OUTPUT_FLAG                          --027
       , NLS_COMPLIANT                             --028
       , LAST_UPDATE_LOGIN                         --029
       , NLS_LANGUAGE                              --030
       , NLS_TERRITORY                             --031
       , PRINTER                                   --032
       , PRINT_STYLE                               --033
       , PRINT_GROUP                               --034
       , REQUEST_CLASS_APPLICATION_ID              --035
       , CONCURRENT_REQUEST_CLASS_ID               --036
       , PARENT_REQUEST_ID                         --037
       , CONC_LOGIN_ID                             --038
       , LANGUAGE_ID                               --039
       , DESCRIPTION                               --040
       , REQ_INFORMATION                           --041
       , RESUBMIT_INTERVAL                         --042
       , RESUBMIT_INTERVAL_UNIT_CODE               --043
       , RESUBMIT_INTERVAL_TYPE_CODE               --044
       , RESUBMIT_TIME                             --045
       , RESUBMIT_END_DATE                         --046
       , RESUBMITTED                               --047
       , CONTROLLING_MANAGER                       --048
       , ACTUAL_START_DATE                         --049
       , ACTUAL_COMPLETION_DATE                    --050
       , COMPLETION_TEXT                           --051
       , OUTCOME_PRODUCT                           --052
       , OUTCOME_CODE                              --053
       , CPU_SECONDS                               --054
       , LOGICAL_IOS                               --055
       , PHYSICAL_IOS                              --056
       , LOGFILE_NAME                              --057
       , LOGFILE_NODE_NAME                         --058
       , OUTFILE_NAME                              --059
       , OUTFILE_NODE_NAME                         --060
       , ARGUMENT_TEXT                             --061
       , ARGUMENT1                                 --062
       , ARGUMENT2                                 --063
       , ARGUMENT3                                 --064
       , ARGUMENT4                                 --065
       , ARGUMENT5                                 --066
       , ARGUMENT6                                 --067
       , ARGUMENT7                                 --068
       , ARGUMENT8                                 --069
       , ARGUMENT9                                 --070
       , ARGUMENT10                                --071
       , ARGUMENT11                                --072
       , ARGUMENT12                                --073
       , ARGUMENT13                                --074
       , ARGUMENT14                                --075
       , ARGUMENT15                                --076
       , ARGUMENT16                                --077
       , ARGUMENT17                                --078
       , ARGUMENT18                                --079
       , ARGUMENT19                                --080
       , ARGUMENT20                                --081
       , ARGUMENT21                                --082
       , ARGUMENT22                                --083
       , ARGUMENT23                                --084
       , ARGUMENT24                                --085
       , ARGUMENT25                                --086
       , CRM_THRSHLD                               --087
       , CRM_TSTMP                                 --088
       , CRITICAL                                  --089
       , REQUEST_TYPE                              --090
       , ORACLE_PROCESS_ID                         --091
       , ORACLE_SESSION_ID                         --092
       , OS_PROCESS_ID                             --093
       , PRINT_JOB_ID                              --094
       , OUTPUT_FILE_TYPE                          --095
       , RELEASE_CLASS_APP_ID                      --096
       , RELEASE_CLASS_ID                          --097
       , STALE_DATE                                --098
       , CANCEL_OR_HOLD                            --099
       , NOTIFY_ON_PP_ERROR                        --100
       , CD_ID                                     --101
       , REQUEST_LIMIT                             --102
       , CRM_RELEASE_DATE                          --103
       , POST_REQUEST_STATUS                       --104
       , COMPLETION_CODE                           --105
       , INCREMENT_DATES                           --106
       , RESTART                                   --107
       , ENABLE_TRACE                              --108
       , RESUB_COUNT                               --109
       , NLS_CODESET                               --110
       , OFILE_SIZE                                --111
       , LFILE_SIZE                                --112
       , STALE                                     --113
       , SECURITY_GROUP_ID                         --114
       , RESOURCE_CONSUMER_GROUP                   --115
       , EXP_DATE                                  --116
       , QUEUE_APP_ID                              --117
       , QUEUE_ID                                  --118
       , OPS_INSTANCE                              --119
       , INTERIM_STATUS_CODE                       --120
       , ROOT_REQUEST_ID                           --121
       , ORIGIN                                    --122
       , NLS_NUMERIC_CHARACTERS                    --123
       , PP_START_DATE                             --124
       , PP_END_DATE                               --125
 --      , ORG_ID                                    --126
 --      , RUN_NUMBER                                --127
 --      , NODE_NAME1                                --128
 --      , NODE_NAME2                                --129
 --      , CONNSTR1                                  --130
 --      , CONNSTR2                                  --131
  FROM   FND_CONCURRENT_REQUESTS
  WHERE  TRUNC(REQUEST_DATE) = TRUNC(SYSDATE)-1;
  --
  vTable := 'XXFND_HIST_CONC_PROCESSES';
  --
  INSERT INTO xxfnd_hist_conc_processes
       (
         CONCURRENT_PROCESS_ID                     --001
       , LAST_UPDATE_DATE                          --002
       , LAST_UPDATED_BY                           --003
       , CREATION_DATE                             --004
       , CREATED_BY                                --005
       , LAST_UPDATE_LOGIN                         --006
       , QUEUE_APPLICATION_ID                      --007
       , CONCURRENT_QUEUE_ID                       --008
       , PROCESS_STATUS_CODE                       --009
       , SESSION_ID                                --010
       , ORACLE_PROCESS_ID                         --011
       , PROCESS_START_DATE                        --012
       , OS_PROCESS_NAME                           --013
       , OS_PROCESS_ID                             --014
       , MANAGER_TYPE                              --015
       , NODE_NAME                                 --016
       , DB_NAME                                   --017
       , DB_DOMAIN                                 --018
       , SQLNET_STRING                             --019
       , LOGFILE_NAME                              --020
       , JOB_ID                                    --021
       , DB_INSTANCE                               --022
       , LK_HANDLE                                 --023
       , PLSQL_LOG                                 --024
       , PLSQL_OUT                                 --025
       , LAST_TXN_START                            --026
       , LAST_TXN_END                              --027
       , PLSQL_DIR                                 --028
       , INSTANCE_NUMBER                           --029
       , PROCESS_CONTEXT                           --030
       , SERVICE_PARAMETERS                        --031
       , GSM_INTERNAL_STATUS                       --032
       , GSM_INTERNAL_INFO                         --033
       )
  SELECT
         CONCURRENT_PROCESS_ID                     --001
       , LAST_UPDATE_DATE                          --002
       , LAST_UPDATED_BY                           --003
       , CREATION_DATE                             --004
       , CREATED_BY                                --005
       , LAST_UPDATE_LOGIN                         --006
       , QUEUE_APPLICATION_ID                      --007
       , CONCURRENT_QUEUE_ID                       --008
       , PROCESS_STATUS_CODE                       --009
       , SESSION_ID                                --010
       , ORACLE_PROCESS_ID                         --011
       , PROCESS_START_DATE                        --012
       , OS_PROCESS_NAME                           --013
       , OS_PROCESS_ID                             --014
       , MANAGER_TYPE                              --015
       , NODE_NAME                                 --016
       , DB_NAME                                   --017
       , DB_DOMAIN                                 --018
       , SQLNET_STRING                             --019
       , LOGFILE_NAME                              --020
       , JOB_ID                                    --021
       , DB_INSTANCE                               --022
       , LK_HANDLE                                 --023
       , PLSQL_LOG                                 --024
       , PLSQL_OUT                                 --025
       , LAST_TXN_START                            --026
       , LAST_TXN_END                              --027
       , PLSQL_DIR                                 --028
       , INSTANCE_NUMBER                           --029
       , PROCESS_CONTEXT                           --030
       , SERVICE_PARAMETERS                        --031
       , GSM_INTERNAL_STATUS                       --032
       , GSM_INTERNAL_INFO                         --033
  FROM   FND_CONCURRENT_PROCESSES
  WHERE  TRUNC(PROCESS_START_DATE) = TRUNC(SYSDATE)-1;
  --
  COMMIT;
  --
EXCEPTION
  WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,'INSERT ERROR - '||vTable||' - '||SQLERRM);
END xxfnd_hist_conc_requests_prc;
/


