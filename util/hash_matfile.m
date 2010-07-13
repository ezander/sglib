function [status, hash]=hash_matfile( matfile )

cmd=['dd if=' matfile ' ibs=80 skip=1 obs=512 status=noxfer 2>/dev/null | sha1sum'];
[status, result]=system( cmd );
hash=strtrim(result(1:40));


%[status, result]=system(['cat ' tmp_name ' | hexdump -C | sed "1,6 d" |
%sha1sum']);
