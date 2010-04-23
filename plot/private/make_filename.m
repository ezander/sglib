function filename=make_filename( name, dir, ext, suffix )

if nargin<4
    suffix='';
end

if iscell(name)
    name=sprintf( name{1}, name{2:end} );
end
name=[name, suffix];
if ~isempty(ext)
    name=[name, '.', ext];
end
filename=fullfile( dir, name );

