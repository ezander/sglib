function r=kendall_correlation(x,y)
% KENDALL_CORRELATION Short description of kendall_correlation.
%   KENDALL_CORRELATION Long description of kendall_correlation.
%
% Example (<a href="matlab:run_example kendall_correlation">run</a>)
%   N=100;
%   x=rand(N,1); y=rand(N,1);
%   fprintf( 'Detects linear dependence well:\n' );
%   fprintf( 'r(x,x)=%g (expected: 1)\n', kendall_correlation(x,x) ); 
%   fprintf( 'r(x,-2*x)=%g (expected: -1)\n', kendall_correlation(x,-2*x) ); 
%   fprintf( 'Detects independence:\n' );
%   fprintf( 'r(x,y)=%g (expected: 0)\n', kendall_correlation(x,y) ); 
%   fprintf( 'r(x,y+0.2*x)=%g (expected: 0.2)\n', kendall_correlation(x,y+0.2*x) ); 
%   fprintf( 'Does not detect nonmonotone, nonlinear dependence:\n' );
%   z=sin(pi*x); 
%   fprintf( 'r(x,z)=%g (expected: 0)\n', kendall_correlation(x,z) ); 
%   fprintf( 'Does detect monotone, nonlinear dependence:\n' );
%   z=x.^2; 
%   fprintf( 'r(x,z)=%g (expected: 1)\n', kendall_correlation(x,z) ); 
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

n=length(x);
if n>1000
    % The current implementation is so lousy that it will trash your
    % computer for too large data sets. So we issue some warning and return
    % zero...
    warning( 'Data set too large for this lousy implementation. Returning zero...' );
    r=0;
    return;
end

[X,Y]=meshgrid(x,y);
Y=Y';
CM=(sign(X-X')==sign(Y-Y')) - (sign(X-X')==-sign(Y-Y'));
n=length(x);
r=(sum(CM(:)))/(n*(n-1));
