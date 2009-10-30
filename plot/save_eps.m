function save_eps( basename, topic );

dir='eps';
[success,message,messageid]=mkdir(dir);
if ~success
    error( messageid, 'mkdir %s did not succeed: %s', dir, message);
end
if ~exist('eps','dir')
    error( '%s exists but is not a directory', dir );
end

filename=sprintf( './%s/%s_%s.eps', dir, basename, topic );
title('');
print( filename, '-depsc2' );
disp(filename);