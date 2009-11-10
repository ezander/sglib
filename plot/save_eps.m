function save_eps( basename, topic, varargin );

options=varargin2options( varargin{:} );
[epsdir,options]=get_option( options, 'epsdir', 'eps' );
[psfrag,options]=get_option( options, 'psfrag', true );
[writetex,options]=get_option( options, 'writetex', false );
[standalonetex,options]=get_option( options, 'standalonetex', false );
[notitle,options]=get_option( options, 'notitle', true );
check_unsupported_options( options, mfilename );


[success,message,messageid]=mkdir(epsdir);
if ~success
    error( messageid, 'mkdir %s did not succeed: %s', epsdir, message);
end
if ~exist(epsdir,'dir')
    error( '%s exists but is not a directory', epsdir );
end

% erase title (this the user should supply in the figure caption), usually
% only needed inside matlab
if notitle;
    title('');
end

% Now save the EPS
filename=sprintf( './%s/%s-%s.eps', epsdir, basename, topic );
print( filename, '-depsc2' );



