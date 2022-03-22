accept ids prompt "sid,#serial = "
accept node prompt "node = "
alter system kill session '&ids,@&node';
undefine ids
undefine node

