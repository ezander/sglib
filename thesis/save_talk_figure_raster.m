function save_talk_figure_raster( handle, name, eps_params, png_params, latex_params )

if nargin<3; eps_params={}; end
if nargin<4; png_params={}; end
if nargin<5; latex_params={}; end

if ~ishandle( handle )
    save_thesis_figure( gca, handle, name, eps_params, png_params );
    return
end

figdir='/home/ezander/projects/docs/presentations/2010_diss_pres/fig2/';
common_params={'figdir', figdir};

check_handle( handle, 'axes' );
[h_workaxis,h_workfig]=reparent_axes( handle );
set( h_workfig, 'renderer', 'painters' );

png_params=[{'res', 150}, png_params];
save_png( h_workfig, name, common_params{:}, png_params{:} );

epsfilename=make_filename( name, figdir, 'eps' );
pngfilename=make_filename( name, figdir, 'png' );
[stat,res]=system( ['sam2p ', pngfilename, ' ', epsfilename ] );
if stat~=0
    disp(res);
    keyboard;
end
%save_eps( h_workfig, name, common_params{:}, eps_params{:} );
%save_latex( h_workaxis, name, common_params{:}, latex_params{:} );

close( h_workfig );



function filename=make_filename( name, dir, ext, suffix )
if nargin<4
    suffix='';
end
if iscell(name)
    name=sprintf( name{1}, name{2:end} );
end
name=[name suffix '.' ext];
filename=fullfile( dir, name );

