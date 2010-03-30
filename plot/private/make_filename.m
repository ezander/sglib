function filename=make_filename( name, dir, ext, suffix )

if nargin<4
    suffix='';
end

if iscell(name)
    name=sprintf( name{1}, name{2:end} );
end
name=[name suffix '.' ext];
filename=fullfile( dir, name );

