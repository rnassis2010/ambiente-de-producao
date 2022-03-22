--create tablespace ATG_WF datafile '+DATAC08' size 10m default storage (initial 5m next 5m);
drop table atg_wf_1;
create table atg_wf_1 (nome varchar2(30)) storage (initial 5m next 5m) tablespace ATG_WF;
