function bool=check_handle( h, type )

if nargin<2
    type=[];
end

if ~ishandle(h)
    error( 'sglib:handle', 'Parameter is no valid graphics handle' );
end

if ~isempty(type) && ~strcmp( get(h,'type'), type )
    error( 'sglib:handle', 'Graphics handle is of wrong type: ''%s'', should have been: ''%s''', get(h,'type'), type );
end
