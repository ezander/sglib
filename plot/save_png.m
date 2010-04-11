function save_png( handle, name, varargin )

if ~ishandle( handle )
    save_eps( gcf, name, varargin{:} );
    return
end

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
