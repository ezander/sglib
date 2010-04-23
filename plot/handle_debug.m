function handle_debug( h )

%#ok<*AGROW>
if nargin<1
    h=0; 
end

props={'type', 'tag', 'name', 'string', 'displayname', 'title', 'xlabel', 'ylabel', 'annotation', 'parent', 'children' };

if ~ishandle(h)
    fprintf( '\n this is not a handle: %g\n', h );
    return
end

fprintf( '\nhandle: %s\n', makehyperlink( sprintf('%g',h), sprintf( 'inspect(%30.18f)', h), 'cmd' ) );
for p=props
    display_prop( h, p{1} );
end
fprintf( '%s\n', makehyperlink( 'more...', sprintf( 'get(%30.18f)', h), 'cmd' ) );

function display_prop( h, p )
if ~isprop( h, p );
    return
end

val=get( h, p );
if ischar(val)
    strval=['char=' '''', val, ''''];
elseif isnumeric(val)
    strval=sprintf('%dx%d double=[',size(val,1), size(val,2) );
    for i=1:numel(val)
        curr=val(i);
        if ishandle(curr)
            strval=[strval,...
                makehyperlink( get( curr, 'type' ), sprintf( 'handle_debug(%30.18f)', curr), 'cmd' )...
                ];  
            strval=[strval sprintf( '(%g),', curr )];
        else
            strval=[strval sprintf( '%g,', curr )];
        end
    end
    if ~isempty(val)
        strval=strval(1:end-1);
    end
    strval=[strval ']' ];
else
    strval=evalc('disp(val)'); strval=strval(1:end-1);
end

fprintf( '%s: %s\n', p, strval );
