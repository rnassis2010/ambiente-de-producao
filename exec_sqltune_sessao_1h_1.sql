execute dbms_sqltune.drop_tuning_task('sqltune_87nt40c5wj7y5');                                                                                                                                                                                           
EXEC :stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => '87nt40c5wj7y5', time_limit => 600, task_name=> 'sqltune_87nt40c5wj7y5');                                                                                                                    
EXECUTE dbms_sqltune.execute_tuning_task('sqltune_87nt40c5wj7y5');                                                                                                                                                                                        
