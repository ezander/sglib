function str=disp_func( func )


if nargin==0
    disp_func( {{@testtest, {'a', 'd', 'r'}, {3,2,5}}, {'a', 'd', 'r'}} )
    return;
end

if isempty( func ) 
    str='<none>';
else
    [handle,args]=collect_args( func );
    str=[ handle2str( handle ), '(', args2str(args), ')'];
end

function s=handle2str( handle )
if isa( handle, 'function_handle' )
    s=['@' func2str(handle) ];
elseif ischar(handle)
    s=handle;
else
    error( 'unknown' );
end
    
function [handle,args]=collect_args( func )
[handle,func]=identity_replace( func );
phs={}; for i=1:10; phs{end+1}=makeph(i); end
args=funcall( func, phs{:} );

function [handle,func]=identity_replace( func )
if iscell(func)
    inner=func{1};
    [handle, inner]=identity_replace(inner);
    func={inner, func{2:end}};
else
    handle=func;
    func=@identity;
end

function out=identity( varargin )
out=varargin;


function s=args2str( args )
last={};

while numel(args)>0 && ~isph(args{end})
    last=[args(end) last];
    args(end)=[];
end
while numel(args)>0 && isph(args{end})
    args(end)=[];
end

s='';
for i=1:length(args)
    if isph(args{i})
        s=[s strvarexpand( ', arg$args{i}{1}$' )];
    else
        s=[s strvarexpand( ', $args{i}$' )];
    end
end
if length( last )
        s=[s ', ...'];
end
for i=1:length(last)
    s=[s strvarexpand( ', $last{i}$' )];
end
if length(s)>=2
    s=s(3:end);
end



function phtag
function arg=makeph( n )
arg={n,@phtag};
function bool=isph( arg )
bool=iscell(arg) && numel(arg)>=2 && isequal( arg{2}, @phtag );
