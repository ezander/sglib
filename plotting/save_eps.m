function save_eps( handle, name, varargin )

check_handle( handle, 'figure' );

options=varargin2options( varargin );
[figdir,options]=get_option( options, 'figdir', '.figs' );
[notitle,options]=get_option( options, 'notitle', true );
check_unsupported_options( options, mfilename );

% erase title (this the user should supply in the figure caption), usually
% only needed inside matlab
if notitle; title(''); end

filename=make_filename( name, figdir, 'eps' );
makesavepath( filename );
print( handle, filename, '-depsc2' );
