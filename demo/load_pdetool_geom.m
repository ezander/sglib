function [pos,els,M]=load_pdetool_geom( name, numrefine, showmesh )


switch name
    case {'square'}
        geom='squareg'; % a square
    case {'crack'}
        geom='crackg'; % rectangular with slit
    case {'cirsg', 'circle_segment' }
        geom='cirsg'; % circle with missing 90deg segment
    case {'lshape'}
        geom='lshapeg'; % an lshape with 3 segments (upper left missing)
    case {'circle'}
        geom='circleg'; % cirlce 
    case {'scatter'}
        geom='scatterg'; % circular with diamond in middle
    case {'card', 'cardioid' }
        geom='cardg'; % a cardioid (heartform with cusp pointing left)
    otherwise
        error( 'load_pdetool_geom:name', 'load_pdetool_geom: unknown geometry: %s', name );
end

% init the mesh and refine onece
[p,e,t]=initmesh(geom);
if nargin>=2
    for i=1:numrefine
        [p,e,t]=refinemesh(geom,p,e,t); 
    end
end

if nargin>=3 && showmesh
    % let's look at it
    pdemesh(p,e,t);
    axis equal;
end

% extract stiffness and massmatrix (throw away the former)
[K,M]=assema(p,t,0,1,0); %#ok
% extract element and position information in a format suitable for sglib
els=t(1:3,:)';
pos=p';
