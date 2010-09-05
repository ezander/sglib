function [pos,els,G,ptdata]=load_pdetool_geom( name, numrefine, showmesh, normalize )

if nargin<2; numrefine=0; end
if nargin<3; showmesh=false; end
if nargin<4; normalize=false; end

T=1; % point transformation matrix (see below)
switch name
    case {'square'}
        geom='squareg'; % a square
    case {'crack'}
        geom='crackg'; % rectangular with slit
    case {'cirsg', 'circle_segment' }
        geom='cirsg'; % circle with missing 90deg segment
    case {'lshape'}
        geom='lshapeg'; % an lshape with 3 segments (upper left missing)
        T=[1 0; 0 -1]; % now it's the lower left that's missing
    case {'circle'}
        geom='circleg'; % cirlce
    case {'scatter'}
        geom='scatterg'; % circular with diamond in middle
    case {'card', 'cardioid' }
        geom='cardg'; % a cardioid (heartform with cusp pointing left)
    otherwise
        error( 'load_pdetool_geom:name', 'load_pdetool_geom: unknown geometry: %s', name );
end

% init the mesh and refine once is requested
[p,e,t]=initmesh(geom);
for i=1:numrefine
    [p,e,t]=refinemesh(geom,p,e,t);
end

% rotate or scale the points
p=T*p;

if showmesh
    % let's look at it
    pdemesh(p,e,t);
    axis equal;
end

% extract element and position information
pos=p;
els=t(1:3,:);

% normalize to [-1,1]^2
if normalize
    pos=pos/max(max(pos)-min(pos))*2;
    pos=pos-repmat( (max(pos)+min(pos))/2, size(pos,1), 1 );
end

% extract stiffness matrix and gramian (throw away the former)
if nargout>=3
    [K,G]=assema(p,t,0,1,0); %#ok
end


% if user to have ptdata structure for further communication with the
% pde-toolbox
if nargout>=4
    ptdata={p,e,t};
end
