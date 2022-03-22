declare
   p_retcode number;
   p_errbuf  varchar2(100);
begin
   for rec in (
                select component_id
                from   fnd_svc_components
                where  COMPONENT_STATUS in ('STOPPED_ERROR','DEACTIVATED_USER','DEACTIVATED_SYSTEM')
              )
   loop
     --
     fnd_svc_component.start_component(rec.component_id, p_retcode, p_errbuf);
     --
     commit;
     --
   end loop;
end;
/
