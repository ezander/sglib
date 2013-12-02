function [pos,els]=load_pdetool_geom( name, varargin)

options=varargin2options(varargin);
[numrefine,options]=get_option( options, 'numrefine', 0 );
[showmesh,options]=get_option( options, 'showmesh', false );
[normalize,options]=get_option( options, 'normalize', false );
[Hmax,options]=get_option( options, 'Hmax', [] );
[transform,options]=get_option( options, 'transform', [] );
check_unsupported_options(options, mfilename);

T=1;
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

if isempty(transform)
    transform=T;
end

% extra options passed to initgeom
pdetool_options={};
if ~isempty(Hmax)
    pdetool_options=[pdetool_options, {'Hmax', Hmax}];
end

% init the mesh and refine once is requested
[p,e,t]=initmesh(geom, pdetool_options{:});
for i=1:numrefine
    [p,e,t]=refinemesh(geom,p,e,t);
end

% rotate or scale the points
p=transform*p;

if showmesh
    % let's look at it
    pdemesh(p,e,t);
    axis equal;
end

% extract element and position information
pos=p;
els=t(1:3,:);
[pos,els]=correct_mesh( pos, els );

% normalize to [-1,1]^2
if normalize
    pos=pos/max(max(pos)-min(pos))*2;
    pos=pos-repmat( (max(pos)+min(pos))/2, size(pos,1), 1 );
end
