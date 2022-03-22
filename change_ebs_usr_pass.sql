set serveroutput on
set pagesize 30
set linesize 500
column LOGIN         format a15
column DESCRIPTION   format a40
column EMAIL_ADDRESS format a40
column USER_GUID     format a35
accept user_name prompt "User Name: "
accept new_pass  prompt "New Password:"

declare
  v_global_name varchar2(1000);
  v_status      boolean;
begin

  select global_name into v_global_name from global_name;

  v_status   := fnd_user_pkg.ChangePassword ( username => '&user_name',
                                              newpassword => '&new_pass'
                                            );

  if v_status = true then
    dbms_output.put_line(' ');
    dbms_output.put_line(' ');
    dbms_output.put_line('==============================================================');
    dbms_output.put_line(' Ambiente : ' || v_global_name );
    dbms_output.put_line('==============================================================');
    dbms_output.put_line('Usuario:  ' || '&user_name');
    dbms_output.put_line('Reset de senha realizado com sucesso.');
    dbms_output.put_line('Favor realizar o login com a Senha:      ' || '&new_pass');
    dbms_output.put_line('==============================================================');
    dbms_output.put_line(' ');
    commit;
  else
    dbms_output.put_line('Nao foi possivel realizar a troca de senha do usuario. Erro:   ' || sqlcode || ' ' || substr(sqlerrm, 1, 100));
  end if;
end;
/
