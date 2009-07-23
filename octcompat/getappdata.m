function value = getappdata(handle, name)

% handle must be 0
global appdata
if isfield( appdata, name )
    value=appdata.(name);
else
    value=[];
end
