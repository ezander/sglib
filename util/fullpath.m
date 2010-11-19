function full=fullpath( path )
if nargin<1 || isempty(path)
    full=pwd;
elseif path(1)==filesep
    full=path;
else
    full=fullfile( pwd, path );
end
