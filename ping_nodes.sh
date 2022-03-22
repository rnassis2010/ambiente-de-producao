/usr/sbin/ping -s SC01ZERPP01 55 6 | xargs -L 1 -I '{}' date '+%d/%m/%Y-%H:%M:%S: {}' > sc01zdbadm08_SC01ZERPP01.log &
/usr/sbin/ping -s SC02ZERPP02 55 6 | xargs -L 1 -I '{}' date '+%d/%m/%Y-%H:%M:%S: {}' > sc01zdbadm08_SC02ZERPP02.log &
/usr/sbin/ping -s SC01ZERPP03 55 6 | xargs -L 1 -I '{}' date '+%d/%m/%Y-%H:%M:%S: {}' > sc01zdbadm08_SC01ZERPP03.log &
/usr/sbin/ping -s SC01ZDBADM08 55 6 | xargs -L 1 -I '{}' date '+%d/%m/%Y-%H:%M:%S: {}' > sc01zdbadm08_SC01ZDBADM08.log &
/usr/sbin/ping -s SC02ZDBADM08 55 6 | xargs -L 1 -I '{}' date '+%d/%m/%Y-%H:%M:%S: {}' > sc01zdbadm08_SC02ZDBADM08.log &
