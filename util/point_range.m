function ti=point_range( t, limit, ext )
% POINT_RANGE Create points for plotting from node vector.
%   TI=POINT_RANGE( T, LIMIT ) create a vector of nodes for plotting from
%   the given node vector. TI includes 100 points from MIN(T) to MAX(T),
%   plus each node in T the node itself and two nodes which are a very
%   small delta to both sides. This is good for plotting non-continuous
%   functions as then the slopes become truly vertical without unduly
%   raising the total number of points. If LIMIT is true (the default) the
%   range of TI is limited to that of T, otherwise it's T plus/minus the
%   same delta, so that jumps at the borders can also be seen.

if nargin<2
    limit=true;
end
if nargin<3
    ext=0;
end
n=100;

t1=min(t);
t2=max(t);
dt=t2-t1;

ti=linspace(t1-ext*dt, t2+ext*dt, n);

del=100*eps*dt;
ti=unique( [t-del, t, t+del, ti] );

if limit
    ti(ti<min(t))=[];
    ti(ti>max(t))=[];
end
