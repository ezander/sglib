function setappdata(handle, name, value)

% handle must be 0
global appdata
appdata.(name)=value;
