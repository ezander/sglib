function result = isappdata(handle, name)

% h must be 0
global appdata
if isfield( appdata, name )
    result=true;
else
    result=false;
end
