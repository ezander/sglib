function save_png( handle, name, varargin )

check_handle( handle, 'figure' );

options=varargin2options( varargin );
[figdir,options]=get_option( options, 'figdir', '.figs' );
[notitle,options]=get_option( options, 'notitle', true );
[res,options]=get_option( options, 'res', 300 );
check_unsupported_options( options, mfilename );

% erase title (this the user should supply in the figure caption), usually
% only needed inside matlab
if notitle; title(''); end

filename=make_filename( name, figdir, 'png' );
makesavepath( filename );
print( handle, filename, '-dpng', sprintf( '-r%d', res ) );

% TODO: this is a hack since sam2p is currently not working for me
%filename=make_filename( name, figdir, 'bmp' );
%print( handle, filename, '-dbmp', sprintf( '-r%d', res ) );
