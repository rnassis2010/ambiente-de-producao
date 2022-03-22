DECLARE
  --
  vFile     UTL_FILE.FILE_TYPE;
  vDir      varchar2(60) := 'TP215_AP_OUT';
  vFilename varchar2(60) := 'arquivo_teste_'||to_char(sysdate,'yyyymmddhh24miss')||'.txt';
  --
BEGIN
  --
  vFile := UTL_FILE.FOPEN( vDir , vFilename , 'W' );
  --
  UTL_FILE.PUT_LINE(VFile, 'TESTE DE GRAVACAO NO DIRETORIO' );
  --
  UTL_FILE.FCLOSE(vFile);
  --
EXCEPTION
  WHEN OTHERS THEN
       raise_application_error(-20000,'Erro utl_file - '||SQLERRM);
END;
/
