function full=fullpath( path )
if nargin<1 || isempty(path)
    full=pwd;
elseif path(1)=='/'
    full=path;
else
    full=fullfile( pwd, path );
end
