function save_eps( basename, topic, varargin )

options=varargin2options( varargin );
[pngdir,options]=get_option( options, 'pngdir', 'eps' );
[notitle,options]=get_option( options, 'notitle', true );
check_unsupported_options( options, mfilename );


[success,message,messageid]=mkdir(pngdir);
if ~success
    error( messageid, 'mkdir %s did not succeed: %s', pngdir, message);
end
if ~exist(pngdir,'dir')
    error( 'util:save_png:not_a_directory', '%s exists but is not a directory', pngdir );
end

% erase title (this the user should supply in the figure caption), usually
% only needed inside matlab
if notitle;
    title('');
end

% Now save the EPS
if ischar(topic)
    % old deprecated version
    filename=sprintf( './%s/%s-%s.png', pngdir, basename, topic );
else
    filename=sprintf( './%s/%s.png', pngdir, basename );
    filename=sprintf( filename, topic{:} );
end
print( filename, '-dpng' );
